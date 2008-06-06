From: Hannes Reinecke <hare@suse.de>
Subject: Re: mpath: don't fail paths on first error
Date: Fri, 06 Jun 2008 16:18:05 +0200
Message-ID: <4849471D.4060104@suse.de>
References: <4848218B.3090404@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:33777 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbYFFOSH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2008 10:18:07 -0400
In-Reply-To: <4848218B.3090404@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Mike,

Mike Christie wrote:
> The problem we see a lot at Red Hat is that if drivers fail a command=
=20
> with DID_BUS_BUSY or DID_ERROR for something like underrun or even fo=
r=20
> transient path problems, we can normally recover from this pretty=20
> quickly and we do not need to switch path groups.
>=20
Yeah, I thought about this, too.
> queue_if_no_path/no_path_retry will prevent IO from being fail upward=
s,=20
> but just switching paths can cause a lot of strain on the target, so =
we=20
> might want to prevent path switching when we do not need to. If we ar=
e=20
> using a box that requires manual failover or a box that does not use=20
> manual failover but still has to shift resources between storage=20
> controllers when switching paths, we most likely do not want to mark=20
> paths failed for these transient errors.
>=20
Well, the original design idea was that it always will be quicker or
less error-prone to just move the I/O to the next path.
Seeing that this is not always the case this approach is probably
better.

> The attached patch allows us to wait X seconds before marking a path =
as=20
> failed. If within X seconds from seeing the first IO error, we do not=
=20
> see a IO complete successfully then we mark a path as failed. This pa=
tch=20
> work best with the fail fast enhancements ones where for a lot of pat=
h=20
> problems the fast io fail / recovery timeout will fail io quickly to =
us=20
> and the test IOs do not get stuck, and where some errors like DID_ERR=
OR=20
> are not even failed fast.
>=20
> The patch should apply over linus's tree or scsi-misc.
>=20
Thanks for this, Mike.

Signed-off-by: Hannes Reinecke <hare@suse.de>

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
