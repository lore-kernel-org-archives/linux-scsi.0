From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv5 00/24] scsi logging update (the boring part)
Date: Wed,  1 Oct 2014 08:22:36 +0200
Message-ID: <1412144580-72880-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaJAGXH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2014 02:23:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

This is the next iteration of my scsi logging patchset.
The patchset just contains some logging updates, code
reshuffling and sanity fixes. Nothing major.

The second part of this patchset (the printk bit)
has been vetoed for the moment, so I'll have to
work on that. But in any case this patchset is
pretty much independent.

Difference to v4:
- Add 'Reviewed-by' tags from hch where applicable
- Split off the fas216 patch into two different patches
- Added a patch to document scsi_try_to_abort_cmd

Hannes Reinecke (24):
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
  scsi: remove last argument from print_opcode_name()
  scsi: Remove scsi_print_command when calling abort
  scsi: separate out scsi_(host|driver)byte_string()
  sd: Cleanup logging
  scsi: simplify scsi_log_(send|completion)
  scsi: fixup logging messages in scsi_error.c
  scsi: use shost argument in scsi_eh_prt_fail_stats
  scsi_error: document scsi_try_to_abort_cmd

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
 drivers/scsi/scsi_error.c    | 120 +++---
 drivers/scsi/scsi_ioctl.c    |   2 +-
 drivers/scsi/scsi_lib.c      |  19 +-
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
 27 files changed, 662 insertions(+), 1335 deletions(-)

-- 
1.8.5.2

