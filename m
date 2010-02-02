From: akpm@linux-foundation.org
Subject: [patch for 2.6.33? 2/2] drivers/scsi/ses.c: eliminate double free
Date: Tue, 02 Feb 2010 14:12:36 -0800
Message-ID: <201002022212.o12MCa7h017503@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756972Ab0BBWMo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2010 17:12:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, julia@diku.dk

From: Julia Lawall <julia@diku.dk>

The few lines below the kfree of hdr_buf may go to the label err_free
which will also free hdr_buf.  The most straightforward solution seems to
be to just move the kfree of hdr_buf after these gotos.

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
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ses.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ses.c~drivers-scsi-sesc-eliminate-double-free drivers/scsi/ses.c
--- a/drivers/scsi/ses.c~drivers-scsi-sesc-eliminate-double-free
+++ a/drivers/scsi/ses.c
@@ -595,8 +595,6 @@ static int ses_intf_add(struct device *c
 		ses_dev->page10_len = len;
 		buf = NULL;
 	}
-	kfree(hdr_buf);
-
 	scomp = kzalloc(sizeof(struct ses_component) * components, GFP_KERNEL);
 	if (!scomp)
 		goto err_free;
@@ -608,6 +606,8 @@ static int ses_intf_add(struct device *c
 		goto err_free;
 	}
 
+	kfree(hdr_buf);
+
 	edev->scratch = ses_dev;
 	for (i = 0; i < components; i++)
 		edev->component[i].scratch = scomp + i;
_
