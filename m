From: Daniel Stekloff <dsteklof@us.ibm.com>
Subject: Re: [RFC] scsi_device printk helper macro - sdev_printk -> with patch
Date: Tue, 30 Sep 2003 05:27:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200309300527.19429.dsteklof@us.ibm.com>
References: <200309291413.51987.dsteklof@us.ibm.com> <3F79740C.5020007@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:4294 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261686AbTI3T0E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2003 15:26:04 -0400
In-Reply-To: <3F79740C.5020007@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, Larry Kessler <lkessler@us.ibm.com>, James Keniston <kenistoj@us.ibm.com>


Hi Doug,


On Tuesday 30 September 2003 05:16 am, Douglas Gilbert wrote:
> Daniel Stekloff wrote:
> > The purpose of the sdev_printk macro, which is intended for the scsi
> > mid-layer and LLDs, is to help with the following:
> >
> > - Adding consistency to printk messages in mid-layer and LLDs where
> > scsi_device is concerned. Scsi_device information will be printed in the
> > same consistent format. A consistent format will help readability and
> > provide a means to automate responding to log messages.
> >
> > - Identifing a printk with a specific scsi_device.
> >
> > - Providing one point for changing what identification information is
> > printed. Instead of having to edit every single printk, one could simply
> > change the macro.
> >
> > The patch below does a couple things:
> >
> > 1) Moves setting scsi_device's sdev_gendev struct device bus_id from
> > scsi_sysfs.c to scsi_scan.c.
> >
> > 2) Adds sdev_printk definition to scsi_device.h
> >
> > 3) Replaces many printks in the mid-layer with sdev_printk.
> >
> > Please take a look, all comments and suggestions are welcome.
>
> Dan,
> Looks great.
> We have a fair amount of scsi command and sense decode logic **
> laying idle in drivers/scsi/constants.[hc] that might enhance
> the output further.


The scsi command logic in constants.c shouldn't be included in sdev_printk 
because sdev_printk could be used in a non-scsi command context. 

We could, however, add sdev_printk to constants.c in the print_Scsi_Cmnd 
function. People who wanted the prefix could use print_Scsi_Cmnd while 
others, concerned with multi-lined printks, could still use print_command. 
And, we could use the wrapper function to print out other scsi_cmnd 
information that's important at that point.

**We could also change the name from print_Scsi_Cmnd to print_sdev_cmnd or 
print_scsi_cmnd, etc.

Example Patch:
-----------------

--- linux-2.6.0-test6/drivers/scsi/constants.c	2003-09-27 17:50:38.000000000 
-0700
+++ linux-2.6.0-test6-sdev/drivers/scsi/constants.c	2003-09-30 
11:48:03.816671824 -0700
@@ -1115,11 +1115,7 @@
 }
 
 void print_Scsi_Cmnd(struct scsi_cmnd *cmd) {
-    printk("scsi%d : destination target %d, lun %d\n", 
-	   cmd->device->host->host_no, 
-	   cmd->device->id, 
-	   cmd->device->lun);
-    printk("        command = ");
+    sdev_printk(KERN_INFO, cmd->device, "command = ");
     print_command(cmd->cmnd);
 }
 



> Perhaps while we are at it, we could make a more useful logging
> mechanism in the scsi subsystem (rather than, or in addition to,
> 'echo "scsi log ..." > /proc/scsi/scsi'). Putting a
> read/write "log" variable in the /sys/class/scsi_device/*/device
> directory would allow per device logging. [Obviously struct
> scsi_device would get a new "log" member, initialized to 0.]


Just curious - is there an interest in having by scsi device logging, rather 
than setting the logging level now by subsystem?


> This does not cover the debugging or logging of a device
> scan. In this case scsi_device::log could be inherited from
> somewhere. Since the device might be the first one seen by the
> first host, that "somewhere" would need to be be the scsi mid
> level. Currently the scsi mid level doesn't have a sysfs
> presence. It is obviously a module and also has a pseudo
> device at /proc/scsi/scsi. Any suggestions where a scsi
> mid level device/driver directory could go in sysfs? Such
> a directory could contain scan, timeout and retry parameters
> as well as a "next_device_log" type entry.


Honestly, I wouldn't know exactly where to put a mid-layer representation in 
sysfs. Will think about it. 

Thanks,

Dan

> ** Sense buffer decoding should be centralized, especially
> since SPC3 has a new (more sane) "descriptor sense data
> format" [SPC-3 rev 15 section 4.5.2 at www.t10.org].
>
> Doug Gilbert
>
>
>
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

