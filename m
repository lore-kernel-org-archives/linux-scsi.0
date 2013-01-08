From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v11 5/9] libata: check zero power ready status for ZPODD
Date: Tue, 08 Jan 2013 17:09:11 +0800
Message-ID: <50EBE237.7040407@intel.com>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com> <1357440509-28108-6-git-send-email-aaron.lu@intel.com> <20130107183610.GR3926@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40468 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab3AHJIe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jan 2013 04:08:34 -0500
In-Reply-To: <20130107183610.GR3926@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On 01/08/2013 02:36 AM, Tejun Heo wrote:
> Hello, Aaron.
> 
> On Sun, Jan 06, 2013 at 10:48:25AM +0800, Aaron Lu wrote:
>> +/* Check zero power ready status */
>> +void zpodd_on_suspend(struct ata_device *dev)
>> +{
>> +	struct zpodd *zpodd = dev->zpodd;
>> +	unsigned long expires;
>> +
>> +	if (!zpready(dev)) {
>> +		zpodd->zp_ready = false;
>> +		zpodd->last_ready = 0;
>> +		return;
>> +	}
>> +
>> +	if (!zpodd->last_ready) {
>> +		zpodd->last_ready = jiffies;
>> +		return;
>> +	}
>> +
>> +	expires = zpodd->last_ready +
>> +		  msecs_to_jiffies(zpodd_poweroff_delay * 1000);
>> +	if (time_before(jiffies, expires))
>> +		return;
>> +
>> +	zpodd->zp_ready = true;
>> +}
> 
> Using 0 jiffies as special value is generally considered a bad form.
> It should be mostly ok here but it's not like avoiding that is
> difficult, so let's please not use 0 jiffies as special value.  If you
> have to, add another variable zp_sample_cnt or whatever.

No problem, thanks!

-Aaron

