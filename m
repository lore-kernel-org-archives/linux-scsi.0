From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Fri, 28 Sep 2012 16:20:50 +0800
Message-ID: <50655DE2.3030600@intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <201209242340.18318.rjw@sisk.pl> <20120925080133.GA1629@mint-spring.sh.intel.com> <3158525.rj2S1Jvnll@linux-lqwf.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <3158525.rj2S1Jvnll@linux-lqwf.site>
Sender: linux-ide-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 09/27/2012 06:46 PM, Oliver Neukum wrote:
> On Tuesday 25 September 2012 16:01:35 Aaron Lu wrote:
>> On Mon, Sep 24, 2012 at 11:40:18PM +0200, Rafael J. Wysocki wrote:
>>> On Monday, September 24, 2012, Aaron Lu wrote:
>>>> On Mon, Sep 24, 2012 at 02:55:31PM +0200, Rafael J. Wysocki wrote:
> 
>> I just checked the spec again and tested, when the ODD has power, it
>> will also send out notifications on pressing the eject button/inserting
>> a disc. So we should be able to capture such a event.
> 
> In this case there's no need to poll for disk change unless the button has
> been pressed.

The SATA spec says the device attention pin shall assert when:
- For tray type ODD, its front panel button is released;
- For slot type ODD, media is inserted.

I've a slot type ODD which has a eject button. The notification will be
sent when a disc is inserted, but not when the eject button is pressed,
and this doesn't violate the spec.

But if we disable the poll for disc changes, we will lose an event when
the disc is ejected by the eject button(the device attention pin shall
not trigger this time). I suppose this is a problem?

I think the device attention scheme is not designed to do this job,
while SATA asynchronous notification is.

> 
>> I'm thinking of enabling this GPE in sr_suspend once we decided that it
>> is ready to be powered off, so the time frame between sr_suspend and
>> when the power is actually removed in libata should be taken care of by
>> the GPE. If GPE fires, the notification function will request a runtime
>> resume of the device. Does this sound OK?
> 
> This sounds terribly, needlessly complicated. Just enable it when
> you detect the presence of a disk drive that supports it.
> 
> Furthermore we have a device which can detect that a button has
> been pressed. It is fundamentally wrong to poll for medium change in
> such devices. You know that it hasn't been changed.

That may depend on the ODD's capability. For the slot type ODD I
mentioned above, we will not know when the disc is gone.

Thanks,
Aaron

> We should notify the upper layers that we can do medium change
> detection on our own.
> 
> 	Regards
> 		Oliver
> 

