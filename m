From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Who do we point to?
Date: Thu, 21 Aug 2008 16:14:12 +0400
Message-ID: <48AD5C14.6050508@vlnb.net>
References: <200808201911.m7KJBTik015082@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:48422 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752591AbYHUMkl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2008 08:40:41 -0400
In-Reply-To: <200808201911.m7KJBTik015082@wind.enjellic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@enjellic.com
Cc: scst-devel@lists.sourceforge.net, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, linuxraid@amcc.com, neilb@suse.de, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org

greg@enjellic.com wrote:
> Good morning hope the day is going well for everyone.
> 
> Apologies for the large broadcast domain on this.  I wanted to make
> sure everyone who may have an interest in this is involved.
> 
> Some feedback on another issue we encountered with Linux in a
> production initiator/target environment with SCST.  I'm including logs
> below from three separate systems involved in the incident.  I've gone
> through them with my team and we are currently unsure on what
> triggered all this, hence mail to everyone who may be involved.
> 
> The system involved is SCST 1.0.0.0 running on a Linux 2.6.24.7 target
> platform using the qla_isp driver module.  The target machine has two
> 9650 eight port 3Ware controller cards driving a total of 16 750
> gigabyte Seagate NearLine drives.  Firmware on the 3ware and Qlogic
> cards should all be current.  There are two identical servers in two
> geographically separated data-centers.
> 
> The drives on each platform are broken into four 3+1 RAID5 devices
> with software RAID.  Each RAID5 volume is a physical volume for an LVM
> volume group. There is currently one logical volume exported from each
> of four RAID5 volumes as a target device.  A total of four initiators
> are thus accessing the target server, each accessing different RAID5
> volumes.
> 
> The initiators are running a stock 2.6.26.2 kernel with a RHEL5
> userspace.  Access to the SAN is via a 2462 dual-port Qlogic card.
> The initiators see a block device from each of the two target servers
> through separate ports/paths.  The block devices form a software RAID1
> device (with bitmaps) which is the physical volume for an LVM volume
> group.  The production filesystem is supported by a single logical
> volume allocated from that volume group.
> 
> A drive failure occured last Sunday afternoon on one of the RAID5
> volumes.  The target kernel recognized the failure, failed the device
> and kept going.
> 
> Unfortunately three of the four initiators picked up a device failure
> which caused the SCST exported volume to be faulted out of the RAID1
> device.  One of the initiators noted an incident was occurring, issued
> a target reset and continued forward with no issues.
> 
> The initiator which got things 'right' was not accessing the RAID5
> volume on the target which experienced the error.  Two of the three
> initiators which faulted out their volumes were not accessing the
> compromised RAID5 volume.  The initiator accessing the volume faulted
> out its device.
> 
> In the logs below the 'init1' initiator was the one which did not fail
> its device.  The init2 log is an example log from the initiators which
> failed out their devices, behavior seemed to be identical on all the
> initiators which faulted their block devices.  The log labelled target
> are the log entries from the event on the SCST server.  All three
> servers from which logs were abstracted were NTP time synchronized so
> log timings are directly correlatable.
> 
> Some items to note:
> 
> ---
> The following log message from the 3Ware driver seems bogus with
> respect to the port number.  Doubtfull this has anything to do with
> the incident but may be of interest to the 3Ware people copied on this
> note:
> 
> Aug 17 17:55:16 scst-target kernel: 3w-9xxx: scsi1: AEN: ERROR (0x04:0x000A): Drive error detected:unit=2, port=-2147483646.
> 
> ---
> The initiators which received I/O errors had the Qlogic driver attempt
> a 'DEVICE RESET' which failed and was then retried.  The second reset
> attempt succeeded.
> 
> The 3Ware driver elected to reset the card at 17:55:32.  A period of
> 44 seconds elapses from that message until end_request picks up on the
> I/O error which causes the RAID5 driver to fault the affected drive.
> The initiators which failed their 'DEVICE RESET' issued their failed
> requests during this time window.
> 
> Of interest to Vlad may be the following log entry(s):
> 
> Aug 17 17:56:07 init2 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): DEVICE RESET FAILED: Task management failed.
> 
> The initiator which had its 'DEVICE RESET' succeed issued the reset
> after the above window with a timestamp identical to that of the
> end_request I/O error message on the target.

It would be good to know the reason for that reset failure. If you had 
SCST on the target built in the debug mode, we would also have an 
interesting info to think over (in this mode all the TM processing by 
SCST core is logged).

But I bet, the reason was a timeout, see below.

> ---
> Of interest to NeilB and why I copied him as well is the following.
> 
> Precisely one minute after the second attempt to reset the target
> succeeeds the kernel indicates the involved RAID1 kthread has blocked
> for more than 120 seconds.  The call trace indicates the thread was
> waiting on a RAID superblock update.
> 
> Immediately after the kernel finishes issueing the message and stack
> trace the Qlogic driver attempts to abort a SCSI command which results
> in end_request getting an I/O error which causes the device to be
> faulted from the RAID1 device.
> 
> This occurs one full minute AFTER the target RAID5 device has had its
> device evicted and is continuing in normal but degraded operation.
> ---
> 
> 
> Empirically it would seem the initiators which were 'unlucky' happened
> to issue their 'DEVICE RESET' requests while the SCST service thread
> they were assigned to was blocked waiting for the 3Ware card to reset.
> What is unclear is why the initiator I/O error was generated after the
> reset succeeded the second time, a minute after the incident was
> completely over as far as the SCST target server was concerned.
> 
> A question for Vlad.  The SCST target server is a dual-processor SMP
> box with the default value of two kernel threads active.  Would it be
> advantageous to increase this value to avoid situations like this?
> Would an appropriate metric be to have the number of active threads
> equal to the number of exported volumes or initiators?

For BLOCKIO or pass-through modes increase of the threads count beyond 
the default CPU count won't affect anything, because all the processing 
is fully asynchronous. For FILEIO you already have a bunch of dedicated 
threads per device. All the TM processing is done in the dedicated 
thread as well.

> I would be interested in any ideas the group may have.  Let me know if
> I can provide additional information or documentation on any of this.

I agree with Stanislaw Gruszka that it was purely a timeout issue. 
Qlogic driver on the initiator was more impatient than the storage stack 
on the target. The failed request before became failed was many times 
retried each time with some timeout. The sum of those timeouts was 
bigger than the corresponding command's timeout on the target + timeout 
for the reset TM command.

As the solution I can suggest to decrease retries count and commands 
failure timeout on the target. I'm recalling something like that already 
was once discussed in linux-scsi, I think it would worth for you to 
search for that thread.

MOANING MODE ON

Testing SCST and target drivers I often have to deal with various 
failures and with how initiators recover from them. And, unfortunately, 
my observations on Linux aren't very encouraging. See, for instance, 
http://marc.info/?l=linux-scsi&m=119557128825721&w=2 thread. Receiving 
from the target TASK ABORTED status isn't really a failure, it's rather 
a corner case behavior, but it leads to immediate file system errors on 
initiator and then after remount ext3 journal replay doesn't completely 
repair it, only manual e2fsck helps. Even mounting with barrier=1 
doesn't improve anything. Target can't be blamed for the failure, 
because it stayed online, all its cache fully healthy and no commands 
were lost. Hence, apparently, the journaling code in ext3 isn't as 
reliable in face of storage corner cases as it's thought. I haven't 
tried that test since I reported it, but recently I've seen the similar 
ext3 failures on 2.6.26 in other tests, so I guess the problem(s) still 
there.

A software SCSI target, like SCST, is beautiful to test things like 
that, because it allows easily simulate any possible corner case and 
storage failure. Unfortunately, I don't work on file systems level and 
can't participate in all that great testing and fixing effort. I can 
only help with setup and assistance in failures simulations.

MOANING MODE OFF

Vlad

