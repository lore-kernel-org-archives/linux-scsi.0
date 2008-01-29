From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC] aic7xxx - ahc_done check SCB_ACTIVE for tagged transactions
Date: Tue, 29 Jan 2008 16:18:16 +0100
Message-ID: <479F43B8.2090902@suse.de>
References: <20080125181618.GB26158@dhcp-210.hsv.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:38177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbYA2PSS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jan 2008 10:18:18 -0500
In-Reply-To: <20080125181618.GB26158@dhcp-210.hsv.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Milburn <dmilburn@redhat.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

David Milburn wrote:
> Hannes,
>=20
> Does ahc_done need to check the SCB_ACTIVE flag only if the SCB
> is not in the untagged queue before panic?
>=20
> If the driver is in error recovery, you may end panic'ing
> on a TUR that is in the untagged queue.
>=20
> Attempting to queue an ABORT message
> CDB: 0x0 0x0 0x0 0x0 0x0 0x0
> SCB 3 done'd twice
>=20
> This patch is included in Adaptec's 6.3.11 driver on their=20
> website.
>=20
> Thank you,
> David
>=20
> --- scsi-misc-2.6.git/drivers/scsi/aic7xxx/aic7xxx_osm.c.abort
> +++ scsi-misc-2.6.git/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -1658,9 +1658,12 @@ ahc_done(struct ahc_softc *ahc, struct s
>  		untagged_q =3D &(ahc->untagged_queues[target_offset]);
>  		TAILQ_REMOVE(untagged_q, scb, links.tqe);
>  		BUG_ON(!TAILQ_EMPTY(untagged_q));
> -	}
> -
> -	if ((scb->flags & SCB_ACTIVE) =3D=3D 0) {
> +	} else if ((scb->flags & SCB_ACTIVE) =3D=3D 0) {
> +		/*
> +		 * Transactions aborted from the untagged queue may
> +		 * not have been dispatched to the controller, so
> +		 * only check the SCB_ACTIVE flag for tagged transactions.
> +		 */
>  		printf("SCB %d done'd twice\n", scb->hscb->tag);
>  		ahc_dump_card_state(ahc);
>  		panic("Stopping for safety");
>=20
Yes, this looks correct. The SCB_ACTIVE flag is reset when doing an ahc=
_scb_free()
at the very end of ahc_done(). And seeing that we are re-using scbs for=
 error recovery
we might indeed end up with an scb with SCB_ACTIVE is set.

But I'll do some more investigation.
Do you have any setup to exercise this?

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
