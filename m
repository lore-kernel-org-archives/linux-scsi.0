Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9F5C3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 02:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AD8A22CED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 02:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfH2C1N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Aug 2019 22:27:13 -0400
Received: from smtp.infotech.no ([82.134.31.41]:40009 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbfH2C1N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Aug 2019 22:27:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id EE69E204259;
        Thu, 29 Aug 2019 04:27:10 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wLbWcCpUYtJx; Thu, 29 Aug 2019 04:27:04 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 5475B204163;
        Thu, 29 Aug 2019 04:27:03 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, hch@infradead.org
Subject: [PATCH v4 00/22] sg: add v4 interface
Date:   Wed, 28 Aug 2019 22:26:37 -0400
Message-Id: <20190829022659.23130-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset extends the SCSI generic (sg) driver found in
lk 5.3 .  The sg driver has a version number which is visible
via ioctl(SG_GET_VERSION_NUM) and is bumped from 3.5.36 to
4.0.03 by this patchset. The additions and changes are
described in some detail in this long webpage:
    http://sg.danny.cz/sg/sg_v40.html

Most new features described in the above webpage are not
implemented in this patchset. Features that are not included are
file descriptor sharing, request sharing, multiple requests (in
one invocation) and the extended ioctl(). A later patchset may add
those features. The SG_IOSUMIT, SG_IOSUBMIT_V3, SG_IORECEIVE and
SG_IORECEIVE_V3 ioctls are added in this patchset.

Testing:
The sg3_utils package has several extensions in sg3_utils-1.45 beta
(revision 829 (see http://sg.danny.cz/sg)) to support and test the
version 4 sg driver presented in this patchset.
The new and revised testing utilities are outlined on the
same webpage as above in the second half of the section
titled: "15 Downloads and testing".

This patchset is against Martin Petersen's 5.4/scsi-queue branch.
To apply this patchset to lk 5.2 and earlier, the
ktime_get_boottime_ns() call needs to be changed back to
ktime_get_boot_ns().

Changes since v3 (sent to linux-scsi list on 20190807):
  - move __must_hold attributes into separate patch
  - move procfs and debugfs file scope definitions toward
    the end of sg.c to avoid forward declarations
  - move module_param* and MODULE_* macros to end of sg.c
  - expand debugfs support with snapshot_devs which allows
    filtering of snapshot output by sg device(s)
  - add a WARN_ONCE when write(2) is used with the sg v3
    interface. Suggest using SG_IOSUBMIT_V3 instead.
  - address more of the review comments from Hannes Reinecke
    and Christoph Hellwig
  - add various reviewed-by tags where appropriate

Changes since v2 (sent to linux-scsi list on 20190727):
  - address issues "Reported-by: kbuild test robot <lkp@intel.com>".
    The main one was to change the bsg header included to:
    include/uapi/linux/bsg.h rather than include/linux/bsg.h
  - address some of the review comments from Hannes Reinecke;
    email responses have been sent for review comments that
    did not result in code changes

Changes since v1 (sent to linux-scsi list on 20190616):
  - change ktime_get_boot_ns() to ktime_get_boottime_ns() to reflect
    kernel API change first seen in lk 5.3.0-rc1

Douglas Gilbert (22):
  sg: move functions around
  sg: remove typedefs, type+formatting cleanup
  sg: sg_log and is_enabled
  sg: rework sg_poll(), minor changes
  sg: bitops in sg_device
  sg: make open count an atomic
  sg: move header to uapi section
  sg: speed sg_poll and sg_get_num_waiting
  sg: sg_allow_if_err_recovery and renames
  sg: remove access_ok functions
  sg: replace rq array with lists
  sg: sense buffer rework
  sg: add sg v4 interface support
  sg: rework debug info
  sg: add 8 byte SCSI LUN to sg_scsi_id
  sg: expand sg_comm_wr_t
  sg: add sg_iosubmit_v3 and sg_ioreceive_v3 ioctls
  sg: add some __must_hold macros
  sg: move procfs objects to avoid forward decls
  sg: first debugfs support
  sg: warn v3 write system call users
  sg: bump version to 4.0.03

 drivers/scsi/sg.c      | 4911 +++++++++++++++++++++++++++-------------
 include/scsi/sg.h      |  268 +--
 include/uapi/scsi/sg.h |  373 +++
 3 files changed, 3675 insertions(+), 1877 deletions(-)
 create mode 100644 include/uapi/scsi/sg.h

-- 
2.23.0

