From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: request sense
Date: Fri, 25 Feb 2005 15:37:50 +0000
Message-ID: <20050225153750.GU28741@parcelfarce.linux.theplanet.co.uk>
References: <20050224231901.GT28741@parcelfarce.linux.theplanet.co.uk> <421EA34C.1060002@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:22736 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262724AbVBYPhv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 10:37:51 -0500
Content-Disposition: inline
In-Reply-To: <421EA34C.1060002@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Fri, Feb 25, 2005 at 02:02:20PM +1000, Douglas Gilbert wrote:
> Matthew Wilcox wrote:
> >3w-9xxx	Never fills in LUN
> >53c700	Always fills in LUN
> >BusLogic	Doesn't send REQUEST_SENSE
> >aic7xxx	Same as sym2 (except it sets its equivalent of scsi_version)
> >dc395x	Always fills in LUN
> >gdth		Doesn't send REQUEST_SENSE
> >ipr		Never fills in LUN
> >ips		Doesn't send REQUEST_SENSE
> >ncr53c8xx	Doesn't send REQUEST_SENSE
> >qla1280	Doesn't send REQUEST_SENSE
> >sym53c416	Doesn't send REQUEST_SENSE
> >tmscsim	Always fills in LUN
> 
> Matthew,
> Back in SCSI-2 (final t10 draft in 1993, standard in 1994) all
> SCSI commands (I believe) used the top 3 bits of byte 1 of a cdb
> for the logical unit number (lun). In those days SCSI had only
> one transport (now called SPI) and luns were limited to 8 (3 bits)
> for each target.
> 
> By SPC (part of the original "SCSI-3") those 3 bits were reserved
> and luns had increased to 32 bits and were conveyed across the
> SCSI transport by soem other mechanism (i.e. not the cdb). SPC was
> standardized in 1997 and the final draft is dated almost 8 years
> ago.

Thanks for the extremely clear explanation.  I suppose the effect of this
bug is pretty minimal -- it only affects multi-lun scsi-2 devices, and even
with those, it simply gets the sense data from the wrong LUN.  

> So unless a LLD knows that it is using such an old version
> of SPI that it has no other mechanism for conveying a lun
> _and_ the mid level structure indicates a lun > 0 (and
> lun < 8) then it should not overwrite those bits, IMO.
> 
> The LLD obviously knows the version of SPI that a target
> supports and the "version" field in an INQUIRY response
> indicates which SCSI command set generation the device claims
> to support (SPC-3 rev 21d, table 81 on page 145). As has been
> discussed elsewhere, one should not necessary believe the
> value a device puts in the version field (especially if
> an LLD hacks it).
> 
> As for REQUEST SENSE, that was used before the days of auto
> sense to retrieve the sense data when a CHECK CONDITION status
> was reported by a command. Now auto sense is mandatory and
> REQUEST SENSE almost fell out of use. Prior to auto-sense,
> the mid level (or perhaps the LLD) build REQUEST SENSE cdbs
> and in SCSI-2 then had to worry about the lun. The good
> news is that the top 3 bits of byte 1 of the REQUEST SENSE
> cdb are still reserved. Only an extremely pedantic SCSI
> command interpreter would complain if they were set (IMO).

That argues in favour of having scsi_error's implementation set the lun
bits, conditional on sdev->scsi_level, right?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
