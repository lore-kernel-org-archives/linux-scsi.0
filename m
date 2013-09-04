From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] atp870u: 64 bit bug in probe()
Date: Wed, 4 Sep 2013 12:50:02 +0300
Message-ID: <20130904095002.GC13892@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49842 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934469Ab3IDJuL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2013 05:50:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On 64 bit CPUs there is a memory corruption bug on probe().  It should
be setting 32 bits of data on both 32 and 64 bit.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker stuff.  I can't test this.

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 15a629d..3edbf30 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -2791,11 +2791,11 @@ next_fblk_885:
 		    p->global_map[m]= 0;
 		    for (k=0; k < 4; k++) {
 			outw(n++,base_io + 0x3c);
-			((unsigned long *)&setupdata[m][0])[k]=inl(base_io + 0x38);
+			((u32 *)&setupdata[m][0])[k]=inl(base_io + 0x38);
 		    }
 		    for (k=0; k < 4; k++) {
 			outw(n++,base_io + 0x3c);
-			((unsigned long *)&p->sp[m][0])[k]=inl(base_io + 0x38);
+			((u32 *)&p->sp[m][0])[k]=inl(base_io + 0x38);
 		    }
 		    n += 8;
 		}
