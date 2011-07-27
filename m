From: "Jack Wang" <jack_wang@usish.com>
Subject: Re: [PATCH] [SCSI] libsas: remove expander from dev list on error
Date: Wed, 27 Jul 2011 11:26:25 +0800
Message-ID: <3B54164438364A3A9A2F19AFF5A4DF0A@usish.com.cn>
References: <1311736140.88961.YahooMailNeo@web31805.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:55919 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab1G0D0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 23:26:46 -0400
In-Reply-To: <1311736140.88961.YahooMailNeo@web31805.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Luben Tuikov' <ltuikov@yahoo.com>, 'James Bottomley' <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

 [PATCH] [SCSI] libsas: remove expander from dev list on error
>=20
> If expander discovery fails (sas_discover_expander()),
> remove the expander from the port device list
> (sas_ex_discover_expander()), before freeing it. Else
> the list is corrupted and, e.g., when we attempt to send
> SMP commands to other devices, the kernel oopses.
>=20
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
> =A0drivers/scsi/libsas/sas_expander.c |=A0=A0=A0 3 +++
> =A01 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/scsi/libsas/sas_expander.c
> b/drivers/scsi/libsas/sas_expander.c
> index 874e29d..f84084b 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -849,6 +849,9 @@ static struct domain_device *sas_ex_discover_expa=
nder(
>=20
> =A0=A0=A0=A0 res =3D sas_discover_expander(child);
> =A0=A0=A0=A0 if (res) {
> +=A0=A0=A0 =A0=A0=A0 spin_lock_irq(&parent->port->dev_list_lock);
> +=A0=A0=A0 =A0=A0=A0 list_del(&child->dev_list_node);
> +=A0=A0=A0 =A0=A0=A0 spin_unlock_irq(&parent->port->dev_list_lock);
> =A0=A0=A0=A0 =A0=A0=A0 kfree(child);
> =A0=A0=A0=A0 =A0=A0=A0 return NULL;
> =A0=A0=A0=A0 }
> --
[Jack Wang] Looks reasonable, thanks for fix this.
You can add my Reviewed-by: Jack Wang <jack_wang@usish.com> if needed.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
