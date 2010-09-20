From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi_dh_alua: add missing transitioning state support
Date: Mon, 20 Sep 2010 11:35:39 -0400
Message-ID: <20100920153539.GA28284@redhat.com>
References: <1282071956-391-1-git-send-email-snitzer@redhat.com>
 <1282073039.30453.37.camel@haakon2.linux-iscsi.org>
 <4C7B7B9E.3020002@suse.de>
 <20100831151129.GA18855@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab0ITPfz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2010 11:35:55 -0400
Content-Disposition: inline
In-Reply-To: <20100831151129.GA18855@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

Hi Hannes,

On Tue, Aug 31 2010 at 11:11am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Aug 30 2010 at  5:36am -0400,
> Hannes Reinecke <hare@suse.de> wrote:
> 
> > Nicholas A. Bellinger wrote:
> > > On Tue, 2010-08-17 at 15:05 -0400, Mike Snitzer wrote:
> > >> Handle transitioning in the prep_fn.
> > >> Handle transitioning in alua_rtpg's implicit alua code too.
> > >>
> > >> These gaps were identified during controller failover testing of an
> > >> ALUA array.
> > >>
> > >> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > >> ---
> > >>  drivers/scsi/device_handler/scsi_dh_alua.c |   10 +++++++---
> > >>  1 files changed, 7 insertions(+), 3 deletions(-)
> > >>
> > >> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> > >> index 1a970a7..c1eedc5 100644
> > >> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> > >> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> > >> @@ -616,6 +616,9 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
> > >>  		    h->state == TPGS_STATE_STANDBY)
> > >>  			/* Useable path if active */
> > >>  			err = SCSI_DH_OK;
> > >> +		else if (h->state == TPGS_STATE_TRANSITIONING)
> > >> +			/* State transition, retry */
> > >> +			goto retry;
> > >>  		else
> > >>  			/* Path unuseable for unavailable/offline */
> > >>  			err = SCSI_DH_DEV_OFFLINED;
> > >> @@ -698,13 +701,14 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
> > >>  	struct alua_dh_data *h = get_alua_data(sdev);
> > >>  	int ret = BLKPREP_OK;
> > >>  
> > >> -	if (h->state != TPGS_STATE_OPTIMIZED &&
> > >> -	    h->state != TPGS_STATE_NONOPTIMIZED) {
> > >> +	if (h->state == TPGS_STATE_TRANSITIONING)
> > >> +		ret = BLKPREP_DEFER;
> > >> +	else if (h->state != TPGS_STATE_OPTIMIZED &&
> > >> +		 h->state != TPGS_STATE_NONOPTIMIZED) {
> > >>  		ret = BLKPREP_KILL;
> > >>  		req->cmd_flags |= REQ_QUIET;
> > >>  	}
> > >>  	return ret;
> > >> -
> > >>  }
> > >>  
> > > 
> > > Makes sense to me..
> > > 
> > > Acked-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > > 
> > Not so fast. There are two problems with this approach:
> > 
> > The path is retried indefinitely. Arrays are _supposed_ to be in 'transitioning'
> > only temporary; however, if the array is stuck due to a fw error we're stuck in 'defer',
> > too.
> 
> And what is the problem with that?  The IO will eventually time out.

To restate as a question: even though we'll retry in alua_rtpg();
shouldn't the SCSI command eventually time out (via
scsi_attempt_requeue_command)?

Note that my proposed change to alua_rtpg() just adds a
TPGS_STATE_TRANSITIONING handler for implicit ALUA -- explicit ALUA
already has such a handler.

Allowing implicit ALUA to fall through (as we do currently) causes a
return alua_rtpg() of SCSI_DH_DEV_OFFLINED -- which isn't the correct
state.

> > Secondly this path fails with 'directio' multipath checker. Remember that 'directio'
> > is using 'fs' requests, not block-pc ones. Hence for all I/O the prep_fn() callback
> > is evaluated, which will return 'DEFER' here once the path is in transitioning.
> > And the state is never updated as RTPG is never called.
> 
> Testing ALUA with directio path checker did not result in such immutable
> state in the few instances that TPGS_STATE_TRANSITIONING was seen in
> alua_prep_fn.

I had another look and I see what you're saying.  Thanks for catching this!

> > I'm currently preparing a patch which addressed these situations, too.
> 
> OK, please share.

Do you have that patch you were preparing?  I look forward to seeing
your solution to this.

Thanks,
Mike
