From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 10/13] drivers/scsi: Remove redundant test
Date: Sun, 21 Dec 2008 16:40:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0812211640020.9555@pc-004.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:59044 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498AbYLUPkY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Dec 2008 10:40:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In drivers/scsi/aacraid/commsup.c, dev is checked not to be NULL near the
beginning of the function, making the test redundant.

In drivers/scsi/sym53c8xx_2/sym_glue.c, shost is similarly checked not to
be NULL near the beginning of the function.

A simplified version of the semantic patch that makes this change is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E;
position p1,p2;
@@

if (x@p1 == NULL || ...) { ... when forall
   return ...; }
... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
(
x@p2 == NULL
|
x@p2 != NULL
)

// another path to the test that is not through p1?
@s exists@
local idexpression r.x;
position r.p1,r.p2;
@@

... when != x@p1
(
x@p2 == NULL
|
x@p2 != NULL
)

@fix depends on !s@
position r.p1,r.p2;
expression x,E;
statement S1,S2;
@@

(
- if ((x@p2 != NULL) || ...)
  S1
|
- if ((x@p2 == NULL) && ...) S1
|
- BUG_ON(x@p2 == NULL);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/aacraid/commsup.c      |    4 ++--
 drivers/scsi/sym53c8xx_2/sym_glue.c |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 289304a..2bf0a4f 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -817,7 +817,7 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 			 * see an AifEnConfigChange AIF come through.
 			 */
 
-			if ((dev != NULL) && (dev->scsi_host_ptr != NULL)) {
+			if (dev->scsi_host_ptr != NULL) {
 				device = scsi_device_lookup(dev->scsi_host_ptr,
 					CONTAINER_TO_CHANNEL(container),
 					CONTAINER_TO_ID(container),
@@ -1068,7 +1068,7 @@ retry_next:
 	 * with changes to existing device IDs.
 	 */
 
-	if (!dev || !dev->scsi_host_ptr)
+	if (!dev->scsi_host_ptr)
 		return;
 	/*
 	 * force reload of disk info via aac_probe_container
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index f4e6cde..b8fe82c 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1416,8 +1416,6 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 		   "TERMINATION, DEVICE POWER etc.!\n", sym_name(np));
 	spin_unlock_irqrestore(shost->host_lock, flags);
  attach_failed:
-	if (!shost)
-		return NULL;
 	printf_info("%s: giving up ...\n", sym_name(np));
 	if (np)
 		sym_free_resources(np, pdev);
