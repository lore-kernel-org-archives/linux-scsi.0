From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: WWID / SerialNo in sysfs?
Date: Mon, 9 Feb 2004 16:48:02 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040209164802.A6756@beaverton.ibm.com>
References: <20040209160856.GS3944@tpkurt.garloff.de> <1076343628.1804.19.camel@mulgrave> <20040209162906.GV3944@tpkurt.garloff.de> <20040209090421.B1568@beaverton.ibm.com> <20040210001928.GE4538@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:53124 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265636AbUBJAsf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2004 19:48:35 -0500
Content-Disposition: inline
In-Reply-To: <20040210001928.GE4538@tpkurt.garloff.de>; from garloff@suse.de on Tue, Feb 10, 2004 at 01:19:28AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Tue, Feb 10, 2004 at 01:19:28AM +0100, Kurt Garloff wrote:
> Hi Patrick,
> 
> On Mon, Feb 09, 2004 at 09:04:21AM -0800, Patrick Mansfield wrote:
> > On Mon, Feb 09, 2004 at 05:29:06PM +0100, Kurt Garloff wrote:

> Well, accessing devices by persistent names, you'll normally want 
> to offer the three:
> (a) naming by path
> (b) naming by device identifier: Serial/WWID
> (c) naming by contents (uuid)

Is (c) the mount -U uuid?

> All of them could be useful, think about backups, multipathing, ...
> 
> scsidev provided (a) and (b).
> 
> But for the name by path (a), scsidev used the driver name to have 
> some protection against scsi host renumbering (or PCI bus changes ...)

Yes, and (a) is harder with the host number being always incremented.

> Thus my patch to export the names.

Does that only narrow the scope of the problem? If you have two host
adapters of the same name, the name is not enough to identify a particular
adapter, and we have to fall back to something else. Using the full sysfs
path with a wildcard for the host number would cover some cases (for
example, if the PCI bus id were constant).

> > Also has these items that could be done in scsidev:
> > 
> > - a white/black list text file, so we don't need to rebuild a kernel or
> >   recompile the user binary to add or remove devices from the lists
> 
> I don't understand what you're telling me here.

That we should have a white and black list, since there are devices that
do not properly support page 0x80 or page 0x83, and that it should not be
compiled into the command.

If you're system has all known good devices (high end server, and no low
cost USB mass storage devices will be attached to it), you might want to
use a black list; if you're system is generic, you might want a white
list.

> > - page 0x80 support
> 
> It's there.

OK, sorry I missed it.

-- Patrick Mansfield
