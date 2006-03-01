From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 17/22] lpfc 8.1.2: Allow turning on internal loop-back mode
Date: Tue, 28 Feb 2006 19:25:32 -0500
Message-ID: <20060301002532.GA15546@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:61888 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S964861AbWCAAZe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:34 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PWjY015552
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:32 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PWdh015551
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Allow turning on internal loop-back mode

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -195,6 +195,9 @@ lpfc_init_link(struct lpfc_hba * phba,
 		mb->un.varInitLnk.link_flags = FLAGS_TOPOLOGY_MODE_PT_PT;
 		mb->un.varInitLnk.link_flags |= FLAGS_TOPOLOGY_FAILOVER;
 		break;
+	case FLAGS_LOCAL_LB:
+		mb->un.varInitLnk.link_flags = FLAGS_LOCAL_LB;
+		break;
 	}
 
 	/* NEW_FEATURE
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -616,6 +616,7 @@ LPFC_ATTR_RW(nodev_tmo, 30, 0, 255,
 /*
 # lpfc_topology:  link topology for init link
 #            0x0  = attempt loop mode then point-to-point
+#            0x01 = internal loopback mode
 #            0x02 = attempt point-to-point mode only
 #            0x04 = attempt loop mode only
 #            0x06 = attempt point-to-point mode then loop
@@ -623,7 +624,7 @@ LPFC_ATTR_RW(nodev_tmo, 30, 0, 255,
 # Set loop mode if you want to run as an NL_Port. Value range is [0,0x6].
 # Default value is 0.
 */
-LPFC_ATTR_R(topology, 0, 0, 6, "Select Fibre Channel topology");
+LPFC_ATTR_RW(topology, 0, 0, 6, "Select Fibre Channel topology");
 
 /*
 # lpfc_link_speed: Link speed selection for initializing the Fibre Channel
