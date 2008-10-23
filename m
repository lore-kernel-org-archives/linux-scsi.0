From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] final merge window updates for SCSI
Date: Thu, 23 Oct 2008 14:42:37 -0500
Message-ID: <1224790957.3330.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60856 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780AbYJWTml (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2008 15:42:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This lot's been through at least four days random config testing in
linux-next (I checked).  It's basically a sequence of small updates that
were all in process before the merge window opened.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Akinobu Mita (1):
      ipr: use memory_read_from_buffer()

Alan Cox (1):
      aic79xx: user visible misuse wrong SI units (not disk size!)

Alan Stern (1):
      sd: remove command-size switching code

Bernd Schubert (1):
      mptfusion: Increase scsi-timeouts, similariy to the LSI 4.x
driver.

Chandra Seetharaman (1):
      scsi_dh: Initialize path state to be passive when path is not
owned

Denys Vlasenko (3):
      aic7xxx: update *_shipped files
      aic7xxx: update .reg files
      aic7xxx: introduce "dont_generate_debug_code" keyword in aicasm
parser

FUJITA Tomonori (2):
      3w-9xxx: remove unnecessary local_irq_save/restore for scsi sg
copy API
      3w-xxxx: remove unnecessary local_irq_save/restore for scsi sg
copy API

H. Peter Anvin (2):
      sd: fix computation of the full size of the device
      lib: string_get_size(): don't hang on zero; no decimals on exact

Harvey Harrison (2):
      aic79xx: fix shadowed variables
      aic79xx: fix shadowed variables, add statics

James Bottomley (1):
      fix removable device inability to detect disk changes

Jamie Wellnitz (1):
      sd: Fix handling of NO_SENSE check condition

Julia Lawall (1):
      sun3x_esp: Convert && to ||

Kiyoshi Ueda (2):
      export busy state via q->lld_busy_fn()
      refactor sdev/starget/shost busy checking

Randy Dunlap (1):
      fix netlink kernel-doc

thomas schorpp (1):
      aic7xxx: Take the LED out of diagnostic mode on PM resume


And the diffstat:

 drivers/message/fusion/mptscsih.c                |    3 
 drivers/scsi/3w-9xxx.c                           |    3 
 drivers/scsi/3w-xxxx.c                           |    7 
 drivers/scsi/aic7xxx/aic79xx.reg                 |  185 ++
 drivers/scsi/aic7xxx/aic79xx_core.c              |   15 
 drivers/scsi/aic7xxx/aic79xx_pci.c               |   12 
 drivers/scsi/aic7xxx/aic79xx_reg.h_shipped       |  567 +------
 drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped | 1723
-----------------------
 drivers/scsi/aic7xxx/aic7xxx.reg                 |  124 +
 drivers/scsi/aic7xxx/aic7xxx_core.c              |    7 
 drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped       |  875 -----------
 drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped | 1165 ---------------
 drivers/scsi/aic7xxx/aicasm/aicasm_gram.y        |   10 
 drivers/scsi/aic7xxx/aicasm/aicasm_scan.l        |    1 
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c      |    3 
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h      |    3 
 drivers/scsi/device_handler/scsi_dh_rdac.c       |    3 
 drivers/scsi/ipr.c                               |   16 
 drivers/scsi/scsi_lib.c                          |   83 -
 drivers/scsi/scsi_netlink.c                      |    9 
 drivers/scsi/sd.c                                |   21 
 drivers/scsi/sun3x_esp.c                         |    4 
 lib/string_helpers.c                             |   34 
 23 files changed, 580 insertions(+), 4293 deletions(-)

James


