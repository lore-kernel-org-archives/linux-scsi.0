From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 00/20] scsi logging update
Date: Wed,  3 Sep 2014 12:05:55 +0200
Message-ID: <1409738775-80876-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327AbaICKGZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2014 06:06:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's the second version of my scsi logging updates.
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

This is the second iteration; in this I've included
the reviews from Christoph Hellwig and Robert Elliot.

Reviews, comments etc are welcome.

Hannes Reinecke (20):
  Remove scsi_cmd_print_sense_hdr()
  aha152x: Debug output update and whitespace cleanup
  sd: Remove scsi_print_sense() in sd_done()
  scsi: introduce sdev_prefix_printk()
  scsi: Use sdev as argument for sense code printing
  scsi: stop decoding if scsi_normalize_sense() fails
  scsi: do not decode sense extras
  scsi: use 'bool' as return value for scsi_normalize_sense()
  scsi: remove scsi_print_status()
  Implement scsi_opcode_sa_name
  scsi: Use scsi_print_command() where possible
  scsi: merge print_opcode_name()
  scsi: consolidate opcode lookup in scsi_opcode_sa_name()
  scsi: use local buffer for printing CDB
  libata: use __scsi_print_command()
  scsi: separate out scsi_retval_string()
  scsi: separate out scsi_host_hostbyte() and scsi_show_driverbyte()
  scsi: remove scsi_show_result()
  sd: Reduce logging output
  scsi_error: format abort error message

 drivers/ata/libata-eh.c      |  12 +-
 drivers/scsi/53c700.c        |   2 +-
 drivers/scsi/aha152x.c       | 950 ++++++++++---------------------------------
 drivers/scsi/arm/acornscsi.c |   9 +-
 drivers/scsi/arm/fas216.c    |  30 +-
 drivers/scsi/ch.c            |   7 +-
 drivers/scsi/constants.c     | 620 ++++++++++++----------------
 drivers/scsi/osst.c          |   8 +-
 drivers/scsi/scsi.c          |  36 +-
 drivers/scsi/scsi_error.c    |  20 +-
 drivers/scsi/scsi_ioctl.c    |   2 +-
 drivers/scsi/scsi_lib.c      |   6 +-
 drivers/scsi/sd.c            |  85 ++--
 drivers/scsi/sg.c            |   2 +-
 drivers/scsi/sr_ioctl.c      |  15 +-
 drivers/scsi/st.c            |   6 +-
 drivers/scsi/storvsc_drv.c   |   3 +-
 include/scsi/scsi_dbg.h      |  26 +-
 include/scsi/scsi_device.h   |   9 +
 include/scsi/scsi_eh.h       |  12 +-
 20 files changed, 621 insertions(+), 1239 deletions(-)

-- 
1.8.5.2

