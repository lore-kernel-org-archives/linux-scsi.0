From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 0/9] scsi logging update: the real thing
Date: Thu,  8 Jan 2015 07:43:41 +0100
Message-ID: <1420699430-9492-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbbAHGoL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2015 01:44:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

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

Thanks go to Stephen Rostedt who suffered my annoying questions
during LPC.

Changes to v3:
- Update to scsi-for-3.20 tree
- Drop upstreamed patches

Changes to v2:
- Include reviews and suggestions from Robert Elliott

Hannes Reinecke (9):
  scsi: Implement per-cpu logging buffer
  scsi: log request tag for scmd_printk()
  scsi: use external buffer for command logging
  libata: use __scsi_format_command()
  scsi: use per-cpu buffer for formatting sense
  scsi: use per-cpu buffer for formatting scsi_print_result()
  scsi: Conditionally compile in constants.c
  scsi: Do not display buffer pointers in scsi_log_send()
  scsi_error: do not display kernel pointer in message logs

 drivers/ata/libata-eh.c     |  17 +-
 drivers/scsi/Kconfig        |   4 +-
 drivers/scsi/Makefile       |   6 +-
 drivers/scsi/ch.c           |   6 +-
 drivers/scsi/constants.c    | 247 +---------------------
 drivers/scsi/scsi.c         |  11 +-
 drivers/scsi/scsi_error.c   |  49 ++---
 drivers/scsi/scsi_logging.c | 489 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c           |   7 +-
 drivers/scsi/sr_ioctl.c     |  13 +-
 drivers/scsi/ufs/ufshcd.c   |   6 +-
 drivers/xen/xen-scsiback.c  |   1 +
 include/scsi/scsi.h         |   3 +
 include/scsi/scsi_dbg.h     |  74 ++++++-
 include/scsi/scsi_device.h  |  21 +-
 15 files changed, 624 insertions(+), 330 deletions(-)
 create mode 100644 drivers/scsi/scsi_logging.c

-- 
1.8.4.5

