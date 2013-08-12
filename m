From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] messages: fusion: Staticize local symbols
Date: Mon, 12 Aug 2013 15:23:58 +0900
Message-ID: <000001ce9724$876541a0$962fc4e0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:18793 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab3HLGYK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2013 02:24:10 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MRE0009IN3LW4A0@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 12 Aug 2013 15:23:58 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Nagalakshmi Nandigama' <Nagalakshmi.Nandigama@lsi.com>
Cc: linux-scsi@vger.kernel.org, 'Sreekanth Reddy' <Sreekanth.Reddy@lsi.com>, support@lsi.com, Jingoo Han <jg1.han@samsung.com>

These local symbols are used only in this file.
Fix the following sparse warnings:

drivers/message/fusion/mptbase.c:7011:1: warning: symbol 'mpt_SoftResetHandler' was not declared. Should it be static?
drivers/message/fusion/mptspi.c:624:1: warning: symbol 'mptscsih_quiesce_raid' was not declared. Should it be static?
drivers/message/fusion/mptsas.c:1578:23: warning: symbol 'mptsas_refreshing_device_handles' was not declared. Should it be static?
drivers/message/fusion/mptsas.c:3653:24: warning: symbol 'mptsas_expander_add' was not declared. Should it be static?
drivers/message/fusion/mptsas.c:5327:1: warning: symbol 'mptsas_shutdown' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/message/fusion/mptbase.c |    2 +-
 drivers/message/fusion/mptsas.c  |    6 +++---
 drivers/message/fusion/mptspi.c  |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 767ff4d..c783a42 100644
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
index dd239bd..906f448 100644
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


