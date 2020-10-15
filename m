Return-Path: <SRS0=rjNM=DW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 350E4C433E7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 02:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3F1322258
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 02:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgJOCGx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Oct 2020 22:06:53 -0400
Received: from smtp.infotech.no ([82.134.31.41]:40061 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgJOCGx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Oct 2020 22:06:53 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 13A0D20425B;
        Thu, 15 Oct 2020 04:06:52 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5UbUWy0M0hbw; Thu, 15 Oct 2020 04:06:45 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id 68B6520414F;
        Thu, 15 Oct 2020 04:06:44 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v11 00/44] sg: add v4 interface
Date:   Wed, 14 Oct 2020 22:05:59 -0400
Message-Id: <20201015020643.432908-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset is the first stage of a two stage rewrite of the scsi
generic (sg) driver. The main goal of the first stage is to introduce
the sg v4 interface that uses 'struct sg_io_v4' as well as keeping and
modernizing the sg v3 interface (based on 'struct sg_io_hdr'). The
async interface formerly requiring the use of write() and read()
system calls now have ioctl(SG_IOSUBMIT) and ioctl(SG_IORECEIVE)
replacements. See:
    http://sg.danny.cz/sg/sg_v40.html
for more details. If accessing http pages is a problem, a temporary
rendering of this page can be found here:
    https://doug-gilbert.github.io/sg_v40.html

This patchset is against Martin Petersen's 5.10/scsi-queue branch.

Changes since v10 (sent to linux-scsi list on 20200823)
  - unchanged: 0001 to 0009, 0010 to 0017
  - rename sg_add_req() to sg_setup_req() [0010]
  - patches 40,41,42 and 43 are new, see their commit messages
  - remove SG_RS_RCV_DONE request state leaving 3.5 states
    [the 0.5 state is SG_RS_BUSY]
  - rework sg_rq_chg_state() code that enforces request
    state changes and associated xarray marks
  - track lowest used and unused indexes in the request arrays so
    iterations over the request xarray are efficient. This is a
    significant saving when the iodepth queue length is large

Changes since v9 (sent to linux-scsi list on 20200421)
  - rebase on MKP's 5.10/scsi-queue branch
  - remove some master/slave terminology that had bled in from
    the part 2 patchset
  - change sg_request::start_ns type from ktime_t to u64
  - pick up several error path correction fixes applied to the
    sg driver by other authors

Changes since v8 (sent to linux-scsi list on 20200301)
  - add new patch to ignore the /proc/scsi/sg/allow_dio setting.
    Now direct IO will be attempted whenever the SG_FLAG_DIRECT_IO
    flag is given
  - add new patch to track mmap_sz from previous mmap() call.
    Allows catching mmap-ed requests that exceed that value
  - change warning about using the v3 interface with the write()
    system call from WARN_ONCE() to pr_warn_once()
  - remove __KERNEL__ conditionals in include/scsi/sg.h
  - change struct sg_fd::start_ns from u64 to ktime_t type
  - introduce a new small sg_rq_state_mul2arr array to avoid
    a multiplication at runtime in the state machine engine
  - tweak mempool introduced in v7 for sense buffers
  - rework sg_mk_sgat() to better handle low memory situations;
    similar work on sg_remove_sgat_helper()

Changes since v7 (sent to linux-scsi list on 20200227)
  - improve direct IO code, remove the SG_FRQ_DIO_IN_USE
    sg_request::frq_bm flag as it is no longer needed
  - simplify state changing code. Many state changes (rq_st) do not
    need changes to the xarray "marks"; only lock those that do
    (reviewer queried the locking)
  - remove some misplaced likely()/unlikely() macros. They are gathered
    together in a separate patch (in a second patchset)
  - change a cast that the kbuild robot complained about. It also
    flagged a stack size problem in sg_ioctl_common() for reasons not
    given nor obvious. That function (and its parents) declare only
    simple scalars on the stack.
  - add 'Reviewed-by' where appropriate

Changes since v6 (sent to linux-scsi list on 20200112)
  - based on Martin Petersen's 5.7/scsi-queue branch in his
    linux-scsi repository
  - major work on mmap support: when mmap(2) is used the reserve
    request scatter gather list is rebuilt to have order=0
    elements (i.e. each is PAGE_SIZE bytes).
  - address one kbuild robot issue: add include defining size_t
  - nearly all patches that have been reviewed have been changed,
    usually in minor ways. Those patches have "***" before the
    "Reviewed-by" line.


Changes since v5 to v1 in earlier patchsets
  - for example: the v10 patchset sent to linux-scsi on 20200823

Douglas Gilbert (44):
  sg: move functions around
  sg: remove typedefs, type+formatting cleanup
  sg: sg_log and is_enabled
  sg: rework sg_poll(), minor changes
  sg: bitops in sg_device
  sg: make open count an atomic
  sg: move header to uapi section
  sg: speed sg_poll and sg_get_num_waiting
  sg: sg_allow_if_err_recovery and renames
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
  sg: xarray for fds in device
  sg: xarray for reqs in fd
  sg: replace rq array with xarray
  sg: sense buffer rework
  sg: add sg v4 interface support
  sg: rework debug info
  sg: add 8 byte SCSI LUN to sg_scsi_id
  sg: expand sg_comm_wr_t
  sg: add sg_iosubmit_v3 and sg_ioreceive_v3 ioctls
  sg: add some __must_hold macros
  sg: move procfs objects to avoid forward decls
  sg: protect multiple receivers
  sg: first debugfs support
  sg: rework mmap support
  sg: defang allow_dio
  sg: warn v3 write system call users
  sg: add mmap_sz tracking
  sg: remove rcv_done request state
  sg: track lowest inactive and await indexes
  sg: remove unit attention check for device changed
  sg: no_dxfer: move to/from kernel buffers
  sg: bump version to 4.0.11

 drivers/scsi/sg.c      | 5317 +++++++++++++++++++++++++++-------------
 include/scsi/sg.h      |  273 +--
 include/uapi/scsi/sg.h |  374 +++
 3 files changed, 4032 insertions(+), 1932 deletions(-)
 create mode 100644 include/uapi/scsi/sg.h

-- 
2.25.1

