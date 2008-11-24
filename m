From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/3] libfc: A modular Fibre Channel library
Date: Mon, 24 Nov 2008 11:13:29 +0100
Message-ID: <87tz9xh1o6.fsf@basil.nowhere.org>
References: <20081118222051.2289.81361.stgit@fritz>
	<20081118222111.2289.35843.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:49196 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbYKXKN0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2008 05:13:26 -0500
In-Reply-To: <20081118222111.2289.35843.stgit@fritz> (Robert Love's message of "Tue, 18 Nov 2008 14:21:11 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, jgarzik@redhat.com, james.smart@emulex.com, davem@davemloft.net, michaelc@cs.wisc.edu, jeffrey.t.kirsher@intel.com, jeykholt@cisco.com

Robert Love <robert.w.love@intel.com> writes:

A quick review. I'm not a SCSI layer expert, so it's
more general code comments.

Could you perhaps give a brief design overview of the library
in the description?

What it does, where it sits on the stack etc.? Doesn't need 
to be very extensive, but should be understandable even
for people not intimate with the FCoE spec.

> +#define FC_DISC_RETRY_LIMIT	3	/* max retries */
> +#define FC_DISC_RETRY_DELAY	500UL	/* (msecs) delay */

Define is not used?

> +
> +#define	FC_DISC_DELAY		3
> +
> +static int fc_disc_debug;
> +
> +#define FC_DEBUG_DISC(fmt...)			\
> +	do {					\
> +		if (fc_disc_debug)		\
> +			FC_DBG(fmt);		\
> +	} while (0)

In 2.6.28 there is dynamic_printk.h now to handle this.


> +
> +static struct mutex		disc_list_lock;
> +static struct list_head		disc_list;
> +
> +struct fc_disc {
> +	unsigned char		retry_count;
> +	unsigned char		delay;
> +	unsigned char		pending;
> +	unsigned char		requested;
> +	unsigned short		seq_count;
> +	unsigned char		buf_len;
> +	enum fc_disc_event	event;
> +
> +	void (*disc_callback)(struct fc_lport *,
> +			      enum fc_disc_event);

While it may seem excessive for a single callback
the tend is towards separate ->ops structures. They 
have the advantage that they can be made const
which has at least some theoretical security advantages.
Also callback numbers tend to grow over time.

> +/**
> + * fc_disc_lookup_rport - lookup a remote port by port_id
> + * @lport: Fibre Channel host port instance
> + * @port_id: remote port port_id to match
> + */
> +struct fc_rport *fc_disc_lookup_rport(const struct fc_lport *lport,
> +				      u32 port_id)
> +{
> +	struct fc_disc *disc;
> +	struct fc_rport *rport, *found = NULL;
> +	struct fc_rport_libfc_priv *rdata;
> +	int disc_found = 0;
> +
> +	mutex_lock(&disc_list_lock);
> +	list_for_each_entry(disc, &disc_list, list) {
> +		if (disc->lport == lport) {
> +			list_for_each_entry(rdata, &disc->rports, peers) {

Hopefully the max numbers of either of those are strictly bounded.

> +
> +/**
> + * fc_disc_alloc - Allocate a discovery work object
> + * @lport: The FC lport associated with the discovery job
> + */
> +static inline struct fc_disc *fc_disc_alloc(struct fc_lport *lport)
> +{
> +	struct fc_disc *disc;
> +
> +	disc = kzalloc(sizeof(struct fc_disc), GFP_KERNEL);

This misses a NULL check

> +	INIT_LIST_HEAD(&disc->list);
> +	INIT_DELAYED_WORK(&disc->disc_work, fc_disc_timeout);
> +	mutex_init(&disc->disc_mutex);
> +	INIT_LIST_HEAD(&disc->rports);
> +
> +	disc->lport = lport;
> +	disc->delay = FC_DISC_DELAY;
> +	disc->event = DISC_EV_NONE;

Is it ok that the callback (and probably some other fields) is not 
initialized here yet?

> +
> +	mutex_lock(&disc_list_lock);
> +	list_add_tail(&disc->list, &disc_list);
> +	mutex_unlock(&disc_list_lock);

... when you make this globally visible?

> +	if (event == RPORT_EV_CREATED) {
> +		mutex_lock(&disc_list_lock);
> +		list_for_each_entry(disc, &disc_list, list) {
> +			if (disc->lport == lport) {
> +				found = 1;
> +				mutex_lock(&disc->disc_mutex);
> +				list_add_tail(&rdata->peers, &disc->rports);
> +				mutex_unlock(&disc->disc_mutex);
> +			}
> +		}
> +		mutex_unlock(&disc_list_lock);

That's a lot of locks. Did you have a locking order comment somewhere? 

> +	if (!rp || rp->rscn_page_len != sizeof(*pp))
> +		goto reject;
> +
> +	len = ntohs(rp->rscn_plen);
> +	if (len < sizeof(*rp))
> +		goto reject;
> +	len -= sizeof(*rp);

Don't you need to check here than len is a multiple of sizeof(*pp) ?
Otherwise bad input could make it loop a very long time.

> +
> +	for (pp = (void *)(rp + 1); len; len -= sizeof(*pp), pp++) {

Also len >= 0 is always safer.

> +			      redisc, lport->state, disc->pending);
> +		list_for_each_entry_safe(dp, next, &disc_ports, peers) {
> +			list_del(&dp->peers);
> +			rport = lport->tt.rport_lookup(lport, dp->ids.port_id);
> +			if (rport) {
> +				rdata = RPORT_TO_PRIV(rport);
> +				list_del(&rdata->peers);

Hopefully there's a mutex here hold for that list.

> +				lport->tt.rport_logoff(rport);
> +			}
> +			fc_disc_single(disc, dp);
> +		}
> +	}
> +	fc_frame_free(fp);
> +	return;
> +reject:
> +	rjt_data.fp = NULL;
> +	rjt_data.reason = ELS_RJT_LOGIC;
> +	rjt_data.explan = ELS_EXPL_NONE;
> +	lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
> +	fc_frame_free(fp);

Some statistics counter for that case would be probably useful.
> +
> +	op = fc_frame_payload_op(fp);
> +	switch (op) {
> +	case ELS_RSCN:
> +		mutex_lock(&disc->disc_mutex);
> +		fc_disc_recv_rscn_req(sp, fp, disc);
> +		mutex_unlock(&disc->disc_mutex);

Ok yes seems the lock is hold.
> +
> +	list_for_each_entry_safe(rdata, next, &disc->rports, peers) {
> +		rport = PRIV_TO_RPORT(rdata);
> +		FC_DEBUG_DISC("list_del(%6x)\n", rport->port_id);
> +		list_del(&rdata->peers);
> +		lport->tt.rport_logoff(rport);

Hopefully that callback knows for which peer that is.

> +static void fc_disc_start(void (*disc_callback)(struct fc_lport *,
> +						enum fc_disc_event),
> +			  struct fc_lport *lport)
> +{
> +	struct fc_rport *rport;
> +	struct fc_rport_identifiers ids;
> +	struct fc_disc *disc;
> +	int found = 0;
> +
> +	mutex_lock(&disc_list_lock);
> +	list_for_each_entry(disc, &disc_list, list) {
> +		if (disc->lport == lport) {
> +			found = 1;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&disc_list_lock);

This seems to be opencoded a lot. Put it into some helper.
> +
> +	/*
> +	 * Handle point-to-point mode as a simple discovery
> +	 * of the remote port. Yucky, yucky, yuck, yuck!
> +	 */
> +	rport = disc->lport->ptp_rp;
> +	if (rport) {
> +		ids.port_id = rport->port_id;
> +		ids.port_name = rport->port_name;
> +		ids.node_name = rport->node_name;
> +		ids.roles = FC_RPORT_ROLE_UNKNOWN;
> +		get_device(&rport->dev);
> +
> +		if (!fc_disc_new_target(disc, rport, &ids)) {
> +			disc->event = DISC_EV_SUCCESS;
> +			fc_disc_done(disc);
> +		}
> +		put_device(&rport->dev);

The ref counting here seems a little dubious. If it's because
disc_new_target can sleep then preemptible kernels can 
do that anyways. Or it's not needed.

> +	}
> +	if (((ids->port_name != -1) || (ids->port_id != -1)) &&
> +	    ids->port_id != fc_host_port_id(lport->host) &&
> +	    ids->port_name != lport->wwpn) {
> +		if (!rport) {
> +			rport = lport->tt.rport_lookup(lport, ids->port_id);
> +			if (!rport) {
> +				struct fc_disc_port dp;
> +				dp.lp = lport;
> +				dp.ids.port_id = ids->port_id;
> +				dp.ids.port_name = ids->port_name;
> +				dp.ids.node_name = ids->node_name;
> +				dp.ids.roles = ids->roles;
> +				rport = fc_rport_rogue_create(&dp);
> +			}
> +			if (!rport)
> +				error = ENOMEM;
> +		}
> +		if (rport) {
> +			rp = rport->dd_data;
> +			rp->event_callback = fc_disc_rport_event;
> +			rp->rp_state = RPORT_ST_INIT;
> +			lport->tt.rport_login(rport);
> +		}
> +	}
> +	return error;

Unusual positive error return convention. Ok?

> +		FC_DBG("Error %ld, retries %d/%d\n",
> +		       PTR_ERR(fp), disc->retry_count,
> +		       FC_DISC_RETRY_LIMIT);
> +
> +	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {

The mixing of non errnos into PTR_ERR is also unusual,
but ok, but make sure you never leak them.

> +		/*
> +		 * Memory allocation failure, or the exchange timed out,
> +		 * retry after delay.
> +		 */
> +		if (disc->retry_count < FC_DISC_RETRY_LIMIT) {
> +			/* go ahead and retry */
> +			if (!fp)
> +				delay = msecs_to_jiffies(500);

Ah that was the missing define above?

> +			else {
> +				delay = jiffies +
> +					msecs_to_jiffies(lport->e_d_tov);
> +
> +				/* timeout faster first time */
> +				if (!disc->retry_count)
> +					delay /= 4;

You have to divide by four before you add to jiffies, dividing
absolute jiffies doesn't make sense.

> +	/*
> +	 * Handle partial name record left over from previous call.
> +	 */
> +	bp = buf;
> +	plen = len;
> +	np = (struct fc_gpn_ft_resp *)bp;
> +	tlen = disc->buf_len;
> +	if (tlen) {
> +		WARN_ON(tlen >= sizeof(*np));
> +		plen = sizeof(*np) - tlen;
> +		WARN_ON(plen <= 0);
> +		WARN_ON(plen >= sizeof(*np));

I hope none of these WARN_ONs in network controllable. They nearly look like
some of them are.

Ok stopping here for now. That's a lot of code. Perhaps split it up
into a little smaller patches?

General impressions:
- Your locking is to complicated I think. Less locks is often more.
For short locks we also recommend spinlocks which perform
better (although you have to make sure you don't sleep then of course)
- I would double check everything that handles network data to
make sure it's not exploitable.

-Andi

-- 
ak@linux.intel.com
