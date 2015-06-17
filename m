From: "Dov Levenglick" <dovl@codeaurora.org>
Subject: Re: [PATCH v2 4/4] scsi: ufs: probe and init of variant driver from
 the platform device
Date: Wed, 17 Jun 2015 07:42:12 -0000
Message-ID: <6934f39953e011404dd5d39073e6ebba.squirrel@www.codeaurora.org>
References: <1433324255-27510-1-git-send-email-ygardi@codeaurora.org>
    <1433324255-27510-5-git-send-email-ygardi@codeaurora.org>
    <CAC5umyis6HU06KU-aSGoy6mCt-u+5Pz16nDk1qHrcsTnFo_2hA@mail.gmail.com>
    <763dbc7b708b5d5b18ce0b5adcc41016.squirrel@www.codeaurora.org>
    <CAC5umyhWTLe_K+q9U=4M4N4Yu4Hp7hUxy4QiL=ch=JmYEiMBnQ@mail.gmail.com>
    <68c91f08f2be6c84055a303ca8aa3fe0.squirrel@www.codeaurora.org>
    <CAL_JsqKYqZyayzN3imi55EFP=ao4NTSgfXjP5J5rSxMAg4ZSMA@mail.gmail.com>
    <bfade46f9d953e10240acb835105b81d.squirrel@www.codeaurora.org>
    <CAL_Jsq+SWq9=xTjVvQH2tMoq=g_rjk44A7T4TMFKvDiUp_ahCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CAL_Jsq+SWq9=xTjVvQH2tMoq=g_rjk44A7T4TMFKvDiUp_ahCg@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Dov Levenglick <dovl@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Akinobu Mita <akinobu.mita@gmail.com>, merez@qti.qualcomm.com, dovl@qti.qualcomm.com, Jej B <james.bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Paul Bolle <pebolle@tiscali.nl>, Gilad Broner <gbroner@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, Dolev Raviv <draviv@codeaurora.org>, Christoph Hellwig <hch@ls>
List-Id: linux-scsi@vger.kernel.org

> On Tue, Jun 9, 2015 at 12:53 AM, Dov Levenglick <dovl@codeaurora.org>
> wrote:
>>> On Sun, Jun 7, 2015 at 10:32 AM,  <ygardi@codeaurora.org> wrote:
>>>>> 2015-06-05 5:53 GMT+09:00  <ygardi@codeaurora.org>:
>
> [...]
>
>>>> If ufshcd-pltfrm driver is loaded before ufs-qcom, (what actually
>>>> happens
>>>> always), then the calling to of_platform_populate() which is added,
>>>> guarantees that ufs-qcom probe will be called and finish, before
>>>> ufshcd_pltfrm probe continues.
>>>> so ufs_variant device is always there, and ready.
>>>> I think it means we are safe - since either way, we make sure ufs-qcom
>>>> probe will be called and finish before dealing with ufs_variant device
>>>> in
>>>> ufshcd_pltfrm probe.
>>>
>>> This is due to the fact that you have 2 platform drivers. You should
>>> only have 1 (and 1 node). If you really think you need 2, then you
>>> should do like many other common *HCIs do and make the base UFS driver
>>> a set of library functions that drivers can use or call. Look at EHCI,
>>> AHCI, SDHCI, etc. for inspiration.
>>
>> Hi Rob,
>> We did look at SDHCI and decided to go with this design due to its
>> simplicity and lack of library functions. Yaniv described the proper
>> flow
>> of probing and, as we understand things, it is guaranteed to work as
>> designed.
>>
>> Furthermore, the design of having a subcore in the dts is used in the
>> Linux kernel. Please have a look at drivers/usb/dwc3 where - as an
>> example
>> - both dwc3-msm and dwc3-exynox invoke the probing function in core.c
>> (i.e. the shared underlying Synopsys USB dwc3 core) by calling
>> of_platform_populate().
>
> That binding has the same problem. Please don't propagate that. There
> is no point in a sub-node in this case.
>
>> Do you see a benefit in the SDHCi implementation?
>
> Yes, it does not let the kernel driver design dictate the hardware
> description.
>
> Rob
>

Hi Rob,
We appear to be having a philosophical disagreement on the practicality of
designing the ufshcd variant's implementation - in other words, we
disagree on the proper design pattern to follow here.
If I understand correctly, you are concerned with a design pattern wherein
a generic implementation is wrapped - at the device-tree level - in a
variant implementation. The main reason for your concern is that you don't
want the "kernel driver design dictate the hardware description".

We considered this point when we suggested our implementation (both before
and after you raised it) and reached the conclusion that - while an
important consideration - it should not be the prevailing one. I believe
that you will agree once you read the reasoning. What guided us was the
following:
1. Keep our change minimal.
2. Keep our patch in line with known design patterns in the kernel.
3. Have our patch extend the existing solution rather than reinvent it.

It is the 3rd point that is most important to this discussion, since UFS
has already been deployed by various vendors and is used by OEM. Changing
ufshcd to a set of library functions that would be called by variants
would necessarily introduce a significant change to the code flow in many
places and would pose a backward compatibility issue. By using the tried
and tested pattern of subnodes in the dts we were able to keep the change
simple, succinct, understandable, maintainable and backward compatible. In
fact, the entire logic tying of the generic implementation to the variant
takes ~20 lines of code - both short and elegant.

As to your concern, while I understand it and understand the underlying
logic, I don't think that it should outweigh the other considerations that
I outlined here.

Dov

QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
