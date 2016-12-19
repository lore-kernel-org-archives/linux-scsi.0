From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v1 07/12] scsi: ufs: add option to change default UFS
 power management level
Date: Mon, 19 Dec 2016 12:38:01 -0600
Message-ID: <CAL_Jsq+mu0R58in7oOq-mho43ERqOQk=jiu5vCWXq5=4eJJSpQ@mail.gmail.com>
References: <1481590462-9981-1-git-send-email-subhashj@codeaurora.org>
 <20161213200427.vzdwyzajcftvvcgu@rob-hp-laptop> <b326fb4217bb894295e83fe252aa7bf1@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b326fb4217bb894295e83fe252aa7bf1@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Hannes Reinecke <hare@suse.com>, Yaniv Gardi <ygardi@codeaurora.org>, Joao Pinto <Joao.Pinto@synopsys.com>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 13, 2016 at 2:16 PM, Subhash Jadavani
<subhashj@codeaurora.org> wrote:
> On 2016-12-13 12:04, Rob Herring wrote:
>>
>> On Mon, Dec 12, 2016 at 04:54:20PM -0800, Subhash Jadavani wrote:
>>>
>>> UFS device and link can be put in multiple different low power modes
>>> hence
>>> UFS driver supports multiple different low power modes. By default UFS
>>> driver selects the default (optimal) low power mode (which gives moderate
>>> power savings and have relatively less enter and exit latencies) but
>>> we might have to tune this default power mode for different chipset
>>> platforms to meet the low power requirements/goals. Hence this patch
>>> adds option to change default UFS low power mode (level).
>>>
>>> Reviewed-by: Yaniv Gardi <ygardi@codeaurora.org>
>>> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
>>> ---
>>>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      | 10 ++++++
>>>  drivers/scsi/ufs/ufshcd-pltfrm.c                   | 14 ++++++++
>>>  drivers/scsi/ufs/ufshcd.c                          | 39
>>> ++++++++++++++++++++++
>>>  drivers/scsi/ufs/ufshcd.h                          |  4 +--
>>>  4 files changed, 65 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>> b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>> index a99ed55..c3836c5 100644
>>> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>> @@ -41,6 +41,14 @@ Optional properties:
>>>  -lanes-per-direction   : number of lanes available per direction -
>>> either 1 or 2.
>>>                           Note that it is assume same number of lanes is
>>> used both
>>>                           directions at once. If not specified, default
>>> is 2 lanes per direction.
>>> +- rpm-level            : UFS Runtime power management level. Following
>>> PM levels are supported:
>>> +                         0 - Both UFS device and Link in active state
>>> (Highest power consumption)
>>> +                         1 - UFS device in active state but Link in
>>> Hibern8 state
>>> +                         2 - UFS device in Sleep state but Link in
>>> active state
>>> +                         3 - UFS device in Sleep state and Link in
>>> hibern8 state (default PM level)
>>> +                         4 - UFS device in Power-down state and Link in
>>> Hibern8 state
>>> +                         5 - UFS device in Power-down state and Link in
>>> OFF state (Lowest power consumption)
>>> +- spm-level            : UFS System power management level. Allowed PM
>>> levels are same as rpm-level.
>>
>>
>> This looks like you are putting policy for Linux into DT.
>>
>> What I would expect to see here is disabling of states that don't work
>> due to some h/w limitation. Otherwise, it is a user decision for what
>> modes to go into. Also, I think link and device states should be
>> separate.
>
>
> Yes, generally default level (3) is good enough (and recommended) for all
> platforms and most likely user is only expected to change this if they see
> issues (most H/W) on their platform or they want even more aggressive power
> state (level-4 or level-5) and ready to take the performance hit associated
> with resume latencies.

What latencies can be tolerated is going to depend on the application
and could vary while running, so putting in DT doesn't make sense. I
would break down settings like this:

broken h/w -> DT
user tuning/config -> sysfs
sensible defaults -> driver

> Also, I think it is better to keep Link and device states tied, one reason
> is that we can't keep device in sleep/active state when Link is in OFF
> state.

The driver can tie the states to together if needed. Just document
what's broken in DT and let the driver make decisions.

Rob
