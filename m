From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 4/7] drivers/scsi: Move a dereference below a NULL test
Date: Fri, 26 Dec 2008 08:28:10 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0812260827490.25450@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753755AbYLZH2e@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mike@i-Connect.Net, linux-eata@i-connect.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/).

// <smpl>
@disable is_null@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (E == NULL) S
  f(...,E->fld,...);
- if (E == NULL) S

@@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (!E) S
  f(...,E->fld,...);
- if (!E) S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/eata_pio.c             |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 952505c..7fec87d 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -500,10 +500,11 @@ static int eata_pio_host_reset(struct scsi_cmnd *cmd)
 
 		sp = HD(cmd)->ccb[x].cmd;
 		HD(cmd)->ccb[x].status = RESET;
-		printk(KERN_WARNING "eata_pio_reset: slot %d in reset, pid %ld.\n", x, sp->serial_number);
-
 		if (sp == NULL)
 			panic("eata_pio_reset: slot %d, sp==NULL.\n", x);
+		printk(KERN_WARNING
+			"eata_pio_reset: slot %d in reset, pid %ld.\n",
+			x, sp->serial_number);
 	}
 
 	/* hard reset the HBA  */
