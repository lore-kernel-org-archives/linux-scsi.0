From: Mark Bellon <mbellon@mvista.com>
Subject: [PATCH] MPT FUSION driver causes panic on bootup on PPC 970 kernel
Date: Mon, 25 Jul 2005 14:48:10 -0700
Message-ID: <42E55E1A.80807@mvista.com>
References: <1122327427.20669.9.camel@madmax.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020505050506040407000500"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([12.44.186.158]:25073 "EHLO
	av.mvista.com") by vger.kernel.org with ESMTP id S261432AbVGYVsi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 17:48:38 -0400
In-Reply-To: <1122327427.20669.9.camel@madmax.msp.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Eric.Moore@lsil.com, linux-scsi@vger.kernel.org


This is a multi-part message in MIME format.
--------------020505050506040407000500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

A PPC 970 kernel with the MPT FUSION driver configured in would cause 
the kernel to panic. The problem occurs because of some apparently 
incorrect logic dealing with the cpu_to_le* and le*_to_cpu routines.

Patch is attached. Comments?

mark




--------------020505050506040407000500
Content-Type: text/x-patch;
 name="cge_mpt_fusion_update.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cge_mpt_fusion_update.patch"

Index: linux-2.6.10/drivers/message/fusion/mptbase.c
===================================================================
--- linux-2.6.10.orig/drivers/message/fusion/mptbase.c
+++ linux-2.6.10/drivers/message/fusion/mptbase.c
@@ -813,8 +813,8 @@
 		mf->u.frame.hwhdr.msgctxu.fld.cb_idx = handle;	/* byte */
 		req_offset = (u8 *)mf - (u8 *)ioc->req_frames;
 								/* u16! */
-		req_idx = cpu_to_le16(req_offset / ioc->req_sz);
-		mf->u.frame.hwhdr.msgctxu.fld.req_idx = req_idx;
+		req_idx = (req_offset / ioc->req_sz);
+		mf->u.frame.hwhdr.msgctxu.fld.req_idx = cpu_to_le16(req_idx);
 		mf->u.frame.hwhdr.msgctxu.fld.rsvd = 0;
 		ioc->RequestNB[req_idx] = ioc->NB_for_64_byte_frame; /* Default, will be changed if necessary in SG generation */
 #ifdef MFCNT
@@ -860,8 +860,8 @@
 	mf->u.frame.hwhdr.msgctxu.fld.cb_idx = handle;		/* byte */
 	req_offset = (u8 *)mf - (u8 *)ioc->req_frames;
 								/* u16! */
-	req_idx = cpu_to_le16(req_offset / ioc->req_sz);
-	mf->u.frame.hwhdr.msgctxu.fld.req_idx = req_idx;
+	req_idx = (req_offset / ioc->req_sz);
+	mf->u.frame.hwhdr.msgctxu.fld.req_idx = cpu_to_le16(req_idx);
 	mf->u.frame.hwhdr.msgctxu.fld.rsvd = 0;
 
 #ifdef MPT_DEBUG_MSG_FRAME
@@ -2337,7 +2337,7 @@
 			return -55;
 		}
 
-		r = sz = le32_to_cpu(facts->BlockSize);
+		r = sz = facts->BlockSize;	/* U8! */
 		vv = ((63 / (sz * 4)) + 1) & 0x03;
 		ioc->NB_for_64_byte_frame = vv;
 		while ( sz )

--------------020505050506040407000500--
