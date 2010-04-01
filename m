From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: [PATCH 0/2 v4] scsi: ftrace based scsi tracer
Date: Thu, 01 Apr 2010 20:37:02 +0900
Message-ID: <4BB4855E.7030509@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46474 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab0DALhr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2010 07:37:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Frederic
Cc: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>

Hi,

This is v4 patch series of SCSI trace.  Only a cosmetic change
from v3.

Because it's been a while since the first posting, I'll put brief
descriptions of the patchset.

  Basically, this is a ftrace based SCSI tracer.  It prints the
  following information for scsi-3 commands.

    o scsi bus number ("host")
    o scsi channel number ("channel")
    o scsi id ("id")
    o LUN ("lun")
    o command info
      - op name (ex. "WRITE_10")
      - LBA ("lba") (for certain commands only)
      - transfer length ("txlen") (for certain commands only)
      - CDB (ex. "raw=28 00 03 60 a2 cb 00 00 08 00")
    o result of the command
      (ex. "result=(driver=DRIVER_OK host=DID_OK
message=COMMAND_COMPLETE status=SAM_STAT_GOOD")

  Those information are printed either at a time:

    o when a command is to be dispatched,
    o when a command dispatched returns in error,
    o when a command is done,
    o when an error handler is to waken up, or
    o when timeout of a command is deteced.

  To use it quickly, try these steps:

    1) Build a kernel with the patchset applied
       (ftrace related kernel configs need to be enabled.)
    2) Boot the kernel
    3) Mount debugfs
       ex. mount -t debugfs none /sys/kernel/debug/
    4) Indicate events to trace
       ex. echo "scsi:*" > /sys/kernel/debug/tracing/set_event
    5) Make some I/Os on your scsi devices
       ex. ls
    6) Retrieve trace log
       ex. cat /sys/kernel/debug/tracing/trace

  Here is an outputs example:

    # tracer: nop
    #
    #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
    #              | |       |          |         |
           flush-8:0-3746  [001]  1374.517152:
scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=0
cmnd=(WRITE_10 lba=32267539 txlen=8 raw=2a 00 01 ec 5d 13 00 00
08 00)
              <idle>-0     [000]  1374.524964:
scsi_dispatch_cmd_done: host_no=0 channel=0 id=0 lun=0
cmnd=(WRITE_10 lba=32267539 txlen=8 raw=2a 00 01 ec 5d 13 00 00
08 00) result=(driver=DRIVER_OK host=DID_OK
message=COMMAND_COMPLETE status=SAM_STAT_GOOD)

This patchset applies to 2.6.34-rc3.

Thanks,
Kei

