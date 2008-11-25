From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: [PATCH 2/3] libfc: A modular Fibre Channel library
Date: Tue, 25 Nov 2008 13:47:47 -0700
Message-ID: <273D38FBE7C6FE46A1689FCD014A0B8B27BB82AE@azsmsx505.amr.corp.intel.com>
References: <20081118222051.2289.81361.stgit@fritz>
	<20081118222111.2289.35843.stgit@fritz> <87tz9xh1o6.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18266 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbYKYUsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Nov 2008 15:48:04 -0500
In-Reply-To: <87tz9xh1o6.fsf@basil.nowhere.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jgarzik@redhat.com" <jgarzik@redhat.com>, "james.smart@emulex.com" <james.smart@emulex.com>, "davem@davemloft.net" <davem@davemloft.net>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>, "jeykholt@cisco.com" <jeykholt@cisco.com>

Andi Kleen wrote:
> Robert Love <robert.w.love@intel.com> writes:
>
> A quick review. I'm not a SCSI layer expert, so it's
> more general code comments.
>
Thanks. I appreciate all reviews.

> Could you perhaps give a brief design overview of the library
> in the description?
>
Sure. I'll put it in the description when I re-submit.

It's fairly complicated, so even though I'm trying to be
breif, this overview got a bit long. The library has 5 major
layers/blocks- the EM, FCP, LP, RP, and disc. The EM is the
Exchange Manager and it is used by each of the other four blocks.
FCP is the mapping of SCSI commands to FC frames, it's the I/O
path. The RP layer handles individual targets (i.e. remote ports).
The LP block handles the host (or local port) for example, fabric
login, registration with the directoy server, etc... The disc
layer handles discovery, it queries the directoy server to find
the targets/RPs that are in its zone.

The FC transport class already provides us some remote port
functionality. It doesn't manage our RP state machine, but we
interact with it to add/delete RPs from both sysfs, it's also
what makes the SCSI-ml aware that there is storage available.

We have some diagrams that might be helpful, but they haven't
been refreshed in a few months. They're at:
http://www.open-fcoe.org/openfc/wiki/index.php/Architecture

My incomplete ASCII representation looks like this.

---------------------------
| FC Transport Class
---------------------------
   ^
   | (add/delete)
   v
---------------------------
| RP
---------------------------
   ^                       ^
   |    (targets)          | (directory server)
   v                       |
--------------     |
| Disc             |
--------------     |
   ^                       |
   |                       |
   v                       v
---------------------------
| LP
---------------------------

The EM is in-use by each of the blocks drawn above.

The I/O path is pretty straight-forward, kind of silly to draw.

-------------------------
| SCSI-ml
-------------------------
   ^
   |
   v
-------------------------
| FCP
-------------------------
   ^
   |
   v
-------------------------
| EM
-------------------------

> What it does, where it sits on the stack etc.? Doesn't need
> to be very extensive, but should be understandable even
> for people not intimate with the FCoE spec.
>
So, libfc is an assist library, fcoe is the LLD. The stack looks
roughly like this.

-----------  --------------------
| SCSI-ml |  | FC transport class
-----------  --------------------
   ^                    ^
   |                    |
   v                    v
---------------------------             -------------
| FCoE                    | <- - -> | libfc     |
---------------------------             -------------
   ^
   |
   v
--------------------------
| netdev
--------------------------


fcoe is the LLD to the SCSI-ml and it allocates the scsi_host.
When allocating the scsi_host it requests some memory for the
fc_lport (as well as a fcoe structure) and then uses the libfc
state machine to login to the fabric and register with the
necessary entities. This process requires the lport to start a
fc_rport for the directory server (we must be logged in to do
discovery). Once that has occurred we start discovery which
queries the directory server and returns us a list of targets.
We create a fc_rport for each of those targets and have the RP
layer log us into each of those targets. Once we're logged into
a target we "add" it to the transport layer. It show up in sysfs
and the SCSI-ml begins querying it (I/O).

We've been trying to make libfc as flexible as possible as we
expect a variety of LLDs to use it eventually. Users could be
traditional FC HBAs, SW only FCoE HBAs or offloaded FC/FCoE HBAs.
Therefore each block (EM, FCP, RP, LP, disc) can be implemented
by libfc or by a LLD. Our transport template in libfc.h defines
all of the transition points between each of these blocks so that
a LLD that doesn't want to use the library provided block can
just assign its own functions in the template before starting the
library.

For libfc we've also added an interface at the FCP layer to allow
LLDs to partially use that layer. This interface allows the
library to do the SCSI->FC mapping and then pass the FCP command
down to the LLD. A mini FC framing mini-library, in fc_encode.h
and an ELS/CT interface is also available.

For FCoE there has been recent work to support FCoE HBAs that
offload various functionality.

>> +#define FC_DISC_RETRY_LIMIT 3       /* max retries */
>> +#define FC_DISC_RETRY_DELAY 500UL   /* (msecs) delay */
>
> Define is not used?
>
Yeah, I think you caught this below. I will fix it.

>> +
>> +#define     FC_DISC_DELAY           3
>> +
>> +static int fc_disc_debug;
>> +
>> +#define FC_DEBUG_DISC(fmt...)                       \
>> +    do {                                    \
>> +            if (fc_disc_debug)              \
>> +                    FC_DBG(fmt);            \
>> +    } while (0)
>
> In 2.6.28 there is dynamic_printk.h now to handle this.
>
Excellent, we have this block in a few places. I'll change this.

>
>> +
>> +static struct mutex         disc_list_lock;
>> +static struct list_head             disc_list;
>> +
>> +struct fc_disc {
>> +    unsigned char           retry_count;
>> +    unsigned char           delay;
>> +    unsigned char           pending;
>> +    unsigned char           requested;
>> +    unsigned short          seq_count;
>> +    unsigned char           buf_len;
>> +    enum fc_disc_event      event;
>> +
>> +    void (*disc_callback)(struct fc_lport *,
>> +                          enum fc_disc_event);
>
> While it may seem excessive for a single callback
> the tend is towards separate ->ops structures. They
> have the advantage that they can be made const
> which has at least some theoretical security advantages.
> Also callback numbers tend to grow over time.
>
>> +/**
>> + * fc_disc_lookup_rport - lookup a remote port by port_id
>> + * @lport: Fibre Channel host port instance
>> + * @port_id: remote port port_id to match
>> + */
>> +struct fc_rport *fc_disc_lookup_rport(const struct fc_lport *lport,
>> +                                  u32 port_id) +{
>> +    struct fc_disc *disc;
>> +    struct fc_rport *rport, *found = NULL;
>> +    struct fc_rport_libfc_priv *rdata;
>> +    int disc_found = 0;
>> +
>> +    mutex_lock(&disc_list_lock);
>> +    list_for_each_entry(disc, &disc_list, list) {
>> +            if (disc->lport == lport) {
>> +                    list_for_each_entry(rdata, &disc->rports, peers) {
>
> Hopefully the max numbers of either of those are strictly bounded.
>
The max number of discovery objects? It isn't bound now. I don't think
that this discovery list is working out as well as I had hoped that it
would. There is a patch on our mailing list now that removes this list
and just attaches the disc object to the lport. This means that there
is no lookup anymore. Since all incoming FC requests go though the
lport first it can just follow its pointer, get the disc object and
use it.

>> +
>> +/**
>> + * fc_disc_alloc - Allocate a discovery work object
>> + * @lport: The FC lport associated with the discovery job + */
>> +static inline struct fc_disc *fc_disc_alloc(struct fc_lport *lport)
>> +{ + struct fc_disc *disc;
>> +
>> +    disc = kzalloc(sizeof(struct fc_disc), GFP_KERNEL);
>
> This misses a NULL check
>
OK, will fix.

>> +    INIT_LIST_HEAD(&disc->list);
>> +    INIT_DELAYED_WORK(&disc->disc_work, fc_disc_timeout);
>> +    mutex_init(&disc->disc_mutex);
>> +    INIT_LIST_HEAD(&disc->rports);
>> +
>> +    disc->lport = lport;
>> +    disc->delay = FC_DISC_DELAY;
>> +    disc->event = DISC_EV_NONE;
>
> Is it ok that the callback (and probably some other fields) is not
> initialized here yet?
>
>> +
>> +    mutex_lock(&disc_list_lock);
>> +    list_add_tail(&disc->list, &disc_list);
>> +    mutex_unlock(&disc_list_lock);
>
> ... when you make this globally visible?
>
>> +    if (event == RPORT_EV_CREATED) {
>> +            mutex_lock(&disc_list_lock);
>> +            list_for_each_entry(disc, &disc_list, list) {
>> +                    if (disc->lport == lport) {
>> +                            found = 1;
>> +                            mutex_lock(&disc->disc_mutex);
>> +                            list_add_tail(&rdata->peers, &disc->rports);
>> +                            mutex_unlock(&disc->disc_mutex);
>> +                    }
>> +            }
>> +            mutex_unlock(&disc_list_lock);
>
> That's a lot of locks. Did you have a locking order comment somewhere?
>
I have a locking comment at the top of fc_lport.c as well as fc_rport.c,
but they don't mention the discovery code. After we change the disc object
management I'll make sure they're up-to-date. The locking has been
particularly troublesome for me, so I'm sure it can be improved.

>> +    if (!rp || rp->rscn_page_len != sizeof(*pp))
>> +            goto reject;
>> +
>> +    len = ntohs(rp->rscn_plen);
>> +    if (len < sizeof(*rp))
>> +            goto reject;
>> +    len -= sizeof(*rp);
>
> Don't you need to check here than len is a multiple of sizeof(*pp) ?
> Otherwise bad input could make it loop a very long time.
>
I'll have to look into this. You're comment seems reasonable though.

>> +
>> +    for (pp = (void *)(rp + 1); len; len -= sizeof(*pp), pp++) {
>
> Also len >= 0 is always safer.
>
Noted.

>> +                          redisc, lport->state, disc->pending);
>> +            list_for_each_entry_safe(dp, next, &disc_ports, peers) {
>> +                    list_del(&dp->peers); +                 rport = lport->tt.rport_lookup(lport,
>> dp->ids.port_id); +                  if (rport) { +                          rdata = RPORT_TO_PRIV(rport);
>> +                            list_del(&rdata->peers);
>
> Hopefully there's a mutex here hold for that list.
>
>> +                            lport->tt.rport_logoff(rport);
>> +                    }
>> +                    fc_disc_single(disc, dp);
>> +            }
>> +    }
>> +    fc_frame_free(fp);
>> +    return;
>> +reject:
>> +    rjt_data.fp = NULL;
>> +    rjt_data.reason = ELS_RJT_LOGIC;
>> +    rjt_data.explan = ELS_EXPL_NONE;
>> +    lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
>> +    fc_frame_free(fp);
>
> Some statistics counter for that case would be probably useful.
>> +
>> +    op = fc_frame_payload_op(fp);
>> +    switch (op) {
>> +    case ELS_RSCN:
>> +            mutex_lock(&disc->disc_mutex);
>> +            fc_disc_recv_rscn_req(sp, fp, disc);
>> +            mutex_unlock(&disc->disc_mutex);
>
> Ok yes seems the lock is hold.
>> +
>> +    list_for_each_entry_safe(rdata, next, &disc->rports, peers) {
>> +            rport = PRIV_TO_RPORT(rdata);
>> +            FC_DEBUG_DISC("list_del(%6x)\n", rport->port_id);
>> +            list_del(&rdata->peers); +              lport->tt.rport_logoff(rport);
>
> Hopefully that callback knows for which peer that is.
>
I'm a little confused what you're referring to here. rport_logoff() is
one of our transport template function pointers, so for the purely SW
case the rport layer will handle the logoff(). I'm not sure if this
is what you were getting at though.

>> +static void fc_disc_start(void (*disc_callback)(struct fc_lport *,
>> +                                            enum fc_disc_event), +                    struct fc_lport *lport)
>> +{
>> +    struct fc_rport *rport;
>> +    struct fc_rport_identifiers ids;
>> +    struct fc_disc *disc;
>> +    int found = 0;
>> +
>> +    mutex_lock(&disc_list_lock);
>> +    list_for_each_entry(disc, &disc_list, list) {
>> +            if (disc->lport == lport) {
>> +                    found = 1;
>> +                    break;
>> +            }
>> +    }
>> +    mutex_unlock(&disc_list_lock);
>
> This seems to be opencoded a lot. Put it into some helper.
Yes, we probably do this too much. If we end up not using the
discovery list we can dump a lot of this code.

>> +
>> +    /*
>> +     * Handle point-to-point mode as a simple discovery
>> +     * of the remote port. Yucky, yucky, yuck, yuck!
>> +     */
>> +    rport = disc->lport->ptp_rp;
>> +    if (rport) {
>> +            ids.port_id = rport->port_id;
>> +            ids.port_name = rport->port_name;
>> +            ids.node_name = rport->node_name;
>> +            ids.roles = FC_RPORT_ROLE_UNKNOWN;
>> +            get_device(&rport->dev);
>> +
>> +            if (!fc_disc_new_target(disc, rport, &ids)) {
>> +                    disc->event = DISC_EV_SUCCESS;
>> +                    fc_disc_done(disc);
>> +            }
>> +            put_device(&rport->dev);
>
> The ref counting here seems a little dubious. If it's because
> disc_new_target can sleep then preemptible kernels can
> do that anyways. Or it's not needed.
>
OK, I'll have to look into this.

>> +    }
>> +    if (((ids->port_name != -1) || (ids->port_id != -1)) &&
>> +        ids->port_id != fc_host_port_id(lport->host) &&
>> +        ids->port_name != lport->wwpn) {
>> +            if (!rport) {
>> +                    rport = lport->tt.rport_lookup(lport, ids->port_id); +                  if
>> (!rport) { +                         struct fc_disc_port dp;
>> +                            dp.lp = lport;
>> +                            dp.ids.port_id = ids->port_id;
>> +                            dp.ids.port_name = ids->port_name;
>> +                            dp.ids.node_name = ids->node_name;
>> +                            dp.ids.roles = ids->roles;
>> +                            rport = fc_rport_rogue_create(&dp);
>> +                    }
>> +                    if (!rport)
>> +                            error = ENOMEM;
>> +            }
>> +            if (rport) {
>> +                    rp = rport->dd_data;
>> +                    rp->event_callback = fc_disc_rport_event;
>> +                    rp->rp_state = RPORT_ST_INIT;
>> +                    lport->tt.rport_login(rport);
>> +            }
>> +    }
>> +    return error;
>
> Unusual positive error return convention. Ok?
>
Just an oversight, I'll correct this.

>> +            FC_DBG("Error %ld, retries %d/%d\n",
>> +                   PTR_ERR(fp), disc->retry_count,
>> +                   FC_DISC_RETRY_LIMIT);
>> +
>> +    if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {
>
> The mixing of non errnos into PTR_ERR is also unusual,
> but ok, but make sure you never leak them.
>
>> +            /*
>> +             * Memory allocation failure, or the exchange timed out, +               *
>> retry after delay. +          */
>> +            if (disc->retry_count < FC_DISC_RETRY_LIMIT) {
>> +                    /* go ahead and retry */
>> +                    if (!fp)
>> +                            delay = msecs_to_jiffies(500);
>
> Ah that was the missing define above?
>
Yeah, we'll take care of this.

>> +                    else {
>> +                            delay = jiffies +
>> +                                    msecs_to_jiffies(lport->e_d_tov);
>> +
>> +                            /* timeout faster first time */
>> +                            if (!disc->retry_count)
>> +                                    delay /= 4;
>
> You have to divide by four before you add to jiffies, dividing
> absolute jiffies doesn't make sense.
>
Will do.

>> +    /*
>> +     * Handle partial name record left over from previous call. +    */
>> +    bp = buf;
>> +    plen = len;
>> +    np = (struct fc_gpn_ft_resp *)bp;
>> +    tlen = disc->buf_len;
>> +    if (tlen) {
>> +            WARN_ON(tlen >= sizeof(*np));
>> +            plen = sizeof(*np) - tlen;
>> +            WARN_ON(plen <= 0);
>> +            WARN_ON(plen >= sizeof(*np));
>
> I hope none of these WARN_ONs in network controllable. They nearly
> look like some of them are.
>
> Ok stopping here for now. That's a lot of code. Perhaps split it up
> into a little smaller patches?
>
OK, I can do that. Honestly, preparing these patches is a pain. We have
a full git tree that isn't reviewable. So, I diff, splitdiff and then
start putting things back together manually. Maybe, patches by the
different blocks would be more easily reviewable...?

Most people are on vacation this week, including myself. We'll correct
the called-out problems and re-send a patch next week.

> General impressions:
> - Your locking is to complicated I think. Less locks is often more.

So, the question for me is really if the discovery object should have
its own lock or if it should share the lport's lock. I liked it having
its own lock because it seemed to make it more modular, but the discovery
code (as well as the EM) still relies on the lport and so it is in
limbo a bit. It has its own members and lock, but still relies on the
lport. If the pointer to the discovery object moves into the lport and
the disc list goes away then maybe it makes sense to just use the lport
lock. I guess I envisioned some meta-data eventually being passed between
the lport and the discovery layer so they were more independent.

> For short locks we also recommend spinlocks which perform
> better (although you have to make sure you don't sleep then of course)
> - I would double check everything that handles network data to
> make sure it's not exploitable.
>
> -Andi

Thanks,

//Rob
