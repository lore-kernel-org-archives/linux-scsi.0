From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v12 1/4] PHY: Add function set_speed to generic PHY framework
Date: Thu, 27 Feb 2014 13:09:57 -0800
Message-ID: <CAPw-ZT=7cu1NoxrBL48RUJV04ofrnNkF=p=23VFfu8ZZWmkQWQ@mail.gmail.com>
References: <1393524848-8207-1-git-send-email-lho@apm.com>
	<1393524848-8207-2-git-send-email-lho@apm.com>
	<20140227190102.GB4862@saruman.home>
	<CAPw-ZT=F07=T0=z=iT=hxJ0+609RBDYRL=MXF5dQoEowLjsRjQ@mail.gmail.com>
	<20140227205039.GE5375@saruman.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og101.obsmtp.com ([64.18.0.141]:54496 "HELO
	exprod5og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751384AbaB0VJ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Feb 2014 16:09:59 -0500
Received: by mail-qa0-f47.google.com with SMTP id w5so4487092qac.20
        for <linux-scsi@vger.kernel.org>; Thu, 27 Feb 2014 13:09:58 -0800 (PST)
In-Reply-To: <20140227205039.GE5375@saruman.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: balbi@ti.com
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Tejun Heo <tj@kernel.org>, Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>

Hi,

>> >> This patch adds function set_speed to the generic PHY framework operation
>> >> structure. This function can be called to instruct the PHY underlying layer
>> >> at specified lane to configure for specified speed in hertz.
>> >
>> > why ? looks like clk_set_rate() is your friend here. Can you be more
>> > descriptive of the use case ? When will this be used ?
>> >
>>
>> The phy_set_speed is used to configure the operation speed of the PHY
>> at run-time. The clock interface in general is used to configure the
>> clock input to the IP. I don't believe they are the same thing. Maybe
>> it will be clear in my response to your second email
>
> The problem with this is that you end up adding SATA-specific details to
> something which is supposed to be generic.

Setting the operation speed is pretty generic from an interface point
of view. An generic multi-purpose PHY can support multiple speed. If
the upper layer wish to operate at an specified speed (say for testing
purpose and etc), it can be allowed.

> After negoatiation, don't you
> get any interrupt from your PHY indicating that link speed negotiation
> is done ? Or is that IRQ only on AHCI IP ?

There is NO interrupt from the PHY. The IRQ is assoicated with the
AHCI IP. With SATA host flow, it starts off with an COMRESET to start
the link negotiation. At that point, it will poll for completion.

Any other concerns?

-Loc
