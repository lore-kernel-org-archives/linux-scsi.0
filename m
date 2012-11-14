From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 03/10] ata: zpodd: identify and init ZPODD devices
Date: Wed, 14 Nov 2012 09:32:27 +0800
Message-ID: <50A2F4AB.6060903@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com> <1352443922-13734-4-git-send-email-aaron.lu@intel.com> <20121112185301.GB5560@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20121112185301.GB5560@mtj.dyndns.org>
Sender: linux-pm-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/13/2012 02:53 AM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Nov 09, 2012 at 02:51:55PM +0800, Aaron Lu wrote:
>>  void ata_acpi_unbind(struct ata_device *dev)
>>  {
>> +	if (zpodd_dev_enabled(dev))
>> +		zpodd_deinit(dev);
> 
> Maybe zpodd_exit() instead?

OK.

> 
>> +void zpodd_init(struct ata_device *dev)
>> +{
>> +	int ret;
>> +	struct zpodd *zpodd;
>> +
>> +	if (dev->private_data)
>> +		return;
>> +
>> +	if (!device_can_poweroff(dev))
>> +		return;
>> +
>> +	if ((ret = check_loading_mechanism(dev)) == -ENODEV)
>> +		return;
>> +
>> +	zpodd = kzalloc(sizeof(struct zpodd), GFP_KERNEL);
>> +	if (!zpodd)
>> +		return;
>> +
>> +	if (ret)
>> +		zpodd->drawer = true;
>> +	else
>> +		zpodd->slot = true;
>> +
>> +	zpodd->dev = dev;
>> +	dev->private_data = zpodd;
> 
> I don't think you're supposed to use dev->private_data from libata
> core layer.  Just add a new field.  Nobody cares about adding 8 more
> bytes to struct ata_device and spending 8 more bytes is way better
> than muddying the ownership of ->private_data.

OK.
And just out of curiosity, who's supposed to use device's private_data?
I didn't find any user for ata_device's private_data in libata.

> 
>> +/* libata-zpodd.c */
>> +#ifdef CONFIG_SATA_ZPODD
>> +void zpodd_init(struct ata_device *dev);
>> +void zpodd_deinit(struct ata_device *dev);
>> +static inline bool zpodd_dev_enabled(struct ata_device *dev)
>> +{
>> +	if (dev->flags & ATA_DFLAG_DA && dev->private_data)
>> +		return true;
>> +	else
>> +		return false;
>> +}
> 
> And this gets completely wrong.  What if the device supports DA and
> low level driver makes use of ->private_data?

I didn't find any user of ata_device's private_data, so I used it for
ZPODD. But if this is dangerous, I'll use a new field.

Thanks,
Aaron

