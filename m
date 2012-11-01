From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v8 09/11] block: add a new interface to block events
Date: Thu, 01 Nov 2012 14:30:53 +0800
Message-ID: <5092171D.8040202@intel.com>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com> <1351501298-3716-10-git-send-email-aaron.lu@intel.com> <20121029153536.GL5171@htj.dyndns.org> <508F7BF1.1040009@intel.com> <20121031215121.GC2945@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20121031215121.GC2945@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 11/01/2012 05:51 AM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Oct 30, 2012 at 03:04:17PM +0800, Aaron Lu wrote:
>>> check_event() can retry.  Just add a per-sr mutex which is try-locked
>>> by sr_block_check_events() and grab it when entering zero power.
>>
>> Good suggestion. I didn't think about solving it this way.
>>
>> Many people suggest me that ZPODD is pure SATA/ACPI stuff, and should
>> not pollute sr driver, so I was trying hard not to touch sr while
>> preparing these patches, unless there is no other choice(like the
>> blocking event interface).
>>
>> So I'm not sure if your suggestion is the way to go.
>>
>> James, what do you think? Is it OK if I add a mutex into the scsi_cd
>> structure to do this? Of course I'll define this only under
>> CONFIG_SATA_ZPODD.
> 
> I don't think what James' and my suggestions are that different.  Just
> silence check_event() while zpodd is kicked in somehow.  There's no

Well, since sr is not supposed to know anything about ZPODD, I don't see
another way to silence check_event() in ATA layer.

What I hope to achieve is when zero power ready status is sensed in ATA
layer, no more sr_check_events should be called, as that function will
runtime resume the ODD.

Thanks,
Aaron

> reason to synchronize across multiple subsystems.
> 
> Thanks.
> 

