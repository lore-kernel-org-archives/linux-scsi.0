From: Girish K S <girish.shivananjappa@linaro.org>
Subject: Re: [PATCH 2/4] [SCSI] ufshcd: UFS UTP Transfer requests handling
Date: Thu, 9 Feb 2012 01:18:55 +0530
Message-ID: <CAGxe1ZEd_9zMpnfDdWByffKaVWT7z=qUYjJ+HZQFwj=sp6JT9g@mail.gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
	<1328158649-4137-3-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1328158649-4137-3-git-send-email-vinholikatti@gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, arnd@arndb.de, venkat@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, Santosh Yaraganavi <santoshsy@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 2 February 2012 10:27, Vinayak Holikatti <vinholikatti@gmail.com> wr=
ote:
> From: Santosh Yaraganavi <santoshsy@gmail.com>
>
> This patch adds support for Transfer request handling.
>
> ufshcd includes following implementations:
> =A0- SCSI queuecommand
> =A0- Compose UPIU(UFS Protocol information unit)
> =A0- Issue commands to UFS host controller
> =A0- Handle completed commands
>
> Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
> Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Saugata Das <saugata.das@linaro.org>
> Reviewed-by: Vishak G <vishak.g@samsung.com>
> Reviewed-by: Girish K S <girish.shivananjappa@linaro.org>
> ---
> =A0drivers/scsi/ufs/ufshcd.c | =A0447 +++++++++++++++++++++++++++++++=
++++++++++++++
> =A01 files changed, 447 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c82eeea..23d758b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -62,6 +62,7 @@
> =A0#include <scsi/scsi.h>
> =A0#include <scsi/scsi_cmnd.h>
> =A0#include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> =A0#include <scsi/scsi_dbg.h>
>
> =A0#include "ufs.h"
> @@ -81,6 +82,7 @@ enum {
> =A0 =A0 =A0 =A0UFSHCD_MAX_CHANNEL =A0 =A0 =A0=3D 1,
> =A0 =A0 =A0 =A0UFSHCD_MAX_ID =A0 =A0 =A0 =A0 =A0 =3D 1,
> =A0 =A0 =A0 =A0UFSHCD_MAX_LUNS =A0 =A0 =A0 =A0 =3D 8,
> + =A0 =A0 =A0 UFSHCD_CMD_PER_LUN =A0 =A0 =A0=3D 16,
> =A0 =A0 =A0 =A0UFSHCD_CAN_QUEUE =A0 =A0 =A0 =A0=3D 32,
> =A0 =A0 =A0 =A0BYTES_128 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 128,
> =A0 =A0 =A0 =A0BYTES_1024 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D 1024
> @@ -146,6 +148,7 @@ struct uic_command {
> =A0* @host: Scsi_Host instance of the driver
> =A0* @pdev: PCI device handle
> =A0* @lrb: local reference block
> + * @outstanding_reqs: Bits representing outstanding transfer request=
s
> =A0* @capabilities: UFS Controller Capabilities
> =A0* @nutrs: Transfer Request Queue depth supported by controller
> =A0* @nutmrs: Task Management Queue depth supported by controller
> @@ -184,6 +187,8 @@ struct ufs_hba {
>
> =A0 =A0 =A0 =A0struct ufshcd_lrb *lrb;
>
> + =A0 =A0 =A0 u32 outstanding_reqs;
> +
> =A0 =A0 =A0 =A0u32 capabilities;
> =A0 =A0 =A0 =A0int nutrs;
> =A0 =A0 =A0 =A0int nutmrs;
> @@ -204,12 +209,28 @@ struct ufs_hba {
> =A0* @ucd_cmd_ptr: UCD address of the command
> =A0* @ucd_rsp_ptr: Response UPIU address for this command
> =A0* @ucd_prdt_ptr: PRDT address of the command
> + * @cmd: pointer to scsi command
> + * @sense_buffer: pointer sense buffer address of the scsi command
> + * @sense_bufflen: Length of the sense buffer
> + * @scsi_status: SCSI status of the command
> + * @command_type: SCSI, UFS, Query.
> + * @task_tag: Task tag of the command
> + * @lun: LUN of the command
> =A0*/
> =A0struct ufshcd_lrb {
> =A0 =A0 =A0 =A0struct utp_transfer_req_desc *utr_descriptor_ptr;
> =A0 =A0 =A0 =A0struct utp_upiu_cmd *ucd_cmd_ptr;
> =A0 =A0 =A0 =A0struct utp_upiu_rsp *ucd_rsp_ptr;
> =A0 =A0 =A0 =A0struct ufshcd_sg_entry *ucd_prdt_ptr;
> +
> + =A0 =A0 =A0 struct scsi_cmnd *cmd;
> + =A0 =A0 =A0 u8 *sense_buffer;
> + =A0 =A0 =A0 unsigned int sense_bufflen;
> + =A0 =A0 =A0 int scsi_status;
> +
> + =A0 =A0 =A0 int command_type;
> + =A0 =A0 =A0 int task_tag;
> + =A0 =A0 =A0 int lun;
> =A0};
>
> =A0/**
> @@ -236,6 +257,18 @@ static inline int ufshcd_is_device_present(u32 r=
eg_hcs)
> =A0}
>
> =A0/**
> + * ufshcd_get_tr_ocs - Get the UTRD Overall Command Status
> + * @lrb: pointer to local command reference block
> + *
> + * This function is used to get the OCS field from UTRD
> + * Returns the OCS field in the UTRD
> + */
> +static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
> +{
> + =A0 =A0 =A0 return lrbp->utr_descriptor_ptr->header.dword_2 & MASK_=
OCS;
> +}
> +
> +/**
> =A0* ufshcd_get_lists_status - Check UCRDY, UTRLRDY and UTMRLRDY
> =A0* @reg: Register value of host controller status
> =A0*
> @@ -303,6 +336,36 @@ static inline void ufshcd_free_hba_memory(struct=
 ufs_hba *hba)
> =A0}
>
> =A0/**
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
> + =A0 =A0 =A0 return ((be32_to_cpu(ucd_rsp_ptr->header.dword_0) >> 24=
) =3D=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0UPIU_TRANSACTION_RESPONSE) ? 0 :
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 (DID_ERROR << 16 |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0COMMAND_COMPLETE << 8);
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
> + =A0 =A0 =A0 return be32_to_cpu(ucd_rsp_ptr->header.dword_1) & MASK_=
RSP_UPIU_RESULT;
> +}
> +
> +/**
> =A0* ufshcd_config_int_aggr - Configure interrupt aggregation values
> =A0* =A0 =A0 =A0 =A0 =A0 =A0 currently there is no use case where we =
want to configure
> =A0* =A0 =A0 =A0 =A0 =A0 =A0 interrupt aggregation dynamically. So to=
 configure interrupt
> @@ -342,6 +405,34 @@ static inline void ufshcd_hba_stop(struct ufs_hb=
a *hba)
> =A0}
>
> =A0/**
> + * ufshcd_send_command - Send SCSI or device management commands
> + * @hba: per adapter instance
> + * @task_tag: Task tag of the command
> + */
> +static inline
> +void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
> +{
> + =A0 =A0 =A0 hba->outstanding_reqs |=3D (1 << task_tag);
> + =A0 =A0 =A0 writel((1 << task_tag),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(UFSHCD_MMIO_BASE + REG_UTP_TRANSFER_REQ=
_DOOR_BELL));
> +}
> +
> +/**
> + * ufshcd_copy_sense_data - Copy sense data in case of check conditi=
on
> + * @lrb - pointer to local reference block
> + */
> +static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
> +{
> + =A0 =A0 =A0 int len;
> + =A0 =A0 =A0 if (lrbp->sense_buffer !=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D be16_to_cpu(lrbp->ucd_rsp_ptr->=
sense_data_len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(lrbp->sense_buffer,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lrbp->ucd_rsp_ptr->sens=
e_data,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 min_t(int, len, SCSI_SE=
NSE_BUFFERSIZE));
> + =A0 =A0 =A0 }
> +}
> +
> +/**
> =A0* ufshcd_hba_capabilities - Read controller capabilities
> =A0* @hba: per adapter instance
> =A0*/
> @@ -385,6 +476,42 @@ ufshcd_send_uic_command(struct ufs_hba *hba, str=
uct uic_command *uic_cmnd)
> =A0}
>
> =A0/**
> + * ufshcd_map_sg - Map scatter-gather list to prdt
> + * @lrbp - pointer to local reference block
> + */
> +static void ufshcd_map_sg(struct ufshcd_lrb *lrbp)
> +{
> + =A0 =A0 =A0 struct ufshcd_sg_entry *prd_table;
> + =A0 =A0 =A0 struct scatterlist *sg;
> + =A0 =A0 =A0 struct scsi_cmnd *cmd;
> + =A0 =A0 =A0 int sg_segments;
> + =A0 =A0 =A0 int i;
> +
> + =A0 =A0 =A0 cmd =3D lrbp->cmd;
> + =A0 =A0 =A0 sg_segments =3D scsi_dma_map(cmd);
> +
> + =A0 =A0 =A0 BUG_ON(sg_segments < 0);
> +
> + =A0 =A0 =A0 if (sg_segments) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lrbp->utr_descriptor_ptr->prd_table_len=
gth =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cpu_to_le16((u16) (sg_segments));
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 prd_table =3D (struct ufshcd_sg_entry *=
)lrbp->ucd_prdt_ptr;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_for_each_sg(cmd, sg, sg_segments, =
i) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prd_table[i].size =A0=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_=
le32(((u32) sg_dma_len(sg))-1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prd_table[i].base_addr =
=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_=
le32(sg->dma_address);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prd_table[i].upper_addr=
 =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_=
le32((sg->dma_address >> 32));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lrbp->utr_descriptor_ptr->prd_table_len=
gth =3D 0;
> + =A0 =A0 =A0 }
> +}
> +
> +/**
> =A0* ufshcd_int_config - enable/disable interrupts
> =A0* @hba: per adapter instance
> =A0* @option: interrupt option
> @@ -410,6 +537,124 @@ static void ufshcd_int_config(struct ufs_hba *h=
ba, u32 option)
> =A0}
>
> =A0/**
> + * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
> + * @hba: per adapter instance
> + * @lrb - pointer to local reference block
> + */
> +static void ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_l=
rb *lrbp)
> +{
> + =A0 =A0 =A0 struct utp_transfer_req_desc *req_desc;
> + =A0 =A0 =A0 struct utp_upiu_cmd *ucd_cmd_ptr;
> + =A0 =A0 =A0 u32 data_direction;
> + =A0 =A0 =A0 u32 upiu_flags;
> +
> + =A0 =A0 =A0 ucd_cmd_ptr =3D lrbp->ucd_cmd_ptr;
> + =A0 =A0 =A0 req_desc =3D lrbp->utr_descriptor_ptr;
> +
> + =A0 =A0 =A0 memset(ucd_cmd_ptr, 0, sizeof(struct utp_upiu_cmd));
> +
> + =A0 =A0 =A0 switch (lrbp->command_type) {
> + =A0 =A0 =A0 case UTP_CMD_TYPE_SCSI:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (DMA_FROM_DEVICE =3D=3D lrbp->cmd->s=
c_data_direction) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 data_direction =3D UTP_=
DEVICE_TO_HOST;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 upiu_flags =3D UPIU_CMD=
_FLAGS_READ;

=46or a read operation the Spec mentions that flag.F bit should be set
to inform the target that current upiu is the final upiu.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (DMA_TO_DEVICE =3D=3D lrbp->c=
md->sc_data_direction) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 data_direction =3D UTP_=
HOST_TO_DEVICE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 upiu_flags =3D UPIU_CMD=
_FLAGS_WRITE;

During write at some point of time flag.F bit has to be set to tell
the target about the last data out upiu.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 data_direction =3D UTP_=
NO_DATA_TRANSFER;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 upiu_flags =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Transfer request desc header field=
s
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* set interrupt bit if interrupt agg=
regation is disabled
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 req_desc->header.dword_0 =3D cpu_to_le3=
2(data_direction |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0UTP_SCSI_COMMAND);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* assigning invalid value for comman=
d status. Controller
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* updates OCS on command completion,=
 with the command
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* status
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 req_desc->header.dword_2 =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le32(OCS_INVALID=
_COMMAND_STATUS);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* command descriptor fields */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ucd_cmd_ptr->exp_data_transfer_len =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_be32(lrbp->cmd->=
transfersize);

updating expected data transfer length can be ignored if flag.R/W is no=
t set

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ucd_cmd_ptr->cdb, lrbp->cmd->cmn=
d,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (min_t(unsigned short,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lrbp->cmd->c=
md_len,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned sh=
ort)MAX_CDB_SIZE)));

casting is unnecessary  as the macro min_t itself will assign this
value to a unsigned integer

> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ucd_cmd_ptr->header.dword_0 =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_be32(UPIU_HEADER=
_DWORD(UPIU_TRANSACTION_COMMAND,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 upiu_flags,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lrbp->lun,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lrbp->task_tag));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ucd_cmd_ptr->header.dword_1 =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_be32(
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UPIU_HE=
ADER_DWORD(UPIU_COMMAND_SET_TYPE_SCSI,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0));

the macro UPIU_COMMAND_SET_TYPE_SCSI is unnecessary. the
lrbp->command_type can be used. One can be deleted
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* set command response to zero */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(lrbp->ucd_rsp_ptr, 0, sizeof(str=
uct utp_upiu_rsp));

The break is missing here. crucial once the below case is populated
with valid dev management info

> + =A0 =A0 =A0 case UTP_CMD_TYPE_DEV_MANAGE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* For query function implementation */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case UTP_CMD_TYPE_UFS:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* For UFS native command implementatio=
n */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 } /* end of switch, command_type */
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
> + =A0 =A0 =A0 struct ufshcd_lrb *lrbp;
> + =A0 =A0 =A0 struct ufs_hba *hba;
> + =A0 =A0 =A0 unsigned long flags;
> + =A0 =A0 =A0 int tag;
> +
> + =A0 =A0 =A0 hba =3D (struct ufs_hba *) &host->hostdata[0];
> +
> + =A0 =A0 =A0 tag =3D cmd->request->tag;
> +
> + =A0 =A0 =A0 if (UFSHCD_STATE_OPERATIONAL !=3D hba->ufshcd_state)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return SCSI_MLQUEUE_HOST_BUSY;
> +
> + =A0 =A0 =A0 lrbp =3D &hba->lrb[tag];
> +
> + =A0 =A0 =A0 lrbp->cmd =3D cmd;
> + =A0 =A0 =A0 lrbp->sense_bufflen =3D SCSI_SENSE_BUFFERSIZE;
> + =A0 =A0 =A0 lrbp->sense_buffer =3D cmd->sense_buffer;
> + =A0 =A0 =A0 lrbp->task_tag =3D tag;
> + =A0 =A0 =A0 lrbp->lun =3D cmd->device->lun;
> +
> + =A0 =A0 =A0 lrbp->command_type =3D UTP_CMD_TYPE_SCSI;
> +
> + =A0 =A0 =A0 /* form UPIU before issuing the command */
> + =A0 =A0 =A0 ufshcd_compose_upiu(hba, lrbp);
> + =A0 =A0 =A0 ufshcd_map_sg(lrbp);
> +
> + =A0 =A0 =A0 /* issue command to the controller */
> + =A0 =A0 =A0 spin_lock_irqsave(host->host_lock, flags);
> + =A0 =A0 =A0 ufshcd_send_command(hba, tag);
> + =A0 =A0 =A0 spin_unlock_irqrestore(host->host_lock, flags);
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/**
> =A0* ufshcd_memory_alloc - allocate memory for host memory space data=
 structures
> =A0* @hba: per adapter instance
> =A0*
> @@ -680,6 +925,7 @@ static int ufshcd_make_hba_operational(struct ufs=
_hba *hba)
> =A0 =A0 =A0 =A0ufshcd_config_int_aggr(hba, INT_AGGR_CONFIG);
>
> =A0 =A0 =A0 =A0hba->ufshcd_state =3D UFSHCD_STATE_OPERATIONAL;
> + =A0 =A0 =A0 scsi_scan_host(hba->host);
>
> =A0 =A0 =A0 =A0return 0;
> =A0}
> @@ -763,6 +1009,190 @@ static int ufshcd_initialize_hba(struct ufs_hb=
a *hba)
> =A0}
>
> =A0/**
> + * ufshcd_slave_alloc - handle initial scsi devie configurations
> + * @sdev: pointer to scsi device
> + *
> + * Returns success
> + */
> +static int ufshcd_slave_alloc(struct scsi_device *sdev)
> +{
> + =A0 =A0 =A0 struct ufs_hba *hba;
> +
> + =A0 =A0 =A0 hba =3D (struct ufs_hba *)sdev->host->hostdata;
> + =A0 =A0 =A0 sdev->tagged_supported =3D 1;
> + =A0 =A0 =A0 scsi_set_tag_type(sdev, MSG_SIMPLE_TAG);
> + =A0 =A0 =A0 scsi_activate_tcq(sdev, hba->nutrs);
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/**
> + * ufshcd_slave_destroy - remove scsi device configurations
> + * @sdev: pointer to scsi device
> + */
> +static void ufshcd_slave_destroy(struct scsi_device *sdev)
> +{
> + =A0 =A0 =A0 struct ufs_hba *hba;
> +
> + =A0 =A0 =A0 hba =3D (struct ufs_hba *)sdev->host->hostdata;
> + =A0 =A0 =A0 scsi_deactivate_tcq(sdev, hba->nutrs);
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
> + =A0 =A0 =A0 int result =3D 0;
> +
> + =A0 =A0 =A0 switch (scsi_status) {
> + =A0 =A0 =A0 case SAM_STAT_GOOD:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DID_OK << 16 |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 COMMAND_COMPLETE <<=
 8 |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SAM_STAT_GOOD;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case SAM_STAT_CHECK_CONDITION:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DRIVER_SENSE << 24 |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 COMMAND_COMPLETE <<=
 8 |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SAM_STAT_CHECK_COND=
ITION;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ufshcd_copy_sense_data(lrbp);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case SAM_STAT_BUSY:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DID_BUS_BUSY << 16 |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SAM_STAT_BUSY;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case SAM_STAT_TASK_SET_FULL:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DID_OK << 16 |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 COMMAND_COMPLETE <<=
 8 |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SAM_STAT_TASK_SET_F=
ULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case SAM_STAT_TASK_ABORTED:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result |=3D =A0DID_ABORT << 16 |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ABORT_TASK << 8 =
|
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SAM_STAT_TASK_AB=
ORTED;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DID_ERROR << 16;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 } /* end of switch */
> +
> + =A0 =A0 =A0 return result;
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
> + =A0 =A0 =A0 int result =3D 0;
> + =A0 =A0 =A0 int scsi_status;
> + =A0 =A0 =A0 int ocs;
> +
> + =A0 =A0 =A0 /* overall command status of utrd */
> + =A0 =A0 =A0 ocs =3D ufshcd_get_tr_ocs(lrbp);
> +
> + =A0 =A0 =A0 switch (ocs) {
> + =A0 =A0 =A0 case OCS_SUCCESS:
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* check if the returned transfer respo=
nse is valid */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result =3D ufshcd_is_valid_req_rsp(lrbp=
->ucd_rsp_ptr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (result) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_err(UFSHCD ":Invalid=
 Response\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* get the response UPIU result to ex=
tract
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the SCSI command status
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result =3D ufshcd_get_rsp_upiu_result(l=
rbp->ucd_rsp_ptr);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* get the result based on SCSI statu=
s response
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to notify the SCSI midlayer of the=
 command status
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_status =3D result & MASK_SCSI_STAT=
US;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result =3D ufshcd_scsi_cmd_status(lrbp,=
 scsi_status);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case OCS_INVALID_CMD_TABLE_ATTR:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DID_ERROR << 16 | COMMAND_C=
OMPLETE << 8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case OCS_INVALID_PRDT_ATTR:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DID_ERROR << 16 | COMMAND_C=
OMPLETE << 8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case OCS_MISMATCH_DATA_BUF_SIZE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DID_ERROR << 16 | COMMAND_C=
OMPLETE << 8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case OCS_MISMATCH_RESP_UPIU_SIZE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DID_ERROR << 16 | COMMAND_C=
OMPLETE << 8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case OCS_PEER_COMM_FAILURE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DID_ERROR << 16 | COMMAND_C=
OMPLETE << 8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case OCS_ABORTED:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DID_ABORT << 16 | ABORT_TAS=
K << 8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case OCS_FATAL_ERROR:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DID_ERROR << 16 | COMMAND_C=
OMPLETE << 8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* should not come here */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result |=3D DID_ERROR << 16 | COMMAND_C=
OMPLETE << 8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_err(UFSHCD ":Invalid OCS from contro=
ller\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 } /* end of switch */
> +
> + =A0 =A0 =A0 return result;
> +}
> +
> +/**
> + * ufshcd_transfer_req_compl - handle SCSI and query command complet=
ion
> + * @hba: per adapter instance
> + */
> +static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
> +{
> + =A0 =A0 =A0 struct ufshcd_lrb *lrb;
> + =A0 =A0 =A0 u32 completed_reqs;
> + =A0 =A0 =A0 u32 tr_doorbell;
> + =A0 =A0 =A0 int result;
> + =A0 =A0 =A0 int index;
> +
> + =A0 =A0 =A0 lrb =3D hba->lrb;
> + =A0 =A0 =A0 tr_doorbell =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 readl(hba->mmio_base + REG_UTP_TRANSFER=
_REQ_DOOR_BELL);
> + =A0 =A0 =A0 completed_reqs =3D tr_doorbell ^ hba->outstanding_reqs;
> +
> + =A0 =A0 =A0 /* clear completed commands from outstanding_reqs */
> + =A0 =A0 =A0 hba->outstanding_reqs ^=3D completed_reqs;
> +
> + =A0 =A0 =A0 for (index =3D 0; index < hba->nutrs; index++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (completed_reqs & (1 << index)) {
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 result =3D ufshcd_trans=
fer_rsp_status(&lrb[index]);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (NULL !=3D lrb[index=
].cmd) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_dm=
a_unmap(lrb[index].cmd);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lrb[ind=
ex].cmd->result =3D result;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lrb[ind=
ex].cmd->scsi_done(lrb[index].cmd);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Mark=
 completed command as NULL in LRB */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lrb[ind=
ex].cmd =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } /* end of if */
> + =A0 =A0 =A0 } /* end of for */
> +
> + =A0 =A0 =A0 /* Reset interrupt aggregation counters */
> + =A0 =A0 =A0 ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
> +}
> +
> +/**
> =A0* ufshcd_uic_cc_handler - handle UIC command completion
> =A0* @work: pointer to a work queue structure
> =A0*
> @@ -793,6 +1223,9 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, =
u32 intr_status)
> =A0{
> =A0 =A0 =A0 =A0if (intr_status & UIC_COMMAND_COMPL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0schedule_work(&hba->uic_workq);
> +
> + =A0 =A0 =A0 if (intr_status & UTP_TRANSFER_REQ_COMPL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ufshcd_transfer_req_compl(hba);
> =A0}
>
> =A0/**
> @@ -830,7 +1263,13 @@ static struct scsi_host_template ufshcd_driver_=
template =3D {
> =A0 =A0 =A0 =A0.module =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D THIS_MODUL=
E,
> =A0 =A0 =A0 =A0.name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D UFSHCD,
> =A0 =A0 =A0 =A0.proc_name =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D UFSHCD,
> + =A0 =A0 =A0 .queuecommand =A0 =A0 =A0 =A0 =A0 =3D ufshcd_queuecomma=
nd,
> + =A0 =A0 =A0 .slave_alloc =A0 =A0 =A0 =A0 =A0 =A0=3D ufshcd_slave_al=
loc,
> + =A0 =A0 =A0 .slave_destroy =A0 =A0 =A0 =A0 =A0=3D ufshcd_slave_dest=
roy,
> =A0 =A0 =A0 =A0.this_id =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D -1,
> + =A0 =A0 =A0 .sg_tablesize =A0 =A0 =A0 =A0 =A0 =3D SG_ALL,
> + =A0 =A0 =A0 .cmd_per_lun =A0 =A0 =A0 =A0 =A0 =A0=3D UFSHCD_CMD_PER_=
LUN,
> + =A0 =A0 =A0 .can_queue =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D UFSHCD_CAN_QU=
EUE
> =A0};
>
> =A0/**
> @@ -1003,6 +1442,7 @@ ufshcd_probe(struct pci_dev *pdev, const struct=
 pci_device_id *id)
> =A0 =A0 =A0 =A0host->max_lun =3D UFSHCD_MAX_LUNS;
> =A0 =A0 =A0 =A0host->max_channel =3D UFSHCD_MAX_CHANNEL;
> =A0 =A0 =A0 =A0host->unique_id =3D host->host_no;
> + =A0 =A0 =A0 host->max_cmd_len =3D MAX_CDB_SIZE;
>
> =A0 =A0 =A0 =A0/* Initialize work queues */
> =A0 =A0 =A0 =A0INIT_WORK(&hba->uic_workq, ufshcd_uic_cc_handler);
> @@ -1014,6 +1454,13 @@ ufshcd_probe(struct pci_dev *pdev, const struc=
t pci_device_id *id)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_lrb_free;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 /* Enable scsi tag mapping */
> + =A0 =A0 =A0 err =3D scsi_init_shared_tag_map(host, host->can_queue)=
;
> + =A0 =A0 =A0 if (err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "init shared queue =
failed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_irq;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0pci_set_drvdata(pdev, hba);
>
> =A0 =A0 =A0 =A0err =3D scsi_add_host(host, &pdev->dev);
> --
> 1.7.5.4
>
