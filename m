From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 04/24] hpsa: allow passthru ioctls to work with
	bidirectional commands
Date: Thu, 29 May 2014 10:52:41 -0500
Message-ID: <20140529155241.8180.83841.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:37796 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757730AbaE2Pyh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:54:37 -0400
Received: from g2t2352.austin.hp.com (g2t2352.austin.hp.com [15.217.128.51])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id D83A46240F
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 15:54:07 +0000 (UTC)
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Treat the the data direction bits as a bit mask allowing both
READ and WRITE at the same time instead of testing for equality
to see if it's a exclusively a READ or a WRITE.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Mike Miller <michael.miller@canonical.com>
Reviewed-by: Webb Scales <webb.scales@hp.com>
---
 drivers/scsi/hpsa.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7ba4e30..1df9a8a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4956,7 +4956,7 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		buff = kmalloc(iocommand.buf_size, GFP_KERNEL);
 		if (buff == NULL)
 			return -EFAULT;
-		if (iocommand.Request.Type.Direction == XFER_WRITE) {
+		if (iocommand.Request.Type.Direction & XFER_WRITE) {
 			/* Copy the data into the buffer we created */
 			if (copy_from_user(buff, iocommand.buf,
 				iocommand.buf_size)) {
@@ -5019,7 +5019,7 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		rc = -EFAULT;
 		goto out;
 	}
-	if (iocommand.Request.Type.Direction == XFER_READ &&
+	if ((iocommand.Request.Type.Direction & XFER_READ) &&
 		iocommand.buf_size > 0) {
 		/* Copy the data out of the buffer we created */
 		if (copy_to_user(iocommand.buf, buff, iocommand.buf_size)) {
@@ -5096,7 +5096,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 			status = -ENOMEM;
 			goto cleanup1;
 		}
-		if (ioc->Request.Type.Direction == XFER_WRITE) {
+		if (ioc->Request.Type.Direction & XFER_WRITE) {
 			if (copy_from_user(buff[sg_used], data_ptr, sz)) {
 				status = -ENOMEM;
 				goto cleanup1;
@@ -5148,7 +5148,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		status = -EFAULT;
 		goto cleanup0;
 	}
-	if (ioc->Request.Type.Direction == XFER_READ && ioc->buf_size > 0) {
+	if ((ioc->Request.Type.Direction & XFER_READ) && ioc->buf_size > 0) {
 		/* Copy the data out of the buffer we created */
 		BYTE __user *ptr = ioc->buf;
 		for (i = 0; i < sg_used; i++) {

