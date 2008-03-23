From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 8/8] Remove reap_ref
Date: Sun, 23 Mar 2008 10:19:36 -0500
Message-ID: <1206285576.3494.17.camel@localhost.localdomain>
References: <20080318133228.ACA1F159169@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35284 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbYCWPTj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Mar 2008 11:19:39 -0400
In-Reply-To: <20080318133228.ACA1F159169@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-03-18 at 14:32 +0100, Hannes Reinecke wrote:
> struct scsi_target contains a 'reap_ref' counter, which is
> basically a reference counter for the target.

Actually, it's not a reference counter, it's an indicator that the
target may not be removed regardless of whether it has any children.

> As we now have proper reference counting we can remove it.
> This also cleans out the calling sequence for scsi_target_reap(),
> which now will only be called from the release function of the
> scsi_device, so we're guaranteed to always have a valid target.

Unfortunately, no.  This patch is founded on a wrong assumption.

The way the reap_ref works is that it's effectively a semaphore on
"don't delete target, I'm using it"---protecting critical target use
sections where we're manipulating or adding its children.  We have to
have a separate counter for this because the target is eligible for
deletion any time it doesn't have any children.  Unfortunately, there
are several times in the life cycle of a target when this may be true:
most notably at creation, but also around deletion (we don't want early
kills on the target until we're ready).

So, when a target is created, it comes with a reap_ref of one.  You
don't reduce it to zero until you're done with the scan otherwise your
target may be killed by a racing delete.  Likewise in deletion, you
raise the reap ref do your deletion and then reap, so the target doesn't
disappear prematurely due to a racing scan.

James


