From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch RESEND] atp870u: 64 bit bug in atp885_init()
Date: Wed, 9 Dec 2015 13:24:53 +0300
Message-ID: <20151209102453.GE3173@mwanda>
References: <55B9CA3B.1030205@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55B9CA3B.1030205@suse.de>
Sender: kernel-janitors-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 64 bit CPUs there is a memory corruption bug on probe().  It should
be a u32 pointer instead of an unsigned long pointer or we write past
the end of the setupdata[] array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
Resending because we have shuffled the code around so the patch needed
to be refreshed against linux-next.  Although I do wonder why we are
still working on this code since it has never worked on 64 bit systems
so probably all the users gave up a decade ago.

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 8b52a9d..b46997c 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1413,11 +1413,11 @@ static void atp885_init(struct Scsi_Host *shpnt)
 			atpdev->global_map[m] = 0;
 			for (k = 0; k < 4; k++) {
 				atp_writew_base(atpdev, 0x3c, n++);
-				((unsigned long *)&setupdata[m][0])[k] = atp_readl_base(atpdev, 0x38);
+				((u32 *)&setupdata[m][0])[k] = atp_readl_base(atpdev, 0x38);
 			}
 			for (k = 0; k < 4; k++) {
 				atp_writew_base(atpdev, 0x3c, n++);
-				((unsigned long *)&atpdev->sp[m][0])[k] = atp_readl_base(atpdev, 0x38);
+				((u32 *)&atpdev->sp[m][0])[k] = atp_readl_base(atpdev, 0x38);
 			}
 			n += 8;
 		}
