From: Hannes Reinecke <hare@suse.de>
Subject: Re: 2.6.24-rc3-mm1
Date: Fri, 14 Dec 2007 10:00:57 +0100
Message-ID: <47624649.3040209@suse.de>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>	 <47462F3C.3040700@googlemail.com>	 <20071122201250.f957e280.akpm@linux-foundation.org>	 <47466B5D.90607@googlemail.com>	 <20071126221509.8f437b61.akpm@linux-foundation.org> <1197390783.3812.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506AbXLNJBB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Dec 2007 04:01:01 -0500
In-Reply-To: <1197390783.3812.19.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2007-11-26 at 22:15 -0800, Andrew Morton wrote:
>> OK, thanks.  I'll assume that James and Hannes have this in hand (or=
 will
>> have, by mid-week) and I won't do anything here.
>=20
> Just to confirm what I think I'm going to be doing:  rebasing the
> scsi-misc tree to remove this commit:
>=20
> commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0
> Author: Hannes Reinecke <hare@suse.de>
> Date:   Tue Nov 6 09:23:40 2007 +0100
>=20
>     [SCSI] Do not requeue requests if REQ_FAILFAST is set
>=20
> And its allied fix ups:
>=20
> commit 983289045faa96fba8841d3c51b98bb8623d9504
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Sat Nov 24 19:47:25 2007 +0200
>=20
>     [SCSI] fix up REQ_FASTFAIL not to fail when state is QUIESCE
>=20
> commit 9dd15a13b332e9f5c8ee752b1ccd9b84cb5bdf17
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Sat Nov 24 19:55:53 2007 +0200
>=20
>     [SCSI] fix domain validation to work again
>=20
> James
>=20
>=20
Or just apply my latest patch (cf Undo __scsi_kill_request).
The main point is that we shouldn't retry requests
with FAILFAST set when the queue is blocked. AFAICS
only FC and iSCSI transports set the queue to blocked,
and use this to indicate a loss of connection. So any
retry with queue blocked is futile.

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
