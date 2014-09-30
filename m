From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 00/23] scsi logging update (the boring part)
Date: Tue, 30 Sep 2014 13:50:29 +0200
Message-ID: <1412077852-40893-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbaI3LvE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2014 07:51:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Hi all,

after the feedback from v3 I've decided to split off the printk
changes to a second patchset, to be applied on top of this.
So this patchset just contains some logging updates, code
reshuffling and sanity fixes. Nothing major.
Most of it has already been reviewed.

Hannes Reinecke (23):
  Remove scsi_cmd_print_sense_hdr()
  sd: Remove scsi_print_sense() in sd_done()
  aha152x: Debug output update and whitespace cleanup
  scsi: introduce sdev_prefix_printk()
  scsi: Use sdev as argument for sense code printing
  acornscsi: use scsi_print_command()
  fas216: Update logging messages
  53c700: remove scsi_print_sense() usage
  scsi: stop decoding if scsi_normalize_sense() fails
  scsi: do not decode sense extras
  scsi: use 'bool' as return value for scsi_normalize_sense()
  scsi: remove scsi_print_status()
  Implement scsi_opcode_sa_name
  scsi: merge print_opcode_name()
  scsi: consolidate opcode lookup in scsi_opcode_sa_name()
  scsi: remove last argument from print_opcode_name()
  scsi: Remove scsi_print_command when calling abort
  scsi: separate out scsi_(host|driver)byte_string()
  sd: Cleanup logging
  scsi: simplify scsi_log_(send|completion)
  scsi: fixup logging messages in scsi_error.c
  scsi: use shost argument in scsi_eh_prt_fail_stats
  scsi_trace: add tracepoint for completion

 drivers/scsi/53c700.c        |  13 +-
 drivers/scsi/NCR5380.c       |   5 +-
 drivers/scsi/aha152x.c       | 994 ++++++++++---------------------------------
 drivers/scsi/arm/acornscsi.c |  12 +-
 drivers/scsi/arm/fas216.c    |  41 +-
 drivers/scsi/atari_NCR5380.c |   3 +-
 drivers/scsi/ch.c            |   5 +-
 drivers/scsi/constants.c     | 572 ++++++++++---------------
 drivers/scsi/hosts.c         |   4 +-
 drivers/scsi/osst.c          |   8 +-
 drivers/scsi/ps3rom.c        |   4 -
 drivers/scsi/scsi.c          |  45 +-
 drivers/scsi/scsi_error.c    | 100 ++---
 drivers/scsi/scsi_ioctl.c    |   2 +-
 drivers/scsi/scsi_lib.c      |  20 +-
 drivers/scsi/scsi_trace.c    |  16 +
 drivers/scsi/sd.c            |  55 +--
 drivers/scsi/sd.h            |   7 +-
 drivers/scsi/sg.c            |   6 +-
 drivers/scsi/sr.h            |   3 +-
 drivers/scsi/sr_ioctl.c      |   6 +-
 drivers/scsi/st.c            |   9 +-
 drivers/scsi/stex.c          |   9 +-
 drivers/scsi/storvsc_drv.c   |   3 +-
 drivers/scsi/sun3_NCR5380.c  |   3 +-
 include/scsi/scsi_dbg.h      |  26 +-
 include/scsi/scsi_device.h   |   9 +
 include/scsi/scsi_eh.h       |  14 +-
 include/trace/events/scsi.h  |  31 ++
 29 files changed, 693 insertions(+), 1332 deletions(-)

-- 
1.8.5.2

