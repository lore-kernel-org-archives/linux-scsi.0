Return-Path: <SRS0=0ZI3=YB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6EC7ECE58E
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 07:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99AD92067B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 07:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbfJHHu0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Oct 2019 03:50:26 -0400
Received: from smtp.infotech.no ([82.134.31.41]:34782 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730317AbfJHHuZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Oct 2019 03:50:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id D457F2041F1;
        Tue,  8 Oct 2019 09:50:22 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dktApEPpX+fj; Tue,  8 Oct 2019 09:50:22 +0200 (CEST)
Received: from xtwo70.bingwo.ca (unknown [82.134.31.172])
        by smtp.infotech.no (Postfix) with ESMTPA id AB9FB204154;
        Tue,  8 Oct 2019 09:50:22 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v5 00/23] sg: add v4 interface
Date:   Tue,  8 Oct 2019 09:49:59 +0200
Message-Id: <20191008075022.30055-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset doesn't actually implement the sg v4 interface
but does preparatory work to reach that goal in a later
pathset. The goal of this patchset is to collect more
reviews.

A major sticking point in the last patchset seems to be the
size and complexity of this item:
    [PATCH v4 11/22] sg: replace rq array with lists
Patches 13/23 through 22/23 in this series break down some
of that complexity. Rather than implement the rest of
"[PATCH v4 11/22] sg: replace rq array with lists" now in
this patchset, the author has decided to experiment with
replacing the doubly linked lists that hold together the
sg_fd and sg_request objects with XArrays. One earlier
reviewer commented that this may be a worthwhile direction
to pursue. So while that is happening, this abridged
patchset, with more but smaller patches, is being presented.

The full patchset, currently containing 34 patches on top
of the 23 presented here, is described here:
     http://sg.danny.cz/sg/sg_v40.html
The full 57 part patchset can be downloaded soon from there.


Changes since v4 (sent to linux-scsi list on 20190829)
  - remove much of the logic in the previous patchset
    series from and including:
        [PATCH v4 11/22] sg: replace rq array with lists
    to
	[PATCH v4 22/22] sg: bump version to 4.0.03
  - bump the driver version number from 3.5.36 to 3.9.01
    [20190606] reflecting that the v4 interface has not
    been implemented (in this patchset)
  - patches 13/23 through to 22/23 reduce the complexity
    of "[PATCH v4 11/22] sg: replace rq array with lists"
    measured in KiloBytes from about 130 KB to 80 KB.
  - various changes suggested by reviewers of the v4
    patchset have been implemented
  - change all %p descriptors (mainly in SG_LOG() macros)
    to %pK so that the debug output remains useful in
    recent kernels. Evidently sys admins can selectively
    turn on pointer obfuscation on %pK as required on
    secure systems.

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


Douglas Gilbert (23):
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
  sg: improve naming
  sg: change rwlock to spinlock
  sg: ioctl handling
  sg: split sg_read
  sg: sg_common_write add structure for arguments
  sg: rework sg_vma_fault
  sg: rework sg_mmap
  sg: replace sg_allow_access
  sg: rework scatter gather handling
  sg: introduce request state machine
  sg: sg_find_srp_by_id
  sg: sg_fill_request_element
  sg: printk change %p to %pK

 drivers/scsi/sg.c      | 2843 +++++++++++++++++++++++-----------------
 include/scsi/sg.h      |  268 +---
 include/uapi/scsi/sg.h |  329 +++++
 3 files changed, 1995 insertions(+), 1445 deletions(-)
 create mode 100644 include/uapi/scsi/sg.h

-- 
2.23.0

