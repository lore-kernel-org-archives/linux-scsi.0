From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 1/7] mptfusion: mark file-private functions as static
Date: Wed, 4 Jun 2014 12:49:43 -0400
Message-ID: <1401900589-19672-2-git-send-email-joe.lawrence@stratus.com>
References: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c11o144.mxlogic.net ([208.65.144.77]:52093 "EHLO
	p02c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaFDQuF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2014 12:50:05 -0400
In-Reply-To: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

Fixes the following sparse warnings:

  drivers/message/fusion/mptbase.c:7011:1: warning: symbol
    'mpt_SoftResetHandler' was not declared. Should it be static?

  drivers/message/fusion/mptsas.c:1578:23: warning: symbol
    'mptsas_refreshing_device_handles' was not declared. Should it be
    static?

  drivers/message/fusion/mptsas.c:3653:24: warning: symbol
    'mptsas_expander_add' was not declared. Should it be static?

  drivers/message/fusion/mptsas.c:5327:1: warning: symbol
    'mptsas_shutdown' was not declared. Should it be static?

  drivers/message/fusion/mptspi.c:624:1: warning: symbol
    'mptscsih_quiesce_raid' was not declared. Should it be static?

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/message/fusion/mptbase.c |    2 +-
 drivers/message/fusion/mptsas.c  |    6 +++---
 drivers/message/fusion/mptspi.c  |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 570b18a..5ef3f89 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -7007,7 +7007,7 @@ EXPORT_SYMBOL(mpt_halt_firmware);
  *	IOC doesn't reply to any outstanding request. This will transfer IOC
  *	to READY state.
  **/
-int
+static int
 mpt_SoftResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 {
 	int		 rc;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 00d339c..8bb580d 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1575,7 +1575,7 @@ mptsas_del_end_device(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info)
 	mptsas_port_delete(ioc, phy_info->port_details);
 }
 
-struct mptsas_phyinfo *
+static struct mptsas_phyinfo *
 mptsas_refreshing_device_handles(MPT_ADAPTER *ioc,
 	struct mptsas_devinfo *sas_device)
 {
@@ -3650,7 +3650,7 @@ mptsas_send_expander_event(struct fw_event_work *fw_event)
  * @handle:
  *
  */
-struct mptsas_portinfo *
+static struct mptsas_portinfo *
 mptsas_expander_add(MPT_ADAPTER *ioc, u16 handle)
 {
 	struct mptsas_portinfo buffer, *port_info;
@@ -5323,7 +5323,7 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return error;
 }
 
-void
+static void
 mptsas_shutdown(struct pci_dev *pdev)
 {
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 5653e50..ed8de0a 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -620,7 +620,7 @@ static void mptspi_read_parameters(struct scsi_target *starget)
 	spi_width(starget) = (nego & MPI_SCSIDEVPAGE0_NP_WIDE) ? 1 : 0;
 }
 
-int
+static int
 mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, u8 channel, u8 id)
 {
 	MPT_ADAPTER	*ioc = hd->ioc;
-- 
1.7.10.4

