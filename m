From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v7 5/9] Disallow changing the device state via sysfs into
 "deleted"
Date: Fri, 07 Dec 2012 14:36:24 +0100
Message-ID: <50C1F0D8.1020201@suse.de>
References: <50C0BEEE.4040907@acm.org> <50C0C046.2060903@acm.org> <50C192CE.3000208@suse.de> <50C1E529.3090107@acm.org> <50C1F047.3020705@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030286Ab2LGNg1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2012 08:36:27 -0500
In-Reply-To: <50C1F047.3020705@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On 12/07/2012 02:33 PM, Bart Van Assche wrote:
> On 12/07/12 13:46, Bart Van Assche wrote:
>> On 12/07/12 07:55, Hannes Reinecke wrote:
>>> On 12/06/2012 04:56 PM, Bart Van Assche wrote:
>>>> Changing the state of a SCSI device via sysfs into "cancel" or
>>>> "deleted" prevents scsi_remove_host() to remove these devices.
>>>> Hence do not allow this.
>>>>
>>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>>> Cc: Tejun Heo <tj@kernel.org>
>>>> Cc: James Bottomley <JBottomley@Parallels.com>
>>>> Cc: Mike Christie <michaelc@cs.wisc.edu>
>>>> Cc: Hannes Reinecke <hare@suse.de>
>>>> ---
>>>>    drivers/scsi/scsi_sysfs.c |    7 +++++--
>>>>    1 file changed, 5 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>>>> index 4348f12..b319c20 100644
>>>> --- a/drivers/scsi/scsi_sysfs.c
>>>> +++ b/drivers/scsi/scsi_sysfs.c
>>>> @@ -591,13 +591,15 @@ sdev_store_delete(struct device *dev, struct
>>>> device_attribute *attr,
>>>>    };
>>>>    static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
>>>>
>>>> +#define INVALID_SDEV_STATE 0
>>>> +
>>> Shouldn't this become part of the enum?
>>> Defining it outside only confuses the compiler.
>>> And the unsuspecting user.
>>
>> I can do that, but that will require changes in every switch stateme=
nt
>> on enum scsi_device_state because the kernel code is compiled with
>> -Wswitch. From the gcc manual: <quote>-Wswitch: Warn whenever a swit=
ch
>> statement has an index of enumerated type and lacks a case for one o=
r
>> more of the named codes of that enumeration. (The presence of a defa=
ult
>> label prevents this warning.)</quote>
>
> (replying to my own e-mail)
>
> Apparently there is only one such switch statement that has to be
> updated. The add-on patch below realizes the above proposal:
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index d80714f..253fc30 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2158,6 +2158,8 @@ scsi_device_set_state(struct scsi_device *sdev,=
 enum scsi_device_state state)
>   		}
>   		break;
>
> +	case INVALID_SDEV_STATE:
> +		goto illegal;
>   	}
>   	sdev->sdev_state =3D state;
>   	return 0;
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 3293ba7..81d9d55 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -592,8 +592,6 @@ sdev_store_delete(struct device *dev, struct devi=
ce_attribute *attr,
>   };
>   static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
>
> -#define INVALID_SDEV_STATE 0
> -
>   static ssize_t
>   store_state_field(struct device *dev, struct device_attribute *attr=
,
>   		  const char *buf, size_t count)
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 83a6532..4281ff4 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -29,7 +29,11 @@ struct scsi_mode_data {
>    * scsi_lib:scsi_device_set_state().
>    */
>   enum scsi_device_state {
> -	SDEV_CREATED =3D 1,	/* device created but not added to sysfs
> +	INVALID_SDEV_STATE,	/* Not a valid SCSI device state but a
> +				 * symbolic name that can be used wherever
> +				 * a value is needed that is different of
> +				 * any valid SCSI device state. */
> +	SDEV_CREATED,		/* device created but not added to sysfs
>   				 * Only internal commands allowed (for inq) */
>   	SDEV_RUNNING,		/* device properly configured
>   				 * All commands allowed */
>

Much better.
enum checking was the main intention for this, after all :-)

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
