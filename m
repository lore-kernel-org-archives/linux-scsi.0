From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 9/9] isci: add version number
Date: Mon, 1 Aug 2011 20:29:16 +0200
Message-ID: <20110801202916.3d78752f@stein>
References: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
	<20110730001721.28430.28086.stgit@localhost6.localdomain6>
	<20110730185507.7b68c0a7@stein>
	<CAA9_cmfnSVdohf5bkfXjZvsa+O2vjvVdy2RA=f2EfVYeXdkX+Q@mail.gmail.com>
	<20110801193806.57dc9b58@stein>
	<1312221286.8212.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:54476 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1HAS31 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2011 14:29:27 -0400
In-Reply-To: <1312221286.8212.29.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org

On Aug 01 James Bottomley wrote:
> On Mon, 2011-08-01 at 19:38 +0200, Stefan Richter wrote:
> > The mainline doesn't generally carry stubs and macros that are only there
> > for backporting.  Well, I guess SCSI drivers are different in that regard.
> 
> This is hardly a stub for a backport.  It's a printk printing the
> version.

It is a printk printing a version that is only of interest in conjuction
with backports.  And even in that context a "major.minor.build"
naming scheme for a device driver is quite naive.  For example, a backport
of a driver which directly or indirectly uses the workqueue infrastructure
back into a kernel from before concurrency managed workqueues will behave
quite differently, regardless what its local version numbers say.

> At least 25% of drivers seem to do this (not that I entirely
> approve ... it does tend to clutter the boot sequence a bit)

25% of SCSI drivers perhaps (surely more than that if we consider only
SCSI drivers).  My random sample of 46 loaded modules on a desktop PC
contains 3 drivers whose modinfo | grep -E '^version' is nonempty
(pata_atiixp, sg, r8169).

However, what 25% or 85% of all drivers do is not quite relevant to a new
driver.

> The whole reason for MODULE_VERSION() is to mark this correctly.

If you (the author, the subsystem maintainer) prefer to have a driver
version, consider to omit the driver init()'s printk at least.  It is
redundant with lsmod, modinfo, or /sys/module/*{,/version}.
-- 
Stefan Richter
-=====-==-== =--- ----=
http://arcgraph.de/sr/
