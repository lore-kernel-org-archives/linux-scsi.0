From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 0/7] scsi: Some seq_file cleanups/optimizations
Date: Sat, 29 Nov 2014 01:34:11 +0100
Message-ID: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:45895 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaK2Aeh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Nov 2014 19:34:37 -0500
Received: by mail-la0-f44.google.com with SMTP id ge10so6308749lab.31
        for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2014 16:34:36 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

These patches mostly replace seq_printf with simpler and faster
equivalents, e.g. seq_printf(m, "something") => seq_puts(m,
"something") and seq_printf(m, "\n") => seq_putc(m, '\n). But before
my Coccinelle scripts could be unleashed I had to clean up some
unnecessary, and in the PRINTP case quite obfuscating, macros.

The patches don't change the semantics of the code (well, that's the
idea anyway), but should make it slightly smaller and faster.

Rasmus Villemoes (7):
  scsi: Remove SPRINTF macro
  scsi/g_NCR5380: Remove obfuscating macros
  scsi/advansys: Replace seq_printf with seq_puts
  scsi/aha152x: Replace seq_printf with seq_puts
  scsi: misc:  Replace seq_printf with seq_puts
  scsi: misc: Merge consecutive seq_puts calls
  scsi: misc: Print single-character strings with seq_putc

 drivers/scsi/BusLogic.c             |  10 +-
 drivers/scsi/NCR5380.c              |  42 +++--
 drivers/scsi/advansys.c             | 145 ++++++++---------
 drivers/scsi/aha152x.c              | 301 ++++++++++++++++++------------------
 drivers/scsi/aic7xxx/aic79xx_proc.c |  38 +++--
 drivers/scsi/aic7xxx/aic7xxx_proc.c |  24 +--
 drivers/scsi/arm/fas216.c           |   6 +-
 drivers/scsi/atari_NCR5380.c        |   4 +-
 drivers/scsi/atp870u.c              |   5 +-
 drivers/scsi/dc395x.c               |  78 +++++-----
 drivers/scsi/dpt_i2o.c              |   2 +-
 drivers/scsi/eata_pio.c             |   2 +-
 drivers/scsi/esas2r/esas2r_main.c   |   2 +-
 drivers/scsi/g_NCR5380.c            |  66 ++++----
 drivers/scsi/gdth_proc.c            |  24 +--
 drivers/scsi/in2000.c               |  18 +--
 drivers/scsi/ips.c                  |   7 +-
 drivers/scsi/megaraid.c             |   2 +-
 drivers/scsi/nsp32.c                |  41 +++--
 drivers/scsi/pcmcia/nsp_cs.c        |  50 +++---
 drivers/scsi/qla2xxx/qla_dfs.c      |   8 +-
 drivers/scsi/scsi_proc.c            |  22 +--
 drivers/scsi/scsi_trace.c           |   6 +-
 drivers/scsi/sun3_NCR5380.c         |   4 +-
 drivers/scsi/wd33c93.c              |  18 +--
 drivers/scsi/wd7000.c               |  41 +++--
 26 files changed, 460 insertions(+), 506 deletions(-)

-- 
2.0.4

