From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v9 2/4] Documentation: Add documentation for APM X-Gene
 SoC SATA host controller DTS binding
Date: Wed, 15 Jan 2014 15:59:27 -0800
Message-ID: <CAPw-ZT=QXwOVvpgJSL5qU8J2eEuAt3nnXJDfDwPXTTo7z4Fe-A@mail.gmail.com>
References: <1389769910-15505-1-git-send-email-lho@apm.com>
	<5905127.tqJ3nFt5cj@wuerfel>
	<CAPw-ZTmVYfPLUVmtes3Gn8Z=+gyFtLoZxc-QUdHH7-ePjKAG9A@mail.gmail.com>
	<4632602.a1zUZOeMuh@wuerfel>
	<CAPw-ZTmn-aNJcLd1mZPRtog_ncq=GC94ULCJb-400oYqERYK5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:32946 "HELO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751890AbaAOX7a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 18:59:30 -0500
Received: by mail-qc0-f172.google.com with SMTP id c9so1711992qcz.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2014 15:59:29 -0800 (PST)
In-Reply-To: <CAPw-ZTmn-aNJcLd1mZPRtog_ncq=GC94ULCJb-400oYqERYK5g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Mark Rutland <mark.rutland@arm.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Suman Tripathi <stripathi@apm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, "tj@kernel.org" <tj@kernel.org>, "dmilburn@redhat.com" <dmilburn@redhat.com>, "olof@lixom.net" <olof@lixom.net>, Tuan Phan <tphan@apm.com>

Hi,

>>> >> >> +- clocks             : Reference to the clock entry.
>>> >> >> +- phys                       : PHY reference with parameter 0.
>>> >> >
>>> >> > The specific value of the phy-specifier shouldn't matter to this
>>> >> > binding. What should matter is what it logically corresponds to.
>>> >>
>>> >> I not quite following this. Are you suggest that I drop the value 0.
>>> >> In the binding, one needs to specify the mode of operation - 0 is for
>>> >> SATA. Can you explain more?
>>> >
>>> > The SATA device should not care what the argument for the PHY
>>> > device is. You could connect the same device to another PHY
>>> > that has a different set of arguments, which is the whole point
>>> > of abstracting it.
>>> >
>>>
>>> I understand what you wrote here. We should not have an argument from
>>> the host controller. Then my question is how should the PHY node
>>> indicates that it needs to be configured itself as an SATA PHY?
>>
>> The "phys" property should specify whatever the configuration of
>> the phy device is supposed to be. It's just not the business of
>> the sata driver or the sata binding to know what that configuration
>> is.
>>
>
> Here is what I have and I am trying to piece this together:
>
> phy1 {
>    #phy-cells = <0>;  /* No parameter as suggest by Mark */
> };
>
> sata1 {
>     :::
>     phys = <&phy1>;
> };
>
> What I don't get is how does one specify the mode
> (SATA/USB/SGMII/etc)? As another parameter in the phy1 node?
>

May be I misread what Mark mentioned. The binding documentation should
not specify the requirement of 0. And the binding of the dts should be
as is:

phy1 {
   #phy-cells = <1>;
};

sata1 {
   :::
   phys = <&phy1 0>;     where 0 indicates the mode of operation?
};

-Loc
