From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2][RESEND] scsi_dh_alua: ALUA handler attach should
 succeed while TPG is transitioning
Date: Wed, 16 Oct 2013 07:49:38 +0200
Message-ID: <525E28F2.3040403@suse.de>
References: <1381852374.1593.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab3JPFtj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Oct 2013 01:49:39 -0400
In-Reply-To: <1381852374.1593.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stewart, Sean" <Sean.Stewart@netapp.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 10/15/2013 05:52 PM, Stewart, Sean wrote:
> During testing, it was discovered that when a device tries to attach =
to the alua handler while in TPG
> state of transitioning, the alua_rtpg function will wait for it to ex=
it the state before allowing it
> to continue. As a result, if the 60 second timeout expires, the alua =
handler will not attach to the
> device.
>=20
> To fix this, I have introduced an input argument to alua_rtpg called =
wait_for_transition.  The idea is
> that it will wait for the transition to complete before an activation=
 (because the current TPG state has
> some bearing in that case), but during a discovery if it is transitio=
ning, it will not wait, and will
> store the state as standby for the time being.
>=20
> I believe the precedent exists for this from commit c0d289b3e59577532=
c45ee9110ef81bd7b341272
> Since if the device reports a state of transitioning, it can transiti=
on to other more valid states, and
> it has been established TPGS is supported on the device, if it is att=
aching.
>=20
> Signed-off-by: Sean Stewart <Sean.Stewart@netapp.com>

Hmm. Looks like you're correct.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
