From: Michael Reed <mdr@sgi.com>
Subject: [REPOST][PATCH 1/6] mpt fusion - fibre channel target discovery prematurely
 terminates
Date: Wed, 24 May 2006 15:06:54 -0500
Message-ID: <4474BCDE.5050107@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060306010405040101050001"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:17561 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932212AbWEXUG6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 May 2006 16:06:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Moore, Eric Dean" <Eric.Moore@lsil.com>

This is a multi-part message in MIME format.
--------------060306010405040101050001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Reset processing sets ioc->active to zero.  This causes target discovery
to be unable to read configuration pages which can result in fewer
than the total number of targets being discovered.  This patch skips
target discovery if ioc->active is zero.  The driver reschedules
target discovery once ioc->active becomes non-zero.

This situation occurs when the lsiutil program is being used to reset
the board.

(Logic change from previously posted 01-mptfc_eagain.patch.)

Signed-off-by: Michael Reed <mdr@sgi.com>


--------------060306010405040101050001
Content-Type: text/x-patch;
 name="01-mptfc_ioc_active.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-mptfc_ioc_active.patch"

Reset processing sets ioc->active to zero.  This causes target discovery
to be unable to read configuration pages which can result in fewer
than the total number of targets being discovered.  This patch skips
target discovery if ioc->active is zero.  The driver reschedules
target discovery once ioc->active becomes non-zero.

This situation occurs when the lsiutil program is being used to reset
the board.

Signed-off-by: Michael Reed <mdr@sgi.com>


--- rc4u/drivers/message/fusion/mptfc.c	2006-05-18 16:43:54.968309949 -0500
+++ rc4/drivers/message/fusion/mptfc.c	2006-05-24 14:08:58.999830952 -0500
@@ -639,6 +639,14 @@
 	struct mptfc_rport_info *ri;
 
 	do {
+		/*
+		 * if the ioc isn't active, cannot fetch config pages
+		 * if it becomes active, work count will increment and
+		 * another pass will occur or work will be rescheduled
+		 */
+		if (ioc->active == 0)
+			goto check_work_remaining;
+
 		/* start by tagging all ports as missing */
 		list_for_each_entry(ri, &ioc->fc_rports, list) {
 			if (ri->flags & MPT_RPORT_INFO_FLAGS_REGISTERED) {
@@ -676,6 +684,7 @@
 			}
 		}
 
+ check_work_remaining:
 		/*
 		 * allow multiple passes as target state
 		 * might have changed during scan

--------------060306010405040101050001--
