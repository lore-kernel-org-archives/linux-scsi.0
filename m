From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] aha1542: queuecommand: change panic() to return
Date: Sun, 25 Jan 2004 12:36:24 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040125123624.01b41fa4.rddunlap@osdl.org>
References: <20040124220006.48dd7746.rddunlap@osdl.org>
	<1075059252.3909.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:395 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S265285AbUAYUic (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jan 2004 15:38:32 -0500
In-Reply-To: <1075059252.3909.11.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On 25 Jan 2004 13:34:11 -0600 James Bottomley <James.Bottomley@steeleye.com> wrote:

| On Sun, 2004-01-25 at 00:00, Randy.Dunlap wrote:
| >  		cptr = (struct chain *) SCpnt->host_scribble;
| >  		if (cptr == NULL)
| > -			panic("aha1542.c: unable to allocate DMA memory\n");
| > +			return 1;
| >  		for (i = 0; i < SCpnt->use_sg; i++) {
| >  			if (sgpnt[i].length == 0 || SCpnt->use_sg > 16 ||
| 
| This is really not right.  If you look, the driver has already claimed a
| cdb for the command, so it will leak scarce resources in this error
| path.
| 
| Also a better return might be SCSI_MLQUEUE_HOST_BUSY, since this would
| be a global resource shortage for all commands.

Ah, an opportunity to update scsi_mid_low_api.txt also... (queued for later).

OK, here's a corrected patch.  Comments on it?

Thanks,
--
~Randy



From: Timmy Yee <shoujun@masterofpi.org>

Hi,

The aha1542 driver calls panic() if kmalloc() fails, which it shouldn't
do. This patch changes that by having the code return a nonzero value, so
it tells the SCSI mid-layer to retry the command, as suggested by Randy.


diffstat:=
 drivers/scsi/aha1542.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff -Naurp ./drivers/scsi/aha1542.c~qcommand_err ./drivers/scsi/aha1542.c
--- ./drivers/scsi/aha1542.c~qcommand_err	2004-01-08 22:59:42.000000000 -0800
+++ ./drivers/scsi/aha1542.c	2004-01-25 12:31:07.000000000 -0800
@@ -707,8 +707,11 @@ static int aha1542_queuecommand(Scsi_Cmn
 		SCpnt->host_scribble = (unsigned char *) kmalloc(512, GFP_DMA);
 		sgpnt = (struct scatterlist *) SCpnt->request_buffer;
 		cptr = (struct chain *) SCpnt->host_scribble;
-		if (cptr == NULL)
-			panic("aha1542.c: unable to allocate DMA memory\n");
+		if (cptr == NULL) {
+			/* free the claimed mailbox slot */
+			HOSTDATA(SCpnt->device->host)->SCint[mbo] = NULL;
+			return SCSI_MLQUEUE_HOST_BUSY;
+		}
 		for (i = 0; i < SCpnt->use_sg; i++) {
 			if (sgpnt[i].length == 0 || SCpnt->use_sg > 16 ||
 			    (((int) sgpnt[i].offset) & 1) || (sgpnt[i].length & 1)) {
