From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 22/36] atari_scsi: Fix atari_scsi deadlocks on Falcon
Date: Thu, 30 Oct 2014 09:07:33 +0100
Message-ID: <5451F1C5.8000709@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052612.445434791@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbaJ3IHf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2014 04:07:35 -0400
In-Reply-To: <20141027052612.445434791@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On 10/27/2014 06:26 AM, Finn Thain wrote:
> Don't disable irqs when waiting for the ST DMA "lock"; its release ma=
y
> require an interrupt.
>=20
> Introduce stdma_try_lock() for use in soft irq context. atari_scsi no=
w tells
> the SCSI mid-layer to defer queueing a command if the ST DMA lock is =
not
> available, as per Michael's patch:
> http://marc.info/?l=3Dlinux-m68k&m=3D139095335824863&w=3D2
>=20
> The falcon_got_lock variable is race prone: we can't disable IRQs whi=
le
> waiting to acquire the lock, so after acquiring it there must be some
> interval during which falcon_got_lock remains false. Introduce
> stdma_is_locked_by() to replace falcon_got_lock.
>=20
> The falcon_got_lock tests in the EH handlers are incorrect these days=
=2E It
> can happen that an EH handler is called after a command completes nor=
mally.
> Remove these checks along with falcon_got_lock.
>=20
> Also remove the complicated and racy fairness wait queues. If fairnes=
s is an
> issue (when SCSI competes with IDE for the ST DMA interrupt), the sol=
ution
> is likely to be a lower value for host->can_queue.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
