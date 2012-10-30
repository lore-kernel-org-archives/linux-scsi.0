From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v8 09/11] block: add a new interface to block events
Date: Tue, 30 Oct 2012 15:04:17 +0800
Message-ID: <508F7BF1.1040009@intel.com>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com> <1351501298-3716-10-git-send-email-aaron.lu@intel.com> <20121029153536.GL5171@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20121029153536.GL5171@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/29/2012 11:35 PM, Tejun Heo wrote:
> Hello,
> 
> On Mon, Oct 29, 2012 at 05:01:36PM +0800, Aaron Lu wrote:
>> ODD_suspend                        disk_events_workfn
>>   ata_port_suspend                   check_events
>>     disk_block_events                  resume ODD
>>       cancel_delayed_work_sync           resume parent
>>       (waiting for disk_events_workfn)   (waiting for suspend callback)
> 
> I don't understand why solving it needs to be this elaborate.
							:-)

> check_event() can retry.  Just add a per-sr mutex which is try-locked
> by sr_block_check_events() and grab it when entering zero power.

Good suggestion. I didn't think about solving it this way.

Many people suggest me that ZPODD is pure SATA/ACPI stuff, and should
not pollute sr driver, so I was trying hard not to touch sr while
preparing these patches, unless there is no other choice(like the
blocking event interface).

So I'm not sure if your suggestion is the way to go.

James, what do you think? Is it OK if I add a mutex into the scsi_cd
structure to do this? Of course I'll define this only under
CONFIG_SATA_ZPODD.

> 
>> +/*
>> + * Under some circumstances, there is a race between the calling thread
>> + * of disk_block_events and the events checking function. To avoid such a race,
>> + * this function will check if the delayed work is pending. If not, it means
>> + * the work is either not queued or is already running, false is returned.
>> + * And if yes, try to cancel the delayed work. If succedded, disk_block_events
>> + * will be called and there is no worry that cancel_delayed_work_sync will
>> + * deadlock the events checking function. And if failed, false is returned.
>> + */
>> +bool disk_try_block_events(struct gendisk *disk)
>> +{
>> +	struct disk_events *ev = disk->ev;
>> +
>> +	if (!ev)
>> +		return false;
>> +
>> +	if (delayed_work_pending(&ev->dwork)) {
> 
> And please don't use delayed_work_pending() like this.  It doesn't add
> anything.  cancel_delayed_work() already needs to perform all the
> necessary tests.

OK, thanks for the suggestion.

-Aaron

> 
>> +		if (cancel_delayed_work(&disk->ev->dwork)) {
>> +			disk_block_events(disk);
>> +			return true;
>> +		}
>> +	}
>> +
>> +	return false;
>> +}
> 
> Thanks.
> 

