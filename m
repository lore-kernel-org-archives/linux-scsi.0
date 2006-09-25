From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: mainline aic94xx firmware woes
Date: Mon, 25 Sep 2006 17:10:19 +0300
Message-ID: <20060925141019.GP6374@rhun.haifa.ibm.com>
References: <20060925101124.GH6374@rhun.haifa.ibm.com> <1159183984.11049.59.camel@localhost.localdomain> <1159184336.3463.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:7206 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S932134AbWIYOKW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 10:10:22 -0400
Content-Disposition: inline
In-Reply-To: <1159184336.3463.3.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-Kernel <linux-kernel@vger.kernel.org>

On Mon, Sep 25, 2006 at 06:38:56AM -0500, James Bottomley wrote:
> On Mon, 2006-09-25 at 12:33 +0100, Alan Cox wrote:
> > We should not be including non-free firmware in the kernel, we should be
> > continuing to drive it out into things like initramfs.
> 
> Right, which is why this was done as one of the conditions for accepting
> the driver

Fair enough.

> > > Also, aic94xx does not compile unless FW_LOADER is set in .config due
> > > to missing 'request_firmware'. What's the right thing to do here -
> > > aic94xx selecting it, depending on it
> > 
> > Either select or depend
> 
> select, I think.

aic94xx relies on external firmware and thus requires FW_LOADER.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>

diff -r 2e01eba444f0 drivers/scsi/aic94xx/Kconfig
--- a/drivers/scsi/aic94xx/Kconfig	Mon Sep 25 10:07:49 2006 +0700
+++ b/drivers/scsi/aic94xx/Kconfig	Mon Sep 25 17:08:09 2006 +0300
@@ -28,6 +28,7 @@ config SCSI_AIC94XX
 	tristate "Adaptec AIC94xx SAS/SATA support"
 	depends on PCI
 	select SCSI_SAS_LIBSAS
+	select FW_LOADER
 	help
 		This driver supports Adaptec's SAS/SATA 3Gb/s 64 bit PCI-X
 		AIC94xx chip based host adapters.

