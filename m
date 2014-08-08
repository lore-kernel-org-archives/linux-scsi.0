From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [RFC PATCH -logging 00/10] scsi/constants: Output continuous error
 messages on trace
Date: Fri, 08 Aug 2014 11:50:04 +0000
Message-ID: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45754 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaHHLuJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2014 07:50:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Christoph Hellwig <hch@lst.de>

Hi All,

This patch set introduces new traceevents in order to output continuous error
messages. Current SCSI printk messages in upstream kernel can be divided by and
mixed with other messages. Even if each error message has its device id,
sometimes we can easily be lost in mixed logs because the message's device id
is separated from it's body. To avoid it, I'd like to use traceevents to
store error messages into the ftrace or perf buuffer, because traceevents
are atomically commited to the buffer.

In this patch set, all printk messages are removed based on a local
discussion with Hannes, but I think printk messages should be kept because all
users don't enable traceevents and rsyslog can store as files.

However, if printk of logging branch is kept, the messages are duplicate and
it can induce stack overflow by using local buffer(*1).

 (*1) https://lkml.org/lkml/2014/5/20/742

So, my suggestion is follows:

1) printk
Keeps current implemntation of upstream kernel.
The messages are divided and can be mixed, but all users can check the error
messages without any settings.

2) traceevents
To get the complete messages, we can use ftrace or perf (or something on them).
Users can always understand correct messages, but they need to set up the
tracers.

This patch set is based on Hannes' logging branch:
http://git.kernel.org/cgit/linux/kernel/git/hare/scsi-devel.git/log/?h=logging

[1/10] ~  [6/10]: just cleanup for logging branch
[7/10] ~ [10/10]: introduce new traceevents

Any comments are welcome!

Thanks,
Yoshihiro YUNOMAE

---

Yoshihiro YUNOMAE (10):
      scsi/constants: Cleanup printk message in __scsi_print_sense()
      scsi/constants: Cleanup printk message in scsi_decode_sense_extras()
      scsi/constants: Cleanup printk message in __scsi_print_command()
      scsi/constants: Cleanup printk message in scsi_dump_sense_buffer()
      scsi/trace: Use macros for getting driver byte, host byte, msg byte, and status byte
      scsi/sd: Delete extra scsi_show_extd_sense() in sd_print_sense_hdr()
      scsi/trace: Use scsi_show_result trace point instead of printk
      scsi/trace: Use scsi_print_sense trace point instead of printk
      scsi/trace: Add additional sense code and additional sense code qualifier to scsi_print_sense trace point
      scsi/trace: Use scsi_print_command trace point instead of printk


 drivers/scsi/Makefile       |    2 
 drivers/scsi/constants.c    | 1543 -------------------------------------------
 drivers/scsi/scsi_trace.c   | 1484 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c           |    2 
 include/scsi/scsi.h         |    8 
 include/scsi/scsi_dbg.h     |    2 
 include/scsi/scsi_eh.h      |    7 
 include/trace/events/scsi.h |  145 ++++
 8 files changed, 1633 insertions(+), 1560 deletions(-)
 delete mode 100644 drivers/scsi/constants.c

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
