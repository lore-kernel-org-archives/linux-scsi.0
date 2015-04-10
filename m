From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/21] lpfc: Fix host reset escalation killing all IOs.
Date: Fri, 10 Apr 2015 08:10:38 +0200
Message-ID: <5527695E.4050109@suse.de>
References: <1428095489.6933.34.camel@myfc17>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbbDJGKk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Apr 2015 02:10:40 -0400
In-Reply-To: <1428095489.6933.34.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com, linux-scsi@vger.kernel.org

On 04/03/2015 11:11 PM, James Smart wrote:
> Fix host reset escalation killing all IOs.
>=20
> SLI-3 adapters will use a new host template. The template differs
> from SLI-4 adapters in that it does not have an eh_host_reset_handler=
=2E
>=20
> Lpfc has traditionally never had a host_reset. The host reset
> handler was added when we ran into a stuck hardware condition on a
> SLI-4 adapter. The host_reset will reset and reinit the pci function,
> clearing the hardware condition.
>=20
> Unfortunately, the host reset handler uses attach/detach code paths,
> which makes scsi_add_host() and scsi_remove_host() calls. Meaning, a
> host_reset will completely remove the scsi_host from the system. As a
> new call to scsi_add_host() is made, the shost# changes, which result=
s
> in completely new scsi_devices and device names. All the older scsi
> devices on the old shost# are now orphaned and unrecoverable.
>=20
> We realize we need to re-implement the host_reset_handler so the scsi=
_host
> stays registered across the host_reset, but that will be a rather
> lengthy effort. In the short term, we had an immediate need to restor=
e
> the SLI-3 devices to their working behavior, with the easiest path be=
ing
> to remove their host_reset handler.
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
> Signed-off-by: James Smart <james.smart@emulex.com>
> ---

Of course, this will disable the eh_deadline mechanism, which relies
on the host_reset to be present.

Of which you are perfectly aware :-)

So, grudgingly:

Reviewed-by: Hannes Reinecke <hare@suse.de>

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
