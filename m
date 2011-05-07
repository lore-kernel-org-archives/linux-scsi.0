From: Madhu Iyengar <madhu.iyengar@qlogic.com>
Subject: RE: [PATCH 12/12] qla2xxx: Provide method for updating I2C attached
 VPD.
Date: Fri, 6 May 2011 18:28:38 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8728AC7EC59@AVEXMB1.qlogic.org>
References: <1304728223-30817-1-git-send-email-madhu.iyengar@qlogic.com>
 <1304728223-30817-18-git-send-email-madhu.iyengar@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.181]:14678
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375Ab1EGB2o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2011 21:28:44 -0400
In-Reply-To: <1304728223-30817-18-git-send-email-madhu.iyengar@qlogic.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Madhu Iyengar <madhu.iyengar@qlogic.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Joe Carnuccio <joe.carnuccio@qlogic.com>

James,

We submitted this patch by mistake. Can you drop this patch?

We still would appreciate for you to consider the 11 scsi-misc patches in this set, and the 4 scsi-rc patches we sent today.

Thanks,
Madhu

> -----Original Message-----
> From: madhu.iyengar@qlogic.com [mailto:madhu.iyengar@qlogic.com]
> Sent: Friday, May 06, 2011 5:30 PM
> To: James.Bottomley@suse.de
> Cc: Giridhar Malavali; Madhu Iyengar; Andrew Vasquez; linux-
> scsi@vger.kernel.org; Joe Carnuccio
> Subject: [PATCH 12/12] qla2xxx: Provide method for updating I2C attached
> VPD.
>
> From: Joe Carnuccio <joe.carnuccio@qlogic.com>
>
> Provide bsg interface for updating VPD attached on the I2C serial bus.
>
> Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
> Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_bsg.c |  151
> ++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_bsg.h |   42 +++++++++++
>  2 files changed, 193 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c
> b/drivers/scsi/qla2xxx/qla_bsg.c
> index 8c10e2c..e6c851f 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -1426,6 +1426,148 @@ qla2x00_update_optrom(struct fc_bsg_job *bsg_job)
>  }
>
>  static int
> +qla2x00_update_fru_versions(struct fc_bsg_job *bsg_job)
> +{
> +     struct Scsi_Host *host = bsg_job->shost;
> +     scsi_qla_host_t *vha = shost_priv(host);
> +     struct qla_hw_data *ha = vha->hw;
> +     int rval = 0;
> +     uint8_t bsg[DMA_POOL_SIZE];
> +     struct qla_image_version_list *list = (void *)bsg;
> +     struct qla_image_version *image;
> +     uint32_t count;
> +     dma_addr_t sfp_dma;
> +     void *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
> +     if (!sfp) {
> +             bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
> +                 EXT_STATUS_NO_MEMORY;
> +             goto done;
> +     }
> +
> +     sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +         bsg_job->request_payload.sg_cnt, list, sizeof(bsg));
> +
> +     image = list->version;
> +     count = list->count;
> +     while (count--) {
> +             memcpy(sfp, &image->field_info, sizeof(image->field_info));
> +             rval = qla2x00_write_sfp(vha, sfp_dma, sfp,
> +                 image->field_address.device, image->field_address.offset,
> +                 sizeof(image->field_info), image->field_address.option);
> +             if (rval) {
> +                     bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
> +                         EXT_STATUS_MAILBOX;
> +                     goto dealloc;
> +             }
> +             image++;
> +     }
> +
> +     bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
> +
> +dealloc:
> +     dma_pool_free(ha->s_dma_pool, sfp, sfp_dma);
> +
> +done:
> +     bsg_job->reply_len = sizeof(struct fc_bsg_reply);
> +     bsg_job->reply->result = DID_OK << 16;
> +     bsg_job->job_done(bsg_job);
> +
> +     return 0;
> +}
> +
> +static int
> +qla2x00_read_fru_status(struct fc_bsg_job *bsg_job)
> +{
> +     struct Scsi_Host *host = bsg_job->shost;
> +     scsi_qla_host_t *vha = shost_priv(host);
> +     struct qla_hw_data *ha = vha->hw;
> +     int rval = 0;
> +     uint8_t bsg[DMA_POOL_SIZE];
> +     struct qla_status_reg *sr = (void *)bsg;
> +     dma_addr_t sfp_dma;
> +     uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
> +     if (!sfp) {
> +             bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
> +                 EXT_STATUS_NO_MEMORY;
> +             goto done;
> +     }
> +
> +     sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +         bsg_job->request_payload.sg_cnt, sr, sizeof(*sr));
> +
> +     rval = qla2x00_read_sfp(vha, sfp_dma, sfp,
> +         sr->field_address.device, sr->field_address.offset,
> +         sizeof(sr->status_reg), sr->field_address.option);
> +     sr->status_reg = *sfp;
> +
> +     if (rval) {
> +             bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
> +                 EXT_STATUS_MAILBOX;
> +             goto dealloc;
> +     }
> +
> +     sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +         bsg_job->reply_payload.sg_cnt, sr, sizeof(*sr));
> +
> +     bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
> +
> +dealloc:
> +     dma_pool_free(ha->s_dma_pool, sfp, sfp_dma);
> +
> +done:
> +     bsg_job->reply_len = sizeof(struct fc_bsg_reply);
> +     bsg_job->reply->reply_payload_rcv_len = sizeof(*sr);
> +     bsg_job->reply->result = DID_OK << 16;
> +     bsg_job->job_done(bsg_job);
> +
> +     return 0;
> +}
> +
> +static int
> +qla2x00_write_fru_status(struct fc_bsg_job *bsg_job)
> +{
> +     struct Scsi_Host *host = bsg_job->shost;
> +     scsi_qla_host_t *vha = shost_priv(host);
> +     struct qla_hw_data *ha = vha->hw;
> +     int rval = 0;
> +     uint8_t bsg[DMA_POOL_SIZE];
> +     struct qla_status_reg *sr = (void *)bsg;
> +     dma_addr_t sfp_dma;
> +     uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
> +     if (!sfp) {
> +             bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
> +                 EXT_STATUS_NO_MEMORY;
> +             goto done;
> +     }
> +
> +     sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +         bsg_job->request_payload.sg_cnt, sr, sizeof(*sr));
> +
> +     *sfp = sr->status_reg;
> +     rval = qla2x00_write_sfp(vha, sfp_dma, sfp,
> +         sr->field_address.device, sr->field_address.offset,
> +         sizeof(sr->status_reg), sr->field_address.option);
> +
> +     if (rval) {
> +             bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =
> +                 EXT_STATUS_MAILBOX;
> +             goto dealloc;
> +     }
> +
> +     bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = 0;
> +
> +dealloc:
> +     dma_pool_free(ha->s_dma_pool, sfp, sfp_dma);
> +
> +done:
> +     bsg_job->reply_len = sizeof(struct fc_bsg_reply);
> +     bsg_job->reply->result = DID_OK << 16;
> +     bsg_job->job_done(bsg_job);
> +
> +     return 0;
> +}
> +
> +static int
>  qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
>  {
>       switch (bsg_job->request->rqst_data.h_vendor.vendor_cmd[0]) {
> @@ -1453,6 +1595,15 @@ qla2x00_process_vendor_specific(struct fc_bsg_job
> *bsg_job)
>       case QL_VND_UPDATE_FLASH:
>               return qla2x00_update_optrom(bsg_job);
>
> +     case QL_VND_SET_FRU_VERSION:
> +             return qla2x00_update_fru_versions(bsg_job);
> +
> +     case QL_VND_READ_FRU_STATUS:
> +             return qla2x00_read_fru_status(bsg_job);
> +
> +     case QL_VND_WRITE_FRU_STATUS:
> +             return qla2x00_write_fru_status(bsg_job);
> +
>       default:
>               bsg_job->reply->result = (DID_ERROR << 16);
>               bsg_job->job_done(bsg_job);
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.h
> b/drivers/scsi/qla2xxx/qla_bsg.h
> index 0f0f54e..70caa63 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.h
> +++ b/drivers/scsi/qla2xxx/qla_bsg.h
> @@ -16,6 +16,16 @@
>  #define QL_VND_FCP_PRIO_CFG_CMD      0x06
>  #define QL_VND_READ_FLASH    0x07
>  #define QL_VND_UPDATE_FLASH  0x08
> +#define QL_VND_SET_FRU_VERSION       0x0B
> +#define QL_VND_READ_FRU_STATUS       0x0C
> +#define QL_VND_WRITE_FRU_STATUS      0x0D
> +
> +/* BSG Vendor specific subcode returns */
> +#define EXT_STATUS_OK                        0
> +#define EXT_STATUS_ERR                       1
> +#define EXT_STATUS_INVALID_PARAM     6
> +#define EXT_STATUS_MAILBOX           11
> +#define EXT_STATUS_NO_MEMORY         17
>
>  /* BSG definations for interpreting CommandSent field */
>  #define INT_DEF_LB_LOOPBACK_CMD         0
> @@ -141,4 +151,36 @@ struct qla_port_param {
>       uint16_t mode;
>       uint16_t speed;
>  } __attribute__ ((packed));
> +
> +
> +/* FRU VPD */
> +
> +#define MAX_FRU_SIZE 36
> +
> +struct qla_field_address {
> +     uint16_t offset;
> +     uint16_t device;
> +     uint16_t option;
> +} __packed;
> +
> +struct qla_field_info {
> +     uint8_t version[MAX_FRU_SIZE];
> +} __packed;
> +
> +struct qla_image_version {
> +     struct qla_field_address field_address;
> +     struct qla_field_info field_info;
> +} __packed;
> +
> +struct qla_image_version_list {
> +     uint32_t count;
> +     struct qla_image_version version[0];
> +} __packed;
> +
> +struct qla_status_reg {
> +     struct qla_field_address field_address;
> +     uint8_t status_reg;
> +     uint8_t reserved[7];
> +} __packed;
> +
>  #endif
> --
> 1.6.0.2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

