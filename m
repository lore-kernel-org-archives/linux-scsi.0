From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] atp870u: 64 bit bug in probe()
Date: Thu, 30 Jul 2015 00:36:05 +0300
Message-ID: <20150729213605.GD21784@mwanda>
References: <20130904095002.GC13892@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18499 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbbG2Vg2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2015 17:36:28 -0400
Content-Disposition: inline
In-Reply-To: <20130904095002.GC13892@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On 64 bit CPUs there is a memory corruption bug on probe().  It should
be a u32 pointer instead of an unsigned long pointer or we write past
the end of the setupdata[] array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Someone reported in 2003 that probe has a NULL deref so maybe it's
related to this memory corruption?
https://bugzilla.kernel.org/show_bug.cgi?id=1118

If only we had applied this patch when I originally sent it two years
ago, then it would only be 10 years too late instead of 12!  :P

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 05301bc..62acabd 100644
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
