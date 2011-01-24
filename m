From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET] scsi: remove use of flush_scheduled_work()
Date: Mon, 24 Jan 2011 14:57:27 +0100
Message-ID: <1295877451-16602-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60520 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab1AXN5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2011 08:57:41 -0500
Received: by fxm20 with SMTP id 20so4042379fxm.19
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2011 05:57:40 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com

Hello,

This series updates scsi so that flush_scheduled_work(), which is
scheduled for deprecation, isn't used anymore.  It includes four
patches.

 0001-scsi-remove-flush_scheduled_work-usages.patch
 0002-scsi-pm8001-simplify-workqueue-usage.patch
 0003-fcoe-use-dedicated-workqueue-instead-of-system_wq.patch
 0004-fusion-don-t-use-flush_scheduled_work.patch

0001 converts all the easy ones.  0002-0004 do non-trivial conversions
one by one.

The patches are on top of 2.6.38-rc2.  Diffstat follows.

 drivers/message/fusion/mptscsih.c         |    1 
 drivers/message/fusion/mptspi.c           |   33 ++++++++++++++++++++++----
 drivers/scsi/NCR5380.c                    |    3 --
 drivers/scsi/arcmsr/arcmsr_hba.c          |    4 +--
 drivers/scsi/fcoe/fcoe.c                  |   25 ++++++++++++--------
 drivers/scsi/ipr.c                        |    2 -
 drivers/scsi/megaraid/megaraid_sas_base.c |    6 +---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      |    1 
 drivers/scsi/pm8001/pm8001_hwi.c          |   37 +++++++++++++-----------------
 drivers/scsi/pm8001/pm8001_init.c         |   27 ++++++++++++++-------
 drivers/scsi/pm8001/pm8001_sas.h          |   10 ++++----
 drivers/scsi/pmcraid.c                    |    2 -
 12 files changed, 92 insertions(+), 59 deletions(-)

Thanks.

--
tejun
