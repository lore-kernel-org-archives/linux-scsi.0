From: Reinhard Nissl <rnissl@gmx.de>
Subject: Re: PATCH: mvsas: increase port type detection delay to suit Seagate's
 15k6 drive ST3450856SS 0003
Date: Fri, 12 Dec 2008 21:23:45 +0100
Message-ID: <4942C851.3080409@gmx.de>
References: <493BC76F.3060105@gmx.de> <49405137.9000902@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060908000008090908010005"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48722 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751902AbYLLUXy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 15:23:54 -0500
In-Reply-To: <49405137.9000902@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ke Wei <kewei@marvell.com>, Jeff Garzik <jgarzik@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>

This is a multi-part message in MIME format.
--------------060908000008090908010005
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi,

I wonder why no one has dropped me a line so far. I hope you
don't mind CCing you directly. I found your email addresses on
mailing list entries regarding mvsas. I attach the little patch
again for ease of use.

Reinhard Nissl schrieb:

> I increased the delay step by step until loading of mvsas
> reliably detected the drive 200 times in sequence. A much better
> approach would be to monitor the hardware for some flag which
> indicates that port detection has finished, but I do not have any
> hardware documentation.
> 
> BTW: patch is against
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
> 
> Signed-off-by: Reinhard Nissl <rnissl@gmx.de>

Bye.
-- 
Dipl.-Inform. (FH) Reinhard Nissl
mailto:rnissl@gmx.de

--------------060908000008090908010005
Content-Type: text/x-patch;
 name="mvsas.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mvsas.diff"

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index 1dd70d7..23e5a87 100644
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -2959,7 +2959,7 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
 
 	/* enable auto port detection */
 	mw32(GBL_PORT_TYPE, MODE_AUTO_DET_EN);
-	msleep(100);
+	msleep(1100);
 	/* init and reset phys */
 	for (i = 0; i < mvi->chip->n_phy; i++) {
 		u32 lo = be32_to_cpu(*(u32 *)&mvi->sas_addr[4]);

--------------060908000008090908010005--
