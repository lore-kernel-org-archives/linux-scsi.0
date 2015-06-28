From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH v2] mpt2sas: Abort initialization if no memory I/O
 resources detected
Date: Sun, 28 Jun 2015 15:11:08 +0530
Message-ID: <CAK=zhgrB9Z_C+g7XK9uDEF52AwVymheBvkQQU7iYF8OmoUg79Q@mail.gmail.com>
References: <557B578D.50706@raptorengineeringinc.com>
	<1435066507.2251.10.camel@HansenPartnership.com>
	<55899867.3010400@raptorengineeringinc.com>
	<1435081516.2251.118.camel@HansenPartnership.com>
	<55899BBA.5030509@raptorengineeringinc.com>
	<1435082169.2251.120.camel@HansenPartnership.com>
	<55899E79.1010208@raptorengineeringinc.com>
	<1435083585.2251.125.camel@HansenPartnership.com>
	<1752241556.3143.1435087724484.JavaMail.zimbra@raptorengineeringinc.com>
	<558F4E50.5040509@raptorengineeringinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33007 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbbF1JlJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2015 05:41:09 -0400
Received: by wgck11 with SMTP id k11so119064739wgc.0
        for <linux-scsi@vger.kernel.org>; Sun, 28 Jun 2015 02:41:08 -0700 (PDT)
In-Reply-To: <558F4E50.5040509@raptorengineeringinc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Timothy Pearson <tpearson@raptorengineeringinc.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Joe Lawrence <joe.lawrence@stratus.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, "Support (LSI)" <support@lsi.com>, DL-MPTFusionLinux@lsi.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Timothy,

Thanks for the patch.

I feel there is some code redundancy after including this patch, I
mean to say is twice we are checking for (ioc->chip == NULL). So I am
working on to reduce this redundancy. Soon I will post a new patch.

Thanks,
Sreekanth

On Sun, Jun 28, 2015 at 7:00 AM, Timothy Pearson
<tpearson@raptorengineeringinc.com> wrote:
> On 06/23/2015 02:28 PM, Timothy Pearson wrote:
>>
>> The mpt2sas driver crashes if the BIOS does not set up at least one
>> memory I/O resource.  This failure can happen if the device is too
>> slow to respond during POST and is missed by the BIOS, but Linux
>> then detects the device later in the boot process.
>>
>> Signed-off-by: Timothy Pearson<tpearson@raptorengineeringinc.com>
>> Tested-by: Timothy Pearson<tpearson@raptorengineeringinc.com>
>> ---
>>   drivers/scsi/mpt2sas/mpt2sas_base.c |    7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
>> b/drivers/scsi/mpt2sas/mpt2sas_base.c
>> index 11248de..b70fa5a 100644
>> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
>> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
>> @@ -1582,6 +1582,13 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER
>> *ioc)
>>                 }
>>         }
>>
>> +       if (ioc->chip == NULL) {
>> +               printk(MPT2SAS_ERR_FMT "unable to map "
>> +                       "adapter memory (resource not found)!\n",
>> ioc->name);
>> +               r = -EINVAL;
>> +               goto out_fail;
>> +       }
>> +
>>         _base_mask_interrupts(ioc);
>>
>>         r = _base_get_ioc_facts(ioc, CAN_SLEEP);
>
>
> Just wanted to follow up on this patch since I haven't received a response.
> As far as I know the (trivial) concerns from the first version should be
> addressed in this version.
>
> Thanks!
>
> --
> Timothy Pearson
> Raptor Engineering
> +1 (415) 727-8645
> http://www.raptorengineeringinc.com



-- 

Regards,
Sreekanth
