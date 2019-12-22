Return-Path: <SRS0=BSUp=2M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E855C2D0D3
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Dec 2019 04:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A894206D3
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Dec 2019 04:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfLVD77 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Dec 2019 22:59:59 -0500
Received: from smtp.infotech.no ([82.134.31.41]:39869 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfLVD77 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 21 Dec 2019 22:59:59 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 176D8204193;
        Sun, 22 Dec 2019 04:59:54 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wJrc9Ejmv2vA; Sun, 22 Dec 2019 04:59:52 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 686FE204190;
        Sun, 22 Dec 2019 04:59:51 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [RFC 0/6] scsi_debug: random doublestore verify
Date:   Sat, 21 Dec 2019 22:59:42 -0500
Message-Id: <20191222035948.30447-1-dgilbert@interlog.com>
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

Since all scsi_debug memory stores accesses are done in the
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

---

One shortcoming of the doublestore approach is that both
stores share all the other module settings that are
held at file scope in the driver. With a little extra hacking
it is possible to have multiple scsi_debug (like) drivers
in a single kernel. That may be one way around this
shortcoming.

Douglas Gilbert (6):
  scsi_debug: randomize command completion time
  scsi_debug: add doublestore option
  scsi_debug: implement verify(10), add verify(16)
  scsi_debug: weaken rwlock around ramdisk access
  scsi_debug: improve command duration calculation
  scsi_debug: bump to version 1.89

 drivers/scsi/scsi_debug.c | 444 +++++++++++++++++++++++++++++---------
 1 file changed, 343 insertions(+), 101 deletions(-)

-- 
2.24.1

