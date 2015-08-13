From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH] scsi: storvsc: be more picky about scmnd->sc_data_direction
Date: Thu, 13 Aug 2015 10:53:48 +0200
Message-ID: <87si7nefhf.fsf@vitty.brq.redhat.com>
References: <1435248731-29085-1-git-send-email-vkuznets@redhat.com>
	<BY2PR0301MB16548730485D11B010D6C4F1A0AB0@BY2PR0301MB1654.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbbHMIxw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Aug 2015 04:53:52 -0400
In-Reply-To: <BY2PR0301MB16548730485D11B010D6C4F1A0AB0@BY2PR0301MB1654.namprd03.prod.outlook.com>
	(KY Srinivasan's message of "Sun, 28 Jun 2015 02:36:22 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Long Li <longli@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, KY Srinivasan <kys@microsoft.com>

KY Srinivasan <kys@microsoft.com> writes:

>> -----Original Message-----
>> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
>> Sent: Thursday, June 25, 2015 9:12 AM
>> To: linux-scsi@vger.kernel.org
>> Cc: Long Li; KY Srinivasan; Haiyang Zhang; James E.J. Bottomley;
>> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org; Radim Kr=
=C4=8Dm=C3=A1=C5=99
>> Subject: [PATCH] scsi: storvsc: be more picky about scmnd-
>> >sc_data_direction
>>=20
>> Under the 'default' case in scmnd->sc_data_direction we have 3 optio=
ns:
>> - DMA_NONE which we handle correctly.
>> - DMA_BIDIRECTIONAL which is never supposed to be set by SCSI stack.
>> - Garbage value.
>>=20
>> Do WARN() and return -EINVAL in the last two cases. virtio_scsi does
>> BUG_ON() here but it looks like an overkill.
>>=20
>> Reported-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Sorry for the ping but it seems the fix never made it to scsi tree...

>> ---
>>  drivers/scsi/storvsc_drv.c | 10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
>> index 3c6584f..61f4855 100644
>> --- a/drivers/scsi/storvsc_drv.c
>> +++ b/drivers/scsi/storvsc_drv.c
>> @@ -1598,10 +1598,18 @@ static int storvsc_queuecommand(struct
>> Scsi_Host *host, struct scsi_cmnd *scmnd)
>>  		vm_srb->data_in =3D READ_TYPE;
>>  		vm_srb->win8_extension.srb_flags |=3D
>> SRB_FLAGS_DATA_IN;
>>  		break;
>> -	default:
>> +	case DMA_NONE:
>>  		vm_srb->data_in =3D UNKNOWN_TYPE;
>>  		vm_srb->win8_extension.srb_flags |=3D
>> SRB_FLAGS_NO_DATA_TRANSFER;
>>  		break;
>> +	default:
>> +		/*
>> +		 * This is DMA_BIDIRECTIONAL or something else we are
>> never
>> +		 * supposed to see here.
>> +		 */
>> +		WARN(1, "Unexpected data direction: %d\n",
>> +		     scmnd->sc_data_direction);
>> +		return -EINVAL;
>>  	}
>>=20
>>=20
>> --
>> 2.4.3

--=20
  Vitaly
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
