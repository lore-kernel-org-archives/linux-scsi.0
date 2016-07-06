From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] qla2xxx: setup data needed in ISR before setting up the
 ISR
Date: Wed, 6 Jul 2016 11:43:06 +0200
Message-ID: <577CD2AA.3080204@suse.de>
References: <1467791510-5307-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbcGFJnJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jul 2016 05:43:09 -0400
In-Reply-To: <1467791510-5307-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>

On 07/06/2016 09:51 AM, Johannes Thumshirn wrote:
> qla2xxx first calls request_irq() and then does the setup of the queu=
e
> entry data needed in the interrupt handlers in when using MSI-X. This
> could lead to a NULL pointer dereference when an IRQ fires between th=
e
> request_irq() call and the assignment of the qentry data structure to=
 the
> rsp->msix field. A possible case for such a race would be in the kdum=
p
> case when the HBA's IRQs are still enabled but the driver is undergoi=
ng
> a new initialisation and thus is not aware of already activated IRQs =
in
> the HBA.
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/qla2xxx/qla_isr.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
