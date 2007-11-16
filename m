From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] multipath: Add new SPC-3 ALUA hardware handler
Date: Fri, 16 Nov 2007 12:36:01 +0100
Message-ID: <473D80A1.7000402@suse.de>
References: <20071115091634.4568D347401@pentland.suse.de> <8764021o7x.fsf@confield.dd.xiranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbXKPLgD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Nov 2007 06:36:03 -0500
In-Reply-To: <8764021o7x.fsf@confield.dd.xiranet.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arne Redlich <arne.redlich@xiranet.com>
Cc: Alasdair Kergon <agk@redhat.com>, michaelc@cs.wisc.edu, dm-devel@redhat.com, linux-scsi@vger.kernel.org

Arne Redlich wrote:
> Hi Hannes,
>=20
> hare@suse.de (Hannes Reinecke) writes:
>=20
>> This adds a new SPC-3 ALUA hardware handler for multipathing.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>=20
> <snip>
>=20
>> +#define TPGS_STATE_OPTIMIZED		0x0
>> +#define TPGS_STATE_NONOPTIMIZED		0x1
>> +#define TPGS_STATE_STANDBY		0x2
>> +#define TPGS_STATE_UNAVAILABLE		0x3
>> +#define TPGS_STATE_OFFLINE		0xe
>=20
> SPC-3 (at least the draft, rev 23 I'm looking at) doesn't know an
> 'Offline' state - I think it's a SPC-4 feature. So maybe 'Unavailable=
'
> should be interpreted as path failure as well / instead?
>=20
It is SPC-4. And if the state is unavailable, we can try to
activate it; spc3r23 says (5.8.2.4.5):
Therefore it may not be possible to transition from this state to
either the active/optimized, active/non-optimized or standby states.

But consequently it _may_ be possible, so we should at least try.
If that fails (ie if SET TARGET PORT GROUPS returns
an error) we'll fail the path anyway.
No harm in trying.

> <snip>
>=20
>> +/*
>> + * SET TARGET GROUP STATES endio handler
>> + *
>> + * We only have to test here if we should resubmit the command;
>> + * any other error is assumed as a failure.
>> + * Maybe we should analyze the sensebuffer here, too.
>> + */
>> +static void stpg_endio(struct request *req, int error)
>> +{
>> +	struct hw_handler *hwh =3D req->end_io_data;
>> +	struct alua_handler *h =3D hwh->context;
>> +
>> +	switch(host_byte(error)) {
>> +	case DID_BUS_BUSY:
>> +		if (!h->retry)
>> +			break;
>> +		h->retry--;
>> +	case DID_REQUEUE:
>> +	case DID_IMM_RETRY:
>> +		dm_enqueue_hw_workq(hwh);
>> +		goto done;
>> +	}
>> +
>> +	if (had_failures(req, error)) {
>> +		if (h->tpgs & TPGS_MODE_IMPLICIT) {
>> +			/* Ignore errors; the array will figure it out */
>> +			DMWARN("%s: stpg failed %x, disabling explicit mode",
>> +			       h->path->dev->name, error);
>> +			h->tpgs &=3D ~TPGS_MODE_EXPLICIT;
>> +			dm_enqueue_hw_workq(hwh);
>> +		} else {
>> +			DMWARN("%s: stpg failed %x, disable path",
>> +			       h->path->dev->name, error);
>> +			dm_pg_init_complete(h->path, MP_FAIL_PATH);
>> +		}
>> +	} else {
>> +		DMWARN("%s: port group %02x new state %c",
>> +		       h->path->dev->name, h->group_id,
>> +		       print_alua_state(h->state) );
>> +		dm_pg_init_complete(h->path, 0);
>=20
> Hmmm, maybe I'm just missing something so CMIIW, but I think the PG
> state should be retrieved once more before finally calling
> dm_pg_init_complete(), because the target might return the STPG comma=
nd
> before the transition has completed (SPC-3, 6.31). This could confuse
> application clients?
>=20
Hmm. Spec isn't exactly clear here. One would expect that these arrays
would have set the T_SUP bit in REPORT TARGET PORT GROUPS, and set the
ALUA state to 'TRANSITIONING' accordingly. But we catch the relevant
sense codes as per SPC-3, so we should retry it properly.

And it's not that I've actually seen an array implementing this, so
it's a bit academic currently.=20

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
