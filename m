From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: RE: [PATCH 2/2] replace sizeof sense_buffer with
 SCSI_SENSE_BUFFERSIZE
Date: Mon, 14 Jan 2008 05:24:13 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F438AEA880@ADPE2K703.adaptec.com>
References: <457feffcfc40101ad9884914d8f223cd425ee5b6.tomof@acm.org>
 <a789287f8ac2eef0d95c6cbb08f68c122b5f7ec4.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:52006 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbYANNYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 08:24:18 -0500
In-Reply-To: <a789287f8ac2eef0d95c6cbb08f68c122b5f7ec4.tomof@acm.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'FUJITA Tomonori' <tomof@acm.org>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'fujita.tomonori@lab.ntt.co.jp'" <fujita.tomonori@lab.ntt.co.jp>

ACK on ips, aacraid and dpt_i2o bits. Cursory inspection of other bits as well. Thanks Fujita, looks good!

Will do a 'min()' cleanup on aacraid once patch propagates into scsi-misc-2.6

Sincerely -- Mark Salyzyn

cur*so*ry - adjective
        going rapidly over something, without noticing details; hasty; superficial. spedd reeding

. . .
> o This is a 'grep and replace' style patch but cleans up dpt_i2o a bit
> as by permission of Mark (I use min macro).
>
> o The previous version overlooked some sizeof sense_buffer lines in
> aacraid and qla4xxx.
. . .
> diff --git a/drivers/scsi/aacraid/aachba.c
> b/drivers/scsi/aacraid/aachba.c
> index 62d9516..aadedbd 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -912,8 +912,8 @@ static int aac_bounds_32(struct aac_dev *
> dev, struct scsi_cmnd * cmd, u64 lba)
>                             ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
>                             0, 0);
>                 memcpy(cmd->sense_buffer,
> &dev->fsa_dev[cid].sense_data,
> -                 (sizeof(dev->fsa_dev[cid].sense_data) >
> sizeof(cmd->sense_buffer))
> -                   ? sizeof(cmd->sense_buffer)
> +                 (sizeof(dev->fsa_dev[cid].sense_data) >
> SCSI_SENSE_BUFFERSIZE)
> +                   ? SCSI_SENSE_BUFFERSIZE
>                     : sizeof(dev->fsa_dev[cid].sense_data));
>                 cmd->scsi_done(cmd);
>                 return 1;
> @@ -1525,8 +1525,8 @@ static void io_callback(void *context,
> struct fib * fibptr)
>
> ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
>                                     0, 0);
>                 memcpy(scsicmd->sense_buffer,
> &dev->fsa_dev[cid].sense_data,
> -                 (sizeof(dev->fsa_dev[cid].sense_data) >
> sizeof(scsicmd->sense_buffer))
> -                   ? sizeof(scsicmd->sense_buffer)
> +                 (sizeof(dev->fsa_dev[cid].sense_data) >
> SCSI_SENSE_BUFFERSIZE)
> +                   ? SCSI_SENSE_BUFFERSIZE
>                     : sizeof(dev->fsa_dev[cid].sense_data));
>         }
>         aac_fib_complete(fibptr);
> @@ -1739,8 +1739,8 @@ static void synchronize_callback(void
> *context, struct fib *fibptr)
>
> ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
>                                     0, 0);
>                 memcpy(cmd->sense_buffer,
> &dev->fsa_dev[cid].sense_data,
> -                 min(sizeof(dev->fsa_dev[cid].sense_data),
> -                         sizeof(cmd->sense_buffer)));
> +                      min_t(size_t,
> sizeof(dev->fsa_dev[cid].sense_data),
> +                            SCSI_SENSE_BUFFERSIZE));
>         }
>
>         aac_fib_complete(fibptr);
> @@ -1949,8 +1949,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>                             SENCODE_INVALID_COMMAND,
>                             ASENCODE_INVALID_COMMAND, 0, 0, 0, 0);
>                 memcpy(scsicmd->sense_buffer,
> &dev->fsa_dev[cid].sense_data,
> -                 (sizeof(dev->fsa_dev[cid].sense_data) >
> sizeof(scsicmd->sense_buffer))
> -                   ? sizeof(scsicmd->sense_buffer)
> +                 (sizeof(dev->fsa_dev[cid].sense_data) >
> SCSI_SENSE_BUFFERSIZE)
> +                   ? SCSI_SENSE_BUFFERSIZE
>                     : sizeof(dev->fsa_dev[cid].sense_data));
>                 scsicmd->scsi_done(scsicmd);
>                 return 0;
> @@ -2002,8 +2002,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>                                 memcpy(scsicmd->sense_buffer,
>                                   &dev->fsa_dev[cid].sense_data,
>
> (sizeof(dev->fsa_dev[cid].sense_data) >
> -                                   sizeof(scsicmd->sense_buffer))
> -                                      ? sizeof(scsicmd->sense_buffer)
> +                                   SCSI_SENSE_BUFFERSIZE)
> +                                      ? SCSI_SENSE_BUFFERSIZE
>                                        :
> sizeof(dev->fsa_dev[cid].sense_data));
>                         }
>                         scsicmd->scsi_done(scsicmd);
> @@ -2259,8 +2259,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>                                 ILLEGAL_REQUEST,
> SENCODE_INVALID_COMMAND,
>                                 ASENCODE_INVALID_COMMAND, 0, 0, 0, 0);
>                         memcpy(scsicmd->sense_buffer,
> &dev->fsa_dev[cid].sense_data,
> -
> (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(scsicmd->sense_buffer))
> -                           ? sizeof(scsicmd->sense_buffer)
> +
> (sizeof(dev->fsa_dev[cid].sense_data) > SCSI_SENSE_BUFFERSIZE)
> +                           ? SCSI_SENSE_BUFFERSIZE
>                             : sizeof(dev->fsa_dev[cid].sense_data));
>                         scsicmd->scsi_done(scsicmd);
>                         return 0;
> @@ -2422,8 +2422,8 @@ static void aac_srb_callback(void
> *context, struct fib * fibptr)
>                 int len;
>                 printk(KERN_WARNING "aac_srb_callback: srb
> failed, status = %d\n", le32_to_cpu(srbreply->status));
>                 len = (le32_to_cpu(srbreply->sense_data_size) >
> -                               sizeof(scsicmd->sense_buffer)) ?
> -                               sizeof(scsicmd->sense_buffer) :
> +                               SCSI_SENSE_BUFFERSIZE) ?
> +                               SCSI_SENSE_BUFFERSIZE :
>
> le32_to_cpu(srbreply->sense_data_size);
>                 scsicmd->result = DID_ERROR << 16 |
> COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
>                 memcpy(scsicmd->sense_buffer,
> srbreply->sense_data, len);
> @@ -2528,8 +2528,8 @@ static void aac_srb_callback(void
> *context, struct fib * fibptr)
>                 int len;
>                 scsicmd->result |= SAM_STAT_CHECK_CONDITION;
>                 len = (le32_to_cpu(srbreply->sense_data_size) >
> -                               sizeof(scsicmd->sense_buffer)) ?
> -                               sizeof(scsicmd->sense_buffer) :
> +                               SCSI_SENSE_BUFFERSIZE) ?
> +                               SCSI_SENSE_BUFFERSIZE :
>
> le32_to_cpu(srbreply->sense_data_size);
>  #ifdef AAC_DETAILED_STATUS_INFO
>                 printk(KERN_WARNING "aac_srb_callback: check
> condition, status = %d len=%d\n",
. . .
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index b31d1c9..577b34c 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -2296,9 +2296,8 @@ static s32 adpt_i2o_to_scsi(void
> __iomem *reply, struct scsi_cmnd* cmd)
>
>                 // copy over the request sense data if it was a check
>                 // condition status
> -               if(dev_status == 0x02 /*CHECK_CONDITION*/) {
> -                       u32 len = sizeof(cmd->sense_buffer);
> -                       len = (len > 40) ?  40 : len;
> +               if (dev_status == 0x02 /*CHECK_CONDITION*/) {
> +                       u32 len = min(SCSI_SENSE_BUFFERSIZE, 40);
>                         // Copy over the sense data
>                         memcpy_fromio(cmd->sense_buffer,
> (reply+28) , len);
>                         if(cmd->sense_buffer[0] == 0x70 /*
> class 7 */ &&
. . .
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index b1b2295..f44993f 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -3433,13 +3433,11 @@ ips_map_status(ips_ha_t * ha,
> ips_scb_t * scb, ips_stat_t * sp)
>
> (IPS_DCDB_TABLE_TAPE *) & scb->dcdb;
>
> memcpy(scb->scsi_cmd->sense_buffer,
>                                                tapeDCDB->sense_info,
> -                                              sizeof (scb->scsi_cmd->
> -                                                      sense_buffer));
> +
> SCSI_SENSE_BUFFERSIZE);
>                                 } else {
>
> memcpy(scb->scsi_cmd->sense_buffer,
>                                                scb->dcdb.sense_info,
> -                                              sizeof (scb->scsi_cmd->
> -                                                      sense_buffer));
> +
> SCSI_SENSE_BUFFERSIZE);
>                                 }
>                                 device_error = 2;       /*
> check condition */
>                         }
. . .
