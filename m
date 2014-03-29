From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 47/55] scsi: Mark functions as static in scsi/pmcraid.c
Date: Sun, 30 Mar 2014 00:13:20 +0530
Message-ID: <ed5dd8c3322473a9b925d9592c24ac36f0ddc2b0.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark functions as static in pmcraid.c because they are not used outside
this file.

This eliminates the following warnings in pmcraid.c:
drivers/scsi/pmcraid.c:349:6: warning: no previous prototype for =E2=80=
=98pmcraid_init_cmdblk=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/pmcraid.c:444:6: warning: no previous prototype for =E2=80=
=98pmcraid_return_cmd=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/pmcraid.c:1759:6: warning: no previous prototype for =E2=80=
=98pmcraid_ioasc_logger=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/pmcraid.c:3217:1: warning: no previous prototype for =E2=80=
=98pmcraid_init_ioadls=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/pmcraid.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index be8ce54..3570982 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -346,7 +346,7 @@ static int pmcraid_change_queue_type(struct scsi_de=
vice *scsi_dev, int tag)
  * Return Value
  *	 None
  */
-void pmcraid_init_cmdblk(struct pmcraid_cmd *cmd, int index)
+static void pmcraid_init_cmdblk(struct pmcraid_cmd *cmd, int index)
 {
 	struct pmcraid_ioarcb *ioarcb =3D &(cmd->ioa_cb->ioarcb);
 	dma_addr_t dma_addr =3D cmd->ioa_cb_bus_addr;
@@ -441,7 +441,7 @@ static struct pmcraid_cmd *pmcraid_get_free_cmd(
  * Return Value:
  *	nothing
  */
-void pmcraid_return_cmd(struct pmcraid_cmd *cmd)
+static void pmcraid_return_cmd(struct pmcraid_cmd *cmd)
 {
 	struct pmcraid_instance *pinstance =3D cmd->drv_inst;
 	unsigned long lock_flags;
@@ -1756,7 +1756,7 @@ static struct pmcraid_ioasc_error *pmcraid_get_er=
ror_info(u32 ioasc)
  * @ioasc: ioasc code
  * @cmd: pointer to command that resulted in 'ioasc'
  */
-void pmcraid_ioasc_logger(u32 ioasc, struct pmcraid_cmd *cmd)
+static void pmcraid_ioasc_logger(u32 ioasc, struct pmcraid_cmd *cmd)
 {
 	struct pmcraid_ioasc_error *error_info =3D pmcraid_get_error_info(ioa=
sc);
=20
@@ -3213,7 +3213,7 @@ static u8 pmcraid_task_attributes(struct scsi_cmn=
d *scsi_cmd)
  *   returns pointer pmcraid_ioadl_desc, initialized to point to inter=
nal
  *   or external IOADLs
  */
-struct pmcraid_ioadl_desc *
+static struct pmcraid_ioadl_desc *
 pmcraid_init_ioadls(struct pmcraid_cmd *cmd, int sgcount)
 {
 	struct pmcraid_ioadl_desc *ioadl;
--=20
1.7.9.5
