From: Andrew Morton <akpm@osdl.org>
Subject: cdrom_ioctl() hanging in 2.6.3
Date: Sun, 22 Feb 2004 13:47:23 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040222134723.7de65a50.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:52965 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261755AbUBVVqm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Feb 2004 16:46:42 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, Frank Pieczynski <pieczy@web.de>


Gents,

apparently KDE's `k3b' command is consistently hanging when accessing a
SCSI CDROM.  See http://bugs.kde.org/show_bug.cgi?id=75553

Frank has generated a stack backtrace, below.

Is this an adaptec driver problem, or a generic thing?

Thanks.


k3b           D 000000000eb40f2f     0  1848   1811                     (NOTLB)
000001007889db78 0000000000000006 000001000268c080 ffffffff8027bb57
       000001003cc14100 0000000000000073 000001003ff9abf0 000001003cc14438
       0000010002705c00 0000000000000000
Call Trace:<ffffffff8027bb57>{ahc_linux_run_device_queue+1703}
       <ffffffff80133715>{wait_for_completion+213} <ffffffff801333a0>{default_wake_function+0}
       <ffffffff802617da>{scsi_request_fn+1034} <ffffffff801333a0>{default_wake_function+0}
       <ffffffff80241c03>{blk_do_rq+179} <ffffffff80135f00>{autoremove_wake_function+0}
       <ffffffff80242068>{sg_io+600} <ffffffff80242842>{scsi_cmd_ioctl+914}
       <ffffffff8016879d>{do_no_page+1069} <ffffffffa004b036>{:sr_mod:sr_media_change+54}
       <ffffffffa004154c>{:cdrom:media_changed+76} <ffffffff801813c6>{check_disk_change+38}
       <ffffffffa00426cd>{:cdrom:cdrom_ioctl+77} <ffffffff80181aef>{blkdev_open+47}
       <ffffffff802409f4>{blkdev_ioctl+900} <ffffffff8018d78c>{sys_ioctl+604}
       <ffffffff8010ff40>{system_call+124}

I hope this helps,
Frank
