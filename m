Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D4CBC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F596613B0
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237016AbhD0V61 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 17:58:27 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38683 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235440AbhD0V60 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:58:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 0100420426C;
        Tue, 27 Apr 2021 23:57:41 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GeF434BTfIm9; Tue, 27 Apr 2021 23:57:37 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 816A220419E;
        Tue, 27 Apr 2021 23:57:36 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 00/45] sg: add v4 interface
Date:   Tue, 27 Apr 2021 17:56:10 -0400
Message-Id: <20210427215733.417746-2-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
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
replacements.

A recent patch to fio allows its sg engine to issue iopoll requests
by using hipri=1 in the fio script. When testing sg device nodes
with fio this option must be set: direct=0. The sync option may
be set to 0 (use sg's write/read async interface) or 1 (uses
ioctl(SG_IO) interface).

For documentation see:
    https://sg.danny.cz/sg/sg_v40.html which is mirrored at:
    https://doug-gilbert.github.io/sg_v40.html

This patchset is against Martin Petersen's 5.13/scsi-queue branch.

Changes since v17 (sent to linux-scsi list on 20210407)
  - make clearer distinction between user pollable (i.e. async)
    requests and (user) non-pollable requests (e.g. those injected
    with ioctl(SG_IO), IOWs sync requests)
  - fix crash in sg_start_req() when blk_get_request() yields an
    error (e.g. -EAGAIN when low on resources)
  - sg_finish_scsi_blk_rq(): remove now_zero variable as suggested
    by Hannes R.
  - change deprecation warning url reference from http to https

Changes since v16 (sent to linux-scsi list on 20210208)
  - sg_start_req() fix double free on error path [KASAN]
  - sg_rq_map_kern() fix uninitialized variable [coverity]
  - sg_add_sfp() fix use after free [coverity]
  - sg_remove_sfp_usercontext(): remove pointless NULL check [coverity]
  - fix misuse of WARN_ONCE in sg_rq_end_io_usercontext() [D. Carpenter]
  - remove unused error checks: tracking blk_put_request() calls and
    multiple SG_XA_RQ_FREE calls
  - hipri: as blk_poll() can return > 0 for requests other than the one
    that is being checked for, need to re-check that request is ready
  - rebased on MKP's 5.13/scsi-queue

Changes since v15 (sent to linux-scsi list on 20210125)
  - tweak state machine which sets INFLIGHT state _before_
    blk_execute_rq_nowait() is called. Add a bit flag that indicates
    the logic flow has returned from that call. This guards against
    blk_poll() being called before the block layer has really
    launched the request.
  - fix bug clearing SG_FFD_HIPRI_SEEN bit as
    atomic_dec_and_test() returns true when the post-decrement value
    is zero, the opposite of what a C conditional does.

Changes since v14 (sent to linux-scsi list on 20210124)
  - two fixes based on report from Dan Carpenter and kernel test
    robot
  - fix Johannes Thumshirn's email address
  - separate patch issued on fio to add 'hipri' option to its sg
    engine. Enables fio to test new sg driver blk_poll() support

Changes since v13 (sent to linux-scsi list on 20210113)
  - fix obscure compile error reported by "kernel test robot
    <lkp@intel.com>"
  - harden code around blk_poll() invocation; needed based on
    fio testing
  - remove SG_FFD_MMAP_CALLED bit code after Hannes Reinecke pointed
    out it was redundant

Changes since v12 (sent to linux-scsi list on 20201115)
  - add blk_poll() support, prefix that patch's subject with 'RFC'

Changes since v11 (sent to linux-scsi list on 20201014)
  - no author originated changes since v11
  - port from lk 5.9.0-rc1 to lk 5.10.0-rc1 picks up a change to
    the import_iovec() which requires a change to patch 25/44
  - only publish this cover letter and v12 of patch 25/44 to
    the linux-scsi list. The other 43 patches remain as published
    on 20201014.

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

Changes since v8 to v1 in earlier patchsets
  - see: the v10 patchset sent to linux-scsi on 20200823

Douglas Gilbert (45):
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
  sg: add blk_poll support
  sg: bump version to 4.0.12

 drivers/scsi/sg.c      | 5409 +++++++++++++++++++++++++++-------------
 include/scsi/sg.h      |  273 +-
 include/uapi/scsi/sg.h |  375 +++
 3 files changed, 4116 insertions(+), 1941 deletions(-)
 create mode 100644 include/uapi/scsi/sg.h

-- 
2.25.1

