From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI_QLA2ABC mustn't select SCSI_FC_ATTRS
Date: Sun, 17 Jul 2005 04:38:09 +0200
Message-ID: <20050717023809.GE3613@stusta.de>
References: <20050715013653.36006990.akpm@osdl.org> <20050715102744.GA3569@stusta.de> <20050715144037.GA25648@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261776AbVGQCjy@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050715144037.GA25648@plap.qlogic.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
List-Id: linux-scsi@vger.kernel.org

[ The subject was adapted to linux-kernel spam filters... ]

On Fri, Jul 15, 2005 at 07:40:37AM -0700, Andrew Vasquez wrote:
> On Fri, 15 Jul 2005, Adrian Bunk wrote:
> 
> > On Fri, Jul 15, 2005 at 01:36:53AM -0700, Andrew Morton wrote:
> > >...
> > > Changes since 2.6.13-rc2-mm2:
> > >...
> > >  git-scsi-misc.patch
> > >...
> > >  Subsystem trees
> > >...
> > 
> ...
> > +obj-$(CONFIG_SCSI_QLA24XX) += qla2xxx.o
> > 
> > 
> > I don't know what exactly you want to achieve, but this is so horribly 
> > wrong.
> 
> 
> Yes, quite.  How about the following to correct the intention.
>...

It looks good (except that you used spaces instead of a tab in the 
"select" line, but that's only a minor nitpick).

Below is another fix for a different issue that was already present.

cu
Adrian


<--  snip  -->


SCSI_QLA2XXX is automatically enabled for (SCSI && PCI).
It therefore mustn't select SCSI_FC_ATTRS, since it otherwise 
unconditionally enables SCSI_FC_ATTRS for all users with
(SCSI && PCI) enabled, even when they don't need any support for
QLogic hardware.

This patch also does a cosmetic change for making the "default" look 
more like in other kernel code.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.13-rc3-mm1-full/drivers/scsi/qla2xxx/Kconfig.old	2005-07-15 22:05:19.000000000 +0200
+++ linux-2.6.13-rc3-mm1-full/drivers/scsi/qla2xxx/Kconfig	2005-07-15 22:07:42.000000000 +0200
@@ -1,8 +1,7 @@
 config SCSI_QLA2XXX
 	tristate
-	default (SCSI && PCI)
 	depends on SCSI && PCI
-	select SCSI_FC_ATTRS
+	default y
 
 config SCSI_QLA21XX
 	tristate "QLogic ISP2100 host adapter family support"
