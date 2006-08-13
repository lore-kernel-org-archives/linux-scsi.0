From: Denis Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 4/4] aic7xxx: remove excessive inlining
Date: Sun, 13 Aug 2006 15:05:58 +0200
Message-ID: <200608131505.58608.vda.linux@googlemail.com>
References: <200608131457.21951.vda.linux@googlemail.com> <200608131502.10664.vda.linux@googlemail.com> <200608131503.07987.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_2Oy3EKef5TulWnp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:26307 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1751216AbWHMNGF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Aug 2006 09:06:05 -0400
Received: by nf-out-0910.google.com with SMTP id a4so1426714nfc
        for <linux-scsi@vger.kernel.org>; Sun, 13 Aug 2006 06:06:05 -0700 (PDT)
In-Reply-To: <200608131503.07987.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

--Boundary-00=_2Oy3EKef5TulWnp
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 13 August 2006 15:03, Denis Vlasenko wrote:
> Basically, patches deinline some functions, mainly those
> which perform port I/O.

Comment says "Read high byte first as some registers increment..."
but code doesn't guarantee that, I think:
	return ((ahd_inb(ahd, port+1) << 8) | ahd_inb(ahd, port));
Compiler can reorder it.

Make the order explicit.
--
vda

--Boundary-00=_2Oy3EKef5TulWnp
Content-Type: text/x-diff;
  charset="koi8-r";
  name="4.inb_order.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="4.inb_order.diff"

diff -urpN -U4 linux-2.6.17.8.aic3/drivers/scsi/aic7xxx/aic79xx_core.c linux-2.6.17.8.aic4/drivers/scsi/aic7xxx/aic79xx_core.c
--- linux-2.6.17.8.aic3/drivers/scsi/aic7xxx/aic79xx_core.c	2006-08-13 12:01:42.000000000 +0200
+++ linux-2.6.17.8.aic4/drivers/scsi/aic7xxx/aic79xx_core.c	2006-08-13 12:14:13.000000000 +0200
@@ -341,9 +341,11 @@ ahd_inw(struct ahd_softc *ahd, u_int por
 	 * Read high byte first as some registers increment
 	 * or have other side effects when the low byte is
 	 * read.
 	 */
-	return ((ahd_inb(ahd, port+1) << 8) | ahd_inb(ahd, port));
+	uint16_t r = ahd_inb(ahd, port+1) << 8;
+	r |= ahd_inb(ahd, port);
+	return r;
 }
 
 void
 ahd_outw(struct ahd_softc *ahd, u_int port, u_int value)

--Boundary-00=_2Oy3EKef5TulWnp--
