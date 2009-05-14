From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patchset 0/4] osd: Stop usage of blk_rq_append_bio
Date: Thu, 14 May 2009 15:35:27 +0000
Message-ID: <1242315327.11484.2.camel@mulgrave.int.hansenpartnership.com>
References: <4A0307F4.50205@panasas.com> <20090512112539.GH4140@kernel.dk>
	 <4A0AD8FA.6030903@panasas.com>  <4A0ADAEF.3040501@panasas.com>
	 <1242226048.4728.24.camel@mulgrave.int.hansenpartnership.com>
	 <4A0C3086.2010802@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36196 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788AbZENPf3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2009 11:35:29 -0400
In-Reply-To: <4A0C3086.2010802@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On Thu, 2009-05-14 at 17:53 +0300, Boaz Harrosh wrote:
> On 05/13/2009 05:47 PM, James Bottomley wrote:
> > On Wed, 2009-05-13 at 17:36 +0300, Boaz Harrosh wrote:
> >> On 05/13/2009 05:28 PM, Boaz Harrosh wrote:
> >>> On 05/12/2009 02:25 PM, Jens Axboe wrote:
> >>>> On Thu, May 07 2009, Boaz Harrosh wrote:
> >>>>> Osd library needs to submit pre-allocated bios, form several sources.
> >>>>> osdblk exofs and pNFS-layout driver all have prepared bios for IO submission.
> >>>>> On top of that the osd library needs to append additional segments to the
> >>>>> IO memory, for get/set attributes and more.
> >>>>>
> >>>>> All these are done today by use of a temporary hack - blk_rq_append_bio.
> >>>>> This is bad on few accounts.
> >>>>> 1. blk_rq_append_bio was not meant to be exported and is very specific to its users.
> >>>>> 2. blk_rq_append_bio does not support chained bios.
> >>>>> 3. blk_rq_append_bio does not bounce the bio and therefore current osd implementation
> >>>>>    has a bug.
> >>>>>
> >>>>> The proposed solution adds two new fixtures to the block layer, and a corresponding
> >>>>> fixing patch to osd. These are:
> >>>>>
> >>>>> [PATCH 1/4] allow blk_rq_map_kern to append to requests
> >>>>> [PATCH 2/4] libosd: Use new blk_rq_map_kern
> >>>>>
> >>>>>   This is originally a James patch and it's used, to let blk_rq_map_kern append it's buffer
> >>>>>   to existing bio, and there for is able to be called multiple times in a loop, to append
> >>>>>   multiple segments. This API can also be useful for scsi/block targets that have segment
> >>>>>   information in some other memory structure (like scatterlist) and wants to set it into
> >>>>>   a request. Until such time that they have a proper support for mapping scatterlists directly.
> >>>>>   (Since above called on long lists might not be good for performance)
> >>>>>
> >>>>>   Here in osd it makes tons of sense, and should be considered for inclusion.
> >>>>>   (The patches are based on linus-tip but should patch on block tree)
> >>>>>
> >>>>> [RFC 3/4] New blk_make_request(), takes bio, returns a request
> >>>>> [RFC 4/4] libosd: Use of new blk_make_request
> >>>>>   
> >>>>>   Here I propose a new block API, that will support proper delegation of a bio
> >>>>>   to a full request. Please read inside the patch descriptions for details.
> >>>>>   After this patch both osd and block layer will have the proper support for osdblk
> >>>>>   driver as well as future needs.
> >>>>>   These patches also eliminate the last use of blk_rq_append_bio which can be now un-exported.
> >>>>>
> >>>>>   These two patches conflic with Tejun's branch and are based on linus-tip. Upon positive review
> >>>>>   I will serialize them with Tejun and submit them properly. But first they must be agreed upon.
> >>>>>   Jens, I specially need your opinion on this?
> >>>> Looks sane to me. Can you resubmit against 'for-2.6.31' of the block git
> >>>> repo?
> >>>>
> >>> Thanks Jens.
> >>>
> >>> I have done the rebase and ran some tests, however I was unable to test these patches
> >>> as is, because there are some inter tree fallouts.
> >>>
> >>> Jens, James, Stephan, I please need your help
> >>>
> >>> The situation is like that.
> >>> - Both block/for-next and scsi/master are based on an old osd upstream-point (v2.6.30-rc3--ce8a7424)
> >>> - Linus tip has important OSD patches that went in via scsi-rc-fixes which changed Wire format
> > 
> > So just pull them into Linus head and build on that ... as long as you
> > explain what the base was, I can rebase scsi-misc (or run a post merge
> > tree) to cope.  It needs rebasing anyway to redo the mvsas patches.
> > 
> >>> - If I try and merge block/for-next ontop of plain linus/master I get a merge conflict
> >>> - If I try merge scsi/master block/for-next I get build errors / conflicts
> > 
> > This is the problem of the renames ... I think we need a block postmerge
> > tree to fix this up, but that probably needs sorting out first.
> > 
> >>> So there is no sane tree point that I can test on.
> >>>
> >>> It would be nice if both Jens block/for-next and scsi-misc/master could be rebased on Linus rc5++
> >>> and resolve these conflicts. (And scsi-misc conflicts with Tejun's cleanups be put in a second stage
> >>> tree)
> >>>
> >>> Should I send the patches as is half tested? Or wait for things to settle after I tested them
> >>> with all changes included?
> >>>
> >>> I have cut a new osd/linux-next branch which is based, not on linus, but on v2.6.30-rc3--ce8a7424
> >>> the base point for block/for-next and scsi-misc/master. So in next it should all come together
> >>> well, and I will try to clone tomorrow's next and test on top of that.
> >>>
> >> This will not work I have one patch [3/4] New blk_make_request(), takes bio, returns a request
> >> which will conflict with block/for-next if I rebase it on v2.6.30-rc3--ce8a7424.
> >>
> >> Should I cut osd/linux-next on top of block/for-next ?
> > 
> > What you really want is on the combination of the necessary trees.  If
> > it's only block, then sure ... if it's block and SCSI, that's postmerge
> > territory.
> > 
> > James
> > 
> > 
> 
> Thank you for your reply.
> 
> I did more-less what you said rebased block/for-next on linus-tip and
> fixed the merge with scsi-misc as per Stephan advise. Plus my patches
> last. Test ran well.
> 
> I see that you rebased by now, though I suspect the fc's blk_end_request
> call will fail to build if merged with block tree.

Yes, that's the bit we need a postmerge tree for.  It has to build on
it's own in scsi-misc, but it's making use of an API Tejun is altering,
so the block postmerge has to do the API alteration based on the SCSI
tree.

> I'm also seeing some recent changes to block git so I suspect that Jens is
> in the middle of rebasing too. (I hope)
> 
> As far as OSD, I managed to separate the two block-based changes to osd
> from the rest of the changes scheduled for 2.6.31 in such a way that they do not
> conflict and can merge either way (block first or scsi-misc first).
> 
> I'll repost all these patches. Sunday hopfuly after Jens rebases.

OK ... thanks.

James


