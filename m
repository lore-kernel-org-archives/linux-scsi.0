From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] scsi_transport_sas: move bsg destructor into sas_rphy_remove
Date: Wed, 12 Feb 2014 11:13:22 -0800
Message-ID: <CAA9_cme2REPT4L+uBkZaYtnfq1W2efO3Cs+5i61ArHiB4XdOgg@mail.gmail.com>
References: <20131120140840.4d1f23ca@jlaw-desktop.mno.stratus.com>
	<20131125112339.45e279db@jlaw-desktop.mno.stratus.com>
	<20131203130305.1d414258@jlaw-desktop.mno.stratus.com>
	<20131203131550.17a56000@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:58941 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaBLTNX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2014 14:13:23 -0500
Received: by mail-qa0-f48.google.com with SMTP id f11so14641562qae.35
        for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2014 11:13:23 -0800 (PST)
In-Reply-To: <20131203131550.17a56000@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Dave Jiang <dave.jiang@gmail.com>, artur.paszkiewicz@intel.com, Lukasz Dorau <lukasz.dorau@intel.com>

Hi Joe, thanks for copying me on that other thread.

On Tue, Dec 3, 2013 at 10:15 AM, Joe Lawrence <joe.lawrence@stratus.com> wrote:
> The recent change in sysfs, bcdde7e221a8750f9b62b6d0bd31b72ea4ad9309
> "sysfs: make __sysfs_remove_dir() recursive" revealed an asymmetric
> rphy device creation/deletion sequence in scsi_transport_sas:
>
>   modprobe mpt2sas
>     sas_rphy_add
>       device_add A               rphy->dev
>       device_add B               sas_device transport class
>       device_add C               sas_end_device transport class
>       device_add D               bsg class
>
>   rmmod mpt2sas
>     sas_rphy_delete
>       sas_rphy_remove
>         device_del B
>         device_del C
>         device_del A
>           sysfs_remove_group     recursive sysfs dir removal
>       sas_rphy_free
>         device_del D             warning
>
>   where device A is the parent of B, C, and D.
>
> When sas_rphy_free tries to unregister the bsg request queue (device D
> above), the ensuing sysfs cleanup discovers that its sysfs group has
> already been removed and emits a warning, "sysfs group... not found for
> kobject 'end_device-X:0'".
>
> Since bsg creation is a side effect of sas_rphy_add, move its
> complementary removal call into sas_rphy_remove. This imposes the
> following tear-down order for the devices above: D, B, C, A.
>
> Note the sas_device and sas_end_device transport class devices (B and C
> above) are created and destroyed both via the list match traversal in
> attribute_container_device_trigger, so the order in which they are
> handled is fixed. This is fine as long as they are deleted before their
> parent device.
>
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> ---
>  drivers/scsi/scsi_transport_sas.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 1b681427dde0..c341f855fadc 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -1621,8 +1621,6 @@ void sas_rphy_free(struct sas_rphy *rphy)
>         list_del(&rphy->list);
>         mutex_unlock(&sas_host->lock);
>
> -       sas_bsg_remove(shost, rphy);
> -
>         transport_destroy_device(dev);
>
>         put_device(dev);
> @@ -1681,6 +1679,7 @@ sas_rphy_remove(struct sas_rphy *rphy)
>         }
>
>         sas_rphy_unlink(rphy);
> +       sas_bsg_remove(NULL, rphy);
>         transport_remove_device(dev);
>         device_del(dev);
>  }

Acked-by: Dan Williams <dan.j.williams@intel.com>

I think this is the right move, and some follow-up cleanups / fixes
come to mind:

1/ Why is sas_bsg_remove() multiplexing 2 use cases?  Let's just have
a sas_host_bsg_remove() and a sas_device_bsg_remove().

2/ I think sas_rphy_free() mishandles the reference counts in the
sas_rphy_add() failing case.
sas_rphy_free() does:
        transport_destroy_device(dev); /* which is just put_device(dev) */
        put_device(dev);

...but if sas_rphy_add() failed we never took the reference from
transport_add_device() and I expect we only have the one reference
from device_initialize() to drop.

We also ignore the return code from transport_add_device() which is
another hole.

--
Dan

Commenting on this mail should refresh this in James' queue.  But you
may want to resend anyways given this is a few months old.
