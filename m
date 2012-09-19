From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Wed, 19 Sep 2012 22:19:52 +0800
Message-ID: <5059D488.6070208@intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <20120919080328.GA4283@mint-spring.sh.intel.com> <1348057667.2479.33.camel@dabdike.int.hansenpartnership.com> <201209191450.37735.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <201209191450.37735.rjw@sisk.pl>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 09/19/2012 08:50 PM, Rafael J. Wysocki wrote:
> On Wednesday, September 19, 2012, James Bottomley wrote:
>> On Wed, 2012-09-19 at 16:03 +0800, Aaron Lu wrote:
>>> Hi James,
>>>
>>> May I know if this patchset will enter v3.7?
>>
>> Sigh, well, I was hoping to persuade the PM people to sort this out
>> first.
>>
>> The first observation is that all this looks to be too specific.  ZPO
>> may be ACPI specific, but the property it abstracts: whether the
>> particular device is powered off or not is generic and probably should
>> be known at the generic PM level.  Nothing actually really cares about
>> how we power off the device until you get all the way down to the ACPI
>> controller.
>>
>> I think we could do this with a couple of flags sitting inside struct
>> device itself: one for pm state and capabilities defined at a generic
>> level and one for device specific pm state.  The latter would be for
>> things like the door lock information which is very specific to CDs
>> (although not specific to SCSI CDs).  Alternatively, even if we can't
>> use these capabilities at the generic pm level, we still need an
>> internal state set of flags because power state stuff traverses the
>> stack and struct device is the only universal object in that stack.
>>
>> So I definitely think all of the sdev flags should become either generic
>> or specific flags in device.
> 
> Well, the problem is that it is kind of irrelevant to the core whether or
> not the given device can be powered off.  Moreover, the actual meaning of
> what "power off" means depends on the platform (it may be an individual device
> state or a power domain state, for instance).  Also, the set of available
> low-power states depends on the platform (or the bus type) and generally
> cannot be universally represented and there are low-power states that
> aren't "power off" per se, but still require the device state to be
> restored when putting it back into full power.
> 
> We've discussed that for a few times and each time we've ended up agreeing
> that struct device is not the right place to store this information (for
> example, PCI stores it in struct pci_dev, USB has its own rules etc.).
> 
> I'll have a look at the patchset again and see what can be done about this.

Thanks Rafael, and if there is any question/problem,
please kindly let me know.

-Aaron
