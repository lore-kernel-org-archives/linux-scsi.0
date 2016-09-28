From: subhashj@codeaurora.org
Subject: Re: UFS API in the kernel
Date: Wed, 28 Sep 2016 15:46:11 -0700
Message-ID: <d2b464eb5091b69e39626865615e7d40@codeaurora.org>
References: <c6a8636a-98e6-61d0-ff4b-350fb3869699@synopsys.com>
 <CGME20160926192330epcas2p4efa9f5e69c8591b6858a3eeb6290c986@epcas2p4.samsung.com>
 <CAJVOszALc04xgNujHi2YdCGpTXNWDoyLVwYT2uSYy6faDLqmYA@mail.gmail.com>
 <009f01d2185b$fcf71ef0$f6e55cd0$@samsung.com>
 <7275e74a9689721ea612fbc6eca555be@codeaurora.org>
 <99ac538d-5123-a58b-247d-160176f63a3d@synopsys.com>
 <875b9e3c-b413-97c2-3731-b8977e7618fd@synopsys.com>
 <2481a900-429f-7fcf-8eb6-12a3f354d919@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59119 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932486AbcI1WqN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2016 18:46:13 -0400
In-Reply-To: <2481a900-429f-7fcf-8eb6-12a3f354d919@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>, 'Shaun Tancheff' <shaun.tancheff@seagate.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org, Carlos Palminha <CARLOS.PALMINHA@synopsys.com>

On 2016-09-28 02:57, Joao Pinto wrote:
> I was able to get the 7 patches to have the UFS IOCTL features from 
> your repo.
> BTW, why weren't these features submitted to the kernel?
> I checked lots of tweaks that you have been making to the UFS... do you
> synchronize them periodically with the mainline? Thanks!

We had mainlined quite a lot UFS patches in past and I am also planning 
to push out the remaining deltas to mainline over next couple of months. 
Thanks.

> 
> On 9/28/2016 10:19 AM, Joao Pinto wrote:
>> 
>> Hi again!
>> Could you also send me an example of how you are using the IOCTL from 
>> your user
>> app (send/receive data)? I already have my implemented but you use a 
>> different
>> mechanism (I have checked your structures in uapi/scsi/ufs/) and I 
>> have to port
>> it! Thanks!
>> 
>> 
>> On 9/28/2016 10:06 AM, Joao Pinto wrote:
>>> 
>>> Hi Subhash,
>>> 
>>> On 9/28/2016 12:05 AM, subhashj@codeaurora.org wrote:
>>>> Hi Joao,
>>>> 
>>>> 
>>>> On 2016-09-26 18:10, Kiwoong Kim wrote:
>>>>> Hi.
>>>>> 
>>>>> If you want to declare some things for user interface,
>>>>> is it be better to put those thing include/uapi/linux/ than 
>>>>> include/linux?
>>>>> 
>>>>> Agreed with Mr. Pinto's opinion with respect to implementing 
>>>>> additional ioctls.
>>>> 
>>>> Yes, "scsi_host_template" allows the LLD's to export their ioctl 
>>>> callback and
>>>> then you can use the sg interface to issue UFS specific ioctls. We 
>>>> had
>>>> implemented similar ioctl for our use, here is the reference code:
>>>> https://source.codeaurora.org/quic/la/kernel/msm-3.18/tree/drivers/scsi/ufs/ufshcd.c?h=LA.HB.1.1.1.c2#n6791.
>>>> This was mainly done to  export the UFS query request interface to 
>>>> user space.
>>>> Declarations where exported under include/uapi/scsi/ufs/ . If you 
>>>> want to build
>>>> upon this already existing functionality, i can post the formal 
>>>> patch on mailing
>>>> list.
>>> 
>>> Yes, of course I have interest on building on top of what you have 
>>> done already.
>>> Did yu submit this patch to the kernel already? Could you please send 
>>> me the
>>> patch and kernel version to apply?
>>> 
>>> Thanks,
>>> Joao
>>> 
>>>> 
>>>> Regards,
>>>> Subhash
>>>> 
>>>> 
>>>>> 
>>>>> Regards.
>>>>> 
>>>>>> -----Original Message-----
>>>>>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>>>>>> owner@vger.kernel.org] On Behalf Of Shaun Tancheff
>>>>>> Sent: Tuesday, September 27, 2016 4:23 AM
>>>>>> To: Joao Pinto
>>>>>> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
>>>>>> Subject: Re: UFS API in the kernel
>>>>>> 
>>>>>> On Thu, Sep 22, 2016 at 10:21 AM, Joao Pinto 
>>>>>> <Joao.Pinto@synopsys.com>
>>>>>> wrote:
>>>>>>> Hi!
>>>>>>> 
>>>>>>> I am designing an application that has the goal to be an utility 
>>>>>>> for
>>>>>>> Unipro and UFS testing purposes. This application is going to run 
>>>>>>> on
>>>>>>> top of a recent Linux Kernel containing the new UFS stack 
>>>>>>> (including the
>>>>>> new DWC drivers).
>>>>>>> 
>>>>>>> I am considering doing the following:
>>>>>>> a) Create a new config item called CONFIG_UFS_CHARDEV which is 
>>>>>>> going
>>>>>>> to create a char device responsible to make some IOCTL available 
>>>>>>> for
>>>>>>> user-space applications
>>>>>>> b) Create a linux/ufs.h header file that contains data structures
>>>>>>> declarations that will be needed in user-space applications
>>>>>> 
>>>>>> I am not very familiar with UFS devices, that said you should have 
>>>>>> an sgX
>>>>>> chardev being created already so you can handle SG_IO requests.
>>>>>> There also appear to be some sysfs entries being created.
>>>>>> 
>>>>>> So between sg and sysfs you should be able to handle any 
>>>>>> user-space out of
>>>>>> band requests without resorting to making a new chardev.
>>>>>> 
>>>>>> Adding more sysfs entries, if you need them, should be fine.
>>>>>> 
>>>>>> You may find it easier to expand on the existing interfaces than 
>>>>>> to get
>>>>>> consensus on a new driver and ioctls.
>>>>>> 
>>>>>> Hope this helps,
>>>>>> Shaun
>>>>>> 
>>>>>>> Could you please advise me about what the correct approach should 
>>>>>>> be
>>>>>>> to make it as standard as possible and usable in the future?
>>>>>>> 
>>>>>>> Thank you very much for your help!
>>>>>>> 
>>>>>>> regards,
>>>>>>> Joao
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe 
>>>>>>> linux-scsi"
>>>>>>> in the body of a message to majordomo@vger.kernel.org More 
>>>>>>> majordomo
>>>>>>> info at
>>>>>>> https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_ma
>>>>>>> jordomo-2Dinfo.html&d=DQICaQ&c=IGDlg0lD0b-nebmJJ0Kp8A&r=Wg5NqlNlVTT7Ug
>>>>>>> l8V50qIHLe856QW0qfG3WVYGOrWzA&m=vJFB6pCywWtdvkgHz9Vc0jQz0xzeyZlr-7eCWY
>>>>>>> u88nM&s=yiQLPFpqmMrbqLZz1Jb3aNqOje2dRMLJHEzUDobwcXc&e=
>>>>>> 
>>>>>> 
>>>>>> 
>>>>>> --
>>>>>> Shaun Tancheff
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe 
>>>>>> linux-scsi" in
>>>>>> the body of a message to majordomo@vger.kernel.org More majordomo 
>>>>>> info at
>>>>>> http://vger.kernel.org/majordomo-info.html
>>>>> 
>>>>> 
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe 
>>>>> linux-scsi" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 
>> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
