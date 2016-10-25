From: Chris Leech <cleech@redhat.com>
Subject: Re: [PATCH 1/1] libfc: don't have fc_exch_find log errors on a new
 exchange
Date: Tue, 25 Oct 2016 10:51:14 -0700
Message-ID: <20161025175114.6zat5mse2vfdecws@straylight.hirudinean.org>
References: <1477084253-1742-1-git-send-email-cleech@redhat.com>
 <c31a1481-75d0-a350-2ef5-1910e9270691@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755426AbcJYRvR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Oct 2016 13:51:17 -0400
Content-Disposition: inline
In-Reply-To: <c31a1481-75d0-a350-2ef5-1910e9270691@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Mon, Oct 24, 2016 at 04:37:59PM +0200, Hannes Reinecke wrote:
> On 10/21/2016 11:10 PM, Chris Leech wrote:
> >With the error message I added in "libfc: sanity check cpu number
> >extracted from xid" I didn't account for the fact that fc_exch_find is
> >called with FC_XID_UNKNOWN at the start of a new exchange if we are the
> >responder.
> >
> >It doesn't come up with the initiator much, but that's basically every
> >exchange for a target.  By checking the xid for FC_XID_UNKNOWN first, we
> >not only prevent the erroneous error message, but skip the unnecessary
> >lookup attempt as well.
> >
> >Signed-off-by: Chris Leech <cleech@redhat.com>
> >---
> > drivers/scsi/libfc/fc_exch.c | 3 +++
> > 1 file changed, 3 insertions(+)
> >
> >diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
> >index 16ca31a..42cc403 100644
> >--- a/drivers/scsi/libfc/fc_exch.c
> >+++ b/drivers/scsi/libfc/fc_exch.c
> >@@ -910,6 +910,9 @@ static struct fc_exch *fc_exch_find(struct fc_exch_mgr *mp, u16 xid)
> > 	struct fc_exch *ep = NULL;
> > 	u16 cpu = xid & fc_cpu_mask;
> >
> >+	if (xid == FC_XID_UNKNOWN)
> >+		return NULL;
> >+
> > 	if (cpu >= nr_cpu_ids || !cpu_possible(cpu)) {
> > 		printk_ratelimited(KERN_ERR
> > 			"libfc: lookup request for XID = %d, "
> >
> Does that still apply with my libfc patchset?
> I was under the impression I've fixed it already ...

I believe so, although it might need refreshing to fix up the context
change.

It looks like you made a change specifically for REC, but in target mode
with tcm_fc the first frame every new exchange comes in with RX_ID
unknown until we assign one.

Chris
