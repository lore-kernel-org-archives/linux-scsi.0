From: Jens Axboe <axboe@suse.de>
Subject: Re: memory leak in scsi_cmd_cache 2.6.15
Date: Sun, 29 Jan 2006 20:57:33 +0100
Message-ID: <20060129195733.GH13831@suse.de>
References: <Pine.LNX.4.62.0601222045180.12815@pureeloreel.qftzy.pbz> <1137997104.2977.7.camel@laptopd505.fenrus.org> <200601230029.12674.chase.venters@clientec.com> <Pine.LNX.4.62.0601230136080.22979@pureeloreel.qftzy.pbz> <20060123072556.GC15490@fifty-fifty.audible.transient.net> <Pine.LNX.4.62.0601261312160.1174@pureeloreel.qftzy.pbz> <87ek2td4i9.fsf@amaterasu.srvr.nix> <20060128192714.GI9750@suse.de> <20060129155009.GT28738@edu.joroinen.fi> <1138552692.3352.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:6236 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1751133AbWA2UAx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jan 2006 15:00:53 -0500
Content-Disposition: inline
In-Reply-To: <1138552692.3352.6.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>, Nix <nix@esperi.org.uk>, Ariel <askernel2615@dsgml.com>, Jamie Heilman <jamie@audible.transient.net>, Chase Venters <chase.venters@clientec.com>, Arjan van de Ven <arjan@infradead.org>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Jan 29 2006, James Bottomley wrote:
> On Sun, 2006-01-29 at 17:50 +0200, Pasi K=E4rkk=E4inen wrote:
> > Are all sata drivers affected by this bug in 2.6.15?
>=20
> Well, all SCSI drivers are affected by it, yes.  However, SATA device=
s
> are peculiarly affected because the ordered_flush method of enforcing
> barriers, which is where the leak is, can only be implemented for
> devices that don't do tag command queueing (i.e. don't have multiple
> commands outstanding for a given single device).  By and large, SATA
> drivers are the only drivers in the SCSI subsystem that can't do tag
> command queueing, which is why the problem didn't show up for any oth=
er
> type of SCSI driver.

2.6.15 didn't support barriers for anything other than ordered flush
SCSI low level drivers, hence only SATA is affected.

> > Any 'official' patch available?
>=20
> Well, yes, 2.6.16-rc1 has this fixed.  I can't see backporting this t=
o
> 2.6.15.x since it represents a significant functionality enhancement =
as
> well, so I'd lean towards just forcing ordered_flush to zero in 2.6.1=
5.x
> which seems to be the best bug fix.

Agree, backporting the barrier rewrite would be insane for stable.

> > Or is the recommended workaround to set ordered_flush to 0 to fix t=
his..
> > does that have any downsides?
>=20
> setting ordered_flush to zero for 2.6.15 turns off the flushing
> functionality and restores the old behaviour.  I don't see that there
> would be any down side to this.

Just the usual correctness issue, but since it's leaky it doesn't seem
like a big deal to wait for 2.6.16.

So here's a patch for 2.6.15:

---

Turn off ordered flush barriers for SCSI driver, since the SCSI barrier
code has a command leak.

Signed-off-by: Jens Axboe <axboe@suse.de>

--- linux-2.6.15.1/drivers/scsi/scsi_lib.c~	2006-01-29 11:55:08.0000000=
00 -0800
+++ linux-2.6.15.1/drivers/scsi/scsi_lib.c	2006-01-29 11:55:38.00000000=
0 -0800
@@ -1534,11 +1534,6 @@
 	 */
 	if (shost->ordered_tag)
 		blk_queue_ordered(q, QUEUE_ORDERED_TAG);
-	else if (shost->ordered_flush) {
-		blk_queue_ordered(q, QUEUE_ORDERED_FLUSH);
-		q->prepare_flush_fn =3D scsi_prepare_flush_fn;
-		q->end_flush_fn =3D scsi_end_flush_fn;
-	}
=20
 	if (!shost->use_clustering)
 		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);

--=20
Jens Axboe

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
