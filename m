From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 4/7] Disallow changing the device state via sysfs into
 "deleted"
Date: Mon, 02 Sep 2013 20:59:30 +0200
Message-ID: <5224E012.6030907@acm.org>
References: <52135B99.2000102@acm.org> <52135C47.4090106@acm.org> <20130901164929.GD4344@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:49417 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758849Ab3IBS7g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Sep 2013 14:59:36 -0400
In-Reply-To: <20130901164929.GD4344@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 09/01/13 18:49, Christoph Hellwig wrote:
> On Tue, Aug 20, 2013 at 02:08:39PM +0200, Bart Van Assche wrote:
>> Changing the state of a SCSI device via sysfs into "cancel",
>> "cancel-offline" or "deleted" prevents removal of these devices by
>> scsi_remove_host(). Hence do not allow this.
>
> Looks good modulo a minor style nipick below.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
>> +	if (state =3D=3D 0 || state =3D=3D SDEV_CANCEL ||
>> +	    state =3D=3D SDEV_CANCEL_OFFLINE || state =3D=3D SDEV_DEL ||
>> +	    scsi_device_set_state(sdev, state) !=3D 0)
>>   		return -EINVAL;
>
> Doing a switch on the state would be a lot more readable here:
>
> 	switch (state) {
> 	case 0:
> 	case SDEV_CANCEL:
> 	case SDEV_CANCEL_OFFLINE:
> 	case SDEV_DEL:
> 		ret =3D -EINVAL;
> 		break;
> 	default:
> 		ret =3D scsi_device_set_state(sdev, state);
> 	}
>
> 	if (ret)
> 		return ret;
>>   	return count;
>>   }

Do you agree with changing switch (state) into switch ((int)state) ?=20
Without that additional change gcc reports the following warning:

drivers/scsi/scsi_sysfs.c: In function =91store_state_field=92:
drivers/scsi/scsi_sysfs.c:640:2: warning: case value =910=92 not in=20
enumerated type =91enum scsi_device_state=92 [-Wswitch]

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
