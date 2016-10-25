From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/10] mpt3sas: Implement device_remove_in_progress check
 in IOCTL path
Date: Tue, 25 Oct 2016 11:51:07 +0200
Message-ID: <801507ae-e99d-2d1f-b4f5-163bf03227af@suse.de>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1476966018-10457-4-git-send-email-suganath-prabu.subramani@broadcom.com>
 <e19f32b5-ff27-4f8f-67dd-c87d2396cc29@suse.de>
 <CA+RiK65NOQ=aArdSkijUuUX8OJwGhGXSdUzvAja76Xr2oqGoww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+RiK65NOQ=aArdSkijUuUX8OJwGhGXSdUzvAja76Xr2oqGoww@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: JBottomley@parallels.com, jejb@kernel.org, Christoph Hellwig <hch@infradead.org>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Krishnaraddi Mankani <krishnaraddi.mankani@broadcom.com>, linux-kernel@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On 10/25/2016 11:19 AM, Suganath Prabu Subramani wrote:
> Hi Hannes,
> 
> Please give us little more info on the third comment. It ll help us to
> understand better and
> incorporate required changes.
> 
> Comment is  "Why don't you need to check for the size of the bitmap here?"
> 
> i have taken care of other two comments in this patch.
> 
>>       /* check if device is present */
>> @@ -5467,6 +5482,7 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
>>         sas_device = mpt3sas_get_sdev_by_addr(ioc,
>>                                         sas_address);
>>         if (sas_device) {
>> +               clear_bit(handle, ioc->pend_os_device_add);
>>                 sas_device_put(sas_device);
>>                 return -1;
>>         }
> 
> Why don't you need to check for the size of the bitmap here?
> 
> 
Thing is, you are using 'ioc->pend_os_device_add' as a bitmap to track
which devices to add.
Which in turn means that the overall number of devices you _can_ add is
restricted by the size of the bitmap.
But as you're adding devices you (might) increase the number of devices,
potentially overflowing the bitmap.
Hence the question: is it possible that you can add _more_ devices than
the bitmap can hold?
Or, to put it the other way round: Why don't you need to check the size
of the bitmap to avoid accessing an invalid bit beyond the end of the mask?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
