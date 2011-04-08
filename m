From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/2] SCSI: Add a SCSI option for persistent device names
 in Kernel.
Date: Fri, 8 Apr 2011 19:21:13 +0200
Message-ID: <20110408192113.2f3d5eda@stein>
References: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp>
	<20110405161400.GA885@kroah.com>
	<4D9F17DF.5030601@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:58271 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1DHRVf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2011 13:21:35 -0400
In-Reply-To: <4D9F17DF.5030601@hitachi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-hotplug@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@suse.de>, Jon Masters <jcm@redhat.com>, 2nddept-manager@sdl.hitachi.co.jp

On Apr 08 Nao Nishijima wrote:
> (2011/04/06 1:14), Greg KH wrote:
> > On Tue, Apr 05, 2011 at 09:49:46PM +0900, Nao Nishijima wrote:
> >> Todo:
> >> - usb support
> > 
> > Why?  USB uses scsi, so why would it not work as-is today?  What about
> > libata devices?
> > 
> 
> Sorry, my explanation was not sufficient.
> It is required to get scsi id using a scsi inguiry command in order to
> create the udev rule, especially in ATTR(disk_id) item in it. The USB
> devices, however, do not respond to the command and we can not get their
> scsi id.

Identifiers and names of target ports and of logical units (per SAM-2 and
later, Annex A) --- whether they are persistent, in which scope they are
unique, how they look like, and how they can be obtained --- are transport
specific.

Neither the INQUIRY command (per SPC) nor any other command is generally
useful to obtain e.g. logical unit identifiers.  Any tool that needs to
obtain identifiers or names of target ports and of logical units must talk
with the transport driver through driver-specific interfaces.

Years ago it was suggested on this list that scsi-mod exposes standard
sysfs attributes for target and LU identifiers and names for all devices,
so that tools that need identfiers or names have a single place where they
can look them up.  (The read() method of these attributes would have to
be provided kernel-internally by transport drivers; and tools that read
these attributes need to be aware that there is not a single format for
identifiers and names.)

The SCSI folks were not interested in such a more standardized sysfs ABI
at that time.  (There was only a proposal anyway, not a patch.)  Hence,
tools have to dig at various places for these SAM-2 artifacts.  These ABIs
have been defined ad hoc by the transport driver implementers.

Anyway.  /How/ to obtain identifiers is just a side issue.  Back to the
proposal of letting userland tell the kernel how to name devices:

> >> I create unnamed devices (not
> >> a block device, but an intermediate device.
[...]
> >> After udev finds the unnamed
> >> device, udev assigns a persistent device name to a specific device
> >> according to udev rules and registers it as a block device. Hence,
> >> this is just a naming, not a renaming.

I disagree to this conclusion.  The "unnamed" device most definitely will
have a name before it can be shown to userland.  This preliminary name
fulfills the very same requirement that "s[drt][a-z]+[0-9]*" fulfill
today:  It is unique within the system during the lifetime of the
device.  So, this /is/ renaming, only that the first name is only exposed
to special tools that know of this new ABI.

It seems to me that today's procedure of /not/ renaming devices but of
providing as many alternative additional names as anyone could ever need
(symlinks within /dev/) is more robust.

If the contents of /var/log/messages or the output of iostat etc. is not
what is needed, how about simply filtering that through a grep/ sed based
script that rewrites names?  (This needs to be run during the lifetime of
the device of course, otherwise a wrong name could be put in.)  The fine
symlinks that udev provides can be used in such a text filter.
-- 
Stefan Richter
-=====-==-== -=-- -=---
http://arcgraph.de/sr/
