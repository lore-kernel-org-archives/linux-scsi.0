From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4/5] [SCSI] Do not use platform_bus as a parent
Date: Sun, 27 Jul 2014 08:07:20 -0700
Message-ID: <20140727150720.GC1723@kroah.com>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
 <1406298233-27876-4-git-send-email-pawel.moll@arm.com>
 <1406299616.1789.13.camel@jarvis.lan>
 <20140726201150.GA21870@kroah.com>
 <1406433177.11069.3.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaG0PHq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Jul 2014 11:07:46 -0400
Content-Disposition: inline
In-Reply-To: <1406433177.11069.3.camel@jarvis>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pawel Moll <pawel.moll@arm.com>, Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>, Catalin Marinas <Catalin.Marinas@arm.com>, paul@pwsan.com, Arnd Bergmann <arnd@arndb.de>, Peter De Schrijver <pdeschrijver@nvidia.com>, arm@kernel.org, linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Jul 27, 2014 at 07:52:57AM +0400, James Bottomley wrote:
> On Sat, 2014-07-26 at 13:11 -0700, Greg Kroah-Hartman wrote:
> > On Fri, Jul 25, 2014 at 07:46:56AM -0700, James Bottomley wrote:
> > > On Fri, 2014-07-25 at 15:23 +0100, Pawel Moll wrote:
> > > > The host devices without a parent were "forcefully adopted"
> > > > by platform bus. This patch removes this assignment. In
> > > > effect the dev_dev may be NULL now, which means ISA.
> > > > 
> > > > Cc: James E.J. Bottomley <JBottomley@parallels.com>
> > > > Cc: linux-scsi@vger.kernel.org
> > > > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> > > > ---
> > > > 
> > > > This patch is a part of effort to remove references to platform_bus
> > > > and make it static.
> > > > 
> > > > James, could you please have a look and advice if the change is
> > > > correct? Would you happen to know the "real reasons" behind
> > > > using the root platform_bus device a parent?
> > > 
> > > Yes, for DMA purposes, the parent cannot now be NULL; we'll get a panic
> > > in the DMA transfers if it is.  A lot of the legacy ISA device on x86
> > > and I thought some ARM SOC devices don't pass in the parent device, so
> > > we hang them off a known parent.
> > 
> > The "generic" platform bus device is not a "known parent".  I don't
> > understand the difference between just setting the parent to be NULL,
> > which will then have a "proper" parent pointer filled in by the driver
> > core when the device is registered, or faking it out here.  What is the
> > difference?
> 
> If you set the parent to NULL, the host template dma_dev will end up
> NULL as well and that will trigger a NULL deref panic in the dma segment
> routines.
>
> If you want to remove platform_bus, we have to have a well known device
> to set dma_dev to at scsi_host_add time.

Why not set the dma_dev after you call device_add()?  That way you will
pick up the right parent no matter what.

> > In the end, the device always ends up with a parent pointer, right?
> 
> The parent pointer isn't the problem ... assigning the correct dma
> device is.

Ah, ok, it's a scsi core thing, not a driver core thing, that's less
confusing now.  For a "fallback" of a platform device, if you switch the
lines around you should be fine, something like this patch perhaps:

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 3cbb57a8b846..d8d3b294f5bc 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -218,16 +218,16 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		goto fail;
 
 	if (!shost->shost_gendev.parent)
-		shost->shost_gendev.parent = dev ? dev : &platform_bus;
-	if (!dma_dev)
-		dma_dev = shost->shost_gendev.parent;
-
-	shost->dma_dev = dma_dev;
+		shost->shost_gendev.parent = dev;
 
 	error = device_add(&shost->shost_gendev);
 	if (error)
 		goto out;
 
+	if (!dma_dev)
+		dma_dev = shost->shost_gendev.parent;
+	shost->dma_dev = dma_dev;
+
 	pm_runtime_set_active(&shost->shost_gendev);
 	pm_runtime_enable(&shost->shost_gendev);
 	device_enable_async_suspend(&shost->shost_gendev);
