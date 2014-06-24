From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [RFC] scsi_debug: locks and delays
Date: Tue, 24 Jun 2014 01:02:07 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B4983D@G9W0745.americas.hpqcorp.net>
References: <53A242A8.6050902@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:47559 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaFXBD5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jun 2014 21:03:57 -0400
In-Reply-To: <53A242A8.6050902@interlog.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Douglas Gilbert
> Sent: Wednesday, 18 June, 2014 8:54 PM
> To: SCSI development list
> Subject: [RFC] scsi_debug: locks and delays
> 
> Currently the scsi_debug driver wraps every queued command
> with the host_lock and every mid-level completion callback
> (apart from delay=0) with a spinlock.
> 
> Attached is a patch against Linus's tree that also applies
> to lk 3.15.1 . It attempts to address some of these issues.
> 
> ChangeLog
>    - 'host_lock' option added that simply drops that lock
>      when host_lock=0 (which is the default)
>    - allow delay=-1 [delay=1 (jiffy) is still the default]
>      that uses a tasklet to schedule the response quickly
>    - for completions (when delay!=0) the callback to the
>      mid-level is un-(spin)locked
>    - completions are counted; can be viewed with
>        cat /proc/scsi/scsi_debug/<host_num>
>    - delay_override removed from TEST UNIT READY.
>      This makes 'sg_turs -n 1m -t /dev/bsg/<hctl>' a more
>      realistic test of command overhead. I get about 100k
>      IOPS on my laptop.
> 
> This patch has been lightly tested. Perhaps someone could
> throw a scsi-mq test at it.
> 
> Comments welcome.
> 
> Doug Gilbert

This is indeed much better with scsi-mq than without scsi-mq, 
which was exhibiting 90K to 171K IOPS on various systems
when I last tried it.

Using one scsi_debug device in fake_rw mode, 4 KiB random
reads get these results:
 236K IOPS	1 thread
1081K IOPS	6 threads
1205K IOPS	6 threads, iodepth_batch=4 iodepth_batch_complete=4
1270K IOPS	6 threads, iodepth_batch=16 iodepth_batch_complete=16

Toying with a few sysfs properties:
* add_random=1 drops from 1270K to 1170K IOPS.
* nomerges=0, 1, or 2 doesn't matter. The average queue size
never exceeds 3 because they complete so fast, so there's not
much searching going on.

I created the device with:
modprobe scsi_debug fake_rw=1 delay=0 physblk_exp=3 dev_size_mb=128

fio options (adjust as needed):
$ cat 1drive_sdah.fio
[global]
direct=1
ioengine=libaio
norandommap
randrepeat=0
bs=4096
iodepth=96
numjobs=1
#numjobs=6
runtime=216000
time_based=1
group_reporting
thread
gtod_reduce=1
#iodepth_batch=4
#iodepth_batch_complete=4
cpus_allowed=0-5
cpus_allowed_policy=split
rw=randread

[4_KiB_RR_drive_ah]
filename=/dev/sdah


---
Rob Elliott    HP Server Storage



