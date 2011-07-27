From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] [SCSI] libsas: remove expander from dev list on error
Date: Wed, 27 Jul 2011 13:32:50 -0700
Message-ID: <CAA9_cmc3RWUFsWkyO4qnTLbVTmcGv51Ab8LyJqJUbNHbnx0kCg@mail.gmail.com>
References: <1311747048.72460.YahooMailNeo@web31810.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43123 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1G0Ucv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2011 16:32:51 -0400
In-Reply-To: <1311747048.72460.YahooMailNeo@web31810.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "JBottomley@Parallels.com" <JBottomley@parallels.com>, Jack Wang <jack_wang@usish.com>

On Tue, Jul 26, 2011 at 11:10 PM, Luben Tuikov <ltuikov@yahoo.com> wrot=
e:
> If expander discovery fails (sas_discover_expander()),
> remove the expander from the port device list
> (sas_ex_discover_expander()), before freeing it. Else
> the list is corrupted and, e.g., when we attempt to send
> SMP commands to other devices, the kernel oopses.
>
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> Reviewed-by: Jack Wang <jack_wang@usish.com>
> ---
> =A0drivers/scsi/libsas/sas_expander.c |=A0=A0=A0 3 +++
> =A01 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas=
/sas_expander.c
> index 874e29d..f84084b 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -849,6 +849,9 @@ static struct domain_device *sas_ex_discover_expa=
nder(
>
> =A0=A0=A0=A0=A0=A0=A0 res =3D sas_discover_expander(child);
> =A0=A0=A0=A0=A0=A0=A0 if (res) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 spin_lock_irq(&parent->po=
rt->dev_list_lock);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 list_del(&child->dev_list=
_node);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 spin_unlock_irq(&parent->=
port->dev_list_lock);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 kfree(child);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;

Acked-by: Dan Williams <dan.j.williams@intel.com>

=2E..but it raises a couple questions for potential follow on patches:

1/ Do we need to add the device to port->dev_list prior to the
discovery?  Seems cleaner to defer the list_add until after the
discovery has succeeded.

2/ We have unlocked list manipulations in sas_ex_discover_end_dev(),
sas_unregister_common_dev(), and sas_ex_discover_end_dev()

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
