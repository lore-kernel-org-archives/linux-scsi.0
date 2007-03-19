From: Horms <horms@verge.net.au>
Subject: Re: [PATCH 2/2] fusion - honour return value of pci_enable_device() in mpt_resume()
Date: Mon, 19 Mar 2007 15:06:44 +0900
Message-ID: <20070319060643.GM25702@verge.net.au>
References: <20070316070521.GB1081@verge.net.au> <20070316070550.GC1081@verge.net.au> <1174055246.3519.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from koto.vergenet.net ([210.128.90.7]:56914 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965632AbXCSGIK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Mar 2007 02:08:10 -0400
Content-Disposition: inline
In-Reply-To: <1174055246.3519.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Eric Moore <Eric.Moore@lsi.com>

On Fri, Mar 16, 2007 at 09:27:26AM -0500, James Bottomley wrote:
> On Fri, 2007-03-16 at 16:05 +0900, Horms wrote:
> > +       err = pci_enable_device(pdev);
> > +       if (err < 0)
> > +               return err;
> 
> Traditionally, this should be 
> 
> if (err)
> 	return err;
> 
> The reason is that <0 is a signed comparison which can be slightly more
> expensive on some architectures and it's unnecessary if zero is the only
> successful return.

That isn't a tradition that I am familiar with, but it seems reasonable
to me.

Updated patch is below.

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

Honour the return value of pci_enable_device(), which
seems to be a desirable thing to do:

  2.6.20-rc4
  gcc (GCC) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)

    CC [M]  drivers/message/fusion/mptbase.o
    drivers/message/fusion/mptbase.c: In function `mpt_resume':
    drivers/message/fusion/mptbase.c:1541: warning: ignoring return value
    of `pci_enable_device', declared with attribute warn_unused_result

It also in turn has mptscsih_resume() honour the return value of
mpt_resume()

I'm not sure about the handling of the other potential error cases
in mpt_resume(), of which there appear to be many. But this does
seem to be a good start.

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/drivers/message/fusion/mptbase.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptbase.c	2007-03-19 10:59:18.000000000 +0900
+++ linux-2.6/drivers/message/fusion/mptbase.c	2007-03-19 15:04:24.000000000 +0900
@@ -1531,6 +1531,7 @@
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 	u32 device_state = pdev->current_state;
 	int recovery_state;
+	int err;
 
 	printk(MYIOC_s_INFO_FMT
 	"pci-resume: pdev=0x%p, slot=%s, Previous operating state [D%d]\n",
@@ -1538,7 +1539,9 @@
 
 	pci_set_power_state(pdev, 0);
 	pci_restore_state(pdev);
-	pci_enable_device(pdev);
+	err = pci_enable_device(pdev);
+	if (err)
+		return err;
 
 	/* enable interrupts */
 	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
Index: linux-2.6/drivers/message/fusion/mptscsih.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptscsih.c	2007-03-19 15:03:22.000000000 +0900
+++ linux-2.6/drivers/message/fusion/mptscsih.c	2007-03-19 15:03:23.000000000 +0900
@@ -1188,8 +1188,7 @@
 int
 mptscsih_resume(struct pci_dev *pdev)
 {
-	mpt_resume(pdev);
-	return 0;
+	return mpt_resume(pdev);
 }
 
 #endif

