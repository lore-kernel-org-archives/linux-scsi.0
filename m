From: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Subject: Re: [PATCH v12 1/4] PHY: Add function set_speed to generic PHY framework
Date: Sun, 2 Mar 2014 22:59:22 -0800
Message-ID: <CAPw-ZTmPqfkm=kkN6tY3N3mAWoC0MosJLrHOw=at_tir7rV3sw@mail.gmail.com>
References: <1393524848-8207-1-git-send-email-lho@apm.com>
	<1393524848-8207-2-git-send-email-lho@apm.com>
	<20140227190102.GB4862@saruman.home>
	<CAPw-ZT=F07=T0=z=iT=hxJ0+609RBDYRL=MXF5dQoEowLjsRjQ@mail.gmail.com>
	<20140227205039.GE5375@saruman.home>
	<CAPw-ZT=7cu1NoxrBL48RUJV04ofrnNkF=p=23VFfu8ZZWmkQWQ@mail.gmail.com>
	<20140227213427.GG5375@saruman.home>
	<CAPw-ZT=6cF77FjVZhXkR4thvkoxDH=aEikoDQjcpskMXE+F8OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPw-ZT=6cF77FjVZhXkR4thvkoxDH=aEikoDQjcpskMXE+F8OA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: balbi-l0cyMroinI0@public.gmane.org
Cc: Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux SCSI List <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "patches-qTEPVZfXA3Y@public.gmane.org" <patches-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Felipe and Kishon,

>>> >> >> This patch adds function set_speed to the generic PHY framework operation
>>> >> >> structure. This function can be called to instruct the PHY underlying layer
>>> >> >> at specified lane to configure for specified speed in hertz.
>>> >> >
>>> >> > why ? looks like clk_set_rate() is your friend here. Can you be more
>>> >> > descriptive of the use case ? When will this be used ?
>>> >> >
>>> >>
>>> >> The phy_set_speed is used to configure the operation speed of the PHY
>>> >> at run-time. The clock interface in general is used to configure the
>>> >> clock input to the IP. I don't believe they are the same thing. Maybe
>>> >> it will be clear in my response to your second email
>>> >
>>> > The problem with this is that you end up adding SATA-specific details to
>>> > something which is supposed to be generic.
>>>
>>> Setting the operation speed is pretty generic from an interface point
>>> of view. An generic multi-purpose PHY can support multiple speed. If
>>
>> no it's not. Specially when you consider that your "speed" argument can
>> be just about anything and depending on the underlying bus, it *will* be
>> treated differently. Note that e.g. in OMAP devices the exact *same* PHY
>> IP is used for PCIe, SATA and USB... now, let's assume for the sake of
>> argument that we were to implement ->set_speed() in that environment,
>> how do you plan to do that ? a 6MHz arguments isn't valid from USB stand
>> point and could mean different things in PCIe or SATA.
>>
>
> Correct me if I am wrong here. If the same PHY is used for PCIe, SATA,
> and USB, would you not need to indicate what speed the PHY should be
> operated at - unless the underlying IP magically negotiate and
> configured automatically? If so, what about PHY isn't so intelligent?
> How should you suggest that we handle these?
>
>>> the upper layer wish to operate at an specified speed (say for testing
>>> purpose and etc), it can be allowed.
>>
>> anything for testing purposes, should be limited to test scenarios.
>
> Testing purpose is only one use case. Another use case is to limit the
> speed so that I can confirm the driver actually works with various
> speed of the device and handle correctly.
>
>>
>>> > After negoatiation, don't you
>>> > get any interrupt from your PHY indicating that link speed negotiation
>>> > is done ? Or is that IRQ only on AHCI IP ?
>>>
>>> There is NO interrupt from the PHY. The IRQ is assoicated with the
>>> AHCI IP. With SATA host flow, it starts off with an COMRESET to start
>>> the link negotiation. At that point, it will poll for completion.
>>>
>>> Any other concerns?
>>
>> hey, calm down... just trying to prevent us from applying something
>> which isn't truly generic and I don't think "->set_speed" is generic
>> enough. The semantics of the "speed" argument won't be valid for all use
>> cases.
>>
>> I can already see people using that to pass
>> USB_SPEED_{LOW,FULL,HIGH,SUPER}, instead of actual speed numbers. We wil
>> end up with a mess to handle from a PHY driver, specially in cases such
>> as OMAP where, as mentioned above, the same IP is used for SATA, PCIe
>> and USB3.
>>
>
> This PHY isn't as "intelligent" as other PHY's. What would you suggest
> as I need an method to indicate to the underlying PHY that I want to
> operate at an specified speed?

Sorry if I am pinging you guys too fast here. I am look from an
solution and open to any solution in which it is acceptable for your
original intent of the generic PHY framework. I understand that you
don't believe set_speed is generic enough and may not apply to omap.
Or if you prefer we can try changing the init function to take an
initial MAX speed?

-Loc
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
