From: Jonathan McDowell <noodles@earth.li>
Subject: Re: [PATCH] Unify sysfs filenames for firmware version
Date: Tue, 20 Nov 2007 12:02:16 -0800
Message-ID: <20071120200212.GI31112@earth.li>
References: <20071120133824.GD31112@earth.li> <47430CCE.50701@emulex.com> <20071120171454.GH31112@earth.li> <AE4F746F2AECFC4DA4AADD66A1DFEF01FEAC9B@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from the.earth.li ([193.201.200.66]:35750 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758368AbXKTUCV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2007 15:02:21 -0500
Content-Disposition: inline
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01FEAC9B@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Matt_Domsch@dell.com

On Tue, Nov 20, 2007 at 12:49:49PM -0500, Salyzyn, Mark wrote:
> Jonathan McDowell sez:
> > On Tue, Nov 20, 2007 at 11:35:26AM -0500, James Smart wrote:
> > > The hearburn I have with these patches is that you are changing
> > > driver-specific attributes, not common ones as enforced/requested
> > > by a subsystem. As such, you are breaking a management interface
> > > for existing tools/scripts.
> > Yes, that's true. Though at present we have the heartburn that
> > anyone wanting to write a script to pull out firmware revisions has
> > to know exactly where every driver stores this information.
> 
> The aacraid cards, which uses hba_monitor_version, hba_kernel_version
> and hba_bios_version for each piece does not fit into the single
> 'firmware revision' common ideal and were noticeably missing from this
> patch set.

I mainly looked for mentions of "firmware" to try and work out which
drivers were exporting this information in a single file. While I've
used the aacraid cards in the past I think I agree with you that no 1 of
those 3 pieces of information represents the firmware. Perhaps it could
export a triplet though?

> Fortunately (?), Adaptec has not bought into using sysfs for their
> management applications to pull these pieces and continues to pick
> them up directly by issuing ioctl pass-through calls to the card's
> firmware, so we have some leeway to change them to mold to a
> developing standard.  The fact that sysfs is a developing standard
> will confirm the management application folks reasoning for shying
> away from sysfs ;-/

Management stuff always seems to be tied to a single card. It's one of
the things that puts me off hardware RAID. It would really rock if we
could get as much as possible exported in the same fashion across cards,
rather than having to cope with each individually (though I accept that
accessing all details/features will probably always require some custom
card knowledge).

Do the management folks actually have some ideas about what sort of
interface they'd like in sysfs?

J.

-- 
If I save time, when do I get it back?
