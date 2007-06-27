From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Wed, 27 Jun 2007 12:27:48 +0200
Message-ID: <200706271227.48725.swen@vnet.ibm.com>
References: <200706191025.30986.swen@vnet.ibm.com> <200706251239.09755.swen@vnet.ibm.com> <467FCB4C.6060907@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:27742 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbXF0K1j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jun 2007 06:27:39 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate7.de.ibm.com (8.13.8/8.13.8) with ESMTP id l5RARcN3377892
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jun 2007 10:27:38 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5RARcxt2084970
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jun 2007 12:27:38 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5RARbxG013322
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jun 2007 12:27:37 +0200
In-Reply-To: <467FCB4C.6060907@suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

On Monday 25 June 2007 16:03, Hannes Reinecke wrote:
> Swen Schillig wrote:
> > On Friday 22 June 2007 16:11, James Bottomley wrote:
> >> On Thu, 2007-06-21 at 21:40 -0700, Mike Anderson wrote:
> >>> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> >>>> A proposal to display the correct form of the LUN would be useful if you
> >>>> wish to make it? ...  The problem is really that SAM specifies a
> >>>> possible 4 level structure with 4 possible address methods per level.
> >>>>
> >>>> The well known LUNs should be simple; there are only three: Report Lun,
> >>>> Access Controls and Target Log Pages.  The rest we really need input on.
> >>>> For instance, I could see the vendors wishing us to combine a
> >>>> multi-level flat addressing space into a single logical unit number,
> >>>> whereas I could see them wanting us to supply some sort of hierarchy for
> >>>> the peripheral and logical unit methods of addressing.
> >>>>
> >>>> Since you're already using 2 level flat addressing, how do you want to
> >>>> see that represented?
> >>> James, why would we would not want to display the lun per SAM4 4.6.2 as
> >>> suggested by Stefan in a previous comment.
> >> Because in a two LUN system, what was LUN 1 would then become LUN
> >> 0x1000000000000 which looks a bit unpalatable.
> >>
> >> James
> >>
> >>
> >> -
> > 
> > Despite the issue whether we should display and/or use (sysfs !?)
> > full blown 64bit values, so with leading zeros, you still have the option to display, 
> > for the single level addressing, the LUN as a 2 byte value as described in  SAM4 4.6.2. 
> > So for your example this would be 0x0001 or 0x1, which is exactly what you'd like to see, right ?
> > Only for 2+ level environment the 64bit representation comes into the play.
> > 
> > And, because you were asking how we'd like that to be represented, I personally prefer
> > a full blown 64bit hex value with leading zeros.
> > It makes the comparison to internal structures/models easier and gets us a bit closer
> > to the documented (SAM4) standard.
> > ...and I think we all can deal with a few extra digits being displayed.
> > 
> Well ...
> why don't we stick with the original implementation like zfcp had it?
> We can simpley expand the midlayer to add an attribute 'lun'
> to each scsi_device. This would be the LUN as returned by eg
> REPORT LUNS.
> No translation, nothing. Would be easy to implement and would allow
> any administrator to map the h:c:i:l value to the 'real' lun.
> 
> Cheers,
> 
> Hannes

What do you mean with "like we had it" ?
I thought you were quite happy with the new version making
the old manual counting thing ("zfcp-ism") obsolete.

What's the benefit of adding another (LUN) attribute to the midlayer, I don't get
what this is supposed to solve.
The initial question was, should we not display the long-ish LUN value in 
hex format making it easier for admins (and us) to actually use it
as it is.
I think Luben and Stefan suggested a good way to do that, ok apart from the be64 bits :-)
So, just use the struct scsi_lun in its full extend, for the sysfs without a leading "0x",
and forgetting about the scsilun_to_int conversion which isn't good for anything.

This way we would be conform to SAM4 as well even though I'm getting the impression
that this isn't the major goal of this discussion.

Anyway, before anyone else is suggesting some other magic attribute extension to the LUN value, 
why not leave it as it is and just have it serving this one purpose of being a unique number ?
(yeah, yeah I know there's already some meaning behind the 4 levels)

Just my 2 cents !

Cheers Swen
