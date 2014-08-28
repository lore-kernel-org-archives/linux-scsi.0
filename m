From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/22] scsi logging update
Date: Thu, 28 Aug 2014 19:33:14 +0200
Message-ID: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbaH1Rdj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

Hi all,

here's my next round of scsi logging updates.
Main feature is the update to have all logging
statements in one line so that they won't be broken
up even under high load.
This will dramatically improve debugging.

Additionally all printk() statements are moved
to dev_printk() variants to ensure proper device
tagging and keep the systemd journal happy.

To achieve this I had to use a on-stack
buffer for formatting opcodes and sense codes;
so the stack usage will increase somewhat.

Reviews, comments etc are welcome.

Hannes Reinecke (22):
  Remove scsi_cmd_print_sense_hdr()
  aha152x: Remove #ifdef 0 section
  sd: Remove scsi_print_sense() in sd_done()
  scsi: introduce sdev_prefix_printk()
  scsi: Use sdev as argument for sense code printing
  scsi: stop decoding if scsi_normalize_sense() fails
  scsi: do not decode sense extras
  scsi: dump sense buffer only for debugging
  Use sdev as argument for scsi_print_result
  scsi: consolidate scsi_print_status()
  Implement scsi_opcode_sa_name
  scsi: remove obsolete __scsi_print_command() usages
  scsi: use local buffer for printing the opcode
  scsi: pass in string buffer to __scsi_print_command()
  scsi: use dev_printk() variants in scsi_print_command()
  libata: use __scsi_print_command()
  scsi: print disposition in scsi_print_result()
  scsi_error: format abort error message
  scsi: use local buffer for scsi_log_(send|completion)
  scsi: align logging messages
  scsi: reduce messages for command failure
  sd: Reduce logging output

 drivers/ata/libata-eh.c       |  12 +-
 drivers/scsi/53c700.c         |   3 +-
 drivers/scsi/aha152x.c        |  32 +--
 drivers/scsi/arm/acornscsi.c  |   9 +-
 drivers/scsi/arm/fas216.c     |  30 +--
 drivers/scsi/ch.c             |   7 +-
 drivers/scsi/constants.c      | 570 ++++++++++++++++++++----------------------
 drivers/scsi/osst.c           |   8 +-
 drivers/scsi/scsi.c           |  65 ++---
 drivers/scsi/scsi_error.c     |  68 ++---
 drivers/scsi/scsi_ioctl.c     |   2 +-
 drivers/scsi/scsi_lib.c       |  10 +-
 drivers/scsi/sd.c             |  28 ++-
 drivers/scsi/sg.c             |   9 +-
 drivers/scsi/sr_ioctl.c       |  16 +-
 drivers/scsi/st.c             |  13 +-
 drivers/scsi/storvsc_drv.c    |   3 +-
 include/scsi/scsi_dbg.h       |  34 +--
 include/scsi/scsi_device.h    |   5 +
 include/trace/events/scsi.h   |  17 +-
 include/trace/events/target.h |  17 +-
 21 files changed, 457 insertions(+), 501 deletions(-)

-- 
1.8.5.2

