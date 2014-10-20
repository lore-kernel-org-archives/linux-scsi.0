From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv7 00/27] scsi logging update (the boring part)
Date: Mon, 20 Oct 2014 08:52:03 +0200
Message-ID: <1413787950-14659-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbaJTGwd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2014 02:52:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

here is now the seventh iteration of my scsi logging update.
With this I've included another patch for ratelimiting
I/O error messages, which resolves the outstanding issue
noted by Robert Elliot.

Hannes Reinecke (27):
  Remove scsi_cmd_print_sense_hdr()
  sd: Remove scsi_print_sense() in sd_done()
  aha152x: Debug output update and whitespace cleanup
  scsi: introduce sdev_prefix_printk()
  scsi: Use sdev as argument for sense code printing
  acornscsi: use scsi_print_command()
  fas216: Return DID_ERROR for incomplete data transfer
  fas216: Update logging messages
  53c700: remove scsi_print_sense() usage
  scsi: stop decoding if scsi_normalize_sense() fails
  scsi: do not decode sense extras
  scsi: use 'bool' as return value for scsi_normalize_sense()
  scsi: remove scsi_print_status()
  Implement scsi_opcode_sa_name
  scsi: merge print_opcode_name()
  scsi: consolidate opcode lookup in scsi_opcode_sa_name()
  scsi: repurpose the last argument from print_opcode_name()
  scsi: Remove scsi_print_command when calling abort
  scsi: separate out scsi_(host|driver)byte_string()
  sd: Cleanup logging
  scsi: simplify scsi_log_(send|completion)
  scsi: fixup logging messages in scsi_error.c
  scsi: use shost argument in scsi_eh_prt_fail_stats
  scsi_error: document scsi_try_to_abort_cmd
  scsi: check for correct return code in scsi_eh_abort_cmds()
  scsi: correct return values for .eh_abort_handler implementations
  scsi: ratelimit I/O error messages

 drivers/scsi/53c700.c             |  13 +-
 drivers/scsi/NCR5380.c            |   7 +-
 drivers/scsi/aha152x.c            | 994 +++++++++-----------------------------
 drivers/scsi/aha1740.c            |   2 +-
 drivers/scsi/arm/acornscsi.c      |  12 +-
 drivers/scsi/arm/fas216.c         |  39 +-
 drivers/scsi/atari_NCR5380.c      |   3 +-
 drivers/scsi/ch.c                 |  29 +-
 drivers/scsi/constants.c          | 578 +++++++++-------------
 drivers/scsi/esas2r/esas2r_main.c |   2 +-
 drivers/scsi/hosts.c              |   4 +-
 drivers/scsi/megaraid.c           |   8 +-
 drivers/scsi/osst.c               |   8 +-
 drivers/scsi/ps3rom.c             |   4 -
 drivers/scsi/scsi.c               |  45 +-
 drivers/scsi/scsi_error.c         | 123 ++---
 drivers/scsi/scsi_ioctl.c         |   2 +-
 drivers/scsi/scsi_lib.c           |  29 +-
 drivers/scsi/sd.c                 |  60 +--
 drivers/scsi/sd.h                 |   6 +-
 drivers/scsi/sg.c                 |   6 +-
 drivers/scsi/sr.h                 |   3 +-
 drivers/scsi/sr_ioctl.c           |  10 +-
 drivers/scsi/st.c                 |   9 +-
 drivers/scsi/stex.c               |   9 +-
 drivers/scsi/storvsc_drv.c        |   3 +-
 drivers/scsi/sun3_NCR5380.c       |   3 +-
 include/scsi/scsi_dbg.h           |  28 +-
 include/scsi/scsi_device.h        |   9 +
 include/scsi/scsi_eh.h            |  14 +-
 30 files changed, 698 insertions(+), 1364 deletions(-)

-- 
1.8.5.2

