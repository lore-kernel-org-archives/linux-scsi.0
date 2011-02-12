From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] scsi: make scsi_devinfo infrastructure optional
Date: Sat, 12 Feb 2011 13:16:50 +0100
Message-ID: <201102121316.51333.bzolnier@gmail.com>
References: <201102091515.16202.bzolnier@gmail.com> <AANLkTinbsTuvRWQXt8ViTKaD+VbH9YG9X-RqzvsdEV_h@mail.gmail.com> <1297440366.4967.83.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57665 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab1BLMRq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Feb 2011 07:17:46 -0500
In-Reply-To: <1297440366.4967.83.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

James Bottomley wrote:

> On Fri, 2011-02-11 at 10:52 +0100, Bartlomiej Zolnierkiewicz wrote:
> > On Thu, Feb 10, 2011 at 4:07 PM, James Bottomley
> > <James.Bottomley@suse.de> wrote:
> > > On Thu, 2011-02-10 at 10:18 +0100, Bartlomiej Zolnierkiewicz wrote:
> > >> On Wed, Feb 9, 2011 at 7:00 PM, James Bottomley <James.Bottomley@suse.de> wrote:
> > >> > On Wed, 2011-02-09 at 15:15 +0100, Bartlomiej Zolnierkiewicz wrote:
> > >> >> Add SCSI_QUIRKS config option (default y and dependent on EMBEDDED
> > >> >> config option) to allow disabling of scsi_devinfo infrastructure.
> > >> >>
> > >> >> The output code size savings are ~14k for CONFIG_SCSI_QUIRKS=n
> > >> >> (as measured on x86-32):
> > >> >
> > >> > I don't understand the point of this patch ... without the quirks SCSI
> > >> > will do the wrong thing on a whole bunch of stuff.  The savings look to
> > >> > be tiny ... since the SCSI module is habitually a lot larger than your
> > >> > figures suggest.
> > >>
> > >> The patch was originally done for embedded ATA-only setups.
> > >
> > > Well, if it's for ATA only then the better course would be extracting
> > > libata from scsi.  It's also a bit misleading to do sizings on x86,
> > > because that doesn't imply embedded to me.  Aren't there still ATAPI
> > > devices that require the quirks?
> > 
> > According to my knowledge all ATAPI quirks are handled locally in libata & sr.
> 
> Then look again: libata handles the transport quirks and sr handles the
> capability quirks.  SCSI handles the protocol quirks.

I'm aware of this.  What I meant was that I don't know of any real-world 
ATAPI hardware needing the protocol quirks handling in SCSI.

> > > Most embedded setups include some form of USB ... again, the pluggable
> > > CD/DVD use the quirks table.
> > 
> > This was done long time ago specifically for embedded 486-like
> > embedded system w/o USB support and only using flash storage but
> > indeed this is not a common case.
> > 
> > > Given the potential for disaster even on embedded systems, I don't
> > > really think something like this is a good idea.
> > 
> > Well, I don't insist on applying it upstream as it is, it is more to
> > show the direction where the possible room for improvements is in case
> > of older/embedded systems and reducing memory/code size usage.  [
> > There were some concerns about it during recent proposal to use more
> > generalized code for support of some rare Intel-like PATA chipsets
> > (which seem to cost ~20k as measured on x86-64 in terms of additional
> > memory/code requirements, though most such systems are x86-32 only so
> > the incurred cost is probably smaller) .]
> > 
> > BTW with some effort we can do on-demand quirk table loading if it
> > ever grows too big in the future.
> 
> But we already have that, if you look.  Part of what you're removing is
> the proc interface that allows on demand loading.  If you just want the
> ability to compile out the built in table and load everything from boot,
> that's about a two line patch.

Indeed!  Though code savings are smaller using this method..

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] scsi: make scsi_devinfo table content optional

Add CONFIG_SCSI_QUIRKS config option (default y and dependent
on EMBEDDED config option) to allow disabling of the default
scsi_devinfo table content.

The output code size savings are ~7.5k for CONFIG_SCSI_QUIRKS=n
(as measured on x86-64):

CONFIG_SCSI_QUIRKS=y:
   text    data     bss     dec     hex filename
   5965    5520     288   11773    2dfd drivers/scsi/scsi_devinfo.o

CONFIG_SCSI_QUIRKS=n:
   text    data     bss     dec     hex filename
   3740      48     288    4076     fec drivers/scsi/scsi_devinfo.o

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/Kconfig        |    9 +++++++++
 drivers/scsi/scsi_devinfo.c |    2 ++
 2 files changed, 11 insertions(+)

Index: b/drivers/scsi/Kconfig
===================================================================
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -47,6 +47,15 @@ config SCSI_TGT
 	  If you want to use SCSI target mode drivers enable this option.
 	  If you choose M, the module will be called scsi_tgt.
 
+config SCSI_QUIRKS
+	bool "SCSI quirks list" if EMBEDDED
+	default y
+	help
+	  This option enables deprecated in-kernel list of devices
+	  that require settings that differ from the default.
+
+	  If unsure say Y.
+
 config SCSI_NETLINK
 	bool
 	default	n
Index: b/drivers/scsi/scsi_devinfo.c
===================================================================
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -53,6 +53,7 @@ static struct {
 	char *revision;	/* revision known to be bad, unused */
 	unsigned flags;
 } scsi_static_device_list[] __initdata = {
+#ifdef CONFIG_SCSI_QUIRKS
 	/*
 	 * The following devices are known not to tolerate a lun != 0 scan
 	 * for one reason or another. Some will respond to all luns,
@@ -251,6 +252,7 @@ static struct {
 	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"Zzyzx", "RocketStor 500S", NULL, BLIST_SPARSELUN},
 	{"Zzyzx", "RocketStor 2000", NULL, BLIST_SPARSELUN},
+#endif
 	{ NULL, NULL, NULL, 0 },
 };
 
