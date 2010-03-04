From: "Hugh Daschbach" <hdasch@broadcom.com>
Subject: RE: System reboot hangs due to race against devices_kset->list
 triggered by SCSI FC workqueue
Date: Thu, 4 Mar 2010 11:09:01 -0800
Message-ID: <233671224A0FED4688218FFDBED26E1A5181BF12D1@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <233671224A0FED4688218FFDBED26E1A517AC38CA5@IRVEXCHCCR01.corp.ad.broadcom.com>
 <Pine.LNX.4.44L0.1003041005530.1657-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1003041005530.1657-100000@iolanthe.rowland.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>, David Vrabel <david.vrabel@csr.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, james Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>
List-Id: linux-scsi@vger.kernel.org

Alan Stern [mailto:stern@rowland.harvard.edu] writes:

> On Wed, 3 Mar 2010, Hugh Daschbach wrote:
>
>> Alan Stern [mailto:stern@rowland.harvard.edu] writes:
>> 
>> > On Wed, 3 Mar 2010, Hugh Daschbach wrote:
>> >
>> >> > Can't we just protect the list?  What is wanting to write to the list
>> >> > while shutdown is happening?
>> >> 
>> >> Indeed, Alan suggested holding the kset spinlock while iterating the
...
>> > What I meant was that you should hold the spinlock while finding and 
>> > unlinking the last device on the list.  Clearly you shouldn't hold it 
>> > while calling the device shutdown routine.
>> 
>> I misunderstood.  But I believe insertion and deletion is properly
>> serliaized.  It looks to me like the list structure is intact.  It's the
>> iterator that's been driven off into the weeds.
...
>> Just to be clear, the list we're talking about is "list" in "struct
>> kset"  And the nodes of the list are chained by "entry" in "struct
>> kobject".
...
>> At a minimum the change looks something like the patch below.
...
> If you really want to do this then you should remove the lock member 
> from struct kset.  However this seems like an awful lot of work 
> compared to my original suggestion -- something like this (untested, 
> and you'll want to add comments):
...

I'm not sure I do want to pursue this.  It does seem particularly
invasive at a fundamental level of a core data structure.

Apparently I still don't understand your original suggestion.  I'd
prefer to, especially if it leads to a simpler fix.  The loop in
device_shutdown() looks something like:

       struct device *dev, *devn;

        list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
                                kobj.entry) {
                if (dev->bus && dev->bus->shutdown) {
                        dev->bus->shutdown(dev);
                } else if (dev->driver && dev->driver->shutdown) {
                        dev->driver->shutdown(dev);
                }
        }

*dev gets delinked kobj_kset_leave() indirectly called from
dev->*->shutdown(dev).  This is protected by the spinlock.

The secondary thread similarly calls kobj_kset_leave().  But when the
secondary thread calls the shutdown routine for the device that devn
points to, the loop hangs.

Is there some way I can detect that devn no longer points to a valid
device upon return from dev->*->shutdown(dev)?  Or, where else can I
look to better understand your suggestion?

Thanks,
Hugh
