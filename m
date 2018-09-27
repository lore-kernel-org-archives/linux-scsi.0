From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 00/10] NCR5380: Various improvements
Date: Thu, 27 Sep 2018 11:17:11 +1000
Message-ID: <cover.1538011031.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, Ondrey Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[This patch series is being re-sent unchanged due to email problems.]

This series addresses issues which became apparent when Michael Schmitz
tried to use an AztecMonster II SATA/SCSI adapter with a 5380 host.

That target seems to have some bugs which thoroughly exercise driver
error paths and EH.

The patch by Hannes Reinecke was cherry-picked from his 'eh-reset.v5'
branch.


Finn Thain (9):
  NCR5380: Reduce goto statements in NCR5380_select()
  NCR5380: Have NCR5380_select() return a bool
  NCR5380: Withhold disconnect privilege for REQUEST SENSE
  NCR5380: Use DRIVER_SENSE to indicate valid sense data
  NCR5380: Check for invalid reselection target
  NCR5380: Don't clear busy flag when abort fails
  NCR5380: Don't call dsprintk() following reselection interrupt
  NCR5380: Handle BUS FREE during reselection
  NCR5380: Check for bus reset

Hannes Reinecke (1):
  NCR5380: Clear all unissued commands on host reset

 drivers/scsi/NCR5380.c | 167 +++++++++++++++++++++++++++++--------------------
 drivers/scsi/NCR5380.h |   2 +-
 2 files changed, 101 insertions(+), 68 deletions(-)

-- 
2.16.4
