From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Wed, 14 Nov 2012 10:18:23 +0800
Message-ID: <50A2FF6F.3080603@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com> <1352443922-13734-7-git-send-email-aaron.lu@intel.com> <20121112191303.GE5560@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20121112191303.GE5560@mtj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/13/2012 03:13 AM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Nov 09, 2012 at 02:51:58PM +0800, Aaron Lu wrote:
>> +#define POWEROFF_DELAY  (30 * 1000)     /* 30 seconds for power off delay */
>> +
>>  struct zpodd {
>>  	bool slot:1;
>>  	bool drawer:1;
>>  	bool from_notify:1;	/* resumed as a result of acpi notification */
>> +	bool status_ready:1;	/* ready status derived from media event poll,
>> +				   it is not accurate, but serves as a hint */
>> +	bool zp_ready:1;	/* zero power ready state */
>> +
>> +	unsigned long last_ready; /* last zero power ready timestamp */
>>  
>>  	struct ata_device *dev;
>>  };
> 
> How are accesses to the bit fields synchronized?

They are synchronized by PM core.
PM core ensures that no two suspend or resume callback run concurrently.
And when ODD is executing a command, it is in active state, no PM
callback will run.

> 
>> +/*
>> + * Snoop the result of GET_STATUS_NOTIFICATION_EVENT, the media
>> + * status byte has information on media present/door closed.
>> + *
>> + * This information serves only as a hint, as it is not accurate.
>> + * The sense code method will be used when deciding if the ODD is
>> + * really zero power ready.
>> + */
> 
> It would be great if you can make the above a proper dockbook function
> comment.  Also, as the snooping for hint thing isn't too obvious it
> would be great if the comment contains more info which is explained in
> the commit message.

OK.

> 
>> +/*
>> + * Check ODD's zero power ready status.
>> + *
>> + * This function is called during ATA port's suspend path,
>> + * when the port is not frozen yet, so that we can still make
>> + * some IO to the ODD to decide if it is zero power ready.
>> + *
>> + * The ODD is regarded as zero power ready when it is in zero
>> + * power ready state for some time(defined by POWEROFF_DELAY).
>> + */
>> +void zpodd_check_zpready(struct ata_device *dev)
>> +{
>> +	bool zp_ready;
>> +	unsigned long expires;
>> +	struct zpodd *zpodd = dev->private_data;
>> +
>> +	if (!zpodd->status_ready) {
>> +		zpodd->last_ready = 0;
>> +		return;
>> +	}
>> +
>> +	if (!zpodd->last_ready) {
>> +		zp_ready = zpready(dev);
>> +		if (zp_ready)
>> +			zpodd->last_ready = jiffies;
>> +		return;
>> +	}
>> +
>> +	expires = zpodd->last_ready + msecs_to_jiffies(POWEROFF_DELAY);
>> +	if (time_before(jiffies, expires))
>> +		return;
>> +
>> +	zpodd->zp_ready = zpready(dev);
>> +	if (!zpodd->zp_ready)
>> +		zpodd->last_ready = 0;
>> +}
> 
> Hmmm... so, the "full" check only happens when autopm kicks in, right?
> Is it really worth avoiding an extra TUR on autopm events?  That's not
> really a hot path.  It seems a bit over-engineered to me.

A little more information about this:
When there is disc inside and no program mounted the drive, the ODD will
be runtime suspended/resumed every 2 seconds along with the event poll.

I'm not sure if the above situation can happen often. Normal desktop
environment should automatically mount the ODD once they got uevent, and
for console users, they will probably manually mount the drive after
they have inserted a disc. The way I did it this way is to deal with the
worst possible case. But if this is deemed as not necessary, I think I
can remove the snoop hint thing and use TUR directly.


Thanks,
Aaron

