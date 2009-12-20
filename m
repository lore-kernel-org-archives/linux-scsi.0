From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 1/2] drivers/scsi: Eliminate double free
Date: Sun, 20 Dec 2009 18:06:52 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0912201806360.26912@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:60947 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbZLTRGz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Dec 2009 12:06:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The few lines below the kfree of hdr_buf may go to the label err_free which
will also free hdr_buf.  The most straightforward solution seems to be to
just move the kfree of hdr_buf after these gotos.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier E;
expression E1;
iterator I;
statement S;
@@

*kfree(E);
... when != E = E1
    when != I(E,...) S
    when != &E
*kfree(E);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/ses.c                  |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 55b034b..3c8a024 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -591,8 +591,6 @@ static int ses_intf_add(struct device *cdev,
 		ses_dev->page10_len = len;
 		buf = NULL;
 	}
-	kfree(hdr_buf);
-
 	scomp = kzalloc(sizeof(struct ses_component) * components, GFP_KERNEL);
 	if (!scomp)
 		goto err_free;
@@ -604,6 +602,8 @@ static int ses_intf_add(struct device *cdev,
 		goto err_free;
 	}
 
+	kfree(hdr_buf);
+
 	edev->scratch = ses_dev;
 	for (i = 0; i < components; i++)
 		edev->component[i].scratch = scomp + i;
