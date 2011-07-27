From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [SCSI] libsas: remove expander from dev list on error
Date: Tue, 26 Jul 2011 23:02:07 -0700 (PDT)
Message-ID: <1311746527.11636.YahooMailNeo@web31811.mail.mud.yahoo.com>
References: <1311736140.88961.YahooMailNeo@web31805.mail.mud.yahoo.com> <3B54164438364A3A9A2F19AFF5A4DF0A@usish.com.cn>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3B54164438364A3A9A2F19AFF5A4DF0A@usish.com.cn>
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

----- Original Message -----

> From: Jack Wang <jack_wang@usish.com>
> To: 'Luben Tuikov' <ltuikov@yahoo.com>; 'James Bottomley' <James.Bott=
omley@suse.de>; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.or=
g
> Cc:=20
> Sent: Tuesday, July 26, 2011 8:26 PM
> Subject: Re: [PATCH] [SCSI] libsas: remove expander from dev list on =
error
>=20
> [PATCH] [SCSI] libsas: remove expander from dev list on error
>>=20
>>  If expander discovery fails (sas_discover_expander()),
>>  remove the expander from the port device list
>>  (sas_ex_discover_expander()), before freeing it. Else
>>  the list is corrupted and, e.g., when we attempt to send
>>  SMP commands to other devices, the kernel oopses.
>>=20
>>  Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
>>  ---
>>  =A0drivers/scsi/libsas/sas_expander.c |=A0=A0=A0 3 +++
>>  =A01 files changed, 3 insertions(+), 0 deletions(-)
>>=20
>>  diff --git a/drivers/scsi/libsas/sas_expander.c
>>  b/drivers/scsi/libsas/sas_expander.c
>>  index 874e29d..f84084b 100644
>>  --- a/drivers/scsi/libsas/sas_expander.c
>>  +++ b/drivers/scsi/libsas/sas_expander.c
>>  @@ -849,6 +849,9 @@ static struct domain_device *sas_ex_discover_ex=
pander(
>>=20
>>  =A0=A0=A0=A0 res =3D sas_discover_expander(child);
>>  =A0=A0=A0=A0 if (res) {
>>  +=A0=A0=A0 =A0=A0=A0 spin_lock_irq(&parent->port->dev_list_lock);
>>  +=A0=A0=A0 =A0=A0=A0 list_del(&child->dev_list_node);
>>  +=A0=A0=A0 =A0=A0=A0 spin_unlock_irq(&parent->port->dev_list_lock);
>>  =A0=A0=A0=A0 =A0=A0=A0 kfree(child);
>>  =A0=A0=A0=A0 =A0=A0=A0 return NULL;
>>  =A0=A0=A0=A0 }
>>  --
> [Jack Wang] Looks reasonable, thanks for fix this.
> You can add my Reviewed-by: Jack Wang <jack_wang@usish.com> if needed=
=2E

Thanks.

Out of curiosity I took a look at my original code from 2005, before Bo=
ttomley changed it off git. This bug doesn't happen as the device is ad=
ded to the port device list only when it is also registered with kobj. =
I guess that's a moot point now.

=A0=A0=A0 Luben
