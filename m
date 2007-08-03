From: Rob Landley <rob@landley.net>
Subject: Re: Some quick scsi documentation questions:
Date: Fri, 3 Aug 2007 15:07:30 -0400
Message-ID: <200708031407.31175.rob@landley.net>
References: <200707252328.28981.rob@landley.net> <200708022112.16298.rob@landley.net> <46B2E41F.7090705@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:42707
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751474AbXHCTJP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2007 15:09:15 -0400
In-Reply-To: <46B2E41F.7090705@s5r6.in-berlin.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Friday 03 August 2007 3:15:27 am Stefan Richter wrote:
> Rob Landley wrote:
> > On Thursday 02 August 2007 5:39:55 pm Stefan Richter wrote:
> >> The place where these symlinks live might change in the future.  See
> >> linux-2.6.23*/Documentation/sysfs-rules.txt.
> >
> > I noticed this.  I had a longish flamewar with Greg KH about this, which
> > would be ongoing if he hadn't stopped replying.
> >
> > It's easy to find out information like this by experimenting with sysfs. 
> > And then they change it in future versions, and blame the user for using
> > what sysfs exports.
>
> Sysfs lets you peek into kernel implementation details.

/sys/class containing all char devices and /sys/block containing all block 
devices was not an implementation detail.  Breaking this assumption by adding 
more char devices under /sys/bus and moving /sys/block moving 
under /sys/class is not an implementation detail.  Deprecating the "device" 
symlink was not an implementation detail.

They keep using the fact that they're exporting random kernel data as an 
excuse for not documenting a stable subset of this as an API userspace can 
rely on.

> Hence what you 
> see in sysfs will change all the time when the implementation is
> changed.  It's important to realize this before making use of sysfs.

It changes dynamically as stuff is hotplugged.  That's no excuse for them not 
making up their minds about what is and isn't a good idea to export, and 
where to put it.

> Sysfs (most of it) is not a stable ABI.

I've noticed this.  This is a bug, not a feature.  Linux has always had a 
stable _USERSPACE_ API.  This is exposed to userspace, and userspace is 
expected to be able to use this.  If they're exporting stuff they shouldn't 
be exporting, then they should stop exporting it.  That's no excuse for 
moving everything around, deprecating paths that used to be the primary way 
to access data that's still exported, just somewhere else...

> Never has been, never will be, 
> never was intended to be.  That's overlooked again and again.

I want to scan sysfs to find:

A) all block devices.
B) all char devices.
C) Whatever attributes of those devices that allow them to be persistently 
identified.

This goal hasn't changed since 2.6.10 or so, but sysfs has changed how we're 
expected to do it, and often they've changed it for no good reason from a UI 
perspective.

> If you want to do something that requires a stable ABI between kernel
> and userspace, then use such a stable ABI (including the small parts of
> sysfs that have been declared stable and hence will remain stable).

You mean like libsysfs? :)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
