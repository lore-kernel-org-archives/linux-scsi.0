From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH 03/10] mpt3sas: Implement device_remove_in_progress check
 in IOCTL path
Date: Tue, 25 Oct 2016 16:06:57 +0530
Message-ID: <CA+RiK67ABpPAX18i6P89cSwNZZNmNHHPAudhb4s3is0x9Zf2uA@mail.gmail.com>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1476966018-10457-4-git-send-email-suganath-prabu.subramani@broadcom.com>
 <e19f32b5-ff27-4f8f-67dd-c87d2396cc29@suse.de> <CA+RiK65NOQ=aArdSkijUuUX8OJwGhGXSdUzvAja76Xr2oqGoww@mail.gmail.com>
 <801507ae-e99d-2d1f-b4f5-163bf03227af@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <801507ae-e99d-2d1f-b4f5-163bf03227af@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: JBottomley@parallels.com, jejb@kernel.org, Christoph Hellwig <hch@infradead.org>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Krishnaraddi Mankani <krishnaraddi.mankani@broadcom.com>, linux-kernel@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Hi Hannes,

Thanks,
>From facts.MaxDevHandle value from firmware, driver will get to know
the max device handle or devices that it can support. Based on that
value only driver will allocate memory for bit mapping.
And driver will not receive any events from controller, if it exceeds
the max devices it can support. So, there is No possibility that
driver can add more devices than bitmap.

Thanks,
Suganath Prabu S



On Tue, Oct 25, 2016 at 3:21 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 10/25/2016 11:19 AM, Suganath Prabu Subramani wrote:
>> Hi Hannes,
>>
>> Please give us little more info on the third comment. It ll help us to
>> understand better and
>> incorporate required changes.
>>
>> Comment is  "Why don't you need to check for the size of the bitmap here=
?"
>>
>> i have taken care of other two comments in this patch.
>>
>>>       /* check if device is present */
>>> @@ -5467,6 +5482,7 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u1=
6 handle, u8 phy_num,
>>>         sas_device =3D mpt3sas_get_sdev_by_addr(ioc,
>>>                                         sas_address);
>>>         if (sas_device) {
>>> +               clear_bit(handle, ioc->pend_os_device_add);
>>>                 sas_device_put(sas_device);
>>>                 return -1;
>>>         }
>>
>> Why don't you need to check for the size of the bitmap here?
>>
>>
> Thing is, you are using 'ioc->pend_os_device_add' as a bitmap to track
> which devices to add.
> Which in turn means that the overall number of devices you _can_ add is
> restricted by the size of the bitmap.
> But as you're adding devices you (might) increase the number of devices,
> potentially overflowing the bitmap.
> Hence the question: is it possible that you can add _more_ devices than
> the bitmap can hold?
> Or, to put it the other way round: Why don't you need to check the size
> of the bitmap to avoid accessing an invalid bit beyond the end of the mas=
k?
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)
