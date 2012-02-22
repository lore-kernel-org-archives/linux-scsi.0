From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] scsi scan: don't fail scans when host is in recovery
Date: Wed, 22 Feb 2012 10:56:58 +0100
Message-ID: <4F44BBEA.3020400@suse.de>
References: <1314250598-2852-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab2BVJ5A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2012 04:57:00 -0500
In-Reply-To: <1314250598-2852-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On 08/25/2011 07:36 AM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
>=20
> The problem is that if we are doing a scsi scan then the device goes
> into recovery then we will wait for the recovery to complete. It wait=
s
> because scsi-ml will send inquiries or report luns and the queueing c=
ode
> will have been blocked due to the host not being ready. However, if w=
e
> are in recovery and then a scan is started the scan will silently fai=
l
> and some devices will not be added.
>=20
> It is easy to hit the problem where devices do not show up with
> FC where we are doing tests that disrupt the target controllers.
> When the controller is disruprted (reboot, or setting firmware, etc),
> and we cause the dev loss tmo to fire then devices will be removed
> Then when the problem has been fixed, the rport will be scanned and
> devices should be added back. But if we cause another disruption befo=
re
> scanning has started then devices will not get added back. If the pro=
blem
> is not started until the scan is started then the devices will be add=
ed
> back.
>=20
> This patch fixes that problem by not failing scans when the host
> is in recovery. We will let scsi-ml send the IO and let the queueing
> and scsi error handling deal with it like is done if we went into
> recovery while scanning.
>=20
> For recovery cases where the host is being torn down then with the
> patch we will still fail the scan since there is not point in scannin=
g.
>=20
> Patch was made and tested over scsi-misc.
>=20
>=20
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  include/scsi/scsi_host.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index f1f2644..22b7b23 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -791,7 +791,8 @@ static inline struct device *scsi_get_device(stru=
ct Scsi_Host *shost)
>   **/
>  static inline int scsi_host_scan_allowed(struct Scsi_Host *shost)
>  {
> -	return shost->shost_state =3D=3D SHOST_RUNNING;
> +	return shost->shost_state =3D=3D SHOST_RUNNING ||
> +	       shost->shost_state =3D=3D SHOST_RECOVERY;
>  }
> =20
>  extern void scsi_unblock_requests(struct Scsi_Host *);

James, ping?
Any reason it was not included?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
