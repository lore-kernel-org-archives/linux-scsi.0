From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 3/6] scsi: sr: support zero power ODD(ZPODD)
Date: Thu, 27 Sep 2012 22:55:34 +0800
Message-ID: <506468E6.1020007@intel.com>
References: <Pine.LNX.4.44L0.1209271038050.1596-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:9696 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab2I0Ozv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Sep 2012 10:55:51 -0400
In-Reply-To: <Pine.LNX.4.44L0.1209271038050.1596-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

On 09/27/2012 10:42 PM, Alan Stern wrote:
> On Thu, 27 Sep 2012, Aaron Lu wrote:
> 
>>> Moreover, I'd like to migrate SCSI drivers to the PM handling based on struct
>>> dev_pm_ops eventually and your change is kind of going in the opposite
>>> direction.  I don't know how much effort the migration is going to take,
>>> though, so perhaps we can just make this change first.
>>
>> Does the following change look OK?
>>
>> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
>> index dc0ad85..1fb7ccc 100644
>> --- a/drivers/scsi/scsi_pm.c
>> +++ b/drivers/scsi/scsi_pm.c
>> @@ -143,7 +143,15 @@ static int scsi_runtime_suspend(struct device *dev)
>>  
>>  	dev_dbg(dev, "scsi_runtime_suspend\n");
>>  	if (scsi_is_sdev_device(dev)) {
>> -		err = scsi_dev_type_suspend(dev, PMSG_AUTO_SUSPEND);
>> +		err = scsi_device_quiesce(to_scsi_device(dev));
>> +		if (err)
>> +			goto out;
>> +
>> +		err = pm_generic_runtime_suspend(dev);
>> +		if (!err)
>> +			goto out;
>> +
>> +		scsi_device_resume(to_scsi_device(dev));
>>  		if (err == -EAGAIN)
>>  			pm_schedule_suspend(dev, jiffies_to_msecs(
>>  				round_jiffies_up_relative(HZ/10)));
> 
> Maybe in the end it will be better, but for now this looks like 
> unnecessary code duplication.  Basically you are copying 
> scsi_dev_type_suspend() into scsi_runtime_suspend(), except that you 
> omitted the debugging statement.

And I've used pm_generic_runtime_suspend :-)
That would allow me to write runtime callbacks of dev_pm_ops for
indivisual scsi drivers, like sr.

Thanks,
Aaron

