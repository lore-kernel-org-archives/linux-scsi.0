From: Doug Ledford <dledford@redhat.com>
Subject: Re: slave_destroy called in scsi_scan.c:scsi_probe_and_add_lun()
Date: Tue, 17 Dec 2002 22:35:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021218033521.GI28100@redhat.com>
References: <170040000.1040080786@aslan.btc.adaptec.com> <20021217054102.GH13989@redhat.com> <797140000.1040156703@aslan.btc.adaptec.com> <20021217222459.GD28100@redhat.com> <955680000.1040177254@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <955680000.1040177254@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Dec 17, 2002 at 07:07:34PM -0700, Justin T. Gibbs wrote:
> I decided to instrument what the SCSI layer does with these calls before
> looking at refcounting.  Here's the output of the scan of a bus with
> two drives on it: id 0 and id 1.
> 
> scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.23
>         <Adaptec aic7899 Ultra160 SCSI adapter>
>         aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
> 
> scsi0: Slave Alloc 0

This is the initial scsi_alloc_sdev() slave_alloc() call.

> scsi0: Slave Destroy 0
> scsi0: Slave Alloc 0

This pair is the first time through the probe_and_add_lun() routine where 
we destroy the old slave and alloc a new one because, all except for this 
first time through, we will be updating the device number.  We also send 
the actual INQUIRY command in between this alloc and the alloc below.

> scsi0: Slave Alloc 0

We alloc the new sdev here and copy the stuff from the scan sdev into it.

>   Vendor: SEAGATE   Model: ST39236LWV        Rev: 0010
>   Type:   Direct-Access                      ANSI SCSI revision: 03

Print the info.

> scsi0: Slave Destroy 0
> scsi0: Slave Alloc 0

I think, but I'm not positive, that this extra Destroy/Alloc pair is from 
the attempt to scan for lun information.

> scsi0: Slave Destroy 1
> scsi0: Slave Alloc 1

And here's the gotcha.  The destroy call you see points to 1 because we 
have already updated the sdev->target value in place before calling 
destroy.  In my case, it's a simple kfree() that doesn't care about what 
number or anything else, it knows what to kfree() simply by grabbing 
sdev->hostdata.  Then we alloc a struct for 1 which is the next device to 
be scanned.  The rest of this is pretty much a straight repeat of events.

> ...
> 
> scsi0: Slave Configure 0
> scsi0: Slave Configure 1
> 
> Notice that for all IDs but 0, a slave destroy call is performed
> prior to any slave allocations.  Very nice.  Note that I wasn't
> complaining that I couldn't work around this kind of crap, just
> that this crap is unsettling. 8-)

I stared at the scsi_scan.c code for a full day, did about 3 rewrites and 
threw them all away half way through each time before I finally gave in 
and left the scan code as much alone as I could.  But, I think I have the 
answer.

I'm headed to a midnight showing of the Two Towers in 30 minutes (OK, the
movie isn't for an hour and a half, but I'm meeting friends at the local
coffee shop to sit around and bullshit until it starts), but when I 
get home from that I'll see if I can't get my idea coded up and out 
before I crash.  Assuming I do, you will get exactly one alloc per 
channel/target/lun value scanned, exactly one configure per device found 
(although still delayed like it is now), and exactly one immediate destroy 
per device alloced and not found and exactly one destroy immediately 
prior to device free at the mid layer level (and this time all the destroy 
events will come after the corresponding alloc :-)

> > In my driver I don't attempt to do anything like send cache flush
> > commands  or the like, so I don't have the shutdown difficulties you do
> > and things  work quite nicely.
> 
> It's not about cache flushing or anything else.  It's about knowing if
> you need to retest the connection to a device, whether or not you should
> force a renegotiation the next time a command is attempted to a device,
> etc. etc.  So, when linux tells the driver that the device is gone,
> we setup our state so that we will not trust the old negotiated values
> and will perform Domain Validation again should the device return.

It's coming together well enough in my mind now that I'm 99% positive 
you'll have this by tomorrow morning.

/me pulls bk latest so he can get a small start before leaving

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
