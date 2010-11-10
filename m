From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Patch added to scsi-rc-fixes-2.6:  [SCSI] host lock push-down
Date: Wed, 10 Nov 2010 17:45:58 -0600
Message-ID: <1289432759.3016.63.camel@mulgrave.site>
References: <201011102240.oAAMe86a001486@hera.kernel.org>
	 <4CDB2A81.5030100@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46369 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009Ab0KJXqF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2010 18:46:05 -0500
In-Reply-To: <4CDB2A81.5030100@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Wed, 2010-11-10 at 18:28 -0500, Jeff Garzik wrote:
> On 11/10/2010 05:40 PM, James Bottomley wrote:
> > Your commit:
> >
> >      [SCSI] host lock push-down
> >
> >      Move the mid-layer's ->queuecommand() invocation from being locked
> >      with the host lock to being unlocked to facilitate speeding up the
> >      critical path for drivers who don't need this lock taken anyway.
> >
> >      The patch below presents a simple SCSI host lock push-down as an
> >      equivalent transformation.  No locking or other behavior should change
> >      with this patch.  All existing bugs and locking orders are preserved.
> >
> >      Minimal code disturbance was attempted with this change.  Most drivers
> >      needed only two one-line modifications for their host lock push-down.
> >
> >      Signed-off-by: Jeff Garzik<jgarzik@redhat.com>
> >      Signed-off-by: James Bottomley<James.Bottomley@suse.de>
> >
> > has been added to the upstream SCSI tree
> > You can find it here:
> 
> No comments on renaming ->queuecommand to something else?

What we wondered about doing differently isn't really relevant for a
change log ... that should just really be about what was done (to avoid
confusion).

> The consequences are rather dire if this goes unnoticed, yes?

You mean if there's a missed in-tree driver?  Yes, but I took care to
make sure all SCSI drivers were accounted for.  For out of tree drivers,
as with the eh lock push down, it's caveat emptor.

James


