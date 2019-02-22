From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH -next] scsi: megaraid_sas: Remove a bunch of set but not
 used variables
Date: Fri, 22 Feb 2019 17:46:35 +0530
Message-ID: <CAL2rwxqwQ0AAD1t55rDBkqF=6hsu0AJO5AQDzTwYHF2PhuDpxg@mail.gmail.com>
References: <20190222015858.9744-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190222015858.9744-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>
Cc: Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, jejb@linux.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 22, 2019 at 7:30 AM Yue Haibing <yuehaibing@huawei.com> wrote:
>
> From: YueHaibing <yuehaibing@huawei.com>
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/scsi/megaraid/megaraid_sas_fusion.c: In function 'wait_and_poll':
> drivers/scsi/megaraid/megaraid_sas_fusion.c:936:25: warning:
>  variable 'fusion' set but not used [-Wunused-but-set-variable]
>
> drivers/scsi/megaraid/megaraid_sas_fusion.c: In function 'megasas_sync_map_info':
> drivers/scsi/megaraid/megaraid_sas_fusion.c:1329:6: warning:
>  variable 'size_sync_info' set but not used [-Wunused-but-set-variable]
>
> drivers/scsi/megaraid/megaraid_sas_fusion.c: In function 'megasas_init_adapter_fusion':
> drivers/scsi/megaraid/megaraid_sas_fusion.c:1639:39: warning:
>  variable 'reg_set' set but not used [-Wunused-but-set-variable]
>
> drivers/scsi/megaraid/megaraid_sas_fusion.c: In function 'megasas_is_prp_possible':
> drivers/scsi/megaraid/megaraid_sas_fusion.c:1925:25: warning:
>  variable 'fusion' set but not used [-Wunused-but-set-variable]
>
> drivers/scsi/megaraid/megaraid_sas_fusion.c: In function 'megasas_make_prp_nvme':
> drivers/scsi/megaraid/megaraid_sas_fusion.c:2047:25: warning:
>  variable 'fusion' set but not used [-Wunused-but-set-variable]
>
> drivers/scsi/megaraid/megaraid_sas_fusion.c: In function 'megasas_build_ldio_fusion':
> drivers/scsi/megaraid/megaraid_sas_fusion.c:2620:42: warning:
>  variable 'req_desc' set but not used [-Wunused-but-set-variable]
>
> drivers/scsi/megaraid/megaraid_sas_fusion.c: In function 'megasas_build_and_issue_cmd_fusion':
> drivers/scsi/megaraid/megaraid_sas_fusion.c:3245:25: warning:
>  variable 'fusion' set but not used [-Wunused-but-set-variable]
>
> drivers/scsi/megaraid/megaraid_sas_fusion.c: In function 'megasas_task_abort_fusion':
> drivers/scsi/megaraid/megaraid_sas_fusion.c:4398:25: warning:
>  variable 'fusion' set but not used [-Wunused-but-set-variable]
>
> drivers/scsi/megaraid/megaraid_sas_fusion.c: In function 'megasas_reset_target_fusion':
> drivers/scsi/megaraid/megaraid_sas_fusion.c:4484:25: warning:
>  variable 'fusion' set but not used [-Wunused-but-set-variable]
>
> They're not used anymore and can be removed.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 26 --------------------------
>  1 file changed, 26 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index fd44e00..1d17128 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -937,11 +937,9 @@ wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
>  {
>         int i;
>         struct megasas_header *frame_hdr = &cmd->frame->hdr;
> -       struct fusion_context *fusion;
>
>         u32 msecs = seconds * 1000;
>
> -       fusion = instance->ctrl_context;
>         /*
>          * Wait for cmd_status to change
>          */
> @@ -1331,7 +1329,6 @@ megasas_sync_map_info(struct megasas_instance *instance)
>         struct megasas_cmd *cmd;
>         struct megasas_dcmd_frame *dcmd;
>         u16 num_lds;
> -       u32 size_sync_info;
>         struct fusion_context *fusion;
>         struct MR_LD_TARGET_SYNC *ci = NULL;
>         struct MR_DRV_RAID_MAP_ALL *map;
> @@ -1360,8 +1357,6 @@ megasas_sync_map_info(struct megasas_instance *instance)
>
>         dcmd = &cmd->frame->dcmd;
>
> -       size_sync_info = sizeof(struct MR_LD_TARGET_SYNC) *num_lds;
> -
>         memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
>
>         ci = (struct MR_LD_TARGET_SYNC *)
> @@ -1640,15 +1635,12 @@ static inline void megasas_free_ioc_init_cmd(struct megasas_instance *instance)
>  u32
>  megasas_init_adapter_fusion(struct megasas_instance *instance)
>  {
> -       struct megasas_register_set __iomem *reg_set;
>         struct fusion_context *fusion;
>         u32 scratch_pad_1;
>         int i = 0, count;
>
>         fusion = instance->ctrl_context;
>
> -       reg_set = instance->reg_set;
> -
>         megasas_fusion_update_can_queue(instance, PROBE_CONTEXT);
>
>         /*
> @@ -1927,7 +1919,6 @@ static bool
>  megasas_is_prp_possible(struct megasas_instance *instance,
>                         struct scsi_cmnd *scmd, int sge_count)
>  {
> -       struct fusion_context *fusion;
>         int i;
>         u32 data_length = 0;
>         struct scatterlist *sg_scmd;
> @@ -1936,7 +1927,6 @@ megasas_is_prp_possible(struct megasas_instance *instance,
>
>         mr_nvme_pg_size = max_t(u32, instance->nvme_page_size,
>                                 MR_DEFAULT_NVME_PAGE_SIZE);
> -       fusion = instance->ctrl_context;
>         data_length = scsi_bufflen(scmd);
>         sg_scmd = scsi_sglist(scmd);
>
> @@ -2049,12 +2039,9 @@ megasas_make_prp_nvme(struct megasas_instance *instance, struct scsi_cmnd *scmd,
>         u32 first_prp_len;
>         bool build_prp = false;
>         int data_len = scsi_bufflen(scmd);
> -       struct fusion_context *fusion;
>         u32 mr_nvme_pg_size = max_t(u32, instance->nvme_page_size,
>                                         MR_DEFAULT_NVME_PAGE_SIZE);
>
> -       fusion = instance->ctrl_context;
> -
>         build_prp = megasas_is_prp_possible(instance, scmd, sge_count);
>
>         if (!build_prp)
> @@ -2622,7 +2609,6 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
>         u32 start_lba_lo, start_lba_hi, device_id, datalength = 0;
>         u32 scsi_buff_len;
>         struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
> -       union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
>         struct IO_REQUEST_INFO io_info;
>         struct fusion_context *fusion;
>         struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
> @@ -2645,8 +2631,6 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
>         rctx->status = 0;
>         rctx->ex_status = 0;
>
> -       req_desc = (union MEGASAS_REQUEST_DESCRIPTOR_UNION *)cmd->request_desc;
> -
>         start_lba_lo = 0;
>         start_lba_hi = 0;
>         fp_possible = false;
> @@ -3247,9 +3231,6 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
>         struct megasas_cmd_fusion *cmd, *r1_cmd = NULL;
>         union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
>         u32 index;
> -       struct fusion_context *fusion;
> -
> -       fusion = instance->ctrl_context;
>
>         if ((megasas_cmd_type(scmd) == READ_WRITE_LDIO) &&
>                 instance->ldio_threshold &&
> @@ -4402,14 +4383,11 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
>  {
>         struct megasas_instance *instance;
>         u16 smid, devhandle;
> -       struct fusion_context *fusion;
>         int ret;
>         struct MR_PRIV_DEVICE *mr_device_priv_data;
>         mr_device_priv_data = scmd->device->hostdata;
>
> -
>         instance = (struct megasas_instance *)scmd->device->host->hostdata;
> -       fusion = instance->ctrl_context;
>
>         scmd_printk(KERN_INFO, scmd, "task abort called for scmd(%p)\n", scmd);
>         scsi_print_command(scmd);
> @@ -4429,7 +4407,6 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
>                 goto out;
>         }
>
> -
>         if (!mr_device_priv_data->is_tm_capable) {
>                 ret = FAILED;
>                 goto out;
> @@ -4488,12 +4465,10 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
>         struct megasas_instance *instance;
>         int ret = FAILED;
>         u16 devhandle;
> -       struct fusion_context *fusion;
>         struct MR_PRIV_DEVICE *mr_device_priv_data;
>         mr_device_priv_data = scmd->device->hostdata;
>
>         instance = (struct megasas_instance *)scmd->device->host->hostdata;
> -       fusion = instance->ctrl_context;
>
>         sdev_printk(KERN_INFO, scmd->device,
>                     "target reset called for scmd(%p)\n", scmd);
> @@ -4513,7 +4488,6 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
>                 goto out;
>         }
>
> -
>         if (!mr_device_priv_data->is_tm_capable) {
>                 ret = FAILED;
>                 goto out;
> --
> 2.7.0
>
>
