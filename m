From: Doug Ledford <dledford@redhat.com>
Subject: Why /dev/sdc1 doesn't show up...
Date: Sun, 17 Nov 2002 14:52:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117195258.GC3280@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>

Because module loading of any incestious, cross-locking modules is horked 
:-P

NOTE: I suspect the same bug applies to IDE devices as well, but you 
wouldn't see it unless you compile your IDE drivers as modules and use 
initrd or equivelant to load the modules.

Longer answer:

Device scans happen almost exclusively at either host module init time or
device module init time.  At that point in time, either the host the
device is on or the high level driver accessing the device will still be
in it's init_module() routine.  That, of course, implies that either
host->hostt->module->live is 0 or that *_template->module->live is 0 (and
consequently so is fops->owner->live == 0).  As a result, when you
register sdc with the driverfs code, it then tries to fops->open(sdc) to
read the partition table and then automatically register subdevices.  
This fails if you are currently loading sd_mod because fops->owner->live
== 0.  This fails if you are loading your low level driver because the
replacement for __MOD_INC_USE_COUNT(sdev->host->hostt->module); in
sd_open() is to instead use try_module_get(sdev->host->hostt->module) and
with the low level driver still in it's init_module() routine, this fails.

For hot plug events when the module is already live, things work fine.  
However, that doesn't help hot plug drivers at boot up because when they 
register their hot plug table they immediately get called for the devices 
that are already present, and in those cases they will have the exact same 
problem that we have with non hot plug drivers.

Hrmph...

Working on a fix.  Haven't decided how to do it yet.  Something as ugly as 
adding:

driver_template.module->live = 1;
scsi_register_host(&driver_template);
driver_template.module->live = 0;

in scsi_module.c works, but is too ugly to live (and totally defeats the
purpose of the new module loading code anyway).  Oh, and all the high
level drivers would have to do the same thing in their module init
routines in order to make things work properly when the lldd is loaded
before the high level driver.

I could make all the scsi drivers delay bus scans (via a work queue entry
that we don't wait for completion on, but I haven't figured out how to do
that without leaking mem yet, unless I write a special SCSI worker thread
that kfree()'s the work structs on completion...) until after their init
routines have finished (and do the same for the high level scsi drivers),
but that's quite a pain in the ass and doesn't fix IDE.  A generic fix
would be preferable.

Suggestions Rusty?


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
