From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] mptspi: fix oops in mptspi_dv_renegotiate_work()
Date: Mon, 07 Jul 2008 11:24:06 -0500
Message-ID: <1215447846.3274.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51580 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753541AbYGGQYJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2008 12:24:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, Satyam Sharma <satyam@infradead.org>

The problem here is that if the ioc faults too early in the bring up
sequence (as it usually does for an irq routing problem), ioc_reset gets
called before the scsi host is even allocated.  This causes an oops when
it later schedules a renegotiation.  Fix this by checking ioc->sh before
trying to renegotiate.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 25bcfcf..5963457 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1266,13 +1266,18 @@ mptspi_dv_renegotiate(struct _MPT_SCSI_HOST *hd)
 static int
 mptspi_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
-	struct _MPT_SCSI_HOST *hd = shost_priv(ioc->sh);
 	int rc;
 
 	rc = mptscsih_ioc_reset(ioc, reset_phase);
 
-	if (reset_phase == MPT_IOC_POST_RESET)
+	/* only try to do a renegotiation if we're properly set up
+	 * if we get an ioc fault on bringup, ioc->sh will be NULL */
+	if (reset_phase == MPT_IOC_POST_RESET &&
+	    ioc->sh) {
+		struct _MPT_SCSI_HOST *hd = shost_priv(ioc->sh);
+	  
 		mptspi_dv_renegotiate(hd);
+	}
 
 	return rc;
 }


