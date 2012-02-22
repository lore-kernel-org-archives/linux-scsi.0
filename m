From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH 1/2]  multipath-tools: fix the bug while processing vpd 0x83
 designation descriptors
Date: Wed, 22 Feb 2012 18:09:00 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B01821B@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:59770 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab2BVSJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 13:09:06 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch fixes the bug while processing the vpd 0x83 designation descriptors.
Removing the buggy check(> sizeof(buf))while loping the descriptors. Sizeof(buf) will 
always return 8 (in 64 bit machine). Descriptor length can be more than 8 bytes in 
some cases. This was causing problems while configuring my storage with alua.

Signed-off-by: Babu Moger <babu.moger@netapp.com>
---
--- multipath-tools/libmultipath/prioritizers/alua_rtpg.c.orig	2012-02-21 16:14:55.000000000 -0600
+++ multipath-tools/libmultipath/prioritizers/alua_rtpg.c	2012-02-21 16:16:41.000000000 -0600
@@ -184,9 +184,6 @@ get_target_port_group(int fd)
 
 		rc = -RTPG_NO_TPG_IDENTIFIER;
 		FOR_EACH_VPD83_DSCR(vpd83, dscr) {
-			if ((((char *) dscr) - ((char *) vpd83)) > sizeof(buf))
-				break;
-
 			if (vpd83_dscr_istype(dscr, IDTYPE_TARGET_PORT_GROUP)) {
 				struct vpd83_tpg_dscr *	p;
 


