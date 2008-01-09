From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: AHCI finds disks; no /dev/sd inodes bound?
Date: Wed, 09 Jan 2008 19:33:46 +0100
Message-ID: <4785138A.4000809@s5r6.in-berlin.de>
References: <c7bcbd620801082340j46839c22n3081c2f5ad6af0ff@mail.gmail.com> <p738x2zosmd.fsf@bingen.suse.de> <c7bcbd620801090921w1a784417wc8aa42ecb83d589b@mail.gmail.com> <1199899766.3493.20.camel@localhost.localdomain> <20080109174945.GB15346@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:38509 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYAISer (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 13:34:47 -0500
In-Reply-To: <20080109174945.GB15346@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jon Watte <jwatte@gmail.com>, linux-scsi@vger.kernel.org

Andi Kleen wrote:
> On Wed, Jan 09, 2008 at 11:29:26AM -0600, James Bottomley wrote:
>> On Wed, 2008-01-09 at 09:21 -0800, Jon Watte wrote:
>> > Yes, that turns out to be the case. Thanks for the quick sanity check!
>> > I wonder if it's possible to magically turn that on when selecting
>> > AHCI support in menuconfig? That way, it'd be harder for someone else
>> > to make the same mistake.
>> 
>> We've had several discussions on this.  However, AHCI is used in a lot
>> of systems for CD-ROM support only.
> 
> Those systems (servers) typically have enough memory to tolerate a few
> extra KB of code without problems.  In fact most PCs these days have.

It would be a stupid solution nevertheless.

(We also don't "select EXT3".)

There are other possible solutions.  For example the split of the SCSI
Kconfig menu which has been proposed some times before.  Provide one
menu for highlevel protocol-type options, and one menu devoted to SCSI
transports and interconnects.  This underlines the central role of the
SCSI midlayer and SCSI highlevel in the kernel, and makes it easier for
people to spot that they need the SCSI highlevel even for their non-SCSI
hardware.


menuconfig "SCSI command sets (for HDDs, CD/DVD-ROM/R/W, tapes,
scanners, and more)"
	tristate SCSI
	help
		This is for [alls sorts of] internal and external
		devices, [e.g. this and that].

		This option is also required for a variety of hardware
		which isn't actually SCSI hardware.  You especially need
		this option for [such and such common kinds of non-SCSI
		hardware whose drivers make use of the SCSI subsystem].

		If unsure, say Y.

(SCSI midlayer options follow)
(SCSI highlevel options follow)

endmenu

if SCSI
menuconfig "SCSI transports and interconnects"
	bool SCSI_LOWLEVEL
	help
		Most of the SCSI transport protocols and interconnect
		drivers are configured here.  Some SCSI transports
		live in other menus.  [obligatory SBP-2 reference]

(SCSI lowlevel options follow)

endmenu
endif SCSI


PS:
It seems only libata users have difficulties to configure SD correctly.
USB users apparently and FireWire users definitely never had that
problem.  The "select SCSI" in libata's Kconfig option is not of great
help with that issue and is misguided and unnecessary as well.
-- 
Stefan Richter
-=====-==--- ---= -=--=
http://arcgraph.de/sr/
