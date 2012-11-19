From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Mon, 19 Nov 2012 11:09:40 +0800
Message-ID: <50A9A2F4.3020006@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com> <1352443922-13734-7-git-send-email-aaron.lu@intel.com> <20121112191303.GE5560@mtj.dyndns.org> <50A2FF6F.3080603@intel.com> <20121118150004.GJ7306@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20121118150004.GJ7306@mtj.dyndns.org>
Sender: linux-pm-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/18/2012 11:00 PM, Tejun Heo wrote:
> Hello, Aaron.
Hi,

> 
> On Wed, Nov 14, 2012 at 10:18:23AM +0800, Aaron Lu wrote:
>> On 11/13/2012 03:13 AM, Tejun Heo wrote:
>>> Hello,
>>>
>>> On Fri, Nov 09, 2012 at 02:51:58PM +0800, Aaron Lu wrote:
>>>> +#define POWEROFF_DELAY  (30 * 1000)     /* 30 seconds for power off delay */
>>>> +
>>>>  struct zpodd {
>>>>  	bool slot:1;
>>>>  	bool drawer:1;
>>>>  	bool from_notify:1;	/* resumed as a result of acpi notification */
>>>> +	bool status_ready:1;	/* ready status derived from media event poll,
>>>> +				   it is not accurate, but serves as a hint */
>>>> +	bool zp_ready:1;	/* zero power ready state */
>>>> +
>>>> +	unsigned long last_ready; /* last zero power ready timestamp */
>>>>  
>>>>  	struct ata_device *dev;
>>>>  };
>>>
>>> How are accesses to the bit fields synchronized?
>>
>> They are synchronized by PM core.
>> PM core ensures that no two suspend or resume callback run concurrently.
>> And when ODD is executing a command, it is in active state, no PM
>> callback will run.
> 
> Care to add short comment for that?  Flag and bitfield updates aren't
> atomic to each other, so I find it usually helpful to clearly state
> the synchronization rules for them.  More so if locking is inherited
> from upprer layer and not immediately obvious.

OK.

> 
>>> Hmmm... so, the "full" check only happens when autopm kicks in, right?
>>> Is it really worth avoiding an extra TUR on autopm events?  That's not
>>> really a hot path.  It seems a bit over-engineered to me.
>>
>> A little more information about this:
>> When there is disc inside and no program mounted the drive, the ODD will
>> be runtime suspended/resumed every 2 seconds along with the event poll.
> 
> Is that a desirable behavior?  I haven't been following autopm and am
> a bit fuzzy about how autopm works and what it does.
> 
> If there isn't any user of the device autopm kicks in.  If zpodd is
> enabled and there's no media, the device goes off power.  If the user
> initiates an event which may change media status, the driver is
> notified via acpi and autopm backs out restoring power to the device.
> Am I understanding it correctly?

Yes.

> 
> What I'm confused about is what autopm does for devices w/o zpodd.
> What happens then?  Is it gonna leave power on for the device and,
> say, go on to suspend the controller?  But, how would that work for,
> say, future devices with async notification for media events?

Maybe we shouldn't allow autopm for such devices?

> 
> Also, if autopm is enabled, an optical device would go in and out of
> suspend every two seconds?
> 
>> I'm not sure if the above situation can happen often. Normal desktop
>> environment should automatically mount the ODD once they got uevent, and
>> for console users, they will probably manually mount the drive after
>> they have inserted a disc. The way I did it this way is to deal with the
>> worst possible case. But if this is deemed as not necessary, I think I
>> can remove the snoop hint thing and use TUR directly.
> 
> The problem with issuing TUR regularly is that some ODDs lock up after
> getting hit by frequent TURs.  That's the reason why sr event check
> routine is being careful with TUR and only issue
> GET_EVENT_STATUS_NOTIFICATION.  Windows does about the same thing and
> some vendors somehow screwed up TUR.
> 
> That said, I can't say the snooping is pretty.  It's a rather nasty
> thing to do.  So, libata now wants information from the event polling
> in block layer, but reaching for block_device from ata_devices is
> nasty too.  Hmmm... but aren't you already doing that to block polling
> on a powered down device?

I was feeling brain damaged by this for some time :-)

Basically, only ATA layer is aware of the power off thing, and sr knows
nothing about this(or it is not supposed to know this, at least, this is
what SCSI people think) and once powered off, I do not want the poll to
disturb the device, so I need to block the poll. I can't come up with
another way to achieve this except this nasty way.

James suggests me to keep the poll, but emulate the command. The problem
with this is, the autopm for resume will kick in on each poll, so I'll
need to decide if power up the ODD for this time's resume is needed in
port's runtime resume callback. This made things complex and it also put
too much logic in the resume callback, which is not desired. And even if
I keep the ODD in powered off state by emulating this poll command, its
ancestor devices will still be resumed, and I may need to do some trick
in their resume callback to avoid needless power/state transitions. This
doesn't feel like an elegant way to solve this either.

So yes, I'm still using this _nasty_ way to make the ODD stay in powered
off state as long as possible. But if there is other elegant ways to
solve this, I would appreciate it and happily using it. Personally, I
hope we can make sr aware of ZPODD, that would make the pain gone.

Thanks,
Aaron

