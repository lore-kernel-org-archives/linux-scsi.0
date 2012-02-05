From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 2/4] [SCSI] ufshcd: UFS UTP Transfer requests handling
Date: Sun, 5 Feb 2012 21:51:24 +0900
Message-ID: <CAKYAXd-F6XruHB_fSs=tBYagf_iYFHHBYN5bGYsLh2H5fXtfkw@mail.gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
	<1328158649-4137-3-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1328158649-4137-3-git-send-email-vinholikatti@gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Yaraganavi <santoshsy@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, arnd@arndb.de, venkat@linaro.org, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com
List-Id: linux-scsi@vger.kernel.org

2012/2/2 Vinayak Holikatti <vinholikatti@gmail.com>:
> From: Santosh Yaraganavi <santoshsy@gmail.com>
>
> This patch adds support for Transfer request handling.
>
> ufshcd includes following implementations:
> =C2=A0- SCSI queuecommand
> =C2=A0- Compose UPIU(UFS Protocol information unit)
> =C2=A0- Issue commands to UFS host controller
> =C2=A0- Handle completed commands
>
> Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
> Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Saugata Das <saugata.das@linaro.org>
> Reviewed-by: Vishak G <vishak.g@samsung.com>
> Reviewed-by: Girish K S <girish.shivananjappa@linaro.org>
> ---
> =C2=A0drivers/scsi/ufs/ufshcd.c | =C2=A0447 +++++++++++++++++++++++++=
++++++++++++++++++++
> =C2=A01 files changed, 447 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c82eeea..23d758b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -62,6 +62,7 @@
> =C2=A0#include <scsi/scsi.h>
> =C2=A0#include <scsi/scsi_cmnd.h>
> =C2=A0#include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> =C2=A0#include <scsi/scsi_dbg.h>
>
> =C2=A0#include "ufs.h"
> @@ -81,6 +82,7 @@ enum {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0UFSHCD_MAX_CHANNEL =C2=A0 =C2=A0 =C2=A0=3D=
 1,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0UFSHCD_MAX_ID =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =3D 1,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0UFSHCD_MAX_LUNS =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =3D 8,
> + =C2=A0 =C2=A0 =C2=A0 UFSHCD_CMD_PER_LUN =C2=A0 =C2=A0 =C2=A0=3D 16,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0UFSHCD_CAN_QUEUE =C2=A0 =C2=A0 =C2=A0 =C2=A0=
=3D 32,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0BYTES_128 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =3D 128,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0BYTES_1024 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D 1024
> @@ -146,6 +148,7 @@ struct uic_command {
> =C2=A0* @host: Scsi_Host instance of the driver
> =C2=A0* @pdev: PCI device handle
> =C2=A0* @lrb: local reference block
> + * @outstanding_reqs: Bits representing outstanding transfer request=
s
> =C2=A0* @capabilities: UFS Controller Capabilities
> =C2=A0* @nutrs: Transfer Request Queue depth supported by controller
> =C2=A0* @nutmrs: Task Management Queue depth supported by controller
> @@ -184,6 +187,8 @@ struct ufs_hba {
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ufshcd_lrb *lrb;
>
> + =C2=A0 =C2=A0 =C2=A0 u32 outstanding_reqs;
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 capabilities;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int nutrs;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int nutmrs;
> @@ -204,12 +209,28 @@ struct ufs_hba {
> =C2=A0* @ucd_cmd_ptr: UCD address of the command
> =C2=A0* @ucd_rsp_ptr: Response UPIU address for this command
> =C2=A0* @ucd_prdt_ptr: PRDT address of the command
> + * @cmd: pointer to scsi command
> + * @sense_buffer: pointer sense buffer address of the scsi command
> + * @sense_bufflen: Length of the sense buffer
> + * @scsi_status: SCSI status of the command
> + * @command_type: SCSI, UFS, Query.
> + * @task_tag: Task tag of the command
> + * @lun: LUN of the command
> =C2=A0*/
> =C2=A0struct ufshcd_lrb {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct utp_transfer_req_desc *utr_descript=
or_ptr;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct utp_upiu_cmd *ucd_cmd_ptr;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct utp_upiu_rsp *ucd_rsp_ptr;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ufshcd_sg_entry *ucd_prdt_ptr;
> +
> + =C2=A0 =C2=A0 =C2=A0 struct scsi_cmnd *cmd;
> + =C2=A0 =C2=A0 =C2=A0 u8 *sense_buffer;
> + =C2=A0 =C2=A0 =C2=A0 unsigned int sense_bufflen;
> + =C2=A0 =C2=A0 =C2=A0 int scsi_status;
> +
> + =C2=A0 =C2=A0 =C2=A0 int command_type;
> + =C2=A0 =C2=A0 =C2=A0 int task_tag;
> + =C2=A0 =C2=A0 =C2=A0 int lun;
> =C2=A0};
>
> =C2=A0/**
> @@ -236,6 +257,18 @@ static inline int ufshcd_is_device_present(u32 r=
eg_hcs)
> =C2=A0}
>
> =C2=A0/**
> + * ufshcd_get_tr_ocs - Get the UTRD Overall Command Status
> + * @lrb: pointer to local command reference block
> + *
> + * This function is used to get the OCS field from UTRD
> + * Returns the OCS field in the UTRD
> + */
> +static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return lrbp->utr_descriptor_ptr->header.dword_=
2 & MASK_OCS;
> +}
> +
> +/**
> =C2=A0* ufshcd_get_lists_status - Check UCRDY, UTRLRDY and UTMRLRDY
> =C2=A0* @reg: Register value of host controller status
> =C2=A0*
> @@ -303,6 +336,36 @@ static inline void ufshcd_free_hba_memory(struct=
 ufs_hba *hba)
> =C2=A0}
>
> =C2=A0/**
> + * ufshcd_is_valid_req_rsp - checks if controller TR response is val=
id
> + * @ucd_rsp_ptr: pointer to response UPIU
> + *
> + * This function checks the response UPIU for valid transaction type=
 in
> + * response field
> + * Returns 0 on success, non-zero on failure
> + */
> +static inline int
> +ufshcd_is_valid_req_rsp(struct utp_upiu_rsp *ucd_rsp_ptr)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return ((be32_to_cpu(ucd_rsp_ptr->header.dword=
_0) >> 24) =3D=3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UPIU_TRANSAC=
TION_RESPONSE) ? 0 :
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 (DID_ERROR << 16 |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0COMMAND_COMPLETE << 8);
> +}
> +
> +/**
> + * ufshcd_get_rsp_upiu_result - Get the result from response UPIU
> + * @ucd_rsp_ptr: pointer to response UPIU
> + *
> + * This function gets the response status and scsi_status from respo=
nse UPIU
> + * Returns the response result code.
> + */
> +static inline int
> +ufshcd_get_rsp_upiu_result(struct utp_upiu_rsp *ucd_rsp_ptr)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return be32_to_cpu(ucd_rsp_ptr->header.dword_1=
) & MASK_RSP_UPIU_RESULT;
> +}
> +
> +/**
> =C2=A0* ufshcd_config_int_aggr - Configure interrupt aggregation valu=
es
> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 currently there is =
no use case where we want to configure
> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 interrupt aggregati=
on dynamically. So to configure interrupt
> @@ -342,6 +405,34 @@ static inline void ufshcd_hba_stop(struct ufs_hb=
a *hba)
> =C2=A0}
>
> =C2=A0/**
> + * ufshcd_send_command - Send SCSI or device management commands
> + * @hba: per adapter instance
> + * @task_tag: Task tag of the command
> + */
> +static inline
> +void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
> +{
> + =C2=A0 =C2=A0 =C2=A0 hba->outstanding_reqs |=3D (1 << task_tag);
> + =C2=A0 =C2=A0 =C2=A0 writel((1 << task_tag),
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(UFSHCD_MMIO_BASE +=
 REG_UTP_TRANSFER_REQ_DOOR_BELL));
> +}
> +
> +/**
> + * ufshcd_copy_sense_data - Copy sense data in case of check conditi=
on
> + * @lrb - pointer to local reference block
> + */
> +static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
> +{
> + =C2=A0 =C2=A0 =C2=A0 int len;
> + =C2=A0 =C2=A0 =C2=A0 if (lrbp->sense_buffer !=3D NULL) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 len =3D be16_to_cp=
u(lrbp->ucd_rsp_ptr->sense_data_len);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(lrbp->sense=
_buffer,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 lrbp->ucd_rsp_ptr->sense_data,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 min_t(int, len, SCSI_SENSE_BUFFERSIZE));
> + =C2=A0 =C2=A0 =C2=A0 }
> +}
> +
> +/**
> =C2=A0* ufshcd_hba_capabilities - Read controller capabilities
> =C2=A0* @hba: per adapter instance
> =C2=A0*/
> @@ -385,6 +476,42 @@ ufshcd_send_uic_command(struct ufs_hba *hba, str=
uct uic_command *uic_cmnd)
> =C2=A0}
>
> =C2=A0/**
> + * ufshcd_map_sg - Map scatter-gather list to prdt
> + * @lrbp - pointer to local reference block
> + */
> +static void ufshcd_map_sg(struct ufshcd_lrb *lrbp)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct ufshcd_sg_entry *prd_table;
> + =C2=A0 =C2=A0 =C2=A0 struct scatterlist *sg;
> + =C2=A0 =C2=A0 =C2=A0 struct scsi_cmnd *cmd;
> + =C2=A0 =C2=A0 =C2=A0 int sg_segments;
> + =C2=A0 =C2=A0 =C2=A0 int i;
> +
> + =C2=A0 =C2=A0 =C2=A0 cmd =3D lrbp->cmd;
> + =C2=A0 =C2=A0 =C2=A0 sg_segments =3D scsi_dma_map(cmd);
> +
> + =C2=A0 =C2=A0 =C2=A0 BUG_ON(sg_segments < 0);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (sg_segments) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lrbp->utr_descript=
or_ptr->prd_table_length =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_=
le16((u16) (sg_segments));
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 prd_table =3D (str=
uct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 scsi_for_each_sg(c=
md, sg, sg_segments, i) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 prd_table[i].size =C2=A0=3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le32(((u32) sg_dma_len(sg))-=
1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 prd_table[i].base_addr =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le32(sg->dma_address);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 prd_table[i].upper_addr =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le32((sg->dma_address >> 32)=
);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 } else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lrbp->utr_descript=
or_ptr->prd_table_length =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 }
> +}
> +
> +/**
> =C2=A0* ufshcd_int_config - enable/disable interrupts
> =C2=A0* @hba: per adapter instance
> =C2=A0* @option: interrupt option
> @@ -410,6 +537,124 @@ static void ufshcd_int_config(struct ufs_hba *h=
ba, u32 option)
> =C2=A0}
>
> =C2=A0/**
> + * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
> + * @hba: per adapter instance
> + * @lrb - pointer to local reference block
> + */
> +static void ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_l=
rb *lrbp)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct utp_transfer_req_desc *req_desc;
> + =C2=A0 =C2=A0 =C2=A0 struct utp_upiu_cmd *ucd_cmd_ptr;
> + =C2=A0 =C2=A0 =C2=A0 u32 data_direction;
> + =C2=A0 =C2=A0 =C2=A0 u32 upiu_flags;
> +
> + =C2=A0 =C2=A0 =C2=A0 ucd_cmd_ptr =3D lrbp->ucd_cmd_ptr;
> + =C2=A0 =C2=A0 =C2=A0 req_desc =3D lrbp->utr_descriptor_ptr;
> +
> + =C2=A0 =C2=A0 =C2=A0 memset(ucd_cmd_ptr, 0, sizeof(struct utp_upiu_=
cmd));
> +
> + =C2=A0 =C2=A0 =C2=A0 switch (lrbp->command_type) {
> + =C2=A0 =C2=A0 =C2=A0 case UTP_CMD_TYPE_SCSI:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (DMA_FROM_DEVIC=
E =3D=3D lrbp->cmd->sc_data_direction) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 data_direction =3D UTP_DEVICE_TO_HOST;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 upiu_flags =3D UPIU_CMD_FLAGS_READ;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (DMA_TO_=
DEVICE =3D=3D lrbp->cmd->sc_data_direction) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 data_direction =3D UTP_HOST_TO_DEVICE;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 upiu_flags =3D UPIU_CMD_FLAGS_WRITE;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 data_direction =3D UTP_NO_DATA_TRANSFER;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 upiu_flags =3D 0;
I think that we can add some enum value for like UTP_NO_DATA_TRANSFER.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Transfer r=
equest desc header fields
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* set interr=
upt bit if interrupt aggregation is disabled
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 req_desc->header.d=
word_0 =3D cpu_to_le32(data_direction |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UTP_SCSI_COMMAND);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* assigning =
invalid value for command status. Controller
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* updates OC=
S on command completion, with the command
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* status
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 req_desc->header.d=
word_2 =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* command descrip=
tor fields */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ucd_cmd_ptr->exp_d=
ata_transfer_len =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cpu_to_be32(lrbp->cmd->transfersize);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(ucd_cmd_ptr=
->cdb, lrbp->cmd->cmnd,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 (min_t(unsigned short,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0lrbp->cmd->cmd_len,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0(unsigned short)MAX_CDB_SIZE)));
Is there any reason type casting for MAX_CDB_SIZE ?

> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ucd_cmd_ptr->heade=
r.dword_0 =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cpu_to_be32(UPIU_HEADER_DWORD(UPIU_TRANSACTION_COMMAND,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 upiu_flags,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lrbp->lun,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lrbp->task_tag));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ucd_cmd_ptr->heade=
r.dword_1 =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cpu_to_be32(
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UPIU_HEADER_DWORD(UPIU_COMMAND_SET_=
TYPE_SCSI,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0));
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* set command res=
ponse to zero */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(lrbp->ucd_r=
sp_ptr, 0, sizeof(struct utp_upiu_rsp));
Why did you set ucd_rsp_ptr to zero afte adding value ?
And plz add break here.
> + =C2=A0 =C2=A0 =C2=A0 case UTP_CMD_TYPE_DEV_MANAGE:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* For query funct=
ion implementation */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case UTP_CMD_TYPE_UFS:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* For UFS native =
command implementation */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 } /* end of switch, command_type */
> +}
> +
> +/**
> + * ufshcd_queuecommand - main entry point for SCSI requests
> + * @cmd: command from SCSI Midlayer
> + * @done: call back function
> + *
> + * Retruns 0 for success, SCSI Midlayer specific error in case of fa=
ilure
> + */
> +static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_c=
mnd *cmd)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct ufshcd_lrb *lrbp;
> + =C2=A0 =C2=A0 =C2=A0 struct ufs_hba *hba;
> + =C2=A0 =C2=A0 =C2=A0 unsigned long flags;
> + =C2=A0 =C2=A0 =C2=A0 int tag;
> +
> + =C2=A0 =C2=A0 =C2=A0 hba =3D (struct ufs_hba *) &host->hostdata[0];
> +
> + =C2=A0 =C2=A0 =C2=A0 tag =3D cmd->request->tag;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (UFSHCD_STATE_OPERATIONAL !=3D hba->ufshcd_=
state)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return SCSI_MLQUEU=
E_HOST_BUSY;
> +
> + =C2=A0 =C2=A0 =C2=A0 lrbp =3D &hba->lrb[tag];
> +
> + =C2=A0 =C2=A0 =C2=A0 lrbp->cmd =3D cmd;
> + =C2=A0 =C2=A0 =C2=A0 lrbp->sense_bufflen =3D SCSI_SENSE_BUFFERSIZE;
> + =C2=A0 =C2=A0 =C2=A0 lrbp->sense_buffer =3D cmd->sense_buffer;
> + =C2=A0 =C2=A0 =C2=A0 lrbp->task_tag =3D tag;
> + =C2=A0 =C2=A0 =C2=A0 lrbp->lun =3D cmd->device->lun;
> +
> + =C2=A0 =C2=A0 =C2=A0 lrbp->command_type =3D UTP_CMD_TYPE_SCSI;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* form UPIU before issuing the command */
> + =C2=A0 =C2=A0 =C2=A0 ufshcd_compose_upiu(hba, lrbp);
> + =C2=A0 =C2=A0 =C2=A0 ufshcd_map_sg(lrbp);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* issue command to the controller */
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(host->host_lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 ufshcd_send_command(hba, tag);
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(host->host_lock, flags)=
;
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +/**
> =C2=A0* ufshcd_memory_alloc - allocate memory for host memory space d=
ata structures
> =C2=A0* @hba: per adapter instance
> =C2=A0*
> @@ -680,6 +925,7 @@ static int ufshcd_make_hba_operational(struct ufs=
_hba *hba)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ufshcd_config_int_aggr(hba, INT_AGGR_CONFI=
G);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0hba->ufshcd_state =3D UFSHCD_STATE_OPERATI=
ONAL;
> + =C2=A0 =C2=A0 =C2=A0 scsi_scan_host(hba->host);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0}
> @@ -763,6 +1009,190 @@ static int ufshcd_initialize_hba(struct ufs_hb=
a *hba)
> =C2=A0}
>
> =C2=A0/**
> + * ufshcd_slave_alloc - handle initial scsi devie configurations
> + * @sdev: pointer to scsi device
> + *
> + * Returns success
> + */
> +static int ufshcd_slave_alloc(struct scsi_device *sdev)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct ufs_hba *hba;
> +
> + =C2=A0 =C2=A0 =C2=A0 hba =3D (struct ufs_hba *)sdev->host->hostdata=
;
> + =C2=A0 =C2=A0 =C2=A0 sdev->tagged_supported =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 scsi_set_tag_type(sdev, MSG_SIMPLE_TAG);
> + =C2=A0 =C2=A0 =C2=A0 scsi_activate_tcq(sdev, hba->nutrs);
> +
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +/**
> + * ufshcd_slave_destroy - remove scsi device configurations
> + * @sdev: pointer to scsi device
> + */
> +static void ufshcd_slave_destroy(struct scsi_device *sdev)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct ufs_hba *hba;
> +
> + =C2=A0 =C2=A0 =C2=A0 hba =3D (struct ufs_hba *)sdev->host->hostdata=
;
> + =C2=A0 =C2=A0 =C2=A0 scsi_deactivate_tcq(sdev, hba->nutrs);
> +}
> +
> +/**
> + * ufshcd_scsi_cmd_status - Update SCSI command result based on scsi=
 status
> + * @lrb: pointer to local reference block of completed command
> + * @scsi_status: SCSI command status
> + *
> + * Returns value base on SCSI command status
> + */
> +static inline int
> +ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status)
> +{
> + =C2=A0 =C2=A0 =C2=A0 int result =3D 0;
> +
> + =C2=A0 =C2=A0 =C2=A0 switch (scsi_status) {
> + =C2=A0 =C2=A0 =C2=A0 case SAM_STAT_GOOD:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result |=3D DID_OK=
 << 16 |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 COMMAND_COMPLETE << 8 |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 SAM_STAT_GOOD;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case SAM_STAT_CHECK_CONDITION:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result |=3D DRIVER=
_SENSE << 24 |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 COMMAND_COMPLETE << 8 |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 SAM_STAT_CHECK_CONDITION;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ufshcd_copy_sense_=
data(lrbp);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case SAM_STAT_BUSY:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result |=3D DID_BU=
S_BUSY << 16 |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 SAM_STAT_BUSY;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case SAM_STAT_TASK_SET_FULL:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result |=3D DID_OK=
 << 16 |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 COMMAND_COMPLETE << 8 |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 SAM_STAT_TASK_SET_FULL;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case SAM_STAT_TASK_ABORTED:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result |=3D =C2=A0=
DID_ABORT << 16 |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0ABORT_TASK << 8 |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0SAM_STAT_TASK_ABORTED;
plz add break here also.
> + =C2=A0 =C2=A0 =C2=A0 default:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result |=3D DID_ER=
ROR << 16;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 } /* end of switch */
> +
> + =C2=A0 =C2=A0 =C2=A0 return result;
> +}
> +
> +/**
> + * ufshcd_transfer_rsp_status - Get overall status of the response
> + * @lrb: pointer to local reference block of completed command
> + *
> + * Returns result of the command to notify SCSI midlayer
> + */
> +static inline int ufshcd_transfer_rsp_status(struct ufshcd_lrb *lrbp=
)
> +{
> + =C2=A0 =C2=A0 =C2=A0 int result =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 int scsi_status;
> + =C2=A0 =C2=A0 =C2=A0 int ocs;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* overall command status of utrd */
> + =C2=A0 =C2=A0 =C2=A0 ocs =3D ufshcd_get_tr_ocs(lrbp);
> +
> + =C2=A0 =C2=A0 =C2=A0 switch (ocs) {
> + =C2=A0 =C2=A0 =C2=A0 case OCS_SUCCESS:
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* check if the re=
turned transfer response is valid */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result =3D ufshcd_=
is_valid_req_rsp(lrbp->ucd_rsp_ptr);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (result) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 pr_err(UFSHCD ":Invalid Response\n");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* get the re=
sponse UPIU result to extract
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* the SCSI c=
ommand status
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result =3D ufshcd_=
get_rsp_upiu_result(lrbp->ucd_rsp_ptr);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* get the re=
sult based on SCSI status response
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* to notify =
the SCSI midlayer of the command status
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 scsi_status =3D re=
sult & MASK_SCSI_STATUS;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result =3D ufshcd_=
scsi_cmd_status(lrbp, scsi_status);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case OCS_INVALID_CMD_TABLE_ATTR:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result |=3D DID_ER=
ROR << 16 | COMMAND_COMPLETE << 8;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case OCS_INVALID_PRDT_ATTR:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result |=3D DID_ER=
ROR << 16 | COMMAND_COMPLETE << 8;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case OCS_MISMATCH_DATA_BUF_SIZE:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result |=3D DID_ER=
ROR << 16 | COMMAND_COMPLETE << 8;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case OCS_MISMATCH_RESP_UPIU_SIZE:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result |=3D DID_ER=
ROR << 16 | COMMAND_COMPLETE << 8;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case OCS_PEER_COMM_FAILURE:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result |=3D DID_ER=
ROR << 16 | COMMAND_COMPLETE << 8;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case OCS_ABORTED:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result |=3D DID_AB=
ORT << 16 | ABORT_TASK << 8;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case OCS_FATAL_ERROR:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result |=3D DID_ER=
ROR << 16 | COMMAND_COMPLETE << 8;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 default:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* should not come=
 here */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result |=3D DID_ER=
ROR << 16 | COMMAND_COMPLETE << 8;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_err(UFSHCD ":In=
valid OCS from controller\n");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 } /* end of switch */
> +
> + =C2=A0 =C2=A0 =C2=A0 return result;
> +}
> +
> +/**
> + * ufshcd_transfer_req_compl - handle SCSI and query command complet=
ion
> + * @hba: per adapter instance
> + */
> +static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct ufshcd_lrb *lrb;
> + =C2=A0 =C2=A0 =C2=A0 u32 completed_reqs;
> + =C2=A0 =C2=A0 =C2=A0 u32 tr_doorbell;
> + =C2=A0 =C2=A0 =C2=A0 int result;
> + =C2=A0 =C2=A0 =C2=A0 int index;
> +
> + =C2=A0 =C2=A0 =C2=A0 lrb =3D hba->lrb;
> + =C2=A0 =C2=A0 =C2=A0 tr_doorbell =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 readl(hba->mmio_ba=
se + REG_UTP_TRANSFER_REQ_DOOR_BELL);
> + =C2=A0 =C2=A0 =C2=A0 completed_reqs =3D tr_doorbell ^ hba->outstand=
ing_reqs;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* clear completed commands from outstanding_r=
eqs */
> + =C2=A0 =C2=A0 =C2=A0 hba->outstanding_reqs ^=3D completed_reqs;
> +
> + =C2=A0 =C2=A0 =C2=A0 for (index =3D 0; index < hba->nutrs; index++)=
 {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (completed_reqs=
 & (1 << index)) {
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 result =3D ufshcd_transfer_rsp_status(&lrb[index]);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (NULL !=3D lrb[index].cmd) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 scsi_dma_unmap(lrb[index].cmd);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lrb[index].cmd->result =3D result;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lrb[index].cmd->scsi_done(lrb[index=
].cmd);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Mark completed command as NULL i=
n LRB */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lrb[index].cmd =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } /* end of if */
> + =C2=A0 =C2=A0 =C2=A0 } /* end of for */
> +
> + =C2=A0 =C2=A0 =C2=A0 /* Reset interrupt aggregation counters */
> + =C2=A0 =C2=A0 =C2=A0 ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
> +}
> +
> +/**
> =C2=A0* ufshcd_uic_cc_handler - handle UIC command completion
> =C2=A0* @work: pointer to a work queue structure
> =C2=A0*
> @@ -793,6 +1223,9 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, =
u32 intr_status)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (intr_status & UIC_COMMAND_COMPL)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0schedule_work(=
&hba->uic_workq);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (intr_status & UTP_TRANSFER_REQ_COMPL)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ufshcd_transfer_re=
q_compl(hba);
> =C2=A0}
>
> =C2=A0/**
> @@ -830,7 +1263,13 @@ static struct scsi_host_template ufshcd_driver_=
template =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.module =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =3D THIS_MODULE,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =3D UFSHCD,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.proc_name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D UFSHCD,
> + =C2=A0 =C2=A0 =C2=A0 .queuecommand =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =3D ufshcd_queuecommand,
> + =C2=A0 =C2=A0 =C2=A0 .slave_alloc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0=3D ufshcd_slave_alloc,
> + =C2=A0 =C2=A0 =C2=A0 .slave_destroy =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=3D ufshcd_slave_destroy,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.this_id =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0=3D -1,
> + =C2=A0 =C2=A0 =C2=A0 .sg_tablesize =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =3D SG_ALL,
> + =C2=A0 =C2=A0 =C2=A0 .cmd_per_lun =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0=3D UFSHCD_CMD_PER_LUN,
> + =C2=A0 =C2=A0 =C2=A0 .can_queue =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0=3D UFSHCD_CAN_QUEUE
> =C2=A0};
>
> =C2=A0/**
> @@ -1003,6 +1442,7 @@ ufshcd_probe(struct pci_dev *pdev, const struct=
 pci_device_id *id)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0host->max_lun =3D UFSHCD_MAX_LUNS;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0host->max_channel =3D UFSHCD_MAX_CHANNEL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0host->unique_id =3D host->host_no;
> + =C2=A0 =C2=A0 =C2=A0 host->max_cmd_len =3D MAX_CDB_SIZE;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Initialize work queues */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_WORK(&hba->uic_workq, ufshcd_uic_cc_h=
andler);
> @@ -1014,6 +1454,13 @@ ufshcd_probe(struct pci_dev *pdev, const struc=
t pci_device_id *id)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_lrb_f=
ree;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> + =C2=A0 =C2=A0 =C2=A0 /* Enable scsi tag mapping */
> + =C2=A0 =C2=A0 =C2=A0 err =3D scsi_init_shared_tag_map(host, host->c=
an_queue);
> + =C2=A0 =C2=A0 =C2=A0 if (err) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dev_err(&pdev->dev=
, "init shared queue failed\n");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_free_irq;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0pci_set_drvdata(pdev, hba);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D scsi_add_host(host, &pdev->dev);
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
