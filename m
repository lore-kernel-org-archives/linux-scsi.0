From: Arne Redlich <arne.redlich@xiranet.com>
Subject: Re: [PATCH 2/3] multipath: Add new SPC-3 ALUA hardware
	handler
Date: Fri, 16 Nov 2007 11:25:38 +0100
Message-ID: <8764021o7x.fsf@confield.dd.xiranet.com>
References: <20071115091634.4568D347401@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071115091634.4568D347401@pentland.suse.de> (Hannes Reinecke's
	message of "Thu\, 15 Nov 2007 10\:16\:34 +0100")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: michaelc@cs.wisc.edu, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Hannes,

hare@suse.de (Hannes Reinecke) writes:

> This adds a new SPC-3 ALUA hardware handler for multipathing.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

<snip>

> +#define TPGS_STATE_OPTIMIZED		0x0
> +#define TPGS_STATE_NONOPTIMIZED		0x1
> +#define TPGS_STATE_STANDBY		0x2
> +#define TPGS_STATE_UNAVAILABLE		0x3
> +#define TPGS_STATE_OFFLINE		0xe

SPC-3 (at least the draft, rev 23 I'm looking at) doesn't know an
'Offline' state - I think it's a SPC-4 feature. So maybe 'Unavailable'
should be interpreted as path failure as well / instead?

<snip>

> +/*
> + * SET TARGET GROUP STATES endio handler
> + *
> + * We only have to test here if we should resubmit the command;
> + * any other error is assumed as a failure.
> + * Maybe we should analyze the sensebuffer here, too.
> + */
> +static void stpg_endio(struct request *req, int error)
> +{
> +	struct hw_handler *hwh = req->end_io_data;
> +	struct alua_handler *h = hwh->context;
> +
> +	switch(host_byte(error)) {
> +	case DID_BUS_BUSY:
> +		if (!h->retry)
> +			break;
> +		h->retry--;
> +	case DID_REQUEUE:
> +	case DID_IMM_RETRY:
> +		dm_enqueue_hw_workq(hwh);
> +		goto done;
> +	}
> +
> +	if (had_failures(req, error)) {
> +		if (h->tpgs & TPGS_MODE_IMPLICIT) {
> +			/* Ignore errors; the array will figure it out */
> +			DMWARN("%s: stpg failed %x, disabling explicit mode",
> +			       h->path->dev->name, error);
> +			h->tpgs &= ~TPGS_MODE_EXPLICIT;
> +			dm_enqueue_hw_workq(hwh);
> +		} else {
> +			DMWARN("%s: stpg failed %x, disable path",
> +			       h->path->dev->name, error);
> +			dm_pg_init_complete(h->path, MP_FAIL_PATH);
> +		}
> +	} else {
> +		DMWARN("%s: port group %02x new state %c",
> +		       h->path->dev->name, h->group_id,
> +		       print_alua_state(h->state) );
> +		dm_pg_init_complete(h->path, 0);

Hmmm, maybe I'm just missing something so CMIIW, but I think the PG
state should be retrieved once more before finally calling
dm_pg_init_complete(), because the target might return the STPG command
before the transition has completed (SPC-3, 6.31). This could confuse
application clients?

Arne
