From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v2 3/5] ata: Add APM X-Gene SATA driver
Date: Wed, 13 Nov 2013 08:06:39 -0800
Message-ID: <CAPw-ZTkhQmWD2EcAQ=yH8SkTsy7t-PP-eSpnJjRYvg9=c-Jmeg@mail.gmail.com>
References: <1383980431-6572-1-git-send-email-lho@apm.com>
	<201311110954.32904.arnd@arndb.de>
	<CAPw-ZT=aVyw2yducpQMD2_rPPV7abKJZOH-Fs3bT2Ja=0tUNSQ@mail.gmail.com>
	<201311121411.54423.arnd@arndb.de>
	<CAPw-ZTnqQk5cEJKSn239m=v9A7KmL8iVPcVnHWgq1E1TRCJ+og@mail.gmail.com>
	<52830C2E.1040603@ti.com>
	<CAPw-ZT=OuZ=zkayCDCSsmS64wUfZSjx7e3iCBwEPYz5H3_tjLg@mail.gmail.com>
	<52831456.8090307@ti.com>
	<CAPw-ZT=0_BNdxyGZsrTB_UUdF=7Ft+eR_K5eMciKYiJ88F3kHQ@mail.gmail.com>
	<528346E9.2040909@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:39133 "HELO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756523Ab3KMQGl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2013 11:06:41 -0500
Received: by mail-pd0-f172.google.com with SMTP id q10so602164pdj.17
        for <linux-scsi@vger.kernel.org>; Wed, 13 Nov 2013 08:06:39 -0800 (PST)
In-Reply-To: <528346E9.2040909@ti.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Olof Johansson <olof@lixom.net>, Suman Tripathi <stripathi@apm.com>, linux-scsi@vger.kernel.org, Jon Masters <jcm@redhat.com>, Tejun Heo <tj@kernel.org>, Tuan Phan <tphan@apm.com>

Hi,

We don't re-initialize the PHY. The code program some registers. Then,
start the link training again via a hardreset. It is preferred that we
don't goes and re-initialize the PHY. As an workaround, I can try the
PHY re-init but from pass experience this doesn't work well.

With regard to your comment on top post (and not familiar to your
terminology), you don't want me to post something that the PHY
framework does support yet?

-Loc

-Loc

On Wed, Nov 13, 2013 at 1:31 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
>
> On Wednesday 13 November 2013 11:32 AM, Loc Ho wrote:
>> Hi,
>>
>> I need an method to tell the PHY layer to go to an specific speed -
>> Gen2 or Gen1. Consider it is an limitation of our PHY. This is done
>> after link up.
>
> After changing the link speed, do you have to go through the entire re-init
> sequence? I'm thinking if link speed should be modelled as an attribute of PHY
> and allow the controller to set the link speed (phy_set_link_speed). After that
> the controller should do the initialization sequence again by calling phy_init?
> Open for suggestions though..
>
> Please do not top post :-)
>
> Thanks
> Kishon
>>
>> -Loc
>>
>> On Tue, Nov 12, 2013 at 9:55 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>>> Hi,
>>>
>>> On Wednesday 13 November 2013 11:03 AM, Loc Ho wrote:
>>>> Hi,
>>>>
>>>> If I need to call a function into the PHY driver to say force an
>>>> specific speed, how would one do this? I notice the USB have a bunch
>>>
>>> There are a bunch of *ops* currently available in the PHY framework which you
>>> can use like phy_init, phy_exit, phy_power_on, phy_power_off. That should be
>>> good enough IMO. If you need any other ops we can have a discussion here.
>>>
>>> Thanks
>>> Kishon
>>>> of functions. Would I need to introduce an structure for SATA as well
>>>> that have a number of required functions that upper layer can call?
>>>>
>>>> -Loc
>>>>
>>>> On Tue, Nov 12, 2013 at 9:20 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>>>>> Hi,
>>>>>
>>>>> On Wednesday 13 November 2013 04:09 AM, Loc Ho wrote:
>>>>>> Hi Arnd,
>>>>>>
>>>>>> I looked at the PHY generic framework and come across this statement
>>>>>> below. Our SATA PHY is embedded into the SoC. Should I ignore this
>>>>>
>>>>> Is your PHY embedded into the SoC or embedded into the SATA controller? If it's
>>>>> within the SoC but not embedded into the SATA controller, you can use PHY
>>>>> framework as the PHY is in a different IP and has a separate address space for
>>>>> itself.
>>>>> If it's within the SATA controller, then you might very well implement the PHY
>>>>> logic in your SATA controller driver itself.
>>>>>> statement below and implement the PHY driver using this framework?
>>>>>>
>>>>>> +This framework will be of use only to devices that use external PHY (PHY
>>>>>> +functionality is not embedded within the controller).
>>>>>
>>>>> It means for PHYs embedded within the SATA controller and not within the SoC ;-)
>>>>>
>>>>> Thanks
>>>>> Kishon
>>>>>>
>>>>>> -Loc
>>>>>>
>>>>>>
>>>>>> On Tue, Nov 12, 2013 at 5:11 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>>>> On Tuesday 12 November 2013, Loc Ho wrote:
>>>>>>>> Hi Arnd/Olof,
>>>>>>>>
>>>>>>>> I looked over the phy code for USB and NET. There isn't such PHY
>>>>>>>> infrastructure for SATA from what I can tell. It seems like I will
>>>>>>>> need to put this all together. I am thinking about porting the USB
>>>>>>>> version over (with changes for SATA) and put it under
>>>>>>>> "./drivers/ata/phy". Any suggestion?
>>>>>>>
>>>>>>> Please have a look at the patches under the subject "Generic PHY Framework"
>>>>>>> posted by Kishon Vijay Abraham. I thought they would have made it in
>>>>>>> by now, but I have not followed the recent kernels closely since I am
>>>>>>> on parental leave at the moment.
>>>>>>>
>>>>>>> IIRC they should unify USB, SATA and other PHY codes, but not network.
>>>>>>>
>>>>>>>         Arnd
>>>>>
>>>
>
