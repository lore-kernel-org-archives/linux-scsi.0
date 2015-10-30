From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v3 RESEND] scsi: report 'INQUIRY result too short' once per host
Date: Fri, 30 Oct 2015 13:56:36 +0100
Message-ID: <874mh8seez.fsf@vitty.brq.redhat.com>
References: <1446205211-12874-1-git-send-email-vkuznets@redhat.com>
	<56335AAD.4040506@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56335AAD.4040506@suse.de> (Hannes Reinecke's message of "Fri, 30
	Oct 2015 12:55:25 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan\" <kys@microsoft.com>, Long Li <longli@microsoft.com>, Dexuan Cui <decui@microsoft.com>"@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hannes Reinecke <hare@suse.de> writes:

> On 10/30/2015 12:40 PM, Vitaly Kuznetsov wrote:
>> Some host adapters (e.g. Hyper-V storvsc) are known for not respecting the
>> SPC-2/3/4 requirement for 'INQUIRY data (see table ...) shall contain at
>> least 36 bytes'. As a result we get tons on 'scsi 0:7:1:1: scsi scan:
>> INQUIRY result too short (5), using 36' messages on console. This can be
>> problematic for slow consoles. Introduce short_inquiry flag in struct
>> Scsi_Host to print the message once per host.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>> Changes since v3 RESEND:
>> - Sorry, I screwed up James address when sending 'v3 RESEND'.
>> 
>> Changes since v3:
>> - no changes, this is just a RESEND.
>> 
>> Changes since v2:
>> - This is a successor of previously sent (and still not merged) "scsi:
>>   introduce short_inquiry flag for broken host adapters" patch. I'm not
>>   particularly sure which solution is better but I'm leaning towards this
>>   one as it doesn't require changes to adapter drivers.
>> ---
>>  drivers/scsi/scsi_scan.c | 9 ++++++---
>>  include/scsi/scsi_host.h | 3 +++
>>  2 files changed, 9 insertions(+), 3 deletions(-)
>> 
> Why not printk_once?
> Should achieve the same result, and we're saving yet another flag...
>

It seems it makes sense to print this warning per-host (as we can have
many hosts) and not just once. It's hard to come up with a reasonable
message for printk_once() -- "some of your SCSI devices are buggy"
sounds to vague. Here we say "this particular scsi controller is buggy".

-- 
  Vitaly
