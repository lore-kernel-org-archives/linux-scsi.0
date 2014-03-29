From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 29/55] scsi: Mark functions as static in
 megaraid/megaraid_sas_fusion.c
Date: Sat, 29 Mar 2014 23:46:50 +0530
Message-ID: <a0017455228e59c42db9004e315b69e763e25aa3.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark functions as static in megaraid/megaraid_sas_fusion.c because they
are not used outside this file.

This eliminates the warnings of following type in
megaraid/megaraid_sas_fusion.c:
drivers/scsi/megaraid/megaraid_sas_fusion.c:91:1: warning: no previous =
prototype for =E2=80=98megasas_enable_intr_fusion=E2=80=99 [-Wmissing-p=
rototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   39 ++++++++++++++-----=
--------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi=
/megaraid/megaraid_sas_fusion.c
index 2806d6d..ce6219c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -74,7 +74,7 @@ extern int resetwaittime;
  * megasas_enable_intr_fusion -	Enables interrupts
  * @regs:			MFI register set
  */
-void
+static void
 megasas_enable_intr_fusion(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *regs;
@@ -94,7 +94,7 @@ megasas_enable_intr_fusion(struct megasas_instance *i=
nstance)
  * megasas_disable_intr_fusion - Disables interrupt
  * @regs:			 MFI register set
  */
-void
+static void
 megasas_disable_intr_fusion(struct megasas_instance *instance)
 {
 	u32 mask =3D 0xFFFFFFFF;
@@ -134,8 +134,8 @@ megasas_clear_intr_fusion(struct megasas_register_s=
et __iomem *regs)
  *
  * Returns a free command from the pool
  */
-struct megasas_cmd_fusion *megasas_get_cmd_fusion(struct megasas_insta=
nce
-						  *instance)
+static struct megasas_cmd_fusion *megasas_get_cmd_fusion(
+				  struct megasas_instance *instance)
 {
 	unsigned long flags;
 	struct fusion_context *fusion =3D
@@ -363,7 +363,7 @@ static int megasas_create_frame_pool_fusion(struct =
megasas_instance *instance)
  * and is used as SMID of the cmd.
  * SMID value range is from 1 to max_fw_cmds.
  */
-int
+static int
 megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 {
 	int i, j, count;
@@ -919,7 +919,7 @@ megasas_display_intel_branding(struct megasas_insta=
nce *instance)
  *
  * This is the main function for initializing firmware.
  */
-u32
+static u32
 megasas_init_adapter_fusion(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *reg_set;
@@ -1037,7 +1037,7 @@ fail_alloc_mfi_cmds:
  * @frame_count :		Number of frames for the command
  * @regs :			MFI register set
  */
-void
+static void
 megasas_fire_cmd_fusion(struct megasas_instance *instance,
 			dma_addr_t req_desc_lo,
 			u32 req_desc_hi,
@@ -1059,7 +1059,7 @@ megasas_fire_cmd_fusion(struct megasas_instance *=
instance,
  * @ext_status :	ext status of cmd returned by FW
  */
=20
-void
+static void
 map_cmd_status(struct megasas_cmd_fusion *cmd, u8 status, u8 ext_statu=
s)
 {
=20
@@ -1199,7 +1199,7 @@ megasas_make_sgl_fusion(struct megasas_instance *=
instance,
  *
  * Used to set the PD LBA in CDB for FP IOs
  */
-void
+static void
 megasas_set_pd_lba(struct MPI2_RAID_SCSI_IO_REQUEST *io_request, u8 cd=
b_len,
 		   struct IO_REQUEST_INFO *io_info, struct scsi_cmnd *scp,
 		   struct MR_FW_RAID_MAP_ALL *local_map_ptr, u32 ref_tag)
@@ -1376,7 +1376,7 @@ megasas_set_pd_lba(struct MPI2_RAID_SCSI_IO_REQUE=
ST *io_request, u8 cdb_len,
  * Prepares the io_request and chain elements (sg_frame) for IO
  * The IO can be for PD (Fast Path) or LD
  */
-void
+static void
 megasas_build_ldio_fusion(struct megasas_instance *instance,
 			  struct scsi_cmnd *scp,
 			  struct megasas_cmd_fusion *cmd)
@@ -1678,7 +1678,7 @@ NonFastPath:
  * Invokes helper functions to prepare request frames
  * and sets flags appropriate for IO/Non-IO cmd
  */
-int
+static int
 megasas_build_io_fusion(struct megasas_instance *instance,
 			struct scsi_cmnd *scp,
 			struct megasas_cmd_fusion *cmd)
@@ -1749,7 +1749,7 @@ megasas_build_io_fusion(struct megasas_instance *=
instance,
 	return 0;
 }
=20
-union MEGASAS_REQUEST_DESCRIPTOR_UNION *
+static union MEGASAS_REQUEST_DESCRIPTOR_UNION *
 megasas_get_request_descriptor(struct megasas_instance *instance, u16 =
index)
 {
 	u8 *p;
@@ -1829,7 +1829,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas=
_instance *instance,
  * @instance:			Adapter soft state
  * Completes all commands that is in reply descriptor queue
  */
-int
+static int
 complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 {
 	union MPI2_REPLY_DESCRIPTORS_UNION *desc;
@@ -1974,7 +1974,7 @@ complete_cmd_fusion(struct megasas_instance *inst=
ance, u32 MSIxIndex)
  *
  * Tasklet to complete cmds
  */
-void
+static void
 megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
 {
 	struct megasas_instance *instance =3D
@@ -1999,7 +1999,7 @@ megasas_complete_cmd_dpc_fusion(unsigned long ins=
tance_addr)
 /**
  * megasas_isr_fusion - isr entry point
  */
-irqreturn_t megasas_isr_fusion(int irq, void *devp)
+static irqreturn_t megasas_isr_fusion(int irq, void *devp)
 {
 	struct megasas_irq_context *irq_context =3D devp;
 	struct megasas_instance *instance =3D irq_context->instance;
@@ -2038,7 +2038,7 @@ irqreturn_t megasas_isr_fusion(int irq, void *dev=
p)
  * mfi_cmd:			megasas_cmd pointer
  *
  */
-u8
+static u8
 build_mpt_mfi_pass_thru(struct megasas_instance *instance,
 			struct megasas_cmd *mfi_cmd)
 {
@@ -2101,7 +2101,7 @@ build_mpt_mfi_pass_thru(struct megasas_instance *=
instance,
  * @cmd:			mfi cmd to build
  *
  */
-union MEGASAS_REQUEST_DESCRIPTOR_UNION *
+static union MEGASAS_REQUEST_DESCRIPTOR_UNION *
 build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *c=
md)
 {
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
@@ -2134,7 +2134,7 @@ build_mpt_cmd(struct megasas_instance *instance, =
struct megasas_cmd *cmd)
  * @cmd:			mfi cmd pointer
  *
  */
-void
+static void
 megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 			  struct megasas_cmd *cmd)
 {
@@ -2197,7 +2197,8 @@ megasas_check_reset_fusion(struct megasas_instanc=
e *instance,
 }
=20
 /* This function waits for outstanding commands on fusion to complete =
*/
-int megasas_wait_for_outstanding_fusion(struct megasas_instance *insta=
nce)
+static int megasas_wait_for_outstanding_fusion(struct megasas_instance
+					       *instance)
 {
 	int i, outstanding, retval =3D 0;
 	u32 fw_state;
--=20
1.7.9.5
