From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] avoid list seatch in fusion ->proc_info
Date: Mon, 31 May 2004 22:35:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040531203517.GA23944@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:693 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264700AbUEaUfY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 May 2004 16:35:24 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com
Cc: linux-scsi@vger.kernel.org

in 2.4 there only was a host no argument to ->proc_info so drivers had
to search on their own.  2.5 has a proper struct Scsi_Host so we better
use it.


--- 1.41/drivers/message/fusion/mptscsih.c	2004-05-29 17:10:51 +02:00
+++ edited/drivers/message/fusion/mptscsih.c	2004-05-31 22:16:41 +02:00
@@ -2188,22 +2188,9 @@
 int mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
 			int length, int func)
 {
-	MPT_ADAPTER	*ioc;
-	MPT_SCSI_HOST	*hd = NULL;
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_ADAPTER	*ioc = hd->ioc;
 	int size = 0;
-
-	dprintk(("Called mptscsih_proc_info: hostno=%d, func=%d\n", host->host_no, func));
-	dprintk(("buffer %p, start=%p (%p) offset=%ld length = %d\n",
-			buffer, start, *start, offset, length));
-
-	for (ioc = mpt_adapter_find_first(); ioc != NULL; ioc = mpt_adapter_find_next(ioc)) {
-		if ((ioc->sh) && (ioc->sh == host)) {
-			hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
-			break;
-		}
-	}
-	if ((ioc == NULL) || (ioc->sh == NULL) || (hd == NULL))
-		return 0;
 
 	if (func) {
 		size = mptscsih_user_command(ioc, buffer, length);
