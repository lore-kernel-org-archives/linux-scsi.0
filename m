From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 3/6] scsi: sr: support zero power ODD(ZPODD)
Date: Thu, 27 Sep 2012 17:26:29 +0800
Message-ID: <50641BC5.2090000@intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <201209210007.23494.rjw@sisk.pl> <20120921013917.GB2142@mint-spring.sh.intel.com> <201209212302.19896.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <201209212302.19896.rjw@sisk.pl>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 09/22/2012 05:02 AM, Rafael J. Wysocki wrote:
> On Friday, September 21, 2012, Aaron Lu wrote:
>> On Fri, Sep 21, 2012 at 12:07:23AM +0200, Rafael J. Wysocki wrote:
>>> On Wednesday, September 12, 2012, Aaron Lu wrote:
>>>>  static struct scsi_driver sr_template = {
>>>>  	.owner			= THIS_MODULE,
>>>> @@ -87,6 +89,8 @@ static struct scsi_driver sr_template = {
>>>>  		.name   	= "sr",
>>>>  		.probe		= sr_probe,
>>>>  		.remove		= sr_remove,
>>>> +		.suspend        = sr_suspend,
>>>> +		.resume         = sr_resume,
>>>>  	},
>>>>  	.done			= sr_done,
>>>>  };
>>>> @@ -172,6 +176,52 @@ static void scsi_cd_put(struct scsi_cd *cd)
>>>>  	mutex_unlock(&sr_ref_mutex);
>>>>  }
>>>
>>> Besides, I need some help to understand how this is supposed to work.
>>>
>>> Do I think correctly that sr_suspend(), for example, will be run by the
>>> SCSI bus type layer in case of a CD device runtime suspend?  However,
>>
>> Yes.
>>
>>> won't this routine be used during system suspend as well and won't it cause
>>> problems to happen if so?
>>
>> On system suspend, nothing needs to be done.
>> I'll add the following code in next version.
>>
>> 	if (!PMSG_IS_AUTO(msg))
>> 		return 0;
> 
> Please don't.  The pm_message_t thing is obsolete and shoulnd't really be
> used by device drivers.  I know that ATA relies on it internally, but that's
> just something that needs to be changed at one point.
> 
> Moreover, I'd like to migrate SCSI drivers to the PM handling based on struct
> dev_pm_ops eventually and your change is kind of going in the opposite
> direction.  I don't know how much effort the migration is going to take,
> though, so perhaps we can just make this change first.

Does the following change look OK?

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index dc0ad85..1fb7ccc 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -143,7 +143,15 @@ static int scsi_runtime_suspend(struct device *dev)
 
 	dev_dbg(dev, "scsi_runtime_suspend\n");
 	if (scsi_is_sdev_device(dev)) {
-		err = scsi_dev_type_suspend(dev, PMSG_AUTO_SUSPEND);
+		err = scsi_device_quiesce(to_scsi_device(dev));
+		if (err)
+			goto out;
+
+		err = pm_generic_runtime_suspend(dev);
+		if (!err)
+			goto out;
+
+		scsi_device_resume(to_scsi_device(dev));
 		if (err == -EAGAIN)
 			pm_schedule_suspend(dev, jiffies_to_msecs(
 				round_jiffies_up_relative(HZ/10)));
@@ -151,6 +159,7 @@ static int scsi_runtime_suspend(struct device *dev)
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
+out:
 	return err;
 }
 
@@ -159,11 +168,17 @@ static int scsi_runtime_resume(struct device *dev)
 	int err = 0;
 
 	dev_dbg(dev, "scsi_runtime_resume\n");
-	if (scsi_is_sdev_device(dev))
+	if (scsi_is_sdev_device(dev)) {
+		err = pm_generic_runtime_resume(dev);
+		if (err)
+			goto out;
+
 		err = scsi_dev_type_resume(dev);
+	}
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
+out:
 	return err;
 }
 

And I'll define runtime callbacks for sr and sd.

Thanks,
Aaron

