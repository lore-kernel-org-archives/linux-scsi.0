From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH V2 7/8] scsi: hpsa: call hpsa_hba_inquiry() after adding
 host
Date: Mon, 5 Feb 2018 18:55:11 +0000
Message-ID: <7cd6ea234585450f972a5cdd73961e97@microsemi.com>
References: <20180205152035.15016-1-ming.lei@redhat.com>
 <20180205152035.15016-8-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0084.outbound.protection.outlook.com ([104.47.36.84]:49633
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753640AbeBESzV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Feb 2018 13:55:21 -0500
In-Reply-To: <20180205152035.15016-8-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>



> -----Original Message-----
> From: Ming Lei [mailto:ming.lei@redhat.com]
> Sent: Monday, February 05, 2018 9:21 AM
> To: Jens Axboe <axboe@kernel.dk>; linux-block@vger.kernel.org; Christoph
> Hellwig <hch@infradead.org>; Mike Snitzer <snitzer@redhat.com>
> Cc: linux-scsi@vger.kernel.org; Hannes Reinecke <hare@suse.de>; Arun Easi
> <arun.easi@cavium.com>; Omar Sandoval <osandov@fb.com>; Martin K .
> Petersen <martin.petersen@oracle.com>; James Bottomley
> <james.bottomley@hansenpartnership.com>; Christoph Hellwig <hch@lst.de>;
> Don Brace <don.brace@microsemi.com>; Kashyap Desai
> <kashyap.desai@broadcom.com>; Peter Rivera <peter.rivera@broadcom.com>;
> Paolo Bonzini <pbonzini@redhat.com>; Laurence Oberman
> <loberman@redhat.com>; Ming Lei <ming.lei@redhat.com>
> Subject: [PATCH V2 7/8] scsi: hpsa: call hpsa_hba_inquiry() after adding =
host
>=20
> EXTERNAL EMAIL
>=20
>=20
> So that we can decide the default reply queue by the map created
> during adding host.
>=20
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Arun Easi <arun.easi@cavium.com>
> Cc: Omar Sandoval <osandov@fb.com>,
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
> Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
> Cc: Christoph Hellwig <hch@lst.de>,
> Cc: Don Brace <don.brace@microsemi.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Peter Rivera <peter.rivera@broadcom.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/hpsa.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 287e5eb0723f..443eabf63a9f 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -8691,12 +8691,9 @@ static int hpsa_init_one(struct pci_dev *pdev, con=
st
> struct pci_device_id *ent)
>         /* Disable discovery polling.*/
>         h->discovery_polling =3D 0;
>=20
> -
>         /* Turn the interrupts on so we can service requests */
>         h->access.set_intr_mask(h, HPSA_INTR_ON);
>=20
> -       hpsa_hba_inquiry(h);
> -
>         h->lastlogicals =3D kzalloc(sizeof(*(h->lastlogicals)), GFP_KERNE=
L);
>         if (!h->lastlogicals)
>                 dev_info(&h->pdev->dev,
> @@ -8707,6 +8704,8 @@ static int hpsa_init_one(struct pci_dev *pdev, cons=
t
> struct pci_device_id *ent)
>         if (rc)
>                 goto clean7; /* perf, sg, cmd, irq, shost, pci, lu, aer/h=
 */
>=20
> +       hpsa_hba_inquiry(h);
> +
>         /* Monitor the controller for firmware lockups */
>         h->heartbeat_sample_interval =3D HEARTBEAT_SAMPLE_INTERVAL;
>         INIT_DELAYED_WORK(&h->monitor_ctlr_work, hpsa_monitor_ctlr_worker=
);
> --
> 2.9.5

Tested-by: Don Brace <don.brace@microsemi.com>
P441, P431, P830i, H240

Acked-by: Don Brace <don.brace@microsemi.com>
