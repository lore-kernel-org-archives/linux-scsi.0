From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 2/4] fusion: fibre channel: properly wait for firmware target
 discovery to complete
Date: Mon, 31 Jul 2006 12:19:40 -0500
Message-ID: <44CE3BAC.8060401@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070509090609030509010706"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:44481 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030269AbWGaRTl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jul 2006 13:19:41 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k6VJmEfT023207
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2006 12:48:14 -0700
Received: from [128.162.233.78] (hd28.americas.sgi.com [128.162.233.78])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k6VHJe2742980870
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2006 10:19:40 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070509090609030509010706
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Based upon a conversation I had with LSI's fibre channel firmware guru,
this patch adds another condition under which the driver waits for the
firmware link initialization / target discovery to complete.

Signed-off-by: Michael Reed <mdr@sgi.com>




--------------070509090609030509010706
Content-Type: text/x-patch;
 name="fusion_target_discovery.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fusion_target_discovery.patch"

--- srfu/drivers/message/fusion/mptfc.c	2006-07-28 16:17:04.022434296 -0500
+++ srf/drivers/message/fusion/mptfc.c	2006-07-28 16:18:50.190272034 -0500
@@ -675,7 +675,10 @@ mptfc_GetFcPortPage0(MPT_ADAPTER *ioc, i
 			 * if still doing discovery,
 			 * hang loose a while until finished
 			 */
-			if (pp0dest->PortState == MPI_FCPORTPAGE0_PORTSTATE_UNKNOWN) {
+			if ((pp0dest->PortState == MPI_FCPORTPAGE0_PORTSTATE_UNKNOWN) ||
+			    (pp0dest->PortState == MPI_FCPORTPAGE0_PORTSTATE_ONLINE &&
+			     (pp0dest->Flags & MPI_FCPORTPAGE0_FLAGS_ATTACH_TYPE_MASK)
+			      == MPI_FCPORTPAGE0_FLAGS_ATTACH_NO_INIT)) {
 				if (count-- > 0) {
 					msleep(100);
 					goto try_again;


--------------070509090609030509010706--
