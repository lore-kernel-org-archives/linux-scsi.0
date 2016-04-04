From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH 1/4] libata: implement ZBC IN translation
Date: Mon, 4 Apr 2016 23:26:09 +0700
Message-ID: <CAJVOszBhAZrRFx+_tNcfLZproxu+d+qYC5FFnsrYd=tfwC8fiQ@mail.gmail.com>
References: <1459763271-125856-1-git-send-email-hare@suse.de> <1459763271-125856-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:9858 "EHLO
	mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754110AbcDDQ0c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2016 12:26:32 -0400
Received: from pps.filterd (m0075555.ppops.net [127.0.0.1])
	by mx0a-00003501.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u34GMw6v039037
	for <linux-scsi@vger.kernel.org>; Mon, 4 Apr 2016 12:26:30 -0400
Received: from mail-yw0-f177.google.com (mail-yw0-f177.google.com [209.85.161.177])
	by mx0a-00003501.pphosted.com with ESMTP id 223uq6g0f8-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 04 Apr 2016 12:26:29 -0400
Received: by mail-yw0-f177.google.com with SMTP id g127so257792127ywf.2
        for <linux-scsi@vger.kernel.org>; Mon, 04 Apr 2016 09:26:29 -0700 (PDT)
In-Reply-To: <1459763271-125856-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

On Mon, Apr 4, 2016 at 4:47 PM, Hannes Reinecke <hare@suse.de> wrote:
> ZAC drives implement 'zac management in' command template,
> which maps onto the ZBC IN command.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/ata/libata-eh.c       |   1 +
>  drivers/ata/libata-scsi.c     | 144 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/ata.h           |   4 ++
>  include/trace/events/libata.h |   1 +
>  4 files changed, 150 insertions(+)
>
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index e6b16f4..e947bd5 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -2480,6 +2480,7 @@ const char *ata_get_cmd_descript(u8 command)
>                 { ATA_CMD_CFA_WRITE_MULT_NE,    "CFA WRITE MULTIPLE WITHOUT ERASE" },
>                 { ATA_CMD_REQ_SENSE_DATA,       "REQUEST SENSE DATA EXT" },
>                 { ATA_CMD_SANITIZE_DEVICE,      "SANITIZE DEVICE" },
> +               { ATA_CMD_ZAC_MGMT_IN,          "ZAC MANAGEMENT IN" },
>                 { ATA_CMD_READ_LONG,            "READ LONG (with retries)" },
>                 { ATA_CMD_READ_LONG_ONCE,       "READ LONG (without retries)" },
>                 { ATA_CMD_WRITE_LONG,           "WRITE LONG (with retries)" },
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index d29832f..21c2b40 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3310,6 +3310,147 @@ invalid_opcode:
>         return 1;
>  }
>
> +/*
> + * ata_scsi_report_zones_complete
> + *
> + * Convert T-13 little-endian field representation into
> + * T-10 big-endian field representation.
> + */
> +static void ata_scsi_report_zones_complete(struct ata_queued_cmd *qc)
> +{
> +       struct scsi_cmnd *scmd = qc->scsicmd;
> +       struct sg_mapping_iter miter;
> +       unsigned long flags;
> +       unsigned int bytes = 0;
> +
> +       sg_miter_start(&miter, scsi_sglist(scmd), scsi_sg_count(scmd),
> +                      SG_MITER_TO_SG | SG_MITER_ATOMIC);
> +
> +       local_irq_save(flags);
> +       while (sg_miter_next(&miter)) {
> +               unsigned int offset = 0;
> +
> +               if (bytes == 0) {
> +                       char *hdr;
> +                       u32 list_length;
> +                       u64 max_lba, opt_lba;
> +                       u16 same;
> +
> +                       /* Swizzle header */
> +                       hdr = miter.addr;
> +                       list_length = get_unaligned_le32(&hdr[0]);
> +                       same = get_unaligned_le16(&hdr[4]);
> +                       max_lba = get_unaligned_le64(&hdr[8]);
> +                       opt_lba = get_unaligned_le64(&hdr[16]);
> +                       put_unaligned_be32(list_length, &hdr[0]);
> +                       hdr[4] = same & 0xf;
> +                       put_unaligned_be64(max_lba, &hdr[8]);
> +                       put_unaligned_be64(opt_lba, &hdr[16]);
> +                       offset += 64;
> +                       bytes += 64;
> +               }
> +               while (offset < miter.length) {
> +                       char *rec;
> +                       u8 cond, type, non_seq, reset;
> +                       u64 size, start, wp;
> +
> +                       /* Swizzle zone descriptor */
> +                       rec = miter.addr + offset;
> +                       type = rec[0] & 0xf;
> +                       cond = (rec[1] >> 4) & 0xf;
> +                       non_seq = (rec[1] & 2);
> +                       reset = (rec[1] & 1);
> +                       size = get_unaligned_le64(&rec[8]);
> +                       start = get_unaligned_le64(&rec[16]);
> +                       wp = get_unaligned_le64(&rec[24]);
> +                       rec[0] = type;
> +                       rec[1] = (cond << 4) | non_seq | reset;

The bit munging around rec[0] and rec[1] look unnecessary to me.

Does the top nibble of re[0] and bits 2 and 3 of rec[1] really
need these cleanups?

> +                       put_unaligned_be64(size, &rec[8]);
> +                       put_unaligned_be64(start, &rec[16]);
> +                       put_unaligned_be64(wp, &rec[24]);
> +                       WARN_ON(offset + 64 > miter.length);
> +                       offset += 64;
> +                       bytes += 64;
> +               }
> +       }
> +       sg_miter_stop(&miter);
> +       local_irq_restore(flags);
> +
> +       ata_scsi_qc_complete(qc);
> +}
> +
> +static unsigned int ata_scsi_zbc_in_xlat(struct ata_queued_cmd *qc)
> +{
> +       struct ata_taskfile *tf = &qc->tf;
> +       struct scsi_cmnd *scmd = qc->scsicmd;
> +       const u8 *cdb = scmd->cmnd;
> +       u16 sect, fp = (u16)-1;
> +       u8 sa, options, bp = 0xff;
> +       u64 block;
> +       u32 n_block;
> +
> +       if (unlikely(scmd->cmd_len < 16)) {
> +               ata_dev_warn(qc->dev, "invalid cdb length %d\n",
> +                            scmd->cmd_len);
> +               fp = 15;
> +               goto invalid_fld;
> +       }
> +       scsi_16_lba_len(cdb, &block, &n_block);
> +       if (n_block != scsi_bufflen(scmd)) {
> +               ata_dev_warn(qc->dev, "non-matching transfer count (%d/%d)\n",
> +                            n_block, scsi_bufflen(scmd));
> +               goto invalid_param_len;
> +       }
> +       sa = cdb[1] & 0x1f;
> +       if (sa != ZI_REPORT_ZONES) {
> +               ata_dev_warn(qc->dev, "invalid service action %d\n", sa);
> +               fp = 1;
> +               goto invalid_fld;
> +       }
> +       /*
> +        * ZAC allows only for transfers in 512 byte blocks,
> +        * and uses a 16 bit value for the transfer count.
> +        */
> +       if ((n_block / 512) > 0xffff || n_block < 512 || (n_block % 512)) {
> +               ata_dev_warn(qc->dev, "invalid transfer count %d\n", n_block);
> +               goto invalid_param_len;
> +       }
> +       sect = n_block / 512;
> +       options = cdb[14];
> +
> +       tf->command = ATA_CMD_ZAC_MGMT_IN;
> +       tf->feature = ATA_SUBCMD_ZAC_MGMT_IN_REPORT_ZONES;
> +       tf->protocol = ATA_PROT_DMA;
> +       tf->hob_feature = options & 0x3f;
> +       tf->hob_nsect = (sect >> 8) & 0xff;
> +       tf->nsect = sect & 0xff;
> +       tf->device = ATA_LBA;
> +       tf->lbah = (block >> 16) & 0xff;
> +       tf->lbam = (block >> 8) & 0xff;
> +       tf->lbal = block & 0xff;
> +       tf->hob_lbah = (block >> 40) & 0xff;
> +       tf->hob_lbam = (block >> 32) & 0xff;
> +       tf->hob_lbal = (block >> 24) & 0xff;
> +
> +       tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48;
> +       qc->flags |= ATA_QCFLAG_RESULT_TF;
> +
> +       ata_qc_set_pc_nbytes(qc);
> +
> +       qc->complete_fn = ata_scsi_report_zones_complete;
> +
> +       return 0;
> +
> +invalid_fld:
> +       ata_scsi_set_invalid_field(qc->dev, scmd, fp, bp);
> +       return 1;
> +
> +invalid_param_len:
> +       /* "Parameter list length error" */
> +       ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
> +       return 1;
> +}
> +
>  /**
>   *     ata_mselect_caching - Simulate MODE SELECT for caching info page
>   *     @qc: Storage for translated ATA taskfile
> @@ -3623,6 +3764,9 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
>                 return ata_scsi_mode_select_xlat;
>                 break;
>
> +       case ZBC_IN:
> +               return ata_scsi_zbc_in_xlat;
> +
>         case START_STOP:
>                 return ata_scsi_start_stop_xlat;
>         }
> diff --git a/include/linux/ata.h b/include/linux/ata.h
> index e402cb3..2e4a6af 100644
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -301,6 +301,7 @@ enum {
>         ATA_CMD_CFA_WRITE_MULT_NE = 0xCD,
>         ATA_CMD_REQ_SENSE_DATA  = 0x0B,
>         ATA_CMD_SANITIZE_DEVICE = 0xB4,
> +       ATA_CMD_ZAC_MGMT_IN     = 0x4A,
>
>         /* marked obsolete in the ATA/ATAPI-7 spec */
>         ATA_CMD_RESTORE         = 0x10,
> @@ -309,6 +310,9 @@ enum {
>         ATA_SUBCMD_FPDMA_SEND_DSM            = 0x00,
>         ATA_SUBCMD_FPDMA_SEND_WR_LOG_DMA_EXT = 0x02,
>
> +       /* Subcmds for ATA_CMD_ZAC_MGMT_IN */
> +       ATA_SUBCMD_ZAC_MGMT_IN_REPORT_ZONES = 0x00,
> +
>         /* READ_LOG_EXT pages */
>         ATA_LOG_SATA_NCQ        = 0x10,
>         ATA_LOG_NCQ_SEND_RECV     = 0x13,
> diff --git a/include/trace/events/libata.h b/include/trace/events/libata.h
> index 8b0fbd9..02ec4e5 100644
> --- a/include/trace/events/libata.h
> +++ b/include/trace/events/libata.h
> @@ -97,6 +97,7 @@
>                  ata_opcode_name(ATA_CMD_CFA_WRITE_MULT_NE),    \
>                  ata_opcode_name(ATA_CMD_REQ_SENSE_DATA),       \
>                  ata_opcode_name(ATA_CMD_SANITIZE_DEVICE),      \
> +                ata_opcode_name(ATA_CMD_ZAC_MGMT_IN),          \
>                  ata_opcode_name(ATA_CMD_RESTORE),              \
>                  ata_opcode_name(ATA_CMD_READ_LONG),            \
>                  ata_opcode_name(ATA_CMD_READ_LONG_ONCE),       \
> --
> 1.8.5.6
>

The zone report looks good.

Tested-by: Shaun Tancheff <shaun.tancheff@seagate.com>

-- 
Shaun Tancheff
