From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH v2 0/4] aic7xxx: fix debugging printks
Date: Fri, 04 Aug 2017 01:28:05 +0200
Message-ID: <cover.1501802726.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([91.227.64.183]:35112 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751900AbdHCX2J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Aug 2017 19:28:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

This series aims to clean up printing of card state after a problem event.
Currently, the output is pretty much unreadable, as it is spread over a lot
of single-word lines.

This series compiles (on x86), but is not tested, yet.

v2: rebased after 516b7db593 ("scsi: aic7xxx: fix firmware build with O=path")


Michał Mirosław (5):
  aic7xxx: remove empty function
  aic7xxx: fix firmware build deps
  aic7xxx: remove rules for shipped files
  aic7xxx: regenerate firmware files
  aic7[9x]xx: printk() lines unbroken

 drivers/scsi/Kconfig                             |    3 +-
 drivers/scsi/aic7xxx/Kconfig                     |    6 +
 drivers/scsi/aic7xxx/Kconfig.aic79xx             |    1 +
 drivers/scsi/aic7xxx/Kconfig.aic7xxx             |    1 +
 drivers/scsi/aic7xxx/Makefile                    |   11 +-
 drivers/scsi/aic7xxx/aic79xx.h                   |    7 -
 drivers/scsi/aic7xxx/aic79xx_core.c              |  242 ++--
 drivers/scsi/aic7xxx/aic79xx_reg.h_shipped       | 1560 +++++-----------------
 drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped |  504 +++----
 drivers/scsi/aic7xxx/aic7xxx.h                   |    7 -
 drivers/scsi/aic7xxx/aic7xxx_core.c              |  182 +--
 drivers/scsi/aic7xxx/aic7xxx_osm.c               |    5 -
 drivers/scsi/aic7xxx/aic7xxx_osm.h               |    1 -
 drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped       |  201 ++-
 drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped |  242 ++--
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c      |   39 +-
 drivers/scsi/aic7xxx/aiclib.c                    |  103 +-
 drivers/scsi/aic7xxx/aiclib.h                    |   32 +
 18 files changed, 1098 insertions(+), 2049 deletions(-)
 create mode 100644 drivers/scsi/aic7xxx/Kconfig

-- 
2.11.0
