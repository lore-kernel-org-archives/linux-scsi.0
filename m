From: Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH] mptsas: fix undefined behaviour of a shift of an int by
 more than 31 places
Date: Thu, 9 May 2019 16:58:46 +0100
Message-ID: <dcc8590c-b665-bcb2-4df6-9f4a37a779e1@canonical.com>
References: <20190504164010.24937-1-colin.king@canonical.com>
 <1557027274.2821.2.camel@HansenPartnership.com>
 <de7e3aaf-0155-5007-c228-510f0d0de428@canonical.com>
 <1557325468.3196.2.camel@HansenPartnership.com>
 <9b4c84b5-31eb-6068-57c2-80ededc21b43@suse.de>
 <1557416545.4268.22.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1557416545.4268.22.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/05/2019 16:42, James Bottomley wrote:
> On Thu, 2019-05-09 at 17:30 +0200, Hannes Reinecke wrote:
>> On 5/8/19 4:24 PM, James Bottomley wrote:
>>> On Wed, 2019-05-08 at 14:07 +0100, Colin Ian King wrote:
>>>> On 05/05/2019 04:34, James Bottomley wrote:
>>>>> On Sat, 2019-05-04 at 17:40 +0100, Colin King wrote:
>>>>>> From: Colin Ian King <colin.king@canonical.com>
>>>>>>
>>>>>> Currently the shift of int value 1 by more than 31 places can
>>>>>> result in undefined behaviour. Fix this by making the 1 a ULL
>>>>>> value before the shift operation.
>>>>>
>>>>> Fusion SAS is pretty ancient.  I thought the largest one ever
>>>>> produced had four phys, so how did you produce the overflow?
>>>>
>>>> This was an issue found by static analysis with Coverity; so I
>>>> guess won't happen in the wild, in which case the patch could be
>>>> ignored.
>>>
>>> The point I was more making is that if we thought this could ever
>>> happen in practice, we'd need more error handling than simply this:
>>> we'd be setting the phy_bitmap to zero which would be every bit as
>>> bad as some random illegal value.
>>>
>>
>> Thing is, mptsas is used as the default emulation in VMWare, and
>> that does allow you to do some pretty weird configurations (I've
>> found myself  fixing a bug with SATA hotplug on mptsas once ...).
>> So I wouldn't discard this issue out of hand.
> 
> I'm not, I'm just saying the proposed fix is no fix at all since it
> would just produce undefined behaviour in the driver.  I thought the
> issue might have been coming from VMWare, which is why I asked how the
> bug was seen.  The proper fix is probably to fail attachment if the phy
> number goes over a fixed value (16 sounds reasonable) but if it's never
> a problem in the field, I'm happy doing nothing because we have no real
> idea what the reasonable value is.

I'm happy with my proposed fix being ignored and (if required) a more
appropriate fix developed by somebody who is more familiar with this
code than me.  Sometimes it is hard to determine if these static
analysis "issues" are fix worthy or not.

Colin

> 
> James
> 
