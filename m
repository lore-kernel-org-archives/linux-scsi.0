From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Fix incorrect reporting of host protection capabilities
Date: Thu, 29 Oct 2009 22:32:26 -0400
Message-ID: <yq1y6mttxvp.fsf@sermon.lab.mkp.net>
References: <yq18wfc8phm.fsf@sermon.lab.mkp.net>
	<20091015191818.GN7545@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:46211 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953AbZJ3Cdl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2009 22:33:41 -0400
In-Reply-To: <20091015191818.GN7545@parisc-linux.org> (Matthew Wilcox's
	message of "Thu, 15 Oct 2009 13:18:18 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

Matthew> And are these performance path?  If not, it might be nice to
Matthew> move them out of line and code them like this:

I compared the object files for the two approaches and it looks like
indexing into the array is a clear win compared to the switch statement.

Also, the DIF case must return the chosen protection type and not
true/false.


scsi: Fix incorrect reporting of host protection capabilities

The advent of DIF Type 2 devices exposed some missing break statements
in the protection mask switch constructs.  However, rewriting the code
to use an index into a small static array seemed like a more elegant
solution.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 6e728b1..47941fc 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -797,30 +797,23 @@ static inline unsigned int scsi_host_get_prot(struct Scsi_Host *shost)
 
 static inline unsigned int scsi_host_dif_capable(struct Scsi_Host *shost, unsigned int target_type)
 {
-	switch (target_type) {
-	case 1:
-		if (shost->prot_capabilities & SHOST_DIF_TYPE1_PROTECTION)
-			return target_type;
-	case 2:
-		if (shost->prot_capabilities & SHOST_DIF_TYPE2_PROTECTION)
-			return target_type;
-	case 3:
-		if (shost->prot_capabilities & SHOST_DIF_TYPE3_PROTECTION)
-			return target_type;
-	}
+	static unsigned char cap[] = { 0,
+				       SHOST_DIF_TYPE1_PROTECTION,
+				       SHOST_DIF_TYPE2_PROTECTION,
+				       SHOST_DIF_TYPE3_PROTECTION };
 
-	return 0;
+	return shost->prot_capabilities & cap[target_type] ? target_type : 0;
 }
 
 static inline unsigned int scsi_host_dix_capable(struct Scsi_Host *shost, unsigned int target_type)
 {
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
-	switch (target_type) {
-	case 0: return shost->prot_capabilities & SHOST_DIX_TYPE0_PROTECTION;
-	case 1: return shost->prot_capabilities & SHOST_DIX_TYPE1_PROTECTION;
-	case 2: return shost->prot_capabilities & SHOST_DIX_TYPE2_PROTECTION;
-	case 3: return shost->prot_capabilities & SHOST_DIX_TYPE3_PROTECTION;
-	}
+	static unsigned char cap[] = { SHOST_DIX_TYPE0_PROTECTION,
+				       SHOST_DIX_TYPE1_PROTECTION,
+				       SHOST_DIX_TYPE2_PROTECTION,
+				       SHOST_DIX_TYPE3_PROTECTION };
+
+	return shost->prot_capabilities & cap[target_type];
 #endif
 	return 0;
 }
