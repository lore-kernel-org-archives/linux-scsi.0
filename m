From: Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v2 2/5] dt-bindings: scsi: ufs: add document for
 hi3660-ufs
Date: Thu, 22 Jun 2017 18:05:40 -0700
Message-ID: <5c4c0a7b844055b32b8463fcee04401e@codeaurora.org>
References: <20170616065119.10704-1-butao@hisilicon.com>
 <20170616065119.10704-3-butao@hisilicon.com>
 <CAK8P3a2aPorzpUzwL=dkUkYNCGkhQMDPOkKRW1-=Hf=yCdvTsQ@mail.gmail.com>
 <0f79aeea-53e3-6bea-ffa6-0e057f2ff83b@huawei.com>
 <CAK8P3a2z7VbPb95Ltj=Duh1v_Yqxedb_g=ADNPWOrpEz1dCTuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAK8P3a2z7VbPb95Ltj=Duh1v_Yqxedb_g=ADNPWOrpEz1dCTuw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Bu Tao <butao-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Wei Xu <xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kevin Hilman <khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>, Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Riku Voipio <riku.voipio-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-fy+rA21nqHI@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 2017-06-22 04:51, Arnd Bergmann wrote:
> On Thu, Jun 22, 2017 at 1:44 PM, Bu Tao <butao-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>> 在 2017/6/17 5:51, Arnd Bergmann 写道:
>>> On Fri, Jun 16, 2017 at 8:51 AM, Bu Tao <butao-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org> wrote:
>>>> +Optional properties for board device:
>>>> +- ufs-hi3660-use-rate-B                : specifies UFS rate-B
>>>> +- ufs-hi3660-broken-fastauto   : specifies no fastauto
>>>> +- ufs-hi3660-use-HS-GEAR3      : specifies UFS HS-GEAR3
>>>> +- ufs-hi3660-use-HS-GEAR2      : specifies UFS HS-GEAR2
>>>> +- ufs-hi3660-use-HS-GEAR1      : specifies UFS HS-GEAR1
>>>> +- ufs-hi3660-broken-clk-gate-bypass    : specifies no clk-gate
>>>> +- ufs-hi3660-use-one-line      : specifies UFS use one line work
>>>> +- reset-gpio                   : specifies to reset devices
>>> 
>>> 
>>> Some of these sound rather generic and might apply to UFS 
>>> implementations
>>> other than hi3660, so I'd suggest adding them to the base ufs binding 
>>> with
>>> a generic name instead.
>>> 
>>> Any DT properties that might be useful across multiple 
>>> implementations
>>> should be parsed in generic code that gets called by the individual
>>> drivers,
>>> and then the properties that are specific to the integration work 
>>> done by
>>> hisilicon should be prefixed with "hisilicon,", but not normally with 
>>> the
>>> SoC name: it is quite possible that another SoC will be derived from 
>>> this
>>> chip and it should reuse the properties.
>> 
>> 
>> I do not know wheher other SoC need to use the optional properties as
>> abover. So here the name of the optional properties has "hi3660".
> 
> They should not have "hi3660" in their names either way, independent
> of where they are used.


Yes, i agree with Arnd that SoCs might also need these so please make 
these properties generic (put them under 
Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt) and also move 
their parsing code in generic driver (ufshcd.c or ufshcd-pltfrm.c).

> 
>>> (note: this is different from the value of the "compatible" property 
>>> that
>>> is meant to be as specific as possible".
>>> 
>>> Also, please clarify how your binding relates to the ufshcd binding
>>> in Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt: does
>>> hi3660 implement any registers that are shared with ufshcd, or does
>>> it use the same physical interface with a different register set?
>> 
>> No, only show how to use the dt-binding for hi3660 SoC
> 
> My question was about the hardware: does hi3660 implement ufshcd
> or not?
> 
>       Arnd

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
