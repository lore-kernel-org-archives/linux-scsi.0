From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH 00/15] Support for PMC 8081/8088/8089 controllers.
Date: Tue, 12 Feb 2013 04:23:00 -0800
Message-ID: <511A3424.70402@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:52612 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933056Ab3BLMWS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2013 07:22:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jack_wang@usish.com, Sangeetha.Gnanasekaran@pmcs.com, Vishwanath.Maram@pmcs.com, Harry.Yang@pmcs.com

James/Linux-scsi,

The following patchset provides support for PMC 8081/88/89 series of controllers.

>From 9c620d9273640b416054ba76cd267aebaf455ed2 Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Thu, 7 Feb 2013 17:03:42 +0530
Subject: [PATCH 00/15] Support for PMC 8081/8088/8089 controllers.

Support for PMC 8081/8088/8089 series of controllers. 

New data structures and hardware functionality files have been added
to support 8088/8089 controllers. The hardware specific file contains
new functionality specific to 8088/8089 controllers including support
for encryption, thermal settings, FW upgradation. Since 8081/8088/8089 
controllers are built on top of 8001 controller most of the data 
structures and functions of 8001 controller are reused.

MSI-X support for 8081/8088/8089 and many more error handling logic to
handle controller specific errors have been introduced. Functionality
to support multiple inbound and outbound queues have been added for 
8088/8089 controllers.

Fixes for 8001 driver include memory region fix, NCQ error handling logic,
WWN number retrieval for the controller. In addition new memory regions
have been introduced for FW flash. 

Sakthivel K (15):
  pm80xx: fix for memory region free
  pm80xx: Added vendor and device ids for SPCv/SPCve controllers
  pm80xx: Added and modified structures, variables and macros for
    SPCv/ve
  pm80xx: Structure and variable name update for SPC
  pm80xx: Multiple inbound/outbound queue configuration
  pm80xx: Updated common functions common for SPC and SPCv/ve
  pm80xx: MSI-X implementation for using 64 interrupts
  pm80xx: Added SPCv/ve specific hardware functionalities
  pm80xx: SPCv/ve specific changes in common files
  pm80xx: SPC new firmware changes for device id 0x8081 alone
  pm80xx: Firmware flash memory free fix, with addition of new memory  
      region for it
  pm80xx: Changed module name and debug messages update
  pm80xx: WWN Modification for PM8081/88/89 controllers
  pm80xx: NCQ error handling changes
  pm80xx: thermal, sas controller config and error handling update

 drivers/scsi/pm8001/Makefile      |    7 +-
 drivers/scsi/pm8001/pm8001_ctl.c  |   74 +-
 drivers/scsi/pm8001/pm8001_defs.h |   34 +-
 drivers/scsi/pm8001/pm8001_hwi.c  |  796 +++++---
 drivers/scsi/pm8001/pm8001_hwi.h  |    4 +-
 drivers/scsi/pm8001/pm8001_init.c | 1478 +++++++++++++-
 drivers/scsi/pm8001/pm8001_sas.c  |  105 +-
 drivers/scsi/pm8001/pm8001_sas.h  |  176 ++-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 4131 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm80xx_hwi.h  | 1524 ++++++++++++++
 10 files changed, 7937 insertions(+), 392 deletions(-)
 create mode 100644 drivers/scsi/pm8001/pm80xx_hwi.c
 create mode 100644 drivers/scsi/pm8001/pm80xx_hwi.h

-Anand

