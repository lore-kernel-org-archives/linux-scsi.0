From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 00/10] scsi logging update: the real thing
Date: Mon, 17 Nov 2014 14:25:18 +0100
Message-ID: <1416230728-66425-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbaKQNZc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 08:25:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

this is the second part of my scsi logging update, covering
CDB and sense code printing. With this patchset CDBs and
sense code bytes will be formatted on a single line
(where possible), and prefixed with the device and command
tag.

To ensure CDBs and sense code bytes are not broken up during
printk I've implemented a per-cpu buffer for formatting
messages. One can allocate a chunk from the buffer using
scsi_log_reserve_buffer() and return it via scsi_log_release_buffer().
Both function do an implicit preempt_disable() / preempt_enable()
to ensure we're not scheduled away from that cpu whilst writing
into the buffer.

With that I've been able to clean up constants.c to remove all the
#ifdef CONFIG_SCSI_CONSTANTS statements. It'll now be compiled in
conditionally if CONFIG_SCSI_CONSTANTS is set.

Additionally I've updated the SCSI command definitions to SPC-3.

Thanks go to Stephen Rostedt who suffered my annoying questions
during LPC.

Changes to v2:
- Include reviews and suggestions from Robert Elliott

Hannes Reinecke (10):
  scsi: Rename SERVICE_ACTION_IN to SERVICE_ACTION_IN_16
  scsi: Add SPC-3 command definitions
  scsi: Implement per-cpu logging buffer
  scsi: log request tag for scmd_printk()
  scsi: use external buffer for command logging
  libata: use __scsi_format_command()
  scsi: use per-cpu buffer for formatting sense
  scsi: use per-cpu buffer for formatting scsi_print_result()
  scsi: Conditionally compile in constants.c
  scsi: Do not display buffer pointers in scsi_log_send()

 block/scsi_ioctl.c                         |   2 +-
 drivers/ata/libata-eh.c                    |  17 +-
 drivers/ata/libata-scsi.c                  |   2 +-
 drivers/block/nvme-scsi.c                  |   4 +-
 drivers/scsi/Kconfig                       |   4 +-
 drivers/scsi/Makefile                      |   6 +-
 drivers/scsi/aacraid/aachba.c              |   4 +-
 drivers/scsi/aacraid/linit.c               |   2 +-
 drivers/scsi/ch.c                          |   6 +-
 drivers/scsi/constants.c                   | 250 +--------------
 drivers/scsi/gdth.c                        |   4 +-
 drivers/scsi/scsi.c                        |  11 +-
 drivers/scsi/scsi_debug.c                  |   2 +-
 drivers/scsi/scsi_logging.c                | 489 +++++++++++++++++++++++++++++
 drivers/scsi/scsi_trace.c                  |   2 +-
 drivers/scsi/sd.c                          |   9 +-
 drivers/scsi/sr_ioctl.c                    |  13 +-
 drivers/scsi/ufs/ufshcd.c                  |   6 +-
 drivers/target/target_core_alua.c          |   2 +-
 drivers/target/target_core_pr.c            |   2 +-
 drivers/target/target_core_sbc.c           |   2 +-
 drivers/usb/gadget/legacy/tcm_usb_gadget.c |   2 +-
 drivers/xen/xen-scsiback.c                 |   1 +
 include/scsi/scsi.h                        |  15 +-
 include/scsi/scsi_dbg.h                    |  74 ++++-
 include/scsi/scsi_device.h                 |  21 +-
 include/trace/events/scsi.h                |   2 +-
 include/trace/events/target.h              |   2 +-
 tools/lib/traceevent/plugin_scsi.c         |   9 +-
 29 files changed, 636 insertions(+), 329 deletions(-)
 create mode 100644 drivers/scsi/scsi_logging.c

-- 
1.8.5.2

