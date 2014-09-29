From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 00/38] scsi logging update
Date: Mon, 29 Sep 2014 13:58:29 +0200
Message-ID: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbaI2L7L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Hi all,

here's the third version of my scsi logging updates.
Main (and most important) difference to the previous
patchset is that the stacksize does not increase when
printing SCSI CDBs, so the objection from hch should
be resolved with this.

To achieve this I've split up vprintk_emit() into two
functions, the original vprintk_emit() which formats
the string into an on-stack buffer and printk_emit_string()
which just ships out a pre-formatted string.
With that printk_emit_string() doesn't need to allocate
a buffer on stack, and I can use this reduced stack
usage to provide my own on-stack buffer, thereby using
the same stack size as the original version.

Unfortunately I've had to modify kernel/printk/printk.c,
but then printk_emit_string() looks as if it'd be useful
for others, too, so with a bit of luck I'll get away with it.

I've been using the (not yet released) patchset from
Steven Rostedt for moving seq_buf into lib; but he promised
me to send it upstream shortly. If that poses a problem it's
fairly straightforward to move it to scnprintf() etc.

And I've included tons of suggestions from Robert Elliott;
thanks for this.

As usual, comments and reviews are welcome.

Hannes Reinecke (36):
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
  tracing: Add trace_seq_buffer_ptr() helper function
  Rearrange buffer formatting in printk()
  Externalize string buffer for printk
  Introduce dev_printk_string() and dev_printk_header()
  scsi: Use real functions for logging
  scsi: log request tag for scmd_printk()
  scsi: use external buffer for command logging
  libata: use __scsi_print_command()
  scsi: Remove command pointer argument from logging messages
  scsi: use seq_buf for formatting sense buffer
  scsi: use seq_buf for formatting scsi_print_result()
  scsi: Conditionally compile in constants.c
  scsi_error: document scsi_try_to_abort_cmd

Steven Rostedt (Red Hat) (2):
  tracing: Create seq_buf layer in trace_seq
  seq_buf: Move the seq_buf code to lib/

 arch/x86/kvm/mmutrace.h              |   2 +-
 drivers/ata/libata-eh.c              |  12 +-
 drivers/base/core.c                  |  24 +
 drivers/firmware/efi/cper.c          |   2 +-
 drivers/scsi/53c700.c                |  13 +-
 drivers/scsi/Makefile                |   6 +-
 drivers/scsi/NCR5380.c               |   5 +-
 drivers/scsi/aha152x.c               | 994 ++++++++---------------------------
 drivers/scsi/arm/acornscsi.c         |  12 +-
 drivers/scsi/arm/fas216.c            |  41 +-
 drivers/scsi/atari_NCR5380.c         |   3 +-
 drivers/scsi/ch.c                    |  11 +-
 drivers/scsi/constants.c             | 533 ++++---------------
 drivers/scsi/hosts.c                 |   4 +-
 drivers/scsi/osst.c                  |   8 +-
 drivers/scsi/ps3rom.c                |   4 -
 drivers/scsi/scsi.c                  |  45 +-
 drivers/scsi/scsi_error.c            | 151 +++---
 drivers/scsi/scsi_ioctl.c            |   2 +-
 drivers/scsi/scsi_lib.c              |  22 +-
 drivers/scsi/scsi_logging.c          | 308 +++++++++++
 drivers/scsi/scsi_trace.c            |  16 +
 drivers/scsi/sd.c                    |  52 +-
 drivers/scsi/sd.h                    |   7 +-
 drivers/scsi/sg.c                    |   6 +-
 drivers/scsi/sr.h                    |   3 +-
 drivers/scsi/sr_ioctl.c              |  19 +-
 drivers/scsi/st.c                    |   9 +-
 drivers/scsi/stex.c                  |   9 +-
 drivers/scsi/storvsc_drv.c           |   3 +-
 drivers/scsi/sun3_NCR5380.c          |   3 +-
 include/linux/device.h               |  12 +
 include/linux/printk.h               |   5 +
 include/linux/seq_buf.h              |  58 ++
 include/linux/trace_seq.h            |  10 +-
 include/scsi/scsi.h                  |   3 +
 include/scsi/scsi_dbg.h              |  71 ++-
 include/scsi/scsi_device.h           |  19 +-
 include/scsi/scsi_eh.h               |  14 +-
 include/trace/events/scsi.h          |  31 ++
 kernel/printk/printk.c               |  47 +-
 kernel/trace/trace.c                 |  39 +-
 kernel/trace/trace_events.c          |   6 +-
 kernel/trace/trace_functions_graph.c |   6 +-
 kernel/trace/trace_seq.c             | 184 ++++---
 lib/Makefile                         |   2 +-
 lib/seq_buf.c                        | 348 ++++++++++++
 lib/trace_seq.c                      | 303 +++++++++++
 48 files changed, 1862 insertions(+), 1625 deletions(-)
 create mode 100644 drivers/scsi/scsi_logging.c
 create mode 100644 include/linux/seq_buf.h
 create mode 100644 lib/seq_buf.c
 create mode 100644 lib/trace_seq.c

-- 
1.8.5.2

