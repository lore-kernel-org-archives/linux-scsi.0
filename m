From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCHv2 11/14] libata: Implement ZBC OUT translation
Date: Wed, 13 Apr 2016 01:54:23 +0700
Message-ID: <CAJVOszCF7NHMkXYGJJXCeBPue2QNYrMF5_aLnADKpkugp6So1g@mail.gmail.com>
References: <1460443678-57934-1-git-send-email-hare@suse.de> <1460443678-57934-12-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:15401 "EHLO
	mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756233AbcDLSyo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2016 14:54:44 -0400
Received: from pps.filterd (m0075553.ppops.net [127.0.0.1])
	by mx0a-00003501.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u3CIrLpN015647
	for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2016 14:54:44 -0400
Received: from mail-yw0-f181.google.com (mail-yw0-f181.google.com [209.85.161.181])
	by mx0a-00003501.pphosted.com with ESMTP id 2296nrg050-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2016 14:54:43 -0400
Received: by mail-yw0-f181.google.com with SMTP id d68so37059689ywe.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2016 11:54:43 -0700 (PDT)
In-Reply-To: <1460443678-57934-12-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org

On Tue, Apr 12, 2016 at 1:47 PM, Hannes Reinecke <hare@suse.de> wrote:
> ZAC drives implement a 'ZAC Management Out' command template,
> which maps onto the ZBC OUT command.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/ata/libata-eh.c       |  1 +
>  drivers/ata/libata-scsi.c     | 67 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/ata/libata-trace.c    | 16 +++++++++++
>  include/linux/ata.h           |  7 +++++
>  include/trace/events/libata.h |  1 +
>  5 files changed, 92 insertions(+)
>
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index 4932ce5..4c2bf7f 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -2503,6 +2503,7 @@ const char *ata_get_cmd_descript(u8 command)
>                 { ATA_CMD_REQ_SENSE_DATA,       "REQUEST SENSE DATA EXT" },
>                 { ATA_CMD_SANITIZE_DEVICE,      "SANITIZE DEVICE" },
>                 { ATA_CMD_ZAC_MGMT_IN,          "ZAC MANAGEMENT IN" },
> +               { ATA_CMD_ZAC_MGMT_OUT,         "ZAC MANAGEMENT OUT" },
>                 { ATA_CMD_READ_LONG,            "READ LONG (with retries)" },
>                 { ATA_CMD_READ_LONG_ONCE,       "READ LONG (without retries)" },
>                 { ATA_CMD_WRITE_LONG,           "WRITE LONG (with retries)" },
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 3e402a8..ef696a3 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3471,6 +3471,70 @@ invalid_param_len:
>         return 1;
>  }
>
> +static unsigned int ata_scsi_zbc_out_xlat(struct ata_queued_cmd *qc)
> +{
> +       struct ata_taskfile *tf = &qc->tf;
> +       struct scsi_cmnd *scmd = qc->scsicmd;
> +       struct ata_device *dev = qc->dev;
> +       const u8 *cdb = scmd->cmnd;
> +       u8 reset_all, sa;
> +       u64 block;
> +       u32 n_block;
> +       u16 fp = (u16)-1;
> +
> +       if (unlikely(scmd->cmd_len < 16)) {
> +               fp = 15;
> +               goto invalid_fld;
> +       }
> +
> +       sa = cdb[1] & 0x1f;
> +       if ((sa != ZO_CLOSE_ZONE) && (sa != ZO_FINISH_ZONE) &&
> +           (sa != ZO_OPEN_ZONE) && (sa != ZO_RESET_WRITE_POINTER)) {
> +               fp = 1;
> +               goto invalid_fld;
> +       }
> +
> +       scsi_16_lba_len(cdb, &block, &n_block);
> +       if (n_block) {
> +               /*
> +                * ZAC MANAGEMENT OUT doesn't define any length
> +                */
> +               goto invalid_param_len;
> +       }
> +       if (block > dev->n_sectors)
> +               goto out_of_range;
> +
> +       reset_all = cdb[14] & 0x1;
> +
> +       tf->protocol = ATA_PROT_NODATA;
> +       tf->command = ATA_CMD_ZAC_MGMT_OUT;
> +       tf->feature = sa;
> +       tf->hob_feature = reset_all & 0x1;
> +
> +       tf->lbah = (block >> 16) & 0xff;
> +       tf->lbam = (block >> 8) & 0xff;
> +       tf->lbal = block & 0xff;
> +       tf->hob_lbah = (block >> 40) & 0xff;
> +       tf->hob_lbam = (block >> 32) & 0xff;
> +       tf->hob_lbal = (block >> 24) & 0xff;
> +       tf->device = ATA_LBA;
> +       tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48;
> +
> +       return 0;
> +
> + invalid_fld:
> +       ata_scsi_set_invalid_field(qc->dev, scmd, fp, 0xff);
> +       return 1;
> + out_of_range:
> +       /* "Logical Block Address out of range" */
> +       ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x21, 0x00);
> +       return 1;
> +invalid_param_len:
> +       /* "Parameter list length error" */
> +       ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
> +       return 1;
> +}
> +
>  /**
>   *     ata_mselect_caching - Simulate MODE SELECT for caching info page
>   *     @qc: Storage for translated ATA taskfile
> @@ -3789,6 +3853,9 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
>         case ZBC_IN:
>                 return ata_scsi_zbc_in_xlat;
>
> +       case ZBC_OUT:
> +               return ata_scsi_zbc_out_xlat;
> +
>         case START_STOP:
>                 return ata_scsi_start_stop_xlat;
>         }
> diff --git a/drivers/ata/libata-trace.c b/drivers/ata/libata-trace.c
> index 9caeabd..1111ba7 100644
> --- a/drivers/ata/libata-trace.c
> +++ b/drivers/ata/libata-trace.c
> @@ -197,6 +197,22 @@ libata_trace_parse_subcmd(struct trace_seq *p, unsigned char cmd,
>                         break;
>                 }
>                 break;
> +       case ATA_CMD_ZAC_MGMT_OUT:
> +               switch (feature) {
> +               case ATA_SUBCMD_ZAC_MGMT_OUT_CLOSE_ZONE:
> +                       trace_seq_printf(p, " CLOSE_ZONE");
> +                       break;
> +               case ATA_SUBCMD_ZAC_MGMT_OUT_FINISH_ZONE:
> +                       trace_seq_printf(p, " FINISH_ZONE");
> +                       break;
> +               case ATA_SUBCMD_ZAC_MGMT_OUT_OPEN_ZONE:
> +                       trace_seq_printf(p, " OPEN_ZONE");
> +                       break;
> +               case ATA_SUBCMD_ZAC_MGMT_OUT_RESET_WRITE_POINTER:
> +                       trace_seq_printf(p, " RESET_WRITE_POINTER");
> +                       break;
> +               }
> +               break;
>         }
>         trace_seq_putc(p, 0);
>
> diff --git a/include/linux/ata.h b/include/linux/ata.h
> index 2f01ba9..e3bf9a3 100644
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -303,6 +303,7 @@ enum {
>         ATA_CMD_REQ_SENSE_DATA  = 0x0B,
>         ATA_CMD_SANITIZE_DEVICE = 0xB4,
>         ATA_CMD_ZAC_MGMT_IN     = 0x4A,
> +       ATA_CMD_ZAC_MGMT_OUT    = 0x9F,
>
>         /* marked obsolete in the ATA/ATAPI-7 spec */
>         ATA_CMD_RESTORE         = 0x10,
> @@ -323,6 +324,12 @@ enum {
>         /* Subcmds for ATA_CMD_ZAC_MGMT_IN */
>         ATA_SUBCMD_ZAC_MGMT_IN_REPORT_ZONES = 0x00,
>
> +       /* Subcmds for ATA_CMD_ZAC_MGMT_OUT */
> +       ATA_SUBCMD_ZAC_MGMT_OUT_CLOSE_ZONE = 0x01,
> +       ATA_SUBCMD_ZAC_MGMT_OUT_FINISH_ZONE = 0x02,
> +       ATA_SUBCMD_ZAC_MGMT_OUT_OPEN_ZONE = 0x03,
> +       ATA_SUBCMD_ZAC_MGMT_OUT_RESET_WRITE_POINTER = 0x04,
> +
>         /* READ_LOG_EXT pages */
>         ATA_LOG_DIRECTORY       = 0x0,
>         ATA_LOG_SATA_NCQ        = 0x10,
> diff --git a/include/trace/events/libata.h b/include/trace/events/libata.h
> index b966417..3032edc 100644
> --- a/include/trace/events/libata.h
> +++ b/include/trace/events/libata.h
> @@ -99,6 +99,7 @@
>                  ata_opcode_name(ATA_CMD_REQ_SENSE_DATA),       \
>                  ata_opcode_name(ATA_CMD_SANITIZE_DEVICE),      \
>                  ata_opcode_name(ATA_CMD_ZAC_MGMT_IN),          \
> +                ata_opcode_name(ATA_CMD_ZAC_MGMT_OUT),         \
>                  ata_opcode_name(ATA_CMD_RESTORE),              \
>                  ata_opcode_name(ATA_CMD_READ_LONG),            \
>                  ata_opcode_name(ATA_CMD_READ_LONG_ONCE),       \
> --
> 1.8.5.6
>

Thanks for adding Open/Close/Finish.

Reviewed-by: Shaun Tancheff <shaun.tancheff@seagate.com>
Tested-by: Shaun Tancheff <shaun.tancheff@seagate.com>

-- 
Shaun Tancheff
