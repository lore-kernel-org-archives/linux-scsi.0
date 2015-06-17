From: "Dov Levenglick" <dovl@codeaurora.org>
Subject: Re: [PATCH v2 4/4] scsi: ufs: probe and init of variant driver from
 the platform device
Date: Wed, 17 Jun 2015 14:38:16 -0000
Message-ID: <3c23cd4feb85680b17203975e48822de.squirrel@www.codeaurora.org>
References: <1433324255-27510-1-git-send-email-ygardi@codeaurora.org>
    <1433324255-27510-5-git-send-email-ygardi@codeaurora.org>
    <CAC5umyis6HU06KU-aSGoy6mCt-u+5Pz16nDk1qHrcsTnFo_2hA@mail.gmail.com>
    <763dbc7b708b5d5b18ce0b5adcc41016.squirrel@www.codeaurora.org>
    <CAC5umyhWTLe_K+q9U=4M4N4Yu4Hp7hUxy4QiL=ch=JmYEiMBnQ@mail.gmail.com>
    <68c91f08f2be6c84055a303ca8aa3fe0.squirrel@www.codeaurora.org>
    <CAL_JsqKYqZyayzN3imi55EFP=ao4NTSgfXjP5J5rSxMAg4ZSMA@mail.gmail.com>
    <bfade46f9d953e10240acb835105b81d.squirrel@www.codeaurora.org>
    <CAL_Jsq+SWq9=xTjVvQH2tMoq=g_rjk44A7T4TMFKvDiUp_ahCg@mail.gmail.com>
    <6934f39953e011404dd5d39073e6ebba.squirrel@www.codeaurora.org>
    <CAL_Jsq+xQqAopQ8mYXbnED=3ioH+8Km9jtDZDeP_18U6Edfo5Q@mail.gmail.com>
    <c650d1bd7228cb0ebb31da7d67baaeaa.squirrel@www.codeaurora.org>
    <CAL_JsqLbGpZk5ZqfgZznj7JA2n-FCCTSjo+2zxG1QRup_zGUbQ@mail.gmail.com>
    <aed3981f6de0d9ca8b4f23c042547afb.squirrel@www.codeaurora.org>
    <1434551474.2222.23.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1434551474.2222.23.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Rob Herring <robherring2@gmail.com>
Cc: Dov Levenglick <dovl@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Akinobu Mita <akinobu.mita@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Paul Bolle <pebolle@tiscali.nl>, Gilad Broner <gbroner@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

> On Wed, 2015-06-17 at 14:21 +0000, Dov Levenglick wrote:
>> Hi James,
>> Rob raises a point that we don't agree with. On the other hand, we are
>> not
>> capable of convincing him in the validity of our approach - we are at an
>> impasse.
>> I would like to point out that our approach was reviewed by Paul and
>> Mita
>> (external reviewers) and neither of them had the objection that Rob has.
>> I urge you to go over this thread, where both sides raised points and
>> argued their cases. We are going to need your call on this so that we
>> can
>> move forward.
>
> The dispute is about device tree bindings.  While I could override a NAK
> in the subsystem I maintain, I'm not going to when it comes from the
> maintainer of the device tree subsystem on a subject that's his province
> of expertise, not mine.
>
> Please agree on what the bindings should look like and then resubmit the
> driver.
>
> James
>

Hi James & Rob,
Until this point I thought that this was a disagreement within the
confines of the scsi list. I was not aware of Rob's position as a
maintainer of the device tree subsystem.
We will take this offline with Rob and come back with a solution that
works for everyone.

Thanks,
Dov

>
>> Thanks,
>> Dov
>>
>>
>> > On Wed, Jun 17, 2015 at 8:17 AM, Dov Levenglick <dovl@codeaurora.org>
>> > wrote:
>> >>> On Wed, Jun 17, 2015 at 2:42 AM, Dov Levenglick
>> <dovl@codeaurora.org>
>> >>> wrote:
>> >>>>> On Tue, Jun 9, 2015 at 12:53 AM, Dov Levenglick
>> >>>>> <dovl@codeaurora.org>
>> >>>>> wrote:
>> >>>>>>> On Sun, Jun 7, 2015 at 10:32 AM,  <ygardi@codeaurora.org> wrote:
>> >>>>>>>>> 2015-06-05 5:53 GMT+09:00  <ygardi@codeaurora.org>:
>> >>>>>
>> >>>>> [...]
>> >>>>>
>> >>>>>>>> If ufshcd-pltfrm driver is loaded before ufs-qcom, (what
>> actually
>> >>>>>>>> happens
>> >>>>>>>> always), then the calling to of_platform_populate() which is
>> >>>>>>>> added,
>> >>>>>>>> guarantees that ufs-qcom probe will be called and finish,
>> before
>> >>>>>>>> ufshcd_pltfrm probe continues.
>> >>>>>>>> so ufs_variant device is always there, and ready.
>> >>>>>>>> I think it means we are safe - since either way, we make sure
>> >>>>>>>> ufs-qcom
>> >>>>>>>> probe will be called and finish before dealing with ufs_variant
>> >>>>>>>> device
>> >>>>>>>> in
>> >>>>>>>> ufshcd_pltfrm probe.
>> >>>>>>>
>> >>>>>>> This is due to the fact that you have 2 platform drivers. You
>> >>>>>>> should
>> >>>>>>> only have 1 (and 1 node). If you really think you need 2, then
>> you
>> >>>>>>> should do like many other common *HCIs do and make the base UFS
>> >>>>>>> driver
>> >>>>>>> a set of library functions that drivers can use or call. Look at
>> >>>>>>> EHCI,
>> >>>>>>> AHCI, SDHCI, etc. for inspiration.
>> >>>>>>
>> >>>>>> Hi Rob,
>> >>>>>> We did look at SDHCI and decided to go with this design due to
>> its
>> >>>>>> simplicity and lack of library functions. Yaniv described the
>> >>>>>> proper
>> >>>>>> flow
>> >>>>>> of probing and, as we understand things, it is guaranteed to work
>> >>>>>> as
>> >>>>>> designed.
>> >>>>>>
>> >>>>>> Furthermore, the design of having a subcore in the dts is used in
>> >>>>>> the
>> >>>>>> Linux kernel. Please have a look at drivers/usb/dwc3 where - as
>> an
>> >>>>>> example
>> >>>>>> - both dwc3-msm and dwc3-exynox invoke the probing function in
>> >>>>>> core.c
>> >>>>>> (i.e. the shared underlying Synopsys USB dwc3 core) by calling
>> >>>>>> of_platform_populate().
>> >>>>>
>> >>>>> That binding has the same problem. Please don't propagate that.
>> >>>>> There
>> >>>>> is no point in a sub-node in this case.
>> >>>>>
>> >>>>>> Do you see a benefit in the SDHCi implementation?
>> >>>>>
>> >>>>> Yes, it does not let the kernel driver design dictate the hardware
>> >>>>> description.
>> >>>>>
>> >>>>> Rob
>> >>>>>
>> >>>>
>> >>>> Hi Rob,
>> >>>> We appear to be having a philosophical disagreement on the
>> >>>> practicality
>> >>>> of
>> >>>> designing the ufshcd variant's implementation - in other words, we
>> >>>> disagree on the proper design pattern to follow here.
>> >>>> If I understand correctly, you are concerned with a design pattern
>> >>>> wherein
>> >>>> a generic implementation is wrapped - at the device-tree level - in
>> a
>> >>>> variant implementation. The main reason for your concern is that
>> you
>> >>>> don't
>> >>>> want the "kernel driver design dictate the hardware description".
>> >>>>
>> >>>> We considered this point when we suggested our implementation (both
>> >>>> before
>> >>>> and after you raised it) and reached the conclusion that - while an
>> >>>> important consideration - it should not be the prevailing one. I
>> >>>> believe
>> >>>> that you will agree once you read the reasoning. What guided us was
>> >>>> the
>> >>>> following:
>> >>>> 1. Keep our change minimal.
>> >>>> 2. Keep our patch in line with known design patterns in the kernel.
>> >>>> 3. Have our patch extend the existing solution rather than reinvent
>> >>>> it.
>> >>>>
>> >>>> It is the 3rd point that is most important to this discussion,
>> since
>> >>>> UFS
>> >>>> has already been deployed by various vendors and is used by OEM.
>> >>>> Changing
>> >>>> ufshcd to a set of library functions that would be called by
>> variants
>> >>>> would necessarily introduce a significant change to the code flow
>> in
>> >>>> many
>> >>>> places and would pose a backward compatibility issue. By using the
>> >>>> tried
>> >>>> and tested pattern of subnodes in the dts we were able to keep the
>> >>>> change
>> >>>> simple, succinct, understandable, maintainable and backward
>> >>>> compatible.
>> >>>> In
>> >>>> fact, the entire logic tying of the generic implementation to the
>> >>>> variant
>> >>>> takes ~20 lines of code - both short and elegant.
>> >>>
>> >>> The DWC3 binding does this and nothing else that I'm aware of. This
>> >>> hardly makes for a common pattern. If you really want to split this
>> to
>> >>> 2 devices, you can create platform devices without having a DT node.
>> >>>
>> >>> If you want to convince me this is the right approach for the
>> binding
>> >>> then you need to convince me the h/w is actually split this way and
>> >>> there is functionality separate from the licensed IP.
>> >>>
>> >>> Rob
>> >>>
>> >>
>> >> I don't understand the challenge that you just posed. It is clear
>> from
>> >> our
>> >> implementation that there is the standard and variants thereof. I
>> know
>> >> this to be a fact on the processors that we are working on.
>> >>
>> >> Furthermore, although I didn't check each and every result in the
>> >> search,
>> >> of_platform_populate is used in more locations than dwc3 and at least
>> a
>> >> few of them seem have be using the same paradigm as ours
>> >> (http://lxr.free-electrons.com/ident?i=of_platform_populate).
>> >
>> > You can ignore everything under arch/ as those are root level calls.
>> > Most of the rest of the list are devices which have multiple unrelated
>> > functions such as PMICs or system controllers which are perfectly
>> > valid uses of of_platform_populate. That leaves at most 10 examples
>> > that may or may not have good bindings. 10 out of hundreds of drivers
>> > in the kernel hardly makes for a pattern to follow.
>> >
>> > Let me be perfectly clear on the binding as is: NAK. I'm done replying
>> > until you propose something different.
>> >
>> > Rob
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>> in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>>
>> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
>> Forum,
>> a Linux Foundation Collaborative Project
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
>


QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
