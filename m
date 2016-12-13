From: Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v1 07/12] scsi: ufs: add option to change default UFS
 power management level
Date: Tue, 13 Dec 2016 12:16:55 -0800
Message-ID: <b326fb4217bb894295e83fe252aa7bf1@codeaurora.org>
References: <1481590462-9981-1-git-send-email-subhashj@codeaurora.org>
 <20161213200427.vzdwyzajcftvvcgu@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161213200427.vzdwyzajcftvvcgu@rob-hp-laptop>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>, Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 2016-12-13 12:04, Rob Herring wrote:
> On Mon, Dec 12, 2016 at 04:54:20PM -0800, Subhash Jadavani wrote:
>> UFS device and link can be put in multiple different low power modes 
>> hence
>> UFS driver supports multiple different low power modes. By default UFS
>> driver selects the default (optimal) low power mode (which gives 
>> moderate
>> power savings and have relatively less enter and exit latencies) but
>> we might have to tune this default power mode for different chipset
>> platforms to meet the low power requirements/goals. Hence this patch
>> adds option to change default UFS low power mode (level).
>> 
>> Reviewed-by: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> Signed-off-by: Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> ---
>>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      | 10 ++++++
>>  drivers/scsi/ufs/ufshcd-pltfrm.c                   | 14 ++++++++
>>  drivers/scsi/ufs/ufshcd.c                          | 39 
>> ++++++++++++++++++++++
>>  drivers/scsi/ufs/ufshcd.h                          |  4 +--
>>  4 files changed, 65 insertions(+), 2 deletions(-)
>> 
>> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt 
>> b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> index a99ed55..c3836c5 100644
>> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> @@ -41,6 +41,14 @@ Optional properties:
>>  -lanes-per-direction	: number of lanes available per direction - 
>> either 1 or 2.
>>  			  Note that it is assume same number of lanes is used both
>>  			  directions at once. If not specified, default is 2 lanes per 
>> direction.
>> +- rpm-level		: UFS Runtime power management level. Following PM 
>> levels are supported:
>> +			  0 - Both UFS device and Link in active state (Highest power 
>> consumption)
>> +			  1 - UFS device in active state but Link in Hibern8 state
>> +			  2 - UFS device in Sleep state but Link in active state
>> +			  3 - UFS device in Sleep state and Link in hibern8 state (default 
>> PM level)
>> +			  4 - UFS device in Power-down state and Link in Hibern8 state
>> +			  5 - UFS device in Power-down state and Link in OFF state (Lowest 
>> power consumption)
>> +- spm-level		: UFS System power management level. Allowed PM levels 
>> are same as rpm-level.
> 
> This looks like you are putting policy for Linux into DT.
> 
> What I would expect to see here is disabling of states that don't work
> due to some h/w limitation. Otherwise, it is a user decision for what
> modes to go into. Also, I think link and device states should be
> separate.

Yes, generally default level (3) is good enough (and recommended) for 
all platforms and most likely user is only expected to change this if 
they see issues (most H/W) on their platform or they want even more 
aggressive power state (level-4 or level-5) and ready to take the 
performance hit associated with resume latencies.

Also, I think it is better to keep Link and device states tied, one 
reason is that we can't keep device in sleep/active state when Link is 
in OFF state.

> 
> Rob

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
