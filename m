From: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [RFC PATCH 6/6] libata: add ZPODD support
Date: Wed, 15 Feb 2012 14:06:23 +0800
Message-ID: <CAOzJMDQHbM9Hyx_W=0nhzK+FTk5i5Hvvn00TerYH54-yH1so2A@mail.gmail.com>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
	<1329124271-29464-7-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34627 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2BOGGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2012 01:06:24 -0500
In-Reply-To: <1329124271-29464-7-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org

Hi,

Good work, I'm also working on ZPODD for AMD platforms, some comments b=
elow.

On Mon, Feb 13, 2012 at 5:11 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> ZPODD(Zero Power Optical Disk Drive) is a new feature in
> SATA 3.1 specification. It provides a way to power off unused CDROM.

I don't see anywhere in the sata 3.1 spec mentioned how to power off th=
e
cdrom, the only relevant content is the newly defined device attention =
pin,
which is used to notify the host that this powered off device needs att=
ention.
Or do I miss something?

>
> CDROM is powered off by executing ACPI power resource's _OFF method.
>

AMD has a different implementation to power off the CDROM, I'll need to
prepare another patch based on yours.

> When CDROM is powered off(D3Cold state), inserting disk will trigger =
a
> wakeup event(GPE). GPE AML handler notifies the associated device. Th=
en
> CDROM is resumed in the notify handler.
>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
> =A0drivers/ata/libata-acpi.c | =A0 64 +++++++++++++++++++++++++++++++=
++++++-------
> =A0drivers/scsi/sr.c =A0 =A0 =A0 =A0 | =A0 39 +++++++++++++++++++++++=
++++
> =A0drivers/scsi/sr.h =A0 =A0 =A0 =A0 | =A0 =A03 ++
> =A03 files changed, 95 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 5fc97d2..bf4eace 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -716,6 +752,9 @@ static int sr_probe(struct device *dev)
> =A0 =A0 =A0 =A0disk->flags |=3D GENHD_FL_REMOVABLE;
> =A0 =A0 =A0 =A0add_disk(disk);
>
> + =A0 =A0 =A0 if (device_run_wake(dev))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cd->zpodd =3D 1;
> +

=46or a cd to support zero power, it has to support device attention pi=
n.
If it does not support that, once it is powered off, it can't be power =
up
back. So I don't think device_run_wake is enough to set the zpodd flag,
unless your firmware has done the check and created the acpi table
according to the result. Is it the case?

Thanks,
Aaron
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
