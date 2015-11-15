From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH] drivers/message/fusion: constify mpt_pci_driver structures
Date: Sun, 15 Nov 2015 20:27:19 +0100
Message-ID: <1447615639-7879-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
Cc: kernel-janitors@vger.kernel.org, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The mpt_pci_driver structures are never modified, so declare them as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/message/fusion/mptbase.c |    8 +++++---
 drivers/message/fusion/mptbase.h |    3 ++-
 drivers/message/fusion/mptctl.c  |    2 +-
 drivers/message/fusion/mptlan.c  |    2 +-
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5dcc031..451e73c 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -140,7 +140,9 @@ static int			 MptDriverClass[MPT_MAX_PROTOCOL_DRIVERS];
 static MPT_EVHANDLER		 MptEvHandlers[MPT_MAX_PROTOCOL_DRIVERS];
 					/* Reset handler lookup table */
 static MPT_RESETHANDLER		 MptResetHandlers[MPT_MAX_PROTOCOL_DRIVERS];
-static struct mpt_pci_driver 	*MptDeviceDriverHandlers[MPT_MAX_PROTOCOL_DRIVERS];
+
+static const
+struct mpt_pci_driver *MptDeviceDriverHandlers[MPT_MAX_PROTOCOL_DRIVERS];
 
 #ifdef CONFIG_PROC_FS
 static struct proc_dir_entry 	*mpt_proc_root_dir;
@@ -826,7 +828,7 @@ mpt_reset_deregister(u8 cb_idx)
  *	@cb_idx: MPT protocol driver index
  */
 int
-mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, u8 cb_idx)
+mpt_device_driver_register(const struct mpt_pci_driver *dd_cbfunc, u8 cb_idx)
 {
 	MPT_ADAPTER	*ioc;
 	const struct pci_device_id *id;
@@ -855,7 +857,7 @@ mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, u8 cb_idx)
 void
 mpt_device_driver_deregister(u8 cb_idx)
 {
-	struct mpt_pci_driver *dd_cbfunc;
+	const struct mpt_pci_driver *dd_cbfunc;
 	MPT_ADAPTER	*ioc;
 
 	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 813d463..e29e4be 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -920,7 +920,8 @@ extern int	 mpt_event_register(u8 cb_idx, MPT_EVHANDLER ev_cbfunc);
 extern void	 mpt_event_deregister(u8 cb_idx);
 extern int	 mpt_reset_register(u8 cb_idx, MPT_RESETHANDLER reset_func);
 extern void	 mpt_reset_deregister(u8 cb_idx);
-extern int	 mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, u8 cb_idx);
+extern int	 mpt_device_driver_register(const struct mpt_pci_driver *dd_cbfunc,
+					      u8 cb_idx);
 extern void	 mpt_device_driver_deregister(u8 cb_idx);
 extern MPT_FRAME_HDR	*mpt_get_msg_frame(u8 cb_idx, MPT_ADAPTER *ioc);
 extern void	 mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf);
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 02b5f69..7d051af 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -2990,7 +2990,7 @@ mptctl_remove(struct pci_dev *pdev)
 {
 }
 
-static struct mpt_pci_driver mptctl_driver = {
+static const struct mpt_pci_driver mptctl_driver = {
   .probe		= mptctl_probe,
   .remove		= mptctl_remove,
 };
diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index cbe9607..4b20af4 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -1443,7 +1443,7 @@ mptlan_remove(struct pci_dev *pdev)
 	}
 }
 
-static struct mpt_pci_driver mptlan_driver = {
+static const struct mpt_pci_driver mptlan_driver = {
 	.probe		= mptlan_probe,
 	.remove		= mptlan_remove,
 };

