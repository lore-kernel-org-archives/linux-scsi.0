From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: slave_destroy called in scsi_scan.c:scsi_probe_and_add_lun()
Date: Tue, 17 Dec 2002 13:25:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <797140000.1040156703@aslan.btc.adaptec.com>
References: <170040000.1040080786@aslan.btc.adaptec.com>
 <20021217054102.GH13989@redhat.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021217054102.GH13989@redhat.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org

>> So, you cannot rely on slave_destroy as an indication of a device really
>> going away in the physical sense.
> 
> No, you can.  In the code snippet above you might be destroying something 
> at scsi0:0:0:0 and adding something at scsi0:0:1:0.  Regardless, the
> thing  being destroyed is in fact going away permanently.

The SDEV, yes.  The physical device, not necessarily.  The concern is that
the API should only be called when the system is saying "physical device
gone", not due to some quirk in how the mid-layer manages its data objects.
In otherwords, the mid-layer could just as easily free the sdev every
time a probe fails, retain the already allocated sdev for the "found
device", and allocate a new sdev for each new probe.  This would avoid
callbacks for physical devices that Linux has successfully probed.

> Whenever we do
> find a  device, we actually allocate a new device struct identical to our
> current  device struct and call slave_alloc() for the newly created
> device.  So,  whenever we find a new device, there will be a momentary
> point in time at  which two device structs will exist that point to the
> same device.  After  the new device is allocated and set up, the original
> sdevscan device is  simply renumbered in place (by updating the target or
> lun value) and then  we call slave_destroy()/slave_alloc() so that the
> low level driver can  also update their target/lun values to match.

Actually, this danger only exists if the low lever driver attaches
something to the SDEV and/or has a pointer to the SDEV.  The device
at a particular target/lun is still the same device.  The little dance
performed in the mid-layer can't change that.
 
>>  In SPI, for example, the driver can only
>> tell that the device is gone if a command is issued to it.  I had hoped
>> that I could detect hot-pull/scsi-remove-single-device operations via
>> this callback.
> 
> You can.  On any device we find, at device tear down time your 
> slave_destroy() entry point will get called right before the device
> struct  itself is kfree()ed.

The problem is that the SDEV lifetime is not representative to the
device's lifetime.

>> Granted, for some drivers, recreating and destroying state associated
>> with a particular device might be pretty cheap, but certainly not in all
>> cases. The
>> aic7xxx and aic79xx drivers maintain domain validation and other
>> negotiation state in these structures.  You certainly don't want to go
>> through another full
>> Domain Validation sequence the next time a device is allocated via
>> slave_alloc() if the device isn't really "new".
> 
> In this case I would suggest that the better course of action is to delay 
> any domain validation stuff until the slave_configure() call.

Waiting for Linux to get around to probing devices will cause, at minimum,
a 2X (7902 is a dual channel device) increase in the time it takes to
perform domain validation.  Because Linux does not probe busses in
parallel, both of these drivers actually perform their DV to all busses in
parallel
before the return from the detect routine (and on any later hot-plugged
device).  This means that the underlying, per-device, data structures are
already configured prior to the first call to slave_alloc() or
slave_configure().  Now I can work around this little wart by ignoring
slave_destroy() calls that occur before slave_configure() is called, but
I would rather the API have semantics that mirror the physical world
rather than be dictated by poor programming practice.

> The 
> original intent of slave_alloc() was for it to be as lightweight as 
> possible simply because I knew that it would get called for every single 
> target/lun value scanned.  Once we do find a device though, and once we 
> have retrieved INQUIRY data so we know what the device is capable of,
> then  we get the slave_configure() call which is a much more appropriate
> place  for heavier initializations once you know a device has been found
> and not  that we are just scanning.

Actually, the slave_configure() is postponed until way after the inquiry
data is retrieved.  If slave_congigure() were called as soon as the
device were properly detected, the slave_destroy() in scsi_scan.c would
be destroying a device that had been slave_configured.

--
Justin
