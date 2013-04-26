From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] dm mpath: attach scsi_dh during table resume
Date: Fri, 26 Apr 2013 09:29:53 -0400
Message-ID: <20130426132953.GA2707@redhat.com>
References: <20130404131631.GA10208@redhat.com>
 <1365457816-31475-1-git-send-email-snitzer@redhat.com>
 <1365457816-31475-2-git-send-email-snitzer@redhat.com>
 <20130422223355.GA4803@redhat.com>
 <Pine.LNX.4.64.1304250938480.8307@file.rdu.redhat.com>
 <20130425141707.GA1947@redhat.com>
 <Pine.LNX.4.64.1304251037320.18633@file.rdu.redhat.com>
 <20130425153147.GA2488@redhat.com>
 <517A192A.1080400@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab3DZN35 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Apr 2013 09:29:57 -0400
Content-Disposition: inline
In-Reply-To: <517A192A.1080400@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On Fri, Apr 26 2013 at  2:05am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 04/25/2013 05:31 PM, Mike Snitzer wrote:
> > On Thu, Apr 25 2013 at 10:50am -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> >>
> >>
> >> On Thu, 25 Apr 2013, Mike Snitzer wrote:
> >>
> >>> On Thu, Apr 25 2013 at  9:48am -0400,
> >>> Mikulas Patocka <mpatocka@redhat.com> wrote:
> >>>
> >>>>
> >>>>
> >>>> On Mon, 22 Apr 2013, Mike Snitzer wrote:
> >>>
> >>> The need to support changing device handlers (via multipath table load)
> >>> is overblown/historic.
> >>
> >> So - do you mean that we make "retain_attached_hw_handler" the default 
> >> option and don't allow the user to change existing device handler in 
> >> multipath configuration?
> >>
> >> That's what my patch did and it was NACKed by Hannes. The problem there is 
> >> that behavior depends on module loading order - if you activate multipath 
> >> with "EMC" option, it activates the EMC handler. If you load the ALUA 
> >> module and activate multipath with "EMC" option, it stays with the ALUA 
> >> handler.
> > 
> > .match allows for correct scsi_dh selection in the decision of alua vs
> > emc (alua has the tpgs bit set) -- but both scsi_dh modules must be
> > loaded.
> > 
> > If the incorrect handler is getting attached then it is either a bug in
> > the .match method (for the handler that should've been attached) or the
> > storage isn't configured how the user thought and they need to
> > adjust/reconfigure to have it be like they expected.
> > 
> > Either way we really _could_ impose not allowing the scsi_dh handler to
> > be changed (by multipath) -- which is why I Acked your patch.  There is
> > always the scsi_dh sysfs interface to allow the user to change the
> > scsi_dh (and possibly shoot themselves in the foot).
> > 
> Always providing there _is_ a correct way.
> For eg RDAC might run in ALUA mode, but this is by no means
> exclusively; the original 'rdac' mode will work there, too.

Just like the emc handler, rdac_match will prefer alua over rdac if tpgs
is set.

> Plus some vendors / admins might prefer for whatever reasons
> to continue to use the original mode.

So you're saying an admin should have the flexibility to use rdac if
they know better?  I don't disagree in principle but in practice
providing that flexibility comes at a cost (e.g. potential for
kernel crashes).

> So I don't think there is a 'correct' hardware handler.
> Only a preferred one. And the preference is set by the user,
> not the installation. Hence it would be a bad idea to
> disallow scsi_dh changes.

Disallowing scsi_dh changes is more about avoiding the potential for
crashes (which have been seen in testing).  As such I think there is
more risk of hitting a crash (very bad) than there is of an admin
_really_ wanting to prefer the proprietary handler (rdac) over the
standards based one (alua).

So I'm in favor of disallowing scsi_dh changes via multipath (until
if/when the potential for scsi_dh crashes is eliminated).  dm-multipath
really doesn't have a role in attaching a scsi_dh these days.  Disallowing
scsi_dh changes acknowledges that the underlying kernel support has
improved and that admins should take notice (and multipath-tools should
now default to 'retain_attached_hw_handler').
