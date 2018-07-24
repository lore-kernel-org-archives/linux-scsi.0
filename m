From: "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Subject: Re: [PATCH v1 4/9] scsi: ufs: add option to change default UFS power
 management level
Date: Tue, 24 Jul 2018 09:04:34 +0530
Message-ID: <f1d3af9d-3ff0-c15b-013d-013ba6dde287@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
 <ff2b648007a400c60ba804a0c5cab0166bd268e7.1530880006.git.asutoshd@codeaurora.org>
 <20180711203317.GA14983@rob-hp-laptop>
 <4b85de8b-d03e-da93-704b-e70922a9fbea@codeaurora.org>
 <CAL_JsqLXUvUj8n=1Xv-_ssqB6rayMvxOTnGzeN1vS9yx4-jqOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL_JsqLXUvUj8n=1Xv-_ssqB6rayMvxOTnGzeN1vS9yx4-jqOQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh@kernel.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>, Can Guo <cang@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Mathieu Malaterre <malat@debian.org>, devicetree@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 7/23/2018 8:06 PM, Rob Herring wrote:
> On Sun, Jul 22, 2018 at 9:20 PM Asutosh Das (asd)
> <asutoshd@codeaurora.org> wrote:
>>
>> On 7/12/2018 2:03 AM, Rob Herring wrote:
>>> On Fri, Jul 06, 2018 at 06:00:31PM +0530, Asutosh Das wrote:
>>>> From: Subhash Jadavani <subhashj@codeaurora.org>
>>>>
>>>> UFS device and link can be put in multiple different low power modes hence
>>>> UFS driver supports multiple different low power modes. By default UFS
>>>> driver selects the default (optimal) low power mode (which gives moderate
>>>> power savings and have relatively less enter and exit latencies) but
>>>> we might have to tune this default power mode for different chipset
>>>> platforms to meet the low power requirements/goals. Hence this patch
>>>> adds option to change default UFS low power mode (level).
>>>>
>>>> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
>>>> Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
>>>> Signed-off-by: Can Guo <cang@codeaurora.org>
>>>> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
>>>> ---
>>>>    .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      | 11 ++++++++
>>>>    drivers/scsi/ufs/ufshcd-pltfrm.c                   | 14 +++++++++++
>>>>    drivers/scsi/ufs/ufshcd.c                          | 29 +++++++++++++++-------
>>>>    drivers/scsi/ufs/ufshcd.h                          |  4 +--
>>>>    4 files changed, 47 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>>> index c39dfef..f564d9a 100644
>>>> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>>> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>>> @@ -38,6 +38,15 @@ Optional properties:
>>>>                         defined or a value in the array is "0" then it is assumed
>>>>                         that the frequency is set by the parent clock or a
>>>>                         fixed rate clock source.
>>>> +- rpm-level         : UFS Runtime power management level. Following PM levels are supported:
>>>> +                      0 - Both UFS device and Link in active state (Highest power consumption)
>>>> +                      1 - UFS device in active state but Link in Hibern8 state
>>>> +                      2 - UFS device in Sleep state but Link in active state
>>>> +                      3 - UFS device in Sleep state and Link in hibern8 state (default PM level)
>>>> +                      4 - UFS device in Power-down state and Link in Hibern8 state
>>>> +                      5 - UFS device in Power-down state and Link in OFF state (Lowest power consumption)
>>>> +- spm-level         : UFS System power management level. Allowed PM levels are same as rpm-level.
>>>
>>> What's the default?
>>>
>>> I assume these are minimums? The OS can pick higher power states. This
>>> seems to be a bit Linux specific (as 'runtime PM' could be considered
>>> Linux specific). For every other device, we don't put this type of
>>> information in DT, but is user controlled.
>> I didn't completely understand your comment.
>> Do you not want these properties to be in DT file?
> 
> Right, not if it is a user decision.
> 
>> When you say user-controlled, do you mean control it through sysfs entries?
> 
> Yes.
> 
>>> So really, wouldn't 1
>>> property be sufficient for cases where a mode doesn't work due to
>>> some h/w limitation. Otherwise, it is an OS or user decision.
>> I didn't completely understand this. Could you please elaborate on your
>> intent here?
> 
> The case that makes sense for this to be in DT is if there are h/w
> limitations that prevent some low power modes. In such a case, that
> limit is not likely specific to runtime PM or system suspend.
> 
>>>>    -lanes-per-direction       : number of lanes available per direction - either 1 or 2.
>>>>                         Note that it is assume same number of lanes is used both
>>>>                         directions at once. If not specified, default is 2 lanes per direction.
>>>> @@ -66,4 +75,6 @@ Example:
>>>>               freq-table-hz = <100000000 200000000>, <0 0>, <0 0>;
>>>>               phys = <&ufsphy1>;
>>>>               phy-names = "ufsphy";
>>>> +            rpm-level = <3>;
>>>
>>> Why specified if 3 is the default?
>> Ah yes - that should be removed.
>> I'll remove it in v2.
>>
>>>
>>>> +            spm-level = <5>;
>>>
>>> These seem like sane defaults. When and why would you use some
>>> different?
>> I think each of the deeper sleep modes are associated with an increasing
>> wakeup latency. For e.g. '0' would have the highest power-consumption
>> and no resume latency at all as compared to '5'.
>> So depending on use-cases other modes may be chosen.
> 
> The use-case can change in a running system. For example if you are
> plugged in, then you probably don't want to enter a lower power mode.
> 
> Rob
> 

Ok - Thanks.
I'm gonna make the following changes in v2:
1. Remove these entries from DT
2. Add support for these entries in sysfs.
3. Keep 3 as the default value for [rpm/spm]-levels

-asd

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
