Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7545DC11F69
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 08:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B29161360
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 08:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhF3IsH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Jun 2021 04:48:07 -0400
Received: from comms.puri.sm ([159.203.221.185]:59142 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233536AbhF3IsG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Jun 2021 04:48:06 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id D4AFBDF765;
        Wed, 30 Jun 2021 01:45:07 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0ZoC0VD6kptH; Wed, 30 Jun 2021 01:45:03 -0700 (PDT)
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     martin.kepplinger@puri.sm, bvanassche@acm.org
Cc:     jejb@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, kernel@puri.sm,
        stern@rowland.harvard.edu
Subject: [PATCH v5 0/3] fix runtime PM for SD card readers
Date:   Wed, 30 Jun 2021 10:44:50 +0200
Message-Id: <20210630084453.186764-1-martin.kepplinger@puri.sm>
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hi,

(According to Alan Stern, "as far as I know, all") SD card readers send
MEDIA_CHANGED unit attention notification on (runtime) resume. We cannot
use runtime PM with these devices as I/O always fails in that case.

This fixes runtime PM for SD cardreaders. I'd appreciate any feedback.

To enable runtime PM for an SD cardreader number 0:0:0:0, do:
    
echo 0 > /sys/module/block/parameters/events_dfl_poll_msecs
echo 1000 > /sys/bus/scsi/devices/0:0:0:0/power/autosuspend_delay_ms
echo auto > /sys/bus/scsi/devices/0:0:0:0/power/control

thank you,
                           martin

revision history
----------------
v5: (thank you Bart)
* simplify the sense request itself and remove unnecessary code

v4: (thank you Bart and Alan)
* send SENSE REQUEST in sd instead of adding a global scsi error flag.
https://lore.kernel.org/linux-scsi/20210628133412.1172068-1-martin.kepplinger@puri.sm/T/#t

v3: (thank you Bart)
 * create a new BLIST entry to mark affected devices instead of the
   sysfs module parameter for sd only. still, only sd implements handling
   the flag for now.
 * cc linux-pm list
https://lore.kernel.org/linux-scsi/20210328102531.1114535-1-martin.kepplinger@puri.sm/

v2:
https://lore.kernel.org/linux-scsi/20210112093329.3639-1-martin.kepplinger@puri.sm/
 * move module parameter to sd
 * add Documentation
v1:
https://lore.kernel.org/linux-scsi/20210111152029.28426-1-martin.kepplinger@puri.sm/T/

For the full background, the discussion started in June 2020 here:
https://lore.kernel.org/linux-scsi/20200623111018.31954-1-martin.kepplinger@puri.sm/


Martin Kepplinger (3):
  scsi: devinfo: add new flag BLIST_MEDIA_CHANGE
  scsi: sd: send REQUEST SENSE for BLIST_MEDIA_CHANGE devices in
    runtime_resume()
  scsi: devinfo: add BLIST_MEDIA_CHANGE for Ultra HS-SD/MMC usb
    cardreaders

 drivers/scsi/scsi_devinfo.c |  1 +
 drivers/scsi/sd.c           | 26 +++++++++++++++++++++++++-
 include/scsi/scsi_devinfo.h |  6 +++---
 3 files changed, 29 insertions(+), 4 deletions(-)

-- 
2.30.2

