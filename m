From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI bug fixes for 2.6.30-rc6 [plus one new driver]
Date: Sat, 23 May 2009 09:13:43 -0500
Message-ID: <1243088023.3630.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49491 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbZEWONn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 May 2009 10:13:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This update is an assorted set of bug fixes (plus an mpt2sas driver
version cockup fix that might confuse userland) and one new driver: fnic
included under the merge exception for new drivers.

The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Abhijeet Joglekar (1):
      fnic: Add new Cisco PCI-Express FCoE HBA

Adam Radford (2):
      3w-xxxx: scsi_dma_unmap fix
      3w-9xxx: scsi_dma_unmap fix

Andrew Vasquez (1):
      fc-transport: Close state transition-window during rport deletion.

Edward Goggin (1):
      initialize max_target_blocked in scsi_alloc_target

Eric Moore (1):
      mpt2sas: fix driver version inconsistency

Yinghai Lu (1):
      ses: fix problems caused by empty SES provided name

The diffstat excluding fnic (diffs for this attached below):

 drivers/misc/enclosure.c            |    6 +++---
 drivers/scsi/3w-9xxx.c              |    3 ++-
 drivers/scsi/3w-xxxx.c              |    5 +++--
 drivers/scsi/3w-xxxx.h              |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h |    2 +-
 drivers/scsi/scsi_scan.c            |    1 +
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 include/scsi/scsi_transport_fc.h    |    4 ++--
 8 files changed, 14 insertions(+), 11 deletions(-)

The fnic diffstat is (diffs not attached: it's about 300k):

 MAINTAINERS                       |    8 
 drivers/scsi/Kconfig              |   11 
 drivers/scsi/Makefile             |    1 
 drivers/scsi/fnic/Makefile        |   15 
 drivers/scsi/fnic/cq_desc.h       |   78 +
 drivers/scsi/fnic/cq_enet_desc.h  |  167 +++
 drivers/scsi/fnic/cq_exch_desc.h  |  182 +++
 drivers/scsi/fnic/fcpio.h         |  780 ++++++++++++++++
 drivers/scsi/fnic/fnic.h          |  265 +++++
 drivers/scsi/fnic/fnic_attrs.c    |   56 +
 drivers/scsi/fnic/fnic_fcs.c      |  742 +++++++++++++++
 drivers/scsi/fnic/fnic_io.h       |   67 +
 drivers/scsi/fnic/fnic_isr.c      |  332 ++++++
 drivers/scsi/fnic/fnic_main.c     |  942 +++++++++++++++++++
 drivers/scsi/fnic/fnic_res.c      |  444 +++++++++
 drivers/scsi/fnic/fnic_res.h      |  197 ++++
 drivers/scsi/fnic/fnic_scsi.c     | 1850 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/fnic/rq_enet_desc.h  |   58 +
 drivers/scsi/fnic/vnic_cq.c       |   85 +
 drivers/scsi/fnic/vnic_cq.h       |  121 ++
 drivers/scsi/fnic/vnic_cq_copy.h  |   62 +
 drivers/scsi/fnic/vnic_dev.c      |  690 ++++++++++++++
 drivers/scsi/fnic/vnic_dev.h      |  161 +++
 drivers/scsi/fnic/vnic_devcmd.h   |  281 +++++
 drivers/scsi/fnic/vnic_intr.c     |   60 +
 drivers/scsi/fnic/vnic_intr.h     |  118 ++
 drivers/scsi/fnic/vnic_nic.h      |   69 +
 drivers/scsi/fnic/vnic_resource.h |   61 +
 drivers/scsi/fnic/vnic_rq.c       |  196 ++++
 drivers/scsi/fnic/vnic_rq.h       |  235 ++++
 drivers/scsi/fnic/vnic_scsi.h     |   99 ++
 drivers/scsi/fnic/vnic_stats.h    |   68 +
 drivers/scsi/fnic/vnic_wq.c       |  182 +++
 drivers/scsi/fnic/vnic_wq.h       |  175 +++
 drivers/scsi/fnic/vnic_wq_copy.c  |  117 ++
 drivers/scsi/fnic/vnic_wq_copy.h  |  128 ++
 drivers/scsi/fnic/wq_enet_desc.h  |   96 +
 37 files changed, 9199 insertions(+)

James

---

--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -119,7 +119,7 @@ enclosure_register(struct device *dev, const char *name, int components,
 	edev->edev.class = &enclosure_class;
 	edev->edev.parent = get_device(dev);
 	edev->cb = cb;
-	dev_set_name(&edev->edev, name);
+	dev_set_name(&edev->edev, "%s", name);
 	err = device_register(&edev->edev);
 	if (err)
 		goto err;
@@ -255,8 +255,8 @@ enclosure_component_register(struct enclosure_device *edev,
 	ecomp->number = number;
 	cdev = &ecomp->cdev;
 	cdev->parent = get_device(&edev->edev);
-	if (name)
-		dev_set_name(cdev, name);
+	if (name && name[0])
+		dev_set_name(cdev, "%s", name);
 	else
 		dev_set_name(cdev, "%u", number);
 
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 8b7983a..36c21b1 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1978,7 +1978,8 @@ static void twa_unmap_scsi_data(TW_Device_Extension *tw_dev, int request_id)
 {
 	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
 
-	scsi_dma_unmap(cmd);
+	if (cmd->SCp.phase == TW_PHASE_SGLIST)
+		scsi_dma_unmap(cmd);
 } /* End twa_unmap_scsi_data() */
 
 /* scsi_host_template initializer */
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index c03f1d2..faa0fcf 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -6,7 +6,7 @@
    		     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>
 
-   Copyright (C) 1999-2007 3ware Inc.
+   Copyright (C) 1999-2009 3ware Inc.
 
    Kernel compatiblity By: 	Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000	Andre Hedrick <andre@suse.com>
@@ -1294,7 +1294,8 @@ static void tw_unmap_scsi_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
 {
 	dprintk(KERN_WARNING "3w-xxxx: tw_unmap_scsi_data()\n");
 
-	scsi_dma_unmap(cmd);
+	if (cmd->SCp.phase == TW_PHASE_SGLIST)
+		scsi_dma_unmap(cmd);
 } /* End tw_unmap_scsi_data() */
 
 /* This function will reset a device extension */
diff --git a/drivers/scsi/3w-xxxx.h b/drivers/scsi/3w-xxxx.h
index 8e71e5e..a5a2ba2 100644
--- a/drivers/scsi/3w-xxxx.h
+++ b/drivers/scsi/3w-xxxx.h
@@ -6,7 +6,7 @@
    		     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>
 
-   Copyright (C) 1999-2007 3ware Inc.
+   Copyright (C) 1999-2009 3ware Inc.
 
    Kernel compatiblity By:	Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000	Andre Hedrick <andre@suse.com>
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 8ed2990..fb27407 100644
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index babd4cc..36b1d10 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -69,7 +69,7 @@
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
 #define MPT2SAS_DRIVER_VERSION		"01.100.02.00"
-#define MPT2SAS_MAJOR_VERSION		00
+#define MPT2SAS_MAJOR_VERSION		01
 #define MPT2SAS_MINOR_VERSION		100
 #define MPT2SAS_BUILD_VERSION		02
 #define MPT2SAS_RELEASE_VERSION		00
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6f51ca4..e2b50d8 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -425,6 +425,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	INIT_LIST_HEAD(&starget->devices);
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
+	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0947954..0a2ce7b 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -357,7 +357,7 @@ int iscsi_session_chkready(struct iscsi_cls_session *session)
 		err = 0;
 		break;
 	case ISCSI_SESSION_FAILED:
-		err = DID_TRANSPORT_DISRUPTED << 16;
+		err = DID_IMM_RETRY << 16;
 		break;
 	case ISCSI_SESSION_FREE:
 		err = DID_TRANSPORT_FAILFAST << 16;
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index c9184f7..68a8d87 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -680,7 +680,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
 		if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
 			result = 0;
 		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
-			result = DID_TRANSPORT_DISRUPTED << 16;
+			result = DID_IMM_RETRY << 16;
 		else
 			result = DID_NO_CONNECT << 16;
 		break;
@@ -688,7 +688,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
 		if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
 			result = DID_TRANSPORT_FAILFAST << 16;
 		else
-			result = DID_TRANSPORT_DISRUPTED << 16;
+			result = DID_IMM_RETRY << 16;
 		break;
 	default:
 		result = DID_NO_CONNECT << 16;


