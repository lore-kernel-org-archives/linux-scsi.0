From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Questions about proc_scsi_write() in scsi_proc.c
Date: Fri, 26 Oct 2007 16:58:19 -0600
Message-ID: <20071026225819.GU27248@parisc-linux.org>
References: <200710261507.49284.rob@landley.net> <1193432977.3293.76.camel@localhost.localdomain> <200710261729.53400.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37641 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbXJZW6V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2007 18:58:21 -0400
Content-Disposition: inline
In-Reply-To: <200710261729.53400.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Fri, Oct 26, 2007 at 05:29:53PM -0500, Rob Landley wrote:
> Ok, I'm unclear on what a LUN is.  All the devices I have lying around give me 
> a LUN of zero.  I used to think that a LUN was a bit like partition, and 
> mostly used for CD changes.  The structure "scsi_target" seems to aggregate 
> host/channel/target and I thought it referred to a device.

Maybe the best way to understand this is by analogy with PCI.  With PCI,
you have a 5-bit device id and a 3-bit function ID.  Most physical
devices implement only one function, but we create a pci_dev for every
implemented function.  I'm not sure how many bits we have for target and
lun in SCSI, but it works much the same way; the target is the physical
thing, and the LUN is a logical entity within that hunk of hardware.  We
create a scsi_device for each LUN.

> Every device I have that shows up as SCSI has shown up with a LUN of 0, which 
> is target-wide unique because none of those targets have sub-functions that 
> need to be independently addressed as devices.

I have two devices with multiple LUNs.  One is a Plasmon PD-2000 combo
CD-reader and optical-disc.  If you put a CD-ROM in it, that's LUN 0
(sr) and if you put an optical disc in it, that shows up on LUN 1 (sd).

The other device is an HP fibre-channel Virtual Array which is a 3U
piece of metal with up to 15 drives inside it.  It splits those discs
up into as many LUNs as you configure it to, at whatever RAID level you
configure it to, and (in my configuration) presents itself as a single
target with 128 LUNs.

Not all storage arrays behave like that; I have another HP array that
presents each disc within it as an individual target, and the controller
is another target (it shows up as a PROCESSOR device).  In this scenario,
you only have LUN 0 on each target.

I'm sure there are plenty of other examples, but hopefully this will
help.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
