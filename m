From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Tue, 2 Aug 2016 13:45:34 -0400
Message-ID: <20160802174533.GA18714@redhat.com>
References: <a5c1a149-b1a2-b5a4-2207-bdaf32db3cbd@sandisk.com>
	<757522831.7667712.1470059860543.JavaMail.zimbra@redhat.com>
	<536022978.7668211.1470060125271.JavaMail.zimbra@redhat.com>
	<931235537.7668834.1470060339483.JavaMail.zimbra@redhat.com>
	<1264951811.7684268.1470065187014.JavaMail.zimbra@redhat.com>
	<17da3ab0-233a-2cec-f921-bfd42c953ccc@sandisk.com>
	<20160801175948.GA6685@redhat.com>
	<f9e71e1d-54ca-40fe-a5ea-ae2863c94ff9@sandisk.com>
	<20160801204628.GA94704@redhat.com>
	<8e265fcc-8021-830e-ffcb-23a8a28ec247@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <8e265fcc-8021-830e-ffcb-23a8a28ec247@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Laurence Oberman <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 01 2016 at  6:41pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 08/01/2016 01:46 PM, Mike Snitzer wrote:
> > Please retry both variant (CONFIG_DM_MQ_DEFAULT=y first) with this patch
> > applied.  Interested to see if things look better for you (WARN_ON_ONCEs
> > added just to see if we hit the corresponding suspend/stopped state
> > while mapping requests -- if so this speaks to an inherently racy
> > problem that will need further investigation for a proper fix but
> > results from this should let us know if we're closer).
> > 
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 1b2f962..0e0f6e0 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -2007,6 +2007,9 @@ static int map_request(struct dm_rq_target_io *tio, struct request *rq,
> >  	struct dm_target *ti = tio->ti;
> >  	struct request *clone = NULL;
> >  
> > +	if (WARN_ON_ONCE(unlikely(dm_suspended_md(md))))
> > +		return DM_MAPIO_REQUEUE;
> > +
> >  	if (tio->clone) {
> >  		clone = tio->clone;
> >  		r = ti->type->map_rq(ti, clone, &tio->info);
> > @@ -2722,6 +2725,9 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
> >  		dm_put_live_table(md, srcu_idx);
> >  	}
> >  
> > +	if (WARN_ON_ONCE(unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state))))
> > +		return BLK_MQ_RQ_QUEUE_BUSY;
> > +
> >  	if (ti->type->busy && ti->type->busy(ti))
> >  		return BLK_MQ_RQ_QUEUE_BUSY;
> 
> Hello Mike,
> 
> The test results with this patch and also the three other patches that
> have been posted in the context of this e-mail thread applied on top of
> kernel v4.7 are as follows:

Hi Bart,

Please do these same tests against a v4.7 kernel with the 4 patches from
this branch applied (no need for your other debug patches):
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.7-mpath-fixes

I've had good results with my blk-mq SRP based testing.

Thanks,
Mike
