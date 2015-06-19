From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 06/20] [SCSI] mpt3sas: Provides the physical location of
 sas drives
Date: Fri, 19 Jun 2015 16:23:47 +0530
Message-ID: <CAK=zhgr0MckU7DJrTxrfYUqJT1Ld3G0b6S8vMBAUNCqtVbFncQ@mail.gmail.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-7-git-send-email-Sreekanth.Reddy@avagotech.com>
	<20150619091946.GC7462@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150619091946.GC7462@c203.arch.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 19, 2015 at 2:49 PM, Johannes Thumshirn <jthumshirn@suse.de=
> wrote:
> On Fri, Jun 12, 2015 at 03:12:18PM +0530, Sreekanth Reddy wrote:
>> This Patch will provide more details of the devices such as slot num=
ber, enclosure logical id, enclosure level & connector name in the foll=
owing scenarios,
>>
>> - When end device is added in the topology,
>> - When the end device is removed from the setup,
>> - When the SCSI mid layer issues TASK ABORT/ DEVICE RESET/ TARGET RE=
SET during error handling,
>> - When any command to the device fails with Sense key Hardware error=
 or Medium error or Unit Attention,
>> - When firmware returns device error or device not ready status for =
the end device,
>> - When a Predicted fault is detected on an end device.
>>
>> This information can be used by the user to identify the location of=
 the desired drive in the topology.
>>
>> Driver will get these information by reading the sas device page0.
>>
>> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_base.h  |   2 +
>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 238 ++++++++++++++++++++++++=
+++++------
>>  2 files changed, 201 insertions(+), 39 deletions(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3=
sas/mpt3sas_base.h
>> index b79ad4f..293ad23 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
>> @@ -317,6 +317,8 @@ struct _sas_device {
>>       u8      fast_path;
>>       u8      pfa_led_on;
>>       u8      pend_sas_rphy_add;
>> +     u8   enclosure_level;
>> +     u8   connector_name[4];
>
> Minor nit of different indent here, don't know if it is worth re-send=
ing?

Not an Issue. I will post the next version of this patch by adjusting
this indent.

Thanks,
Sreekanth
>
> Other than that:
>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>
> --
> Johannes Thumshirn                                       Storage
> jthumshirn@suse.de                             +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)



--=20

Regards,
Sreekanth
