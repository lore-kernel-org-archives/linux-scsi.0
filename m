From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 17/22] lpfc 8.1.2 : Allow turning on internal loop-back mode
Date: Wed, 08 Feb 2006 10:43:07 -0500
Message-ID: <43EA118B.8040700@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51341 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030515AbWBHPnK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:43:10 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k18Fh9rf011927
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 07:43:09 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Allow turning on internal loop-back mode


Signed-off-by: James Smart <James.Smart@emulex.com>

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

