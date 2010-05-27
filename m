From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 7/11] drivers/scsi: Eliminate a NULL pointer dereference
Date: Thu, 27 May 2010 14:33:47 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1005271433330.5422@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:48521 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099Ab0E0Mdx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2010 08:33:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: HighPoint Linux Team <linux@highpoint-tech.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The end of the function is reachable both when host is and is not NULL.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E,E1;
identifier f;
statement S1,S2,S3;
@@

if ((E == NULL && ...) || ...)
{
  ... when != if (...) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
If it is a problem to use 0 when host is NULL, then the code could be fixed
in another way.

 drivers/scsi/hptiop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 645f7cd..0729f15 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1157,7 +1157,7 @@ free_pci_regions:
 disable_pci_device:
 	pci_disable_device(pcidev);
 
-	dprintk("scsi%d: hptiop_probe fail\n", host->host_no);
+	dprintk("scsi%d: hptiop_probe fail\n", host ? host->host_no : 0);
 	return -ENODEV;
 }
 
