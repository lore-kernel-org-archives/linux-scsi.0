From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla2xxx errors? (2.6.19)
Date: Tue, 12 Jun 2007 10:48:54 -0700
Message-ID: <20070612174854.GD12266@plap.qlogic.org>
References: <20070610100011.GG5705@digitus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:44119 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbXFLRt5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2007 13:49:57 -0400
Content-Disposition: inline
In-Reply-To: <20070610100011.GG5705@digitus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Csillag Tamas <cstamas@digitus.itk.ppke.hu>
Cc: linux-scsi@vger.kernel.org

On Sun, 10 Jun 2007, Csillag Tamas wrote:

> The university I work at has 4 Blade HS20 servers connected to a IBM
> DS400 storage via Fibre Channel.
> The fibre channel module is:
> 
> 06:01.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 02)
> 06:01.1 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 02)
> 
> # lsmod
> Module                  Size  Used by
> ...
> qla2xxx               143584  1
> 
> # l /lib/firmware 
> total 244
> lrwxrwxrwx 1 root root     21 2007-05-05 22:02 ql2300_fw.bin -> ql2300_fw.bin.3.03.18
> 
> With recent kernels filesystem corruption occurs under high disk I/O.
> I have just tried 2.6.19 and I got the same, but kernel 2.6.18 and
> before looks safe.

Could you load the driver with the ql2xextended_error_logging module
parameter enabled:

	$ echo "6 4 1 7"  > /proc/sys/kernel/printk
	$ insmod qla2xxx.ko ql2xextended_error_logging=1

and forward over the resultant messages file beginning with the load
of the driver to the point at which the File-system failure occurs.

> The test I use is the following:
> I first checkout the kernel's git tree:
> # git-clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6.git
> Then
> # for i in {100..400}; do; rsync -a linux-2.6.git/ c2_$i& done
> .... waiting for finish
> # for i in {100..400}; do; rsync -a linux-2.6.git/ c3_$i& done
> .... waiting for finish
> # for i in {100..400}; do; rsync -a linux-2.6.git/ c4_$i& done
> 
> Some error messages:
> ReiserFS: warning: is_tree_node: node level 32010 does not match to the expected one 1
> ReiserFS: sdb1: warning: vs-5150: search_by_key: invalid format found in block 8093723. Fsck?
> ReiserFS: sdb1: warning: vs-13070: reiserfs_read_locked_inode: i/o failure occurred trying to find stat data of [961831 1064427 0x0 SD]

I can setup somthing similar locally, I take it you are writing
directly some some lun exported off the DS400, and not using DM?

> I am able to reproduce this errors.
> 
> With other filesystems I get similar errors.

Just curious, what are those errors?

> I suspect a bug in qla2xxx, but I am not sure.
> Can you help me how to track down this problem?

Please also provide the output of:

	$ cat /proc/scsi/scsi
	$ lspci -vvx

and your .config file.

Regards,
Andrew Vasquez
