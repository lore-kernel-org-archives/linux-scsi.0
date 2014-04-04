From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Scst-devel] OSS target - VMware SCSI reservation bug
 conformity.
Date: Fri, 04 Apr 2014 07:39:41 -0700
Message-ID: <1396622381.2264.23.camel@dabdike.int.hansenpartnership.com>
References: <201404022029.s32KTrqs006179@wind.enjellic.com>
	 <1396556464.21998.5.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40247 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753279AbaDDOjn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2014 10:39:43 -0400
In-Reply-To: <1396556464.21998.5.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: greg@enjellic.com, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Thu, 2014-04-03 at 13:21 -0700, Nicholas A. Bellinger wrote:
> On Wed, 2014-04-02 at 15:29 -0500, Dr. Greg Wettstein wrote:
> > On Mar 28,  8:53pm, Vladislav Bolkhovitin wrote:
> > } Subject: Re: [Scst-devel] OSS target - VMware SCSI reservation bug conform
> > 
> > > Dr. Greg Wettstein, on 03/27/2014 11:21 AM wrote:
> > > > Hi, hope the week is going well for everyone.
> > > >
> > > > There appears to be evidence that VMware has an issue with exact SCSI
> > > > standards compliance when it comes to handling corner cases with SCSI
> > > > reservation requests.  It appears as if Dell is pushing firmware hot
> > > > fixes for the EqualLogic controllers to work around the issue.
> > 
> > > Hi Greg,
> > 
> > Hi Vlad, thanks for taking the time to respond.
> > 
> > > That's interesting, but, unfortunately, your message doesn't contain
> > > sufficient technical details to look at this issue, if it exists. Or
> > > do you think we are magicians who can read minds and see through
> > > walls? ;)
> > 
> > Actually I did, but I assumed a maintenance contract would be needed
> > for that.
> > 
> > I had the following reasons for raising the issue:
> > 
> > 	1.) Does anyone in the open-source storage eco-system,
> > 	    ie. SCST/LIO whatever, have any confirmation that this
> > 	    is a known issue.
> > 
> 
> FYI guys, AFAICT this bug is specific to targets that don't support VAAI
> AtomicTestandSet (COMPARE_AND_WRITE), and need to use the legacy SCSI-2
> reservations instead.

This would be a significant problem.  SCSI-2 reservation holders have to
be aware of resets and reapply the reservation accordingly.  When I
worked at SteelEye, we used a reservation ping and reset detection
mechanism for this ... of course, that was before we switched to SCSI-3
reservations in 2005 ... why is VMware still using legacy SCSI-2?

The "bug" seems to be that VMware is using legacy reservations but not
maintaining them properly.  There's not much anyone can do to fix that.
SCSI-2 reservations have to be dropped on reset and if no-one maintains
them, they can't get magically reapplied because a reset is the way they
get broken for a dead node.  SCSI-3 reservations are reset immune, so
why isn't VMware using them (that's why SteelEye switched, for the
predictability in the face of fabric problems)?

James

> When AtomicTestandSet is available, ESX will avoid using reservations to
> lock the whole LUN and obtain exclusive access to individual VMFS extent
> on a per node basis instead.



