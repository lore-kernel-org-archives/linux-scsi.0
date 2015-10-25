From: ygardi@codeaurora.org
Subject: Re: [PATCH v3 6/8] scsi: ufs: make the UFS variant a platform
 device
Date: Sun, 25 Oct 2015 09:24:24 -0000
Message-ID: <337eb8cbc465fa36925c54da90531810.squirrel@www.codeaurora.org>
References: <1440335381-5122-1-git-send-email-ygardi@codeaurora.org>
    <1440335381-5122-7-git-send-email-ygardi@codeaurora.org>
    <CAL_JsqLYeM3fbU5jHq-+7SbwHH7T80bETZpkkjR_hbg=un1BBg@mail.gmail.com>
    <c07dbe55ff782a2323cc053d89d49480.squirrel@www.codeaurora.org>
    <CAL_JsqKDaqSX=DNL0AC2RDy53YUhtF2Eg2t=fJ7eVCoSB6P+JA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL_JsqKDaqSX=DNL0AC2RDy53YUhtF2Eg2t=fJ7eVCoSB6P+JA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Jej B <james.bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, hch@infradead.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaur>
List-Id: linux-scsi@vger.kernel.org

> On Sun, Aug 30, 2015 at 3:43 AM,  <ygardi@codeaurora.org> wrote:
>>> On Sun, Aug 23, 2015 at 8:09 AM, Yaniv Gardi <ygardi@codeaurora.org>
>>> wrote:
>>>> This change turns the UFS variant (SCSI_UFS_QCOM) into a UFS
>>>> a platform device.
>>>> In order to do so a few additional changes are required:
>>>> 1. The ufshcd-pltfrm is no longer serves as a platform device.
>>>>    Now it only serves as a group of platform APIs such as PM APIs
>>>>    (runtime suspend/resume, system suspend/resume etc), parsers of
>>>>    clocks, regulators and pm_levels from DT.
>>>> 2. What used to be the old platform "probe" is now "only"
>>>>    a pltfrm_init() routine, that does exactly the same, but only
>>>>    being called by the new probe function of the UFS variant.
>>>>
>>>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>>>
>>>> ---
>>>>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  2 +-
>>>>  drivers/scsi/ufs/ufs-qcom.c                        | 78
>>>> +++++++++++++++++-
>>>>  drivers/scsi/ufs/ufshcd-pltfrm.c                   | 92
>>>> ++++++----------------
>>>>  drivers/scsi/ufs/ufshcd-pltfrm.h                   | 41 ++++++++++
>>>>  drivers/scsi/ufs/ufshcd.c                          | 10 +++
>>>>  drivers/scsi/ufs/ufshcd.h                          |  1 +
>>>>  6 files changed, 152 insertions(+), 72 deletions(-)
>>>>  create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.h
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>>> b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>>> index 5357919..b39e765 100644
>>>> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>>> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>>> @@ -4,7 +4,7 @@ UFSHC nodes are defined to describe on-chip UFS host
>>>> controllers.
>>>>  Each UFS controller instance should have its own node.
>>>>
>>>>  Required properties:
>>>> -- compatible        : compatible list, contains "jedec,ufs-1.1"
>>>> +- compatible        : compatible list, contains "jedec,ufs-1.1" or
>>>> "qcom,ufshc"
>>>
>>> Replying again as I inadvertently dropped everyone.
>>>
>>> This should also have a more specific compatible string with the SOC
>>> name/number in it. It may be "the same in all SOCs", but there is
>>> always the possibility for bugs/limitations to be found that are
>>> specific to an SOC even if all RTL versions are identical (e.g.
>>> different max clock speeds). It is about making the dtb future proof,
>>> not about what exactly you need today. You can keep qcom,ufshc for
>>> driver matching if you want.
>>
>> I see your point.
>> I just would like to make sure, syntactically speaking, if what you mean
>> should look like:
>>
>> compatible        : compatible list, contains "jedec,ufs-1.1" or
>>                     "qcom,ufshc" for msm8994, msm8996 SOCs.
>
> No, you need actual compatible strings:
>
> contains one of:
>   "jedec,ufs-1.1"
>   "qcom,msm8994-ufshc" or "qcom,msm8996-ufshc" followed by "qcom,ufshc"
>
> Really, we should probably never had allowed "jedec,ufs-1.1" by itself.
>
>>>>  - interrupts        : <interrupt mapping for UFS host controller IRQ>
>>>>  - reg               : <registers mapping>
>>>
>>> What about phy properties? No Unipro PHY block that requires setup?
>>>
>>
>> yes, i will add another documentation file for it.
>
> And you need the "phy" property here with the phandle to the phy node.
>

The "phy" properties will be updated in V8 i'm about to uploade

> Rob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
