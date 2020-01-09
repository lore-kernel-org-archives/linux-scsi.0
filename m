Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E65C32771
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 08:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2511520848
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 08:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgAIIam (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 03:30:42 -0500
Received: from smtp.infotech.no ([82.134.31.41]:33878 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbgAIIam (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Jan 2020 03:30:42 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 762AB204192;
        Thu,  9 Jan 2020 09:30:40 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3EFgyByKerwp; Thu,  9 Jan 2020 09:30:40 +0100 (CET)
Received: from xtwo70.infotech.no (unknown [82.134.31.177])
        by smtp.infotech.no (Postfix) with ESMTPA id 46A70204148;
        Thu,  9 Jan 2020 09:30:40 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [RFC v2 0/6] scsi_debug: random doublestore verify
Date:   Thu,  9 Jan 2020 09:30:33 +0100
Message-Id: <20200109083039.16582-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset contains various measures to improve the speed and
usefulness of this driver. It has been used to test the rewrite
of the SCSI generic (sg) driver which is still underway.

Disk to disk copies are the test of choice by the author. Some
testing has been done using real hard disks and SSDs but the
bulk of the testing has been done using this driver as both the
source and destination of the copy. SSDs have two shortcomings:
they are not as fast as the manufacturers would like users to
believe with an average latency to READ at around 100
microseconds; the second problem is "endurance". Endurance is
a wear-out factor based on the number of WRITEs to the SSD.
One would hope both these measures will improve in the future.

The author found that precise command duration timing gave a
false impression of how "bulletproof" the sg driver state
machines and locking was. The first patch involving randomizing
the command durations and it did expose various issues in the
driver under test (sg). The next issue was the correctness of
the bulk copies being done. The doublestore and verify patches
allow the copies to be verified and it demonstrated at least
one area of concern for the sg driver.

Since all scsi_debug memory store accesses are done in the
context of queuecommand() call, the *_irqsave() and
*_irqrestore() variants of the associated locks have been
removed.  That could be a problem if queuecommand() can ever
be called form an interrupt or related context.

Finally to address the discrepancy between command duration
times seen by the sg driver compared to what was set with
this driver's ndelay option, this driver's timekeeping for
short durations was made more accurate.

This patchset is against Martin Petersen's git repository
and its 5.6/scsi-queue branch.

Changes since v1:
  - testing with version 1 caused several strange crashes that
    turned out to be caused by a code trick to read in the
    data-out buffer but _not_ place it in the big fake_storep
    array. This approach failed badly when multiple threads
    were doing verifies at the same time.
  - replace the code trick with a new do_dout_fetch() function
  - since the code trick was borrowed from the COMPARE AND
    WRITE implementation [resp_comp_write()] using
    do_dout_fetch() fixes the same bug in the existing driver
    which hasn't been reported (yet).

Douglas Gilbert (6):
  scsi_debug: randomize command completion time
  scsi_debug: add doublestore option
  scsi_debug: implement verify(10), add verify(16)
  scsi_debug: weaken rwlock around ramdisk access
  scsi_debug: improve command duration calculation
  scsi_debug: bump to version 1.89

 drivers/scsi/scsi_debug.c | 442 +++++++++++++++++++++++++++++---------
 1 file changed, 340 insertions(+), 102 deletions(-)

-- 
2.24.1

