From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] 2.4.19 scsi_rescan patch (2nd pass)
Date: Wed, 2 Oct 2002 12:49:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021002164937.GE30234@redhat.com>
References: <andrew.r.cress@intel.com> <A5974D8E5F98D511BB910002A50A66470580D24F@hdsmsx103.hd.intel.com> <200210021534.g92FYh002462@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210021534.g92FYh002462@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Cress, Andrew R" <andrew.r.cress@intel.com>, linux-scsi@vger.kernel.org

On Wed, Oct 02, 2002 at 11:34:43AM -0400, James Bottomley wrote:
> andrew.r.cress@intel.com said:
> > Here is a 2nd pass at a patch to do a scsi rescan so that hot-inserted
> > scsi disks can automatically be recognized.  It includes some
> > recommended changes/cleanup from Patrick and Mike. 
> 
> Is there a really good reason we can't use the hotplug infrastructure for this 
> and scan from user level?  I know the 2.4 hotplug is less well developed than 
> 2.5, but I believe it will work well enough for this.
> 
> If you go the hotplug route, all we need is a hook to trigger the SCSI hotplug 
> event.

Well, I hate to say it because I don't want to be mean or anything, but 
this patch is a waste of time.  It only triggers a rescan on a reset, and 
that's not a valid rescan trigger.  Any sane hot plug hardware interface 
will *not* cause a reset when a new drive is plugged in.  The only hot 
plug scenario this will catch is if someone is hot plugging a drive 
directly into a cable and they manage to momentarily unsettle the bus in 
the process.  That isn't really anything we care about.  Furthermore, a 
scan is time intensive because of selection timeout delays on a SCSI bus 
(FC or other methods aren't so bad).  The last thing we want to do is to 
start scanning all the currently empty slots every time a reset occurs.

Nope, sorry, but this patch is a non-starter.  Interesting idea, but not 
suitable for the kernel at all.

In fact, *all* of the hot plug hardware out there has some facility for 
telling a controller exactly where it is (SES boxes can use mjacob's SES 
user space library to tell us about hot inserts, in which case we know the 
exact target id of the device inserted, and we know the host/bus from the 
host/bus that the SES itself is on, so we just scan that target by itself, 
while FC controllers can check the fiber node database and specifically 
add the new device in their tables and therefore they know where in their 
tables the device is located and consequently only need to scan that 
single device, etc).  So we don't need a "rescan the bus" facility, all we 
really need to do is allow the user space SES code to hot add devices 
(which it can actually just by using the /proc/scsi/scsi interface that 
exists, but that proc code should be cleaned up and made less race prone) 
and we then need to export the scanning functions inside scsi_scan.c so 
that low level device drivers can, when notified of a new device on the 
fabric loop for example, have an approved method by which they call into 
the scsi scan code and trigger a scan of a specific target location (or 
conversely they should be able to call in and tell the mid layer that a 
device has disappeared if they so desire).  That's the correct way to 
handle this stuff IMNSHO.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
