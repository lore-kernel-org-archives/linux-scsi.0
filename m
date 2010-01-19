From: Dan Carpenter <error27@gmail.com>
Subject: [patch] ses: double free
Date: Tue, 19 Jan 2010 12:36:39 +0300
Message-ID: <20100119093639.GB23956@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62467 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab0ASJhE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2010 04:37:04 -0500
Received: by fxm25 with SMTP id 25so339507fxm.21
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jan 2010 01:37:02 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

There are some code paths that go to err_free after already calling
kfree(hdr_buf).  I moved the kfree() lower to avoid the double free.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: stable@kernel.org

--- orig/drivers/scsi/ses.c	2010-01-18 21:54:14.000000000 +0300
+++ devel/drivers/scsi/ses.c	2010-01-18 21:54:25.000000000 +0300
@@ -591,7 +591,6 @@ static int ses_intf_add(struct device *c
 		ses_dev->page10_len = len;
 		buf = NULL;
 	}
-	kfree(hdr_buf);
 
 	scomp = kzalloc(sizeof(struct ses_component) * components, GFP_KERNEL);
 	if (!scomp)
@@ -618,6 +617,7 @@ static int ses_intf_add(struct device *c
 		ses_match_to_enclosure(edev, tmp_sdev);
 	}
 
+	kfree(hdr_buf);
 	return 0;
 
  recv_failed:
