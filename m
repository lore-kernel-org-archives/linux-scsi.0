From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 03/10] ata: zpodd: identify and init ZPODD devices
Date: Mon, 19 Nov 2012 10:15:52 +0800
Message-ID: <50A99658.9090904@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com> <1352443922-13734-4-git-send-email-aaron.lu@intel.com> <20121112185301.GB5560@mtj.dyndns.org> <50A2F4AB.6060903@intel.com> <20121118143800.GI7306@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20121118143800.GI7306@mtj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/18/2012 10:38 PM, Tejun Heo wrote:
> Hello, Aaron.
Hi,

> 
> On Wed, Nov 14, 2012 at 09:32:27AM +0800, Aaron Lu wrote:
>>> I don't think you're supposed to use dev->private_data from libata
>>> core layer.  Just add a new field.  Nobody cares about adding 8 more
>>> bytes to struct ata_device and spending 8 more bytes is way better
>>> than muddying the ownership of ->private_data.
>>
>> OK.
>> And just out of curiosity, who's supposed to use device's private_data?
>> I didn't find any user for ata_device's private_data in libata.
> 
> All the ->private_data fields are to be used by low level drivers
> (ahci, ata_piix, pata_via...).  Given the twisted nature of ATA
> devices, it's a bit surprising that no driver yet found a need for
> ata_dev->private_data.  For most SATA controllers, port to device is
> one to one so maybe ap->private_data is enough.
> 
>>> And this gets completely wrong.  What if the device supports DA and
>>> low level driver makes use of ->private_data?
>>
>> I didn't find any user of ata_device's private_data, so I used it for
>> ZPODD. But if this is dangerous, I'll use a new field.
> 
> As there currently is no other user, it won't break anything but yeah
> please add a properly typed and named field.

OK, and thanks for the suggestion.

-Aaron

> 
> Thanks.
> 

