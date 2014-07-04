From: Himangi Saraogi <himangi774@gmail.com>
Subject: [PATCH] qla4xxx: Return -ENOMEM on memory allocation failure
Date: Fri, 4 Jul 2014 23:57:56 +0530
Message-ID: <20140704182756.GA9319@himangi-Dell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53064 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbaGDS2F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2014 14:28:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, iscsi-driver@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr

In this code, 0 is returned on memory allocation failure, even though
other failures return -ENOMEM or other similar values.

A simplified version of the Coccinelle semantic match that finds this
problem is as follows:

// <smpl>
@@
expression ret;
expression x,e1,e2,e3;
identifier alloc;
@@

ret = 0
... when != ret = e1
*x = alloc(...)
... when != ret = e2
if (x == NULL) { ... when != ret = e3
  return ret;
}
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/scsi/qla4xxx/ql4_os.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c5d9564..72ba671 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1050,6 +1050,7 @@ static int qla4xxx_get_host_stats(struct Scsi_Host *shost, char *buf, int len)
 	if (!ql_iscsi_stats) {
 		ql4_printk(KERN_ERR, ha,
 			   "Unable to allocate memory for iscsi stats\n");
+		ret = -ENOMEM;
 		goto exit_host_stats;
 	}
 
-- 
1.9.1

