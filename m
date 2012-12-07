From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v7 5/9] Disallow changing the device state via sysfs into
 "deleted"
Date: Fri, 07 Dec 2012 07:55:10 +0100
Message-ID: <50C192CE.3000208@suse.de>
References: <50C0BEEE.4040907@acm.org> <50C0C046.2060903@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab2LGGzM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2012 01:55:12 -0500
In-Reply-To: <50C0C046.2060903@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On 12/06/2012 04:56 PM, Bart Van Assche wrote:
> Changing the state of a SCSI device via sysfs into "cancel" or
> "deleted" prevents scsi_remove_host() to remove these devices.
> Hence do not allow this.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/scsi_sysfs.c |    7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 4348f12..b319c20 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -591,13 +591,15 @@ sdev_store_delete(struct device *dev, struct de=
vice_attribute *attr,
>   };
>   static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
>
> +#define INVALID_SDEV_STATE 0
> +
Shouldn't this become part of the enum?
Defining it outside only confuses the compiler.
And the unsuspecting user.

>   static ssize_t
>   store_state_field(struct device *dev, struct device_attribute *attr=
,
>   		  const char *buf, size_t count)
>   {
>   	int i;
>   	struct scsi_device *sdev =3D to_scsi_device(dev);
> -	enum scsi_device_state state =3D 0;
> +	enum scsi_device_state state =3D INVALID_SDEV_STATE;
>
>   	for (i =3D 0; i < ARRAY_SIZE(sdev_states); i++) {
>   		const int len =3D strlen(sdev_states[i].name);
> @@ -607,7 +609,8 @@ store_state_field(struct device *dev, struct devi=
ce_attribute *attr,
>   			break;
>   		}
>   	}
> -	if (!state)
> +	if (state =3D=3D INVALID_SDEV_STATE || state =3D=3D SDEV_CANCEL ||
> +	    state =3D=3D SDEV_DEL)
>   		return -EINVAL;
>
>   	if (scsi_device_set_state(sdev, state))
>
Why not scsi_device_being_removed() here?

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
