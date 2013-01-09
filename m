From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v11 7/9] libata: expose pm qos flags for ata device
Date: Wed, 09 Jan 2013 13:11:39 +0800
Message-ID: <50ECFC0B.5070008@intel.com>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com> <1357440509-28108-8-git-send-email-aaron.lu@intel.com> <20130107184358.GT3926@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20130107184358.GT3926@htj.dyndns.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/08/2013 02:43 AM, Tejun Heo wrote:
> On Sun, Jan 06, 2013 at 10:48:27AM +0800, Aaron Lu wrote:
>> Expose pm qos flags to user space so that user has a chance to disable
>> pm features like power off, if he/she has a broken platform or devices
>> or simply does not like this pm feature.
>>
>> This flag is exposed to user space only for ata device or atapi device
>> that is zero power capable. For normal atapi device, it will never be
>> powered off.
>>
>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>> ---
>>  drivers/ata/libata-acpi.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
>> index e832bf6..5b67be3 100644
>> --- a/drivers/ata/libata-acpi.c
>> +++ b/drivers/ata/libata-acpi.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/pci.h>
>>  #include <linux/slab.h>
>>  #include <linux/pm_runtime.h>
>> +#include <linux/pm_qos.h>
>>  #include <scsi/scsi_device.h>
>>  #include "libata.h"
>>  
>> @@ -1022,6 +1023,8 @@ static void ata_acpi_unregister_power_resource(struct ata_device *dev)
>>  void ata_acpi_bind(struct ata_device *dev)
>>  {
>>  	ata_acpi_register_power_resource(dev);
>> +	if (dev->class == ATA_DEV_ATA || zpodd_dev_enabled(dev))
>> +		dev_pm_qos_expose_flags(&dev->sdev->sdev_gendev, 0);
>>  }
> 
> Why from ata_acpi_bind()?

I think I should add a check to see if platform can power off the device
before export this qos flag. The check is done by ACPI, and the qos flag
is for the scsi device. So looks like this is the proper place?

Thanks,
Aaron

