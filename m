From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: fix synchronous request flags for better performance
Date: Thu, 31 Mar 2011 09:56:10 -0700
Message-ID: <4D94B22A.5010809@linux.vnet.ibm.com>
References: <20110331165142.303106723@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38722 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab1CaQ4M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2011 12:56:12 -0400
Received: from d01dlp01.pok.ibm.com (d01dlp01.pok.ibm.com [9.56.224.56])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p2VGSo2a011988
	for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2011 12:28:50 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 070DC38C803B
	for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2011 12:56:05 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p2VGuBhZ2572372
	for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2011 12:56:11 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p2VGuA9D005223
	for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2011 13:56:11 -0300
In-Reply-To: <20110331165142.303106723@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>

In testing it was noticed that Extended Delay after Reset flag was being set
for gscsi and volume set devices.  This had a negative effect on performance
for volume sets.  The fix is to only set the flag for gscsi devices.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    3 ++-
 drivers/scsi/ipr.h |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2011-03-31 09:48:18.998471040 -0700
+++ b/drivers/scsi/ipr.c	2011-03-31 09:48:50.318094131 -0700
@@ -5773,7 +5773,8 @@ static int ipr_queuecommand_lck(struct s
 		}

 		ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
-		ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_DELAY_AFTER_RST;
+		if (ipr_is_gscsi(res))
+			ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_DELAY_AFTER_RST;
 		ioarcb->cmd_pkt.flags_lo |= IPR_FLAGS_LO_ALIGNED_BFR;
 		ioarcb->cmd_pkt.flags_lo |= ipr_get_task_attributes(scsi_cmd);
 	}
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2011-03-31 09:48:20.438637636 -0700
+++ b/drivers/scsi/ipr.h	2011-03-31 09:49:19.381456240 -0700
@@ -474,7 +474,7 @@ struct ipr_cmd_pkt {

 	u8 flags_lo;
 #define IPR_FLAGS_LO_ALIGNED_BFR		0x20
-#define IPR_FLAGS_LO_DELAY_AFTER_RST	0x10
+#define IPR_FLAGS_LO_DELAY_AFTER_RST		0x10
 #define IPR_FLAGS_LO_UNTAGGED_TASK		0x00
 #define IPR_FLAGS_LO_SIMPLE_TASK		0x02
 #define IPR_FLAGS_LO_ORDERED_TASK		0x04

