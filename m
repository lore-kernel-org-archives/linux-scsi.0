From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] multipath: Evaluate request result and sense code
Date: Thu, 26 Nov 2009 09:03:59 +0100
Message-ID: <4B0E366F.6060805@suse.de>
References: <20091119122503.413AD3A174@ochil.suse.de> <E463DF2B2E584B4A82673F53D62C2EF48723766A@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759367AbZKZIDy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Nov 2009 03:03:54 -0500
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF48723766A@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: James Bottomley <James.Bottomley@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Moger, Babu wrote:
> Hannes,
>   My .02 cents on this below..
>=20
> ________________________________________
> From: linux-scsi-owner@vger.kernel.org [linux-scsi-owner@vger.kernel.=
org] On Behalf Of Hannes Reinecke [hare@suse.de]
> Sent: Thursday, November 19, 2009 6:25 AM
> To: James Bottomley
> Cc: dm-devel@redhat.com; linux-scsi@vger.kernel.org
> Subject: [PATCH] multipath: Evaluate request result and sense code
>=20
> As we now see the result for every command we
> can use it to make some more elaborate choices
> if we should retry the request on another path.
>=20
> This solves a potential data corruption when
> a request is being terminated with RESERVATION
> CONFLICT and queue_if_no_path is active; the
> request will be queued until the reservation
> status changes and then transmitted.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-mpath.c |   49 +++++++++++++++++++++++++++++++++++++++=
++++++++++
>  1 files changed, 49 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index dce971d..460e11f 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -19,6 +19,7 @@
>  #include <linux/time.h>
>  #include <linux/workqueue.h>
>  #include <scsi/scsi_dh.h>
> +#include <scsi/scsi_eh.h>
>  #include <asm/atomic.h>
>=20
>  #define DM_MSG_PREFIX "multipath"
> @@ -101,6 +102,7 @@ struct multipath {
>  struct dm_mpath_io {
>         struct pgpath *pgpath;
>         size_t nr_bytes;
> +       char sense[SCSI_SENSE_BUFFERSIZE];
>  };
>=20
>  typedef int (*action_fn) (struct pgpath *pgpath);
> @@ -913,6 +915,9 @@ static int multipath_map(struct dm_target *ti, st=
ruct request *clone,
>=20
>         map_context->ptr =3D mpio;
>         clone->cmd_flags |=3D REQ_FAILFAST_TRANSPORT;
> +       /* Always attach a sense buffer */
> +       if (!clone->sense)
> +               clone->sense =3D mpio->sense;
>         r =3D map_io(m, clone, mpio, 0);
>         if (r < 0 || r =3D=3D DM_MAPIO_REQUEUE)
>                 mempool_free(mpio, m->mpio_pool);
> @@ -1192,6 +1197,42 @@ static void activate_path(struct work_struct *=
work)
>  }
>=20
>  /*
> + * Evaluate scsi return code
> + */
> +static int eval_scsi_error(int result, char *sense, int sense_len)
> +{
> +       struct scsi_sense_hdr sshdr;
> +       int r =3D DM_ENDIO_REQUEUE;
> +
> +       if (host_byte(result) !=3D DID_OK)
> +               return r;
> +
> +       if (msg_byte(result) !=3D COMMAND_COMPLETE)
> +               return r;
> +
> +       if (status_byte(result) =3D=3D RESERVATION_CONFLICT)
> +               /* Do not retry here, possible data corruption */
> +               return -EIO;
> +
> +       if (status_byte(result) =3D=3D CHECK_CONDITION &&
> +           !scsi_normalize_sense(sense, sense_len, &sshdr)) {
> +
> +               switch (sshdr.sense_key) {
> +               case MEDIUM_ERROR:
> +               case DATA_PROTECT:
> +               case BLANK_CHECK:
> +               case COPY_ABORTED:
> +               case VOLUME_OVERFLOW:
> +               case MISCOMPARE:
> +                       r =3D -EIO;
> +                       break;
> +               }
>=20
> The above sense key list does not cover all the cases(at least for my=
 case).
Of course. This is by no means meant to be the final list on sense keys=
=2E
This is basically copied from scsi_decide_dispostion to give us a start=
ing
point with some sane defaults.

> For example, I have these requirements for my storage.
> 1. For certain check conditions I should be reporting I/O error immed=
iately
> without retrying on other paths. You have covered some cases here but=
 we a
> have bigger list.
> 2. For few other check condtions I should be calling activate_path in=
stead
> of failing the path.
> So, I am thinking it may be better to handle this with scsi device ha=
ndlers
> (may be providing a new scsi_dh interface and fallback to default han=
dling
> if the device handler does not handle the sense).  I am not sure if t=
his is
> feasible but something to think about.
>=20
Yes, this is the plan. Each device_handler has it's own sense_handler t=
o
handle the sense codes it cares about. This handler is called prior
to the generic one (ie the one I posted), enabling it to modify
the return code so that the generic handler can do the right decision.

Of course this patch isn't final, it was meant as a starting point
to agree on the infrastructure. How the individual errors should
be handled should be discussed in the next stage once the infrastructur=
e
is in place.

Alternatively you could sent a patch on top of my patchset to modify
the behaviour. I'll be happy to include it in the next revision of the
patchset :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
