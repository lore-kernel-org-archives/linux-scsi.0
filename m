From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Fw: 2.5.65 panic in remove_proc_entry() while trying to rmmod
Date: Sat, 22 Mar 2003 21:20:23 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E7C46F7.4030604@torque.net>
References: <20030321164855.598090d7.akpm@digeo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: linux-scsi@vger.kernel.org

Andrew Morton wrote:
> Looks like removal on the scsi_deubg module causes some
> /proc entries to be removed twice.
> 
> 
> Begin forwarded message:
> 
> Date: Fri, 21 Mar 2003 10:36:35 -0800
> From: Badari Pulavarty <pbadari@us.ibm.com>
> To: linux-kernel@vger.kernel.org
> Cc: andrew <akpm@digeo.com>
> Subject: 2.5.65 panic in remove_proc_entry() while trying to rmmod
> 
> 
> Hi,
> 
> I get following panic while playing with scsi_debug.
> Any ideas on how to fix this ?

Andrew,
The scsi_debug driver doesn't do any procfs handling directly,
rather it uses scsi_register() and scsi_unregister()
[defined in the mid level] which seem to correctly
call helper functions in scsi_proc.c . This procfs
handling is in common with all other scsi LLDs.

Mike Anderson and I have been aware of two oops
scenarios with scsi_debug for about the last 10
versions of lk 2.5 . They are:
   1) a modprobe, rmmod, modprobe [scsi_debug] sequence
      oopses [in sysfs] on the second modprobe. A reason
      may be that the rmmod fails to remove the
      /sys/class/scsi-host and the /sys/bus/scsi subdirectories
      for the hosts and devices added by the first modprobe.
      This is 100% repeatable.
   2) rarely rmmod fails with the procfs oops reported.
      This typically happens on very large pseudo disk
      allocations by scsi_debug.

I traced scsi_debug's calls to sdebug_driver_probe()
and sdebug_driver_remove() that are wired into the
struct device_driver instance for scsi_debug and
they looked sane and balanced. [It wouldn't oops for
me but it has in the past.]

Doug Gilbert

