From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 0/7] scsi: Fix transfer length 0 for 6-byte r/w commands
Date: Sat, 16 May 2015 16:17:46 +0900
Message-ID: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34750 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbbEPHSX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2015 03:18:23 -0400
Received: by pabru16 with SMTP id ru16so53513970pab.1
        for <linux-scsi@vger.kernel.org>; Sat, 16 May 2015 00:18:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Don Brace <don.brace@pmcs.com>, iss_storagedev@hp.com, storagedev@pmcs.com, Adam Radford <linuxraid@lsi.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, megaraidlinux.pdl@avagotech.com

For 6-byte r/w commands, transfer length 0 means 256 blocks of data,
not 0 block.

But some drivers consider transfer length 0 as 0 block.
Fortunately, the scsi disk driver sets up 10-byte r/w commands for
256 blocks of data instead of 6-byte r/w commands.  So this could be
an issue when SCSI commands are issued by SG_IO ioctl.

Akinobu Mita (7):
  hpsa: fix transfer length 0 for 6-byte r/w commands
  3w-xxxx: fix transfer length 0 for 6-byte r/w commands
  3w-9xxx: fix transfer length 0 for 6-byte r/w commands
  scsi: trace: fix transfer length 0 for 6-byte r/w commands
  staging: rts5208: fix transfer length 0 for 6-byte r/w commands
  megaraid_mbox: fix transfer length 0 for 6-byte r/w commands
  megaraid: fix transfer length 0 for 6-byte r/w commands

 drivers/scsi/3w-9xxx.c                | 5 ++++-
 drivers/scsi/3w-xxxx.c                | 2 ++
 drivers/scsi/hpsa.c                   | 2 ++
 drivers/scsi/megaraid.c               | 2 ++
 drivers/scsi/megaraid/megaraid_mbox.c | 2 ++
 drivers/scsi/scsi_trace.c             | 2 ++
 drivers/staging/rts5208/rtsx_scsi.c   | 8 ++++++--
 7 files changed, 20 insertions(+), 3 deletions(-)

Cc: Don Brace <don.brace@pmcs.com>
Cc: iss_storagedev@hp.com
Cc: storagedev@pmcs.com
Cc: Adam Radford <linuxraid@lsi.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Sumit Saxena <sumit.saxena@avagotech.com>
Cc: Uday Lingala <uday.lingala@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org
-- 
1.9.1

