From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH v3] scsi-ml: adds queue_depth ramp up code
Date: Wed, 21 Oct 2009 08:37:19 -0500
Message-ID: <4ADF0E8F.1020204@sgi.com>
References: <20091016004700.22451.42962.stgit@vifc.jf.intel.com>	 <20091016230824.18916.84116.stgit@vifc.jf.intel.com>	 <20091020185426.GA5905@schmichrtp.de.ibm.com> <1256077937.16472.60.camel@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:35006 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751980AbZJUNhS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 09:37:18 -0400
In-Reply-To: <1256077937.16472.60.camel@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, Vasu Dev <vasu.dev@intel.com>, linux-scsi@vger.kernel.org, devel@open-fcoe.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu



Vasu Dev wrote:
> On Tue, 2009-10-20 at 20:54 +0200, Christof Schmitt wrote:
>> On Fri, Oct 16, 2009 at 04:08:24PM -0700, Vasu Dev wrote:
>>> -v3
>>>  Moves max_queue_depth initialization after slave_configure is
>>> called from after slave_alloc calling done. Also adjusted
>>> max_queue_depth check to skip ramp up if current queue_depth
>>> is >= max_queue_depth.
>>>
>>> Signed-off-by: Vasu Dev <vasu.dev@intel.com>
>> Looks good to me. I ran some tests on s390 and the queue depth counter
>> increased until hitting the defined maximum.
>>
> 
> Good.
> 
>>> @@ -779,6 +781,36 @@ static struct device_attribute sdev_attr_queue_depth_rw =
>>>  	       sdev_store_queue_depth_rw);
>>>
>>>  static ssize_t
>>> +sdev_show_queue_ramp_up_period(struct device *dev,
>>> +			       struct device_attribute *attr,
>>> +			       char *buf)
>>> +{
>>> +	struct scsi_device *sdev;
>>> +	sdev = to_scsi_device(dev);
>>> +	return snprintf(buf, 20, "%lu\n", sdev->queue_ramp_up_period);
>>> +}
>>> +
>>> +static ssize_t
>>> +sdev_store_queue_ramp_up_period(struct device *dev,
>>> +				struct device_attribute *attr,
>>> +				const char *buf, size_t count)
>>> +{
>>> +	struct scsi_device *sdev = to_scsi_device(dev);
>>> +	unsigned long period;
>>> +
>>> +	if (strict_strtoul(buf, 10, &period))
>>> +		return -EINVAL;
>>> +
>>> +	sdev->queue_ramp_up_period = period;
>>> +	return period;
>>> +}
>> [...]
>>> +	unsigned long queue_ramp_up_period;	/* ramp up period in jiffies */
>>> +#define SCSI_DEFAULT_RAMP_UP_PERIOD	(120 * HZ)
>> Only a small inconvenience i guess: The sysfs attribute shows the
>> ramp-up-period in jiffies. On my system with HZ==100 the default is
>> 12000 and i was wondering if this would be milliseconds or something
>> related. If HZ changes, the unit of the ramp-up-period also changes.
>>
>> I would prefer having seconds or milliseconds in sysfs and only using
>> jiffies internally.
>>
> 
> Added timestamp comparison checks are straightforward without any
> additional conversion on each check since added timestamps and
> queue_ramp_up_period both are jiffies, so works better this way with
> stored queue_ramp_up_period in jiffies. 
> 
> I do see your point as well but jiffies unit is also common in Linux.
> However if you or some other feels strongly to change this to ms or
> seconds unit then I could change store or show sysfs functions to handle
> this value in ms or second unit while storing it in jiffies in
> queue_ramp_up_period.

sysfs values should be presented in seconds.  jiffies is not a user accessible
unit of measure.  Esp. for systems with HZ != 100.  Milliseconds is too
fine grained (in my opinion).

Mike

> 
> 	Vasu
> 
>> Thanks for doing this,
>>
>> Christof
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
