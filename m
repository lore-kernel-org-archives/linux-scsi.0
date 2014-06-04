From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 2/7] mptfusion: remove redundant kfree checks
Date: Wed, 4 Jun 2014 12:49:44 -0400
Message-ID: <1401900589-19672-3-git-send-email-joe.lawrence@stratus.com>
References: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o141.mxlogic.net ([208.65.145.64]:32989 "EHLO
	p01c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaFDQuP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2014 12:50:15 -0400
In-Reply-To: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

Fixes the following smatch warnings:

  drivers/message/fusion/mptfc.c:529 mptfc_target_destroy() info:
    redundant null check on starget->hostdata calling kfree()

  drivers/message/fusion/mptspi.c:465 mptspi_target_destroy() info:
    redundant null check on starget->hostdata calling kfree()

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/message/fusion/mptfc.c  |    3 +--
 drivers/message/fusion/mptspi.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index fd75108..4bac2ad 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -525,8 +525,7 @@ mptfc_target_destroy(struct scsi_target *starget)
 		if (ri)	/* better be! */
 			ri->starget = NULL;
 	}
-	if (starget->hostdata)
-		kfree(starget->hostdata);
+	kfree(starget->hostdata);
 	starget->hostdata = NULL;
 }
 
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index ed8de0a..7ce9a5e 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -461,8 +461,7 @@ static int mptspi_target_alloc(struct scsi_target *starget)
 static void
 mptspi_target_destroy(struct scsi_target *starget)
 {
-	if (starget->hostdata)
-		kfree(starget->hostdata);
+	kfree(starget->hostdata);
 	starget->hostdata = NULL;
 }
 
-- 
1.7.10.4

