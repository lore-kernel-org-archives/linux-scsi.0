From: Doug Ledford <dledford@redhat.com>
Subject: Re: slave_destroy called in scsi_scan.c:scsi_probe_and_add_lun()
Date: Tue, 17 Dec 2002 00:41:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021217054102.GH13989@redhat.com>
References: <170040000.1040080786@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <170040000.1040080786@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@btc.adaptec.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Dec 16, 2002 at 04:19:46PM -0700, Justin T. Gibbs wrote:
> In debugging a different bug in the new 2.5.X port of the aic7xxx driver,
> I came across this behavior in scsi_probe_and_add_lun()
> 
>         /*
>          * Since we reuse the same sdevscan over and over with different
>          * target and lun values, we have to destroy and then recreate
>          * any possible low level attachments since they very will might
>          * also store the id and lun numbers in some form and need updating
>          * with each scan.
>          */
>         if (sdevscan->host->hostt->slave_destroy)
>                 sdevscan->host->hostt->slave_destroy(sdevscan);
>         if (sdevscan->host->hostt->slave_alloc)
>                 sdevscan->host->hostt->slave_alloc(sdevscan);
> 
> So, you cannot rely on slave_destroy as an indication of a device really
> going away in the physical sense.

No, you can.  In the code snippet above you might be destroying something 
at scsi0:0:0:0 and adding something at scsi0:0:1:0.  Regardless, the thing 
being destroyed is in fact going away permanently.  Whenever we do find a 
device, we actually allocate a new device struct identical to our current 
device struct and call slave_alloc() for the newly created device.  So, 
whenever we find a new device, there will be a momentary point in time at 
which two device structs will exist that point to the same device.  After 
the new device is allocated and set up, the original sdevscan device is 
simply renumbered in place (by updating the target or lun value) and then 
we call slave_destroy()/slave_alloc() so that the low level driver can 
also update their target/lun values to match.

>  In SPI, for example, the driver can only
> tell that the device is gone if a command is issued to it.  I had hoped that
> I could detect hot-pull/scsi-remove-single-device operations via this
> callback.

You can.  On any device we find, at device tear down time your 
slave_destroy() entry point will get called right before the device struct 
itself is kfree()ed.

> Granted, for some drivers, recreating and destroying state associated with a
> particular device might be pretty cheap, but certainly not in all cases.
> The
> aic7xxx and aic79xx drivers maintain domain validation and other negotiation
> state in these structures.  You certainly don't want to go through another
> full
> Domain Validation sequence the next time a device is allocated via
> slave_alloc() if the device isn't really "new".

In this case I would suggest that the better course of action is to delay 
any domain validation stuff until the slave_configure() call.  The 
original intent of slave_alloc() was for it to be as lightweight as 
possible simply because I knew that it would get called for every single 
target/lun value scanned.  Once we do find a device though, and once we 
have retrieved INQUIRY data so we know what the device is capable of, then 
we get the slave_configure() call which is a much more appropriate place 
for heavier initializations once you know a device has been found and not 
that we are just scanning.

> Any chance in changing this behavior?

Possibly.  But, does the explanation above and the one suggestion above 
solve your issues?

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
