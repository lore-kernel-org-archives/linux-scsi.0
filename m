Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51CA1C3A59D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 03:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiJXDXD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 23:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiJXDWd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 23:22:33 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8F78AE7C
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 20:21:03 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 004242041BB;
        Mon, 24 Oct 2022 05:21:02 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mtu1uvzCrsU2; Mon, 24 Oct 2022 05:21:01 +0200 (CEST)
Received: from treten.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id C22282041AF;
        Mon, 24 Oct 2022 05:21:00 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v25 00/44]  sg: add v4 interface
Date:   Sun, 23 Oct 2022 23:20:14 -0400
Message-Id: <20221024032058.14077-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
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
system calls now has ioctl(SG_IOSUBMIT) and ioctl(SG_IORECEIVE)
replacements. The sg v4 interface is not new, it has been used by
the bsg driver since it was introduced to the kernel around 15
years ago.

For documentation see either url:
    https://sg.danny.cz/sg/sg_v40.html
    https://doug-gilbert.github.io/sg_v40.html

This driver has been tested with utilities found at:
    https://github.com/doug-gilbert/sg3_utils
specifically sgh_dd found under the testing directory. The new
statistics gathering facility can be tested with either sgstat
or 'tapestat -g' using the author's clone of the sysstat package:
    https://github.com/doug-gilbert/sysstat

This patchset is against Martin Petersen's 6.2/scsi-queue branch.

Changes since v24 (sent to linux-scsi list on 20220410)
  - refine "scsi: sg: Allow waiting for commands to complete on
    removed device" patch after discussion with author, see patch 43
  - pick up block layer changes since lk 5.19
  - point out that this patchset adds debugfs support that may
    hasten the retirement of /proc/scsi/sg/debug and friends

Changes since v21 (sent to linux-scsi list on 20211003)
  - versions 21, 22 and 23 failed under heavy load when the
    'POLLED' flag (formerly 'HIPRI') was used. It took several
    kernel cycles for driver to successfully pass that area of
    the testing code. Bug fixes in the scsi_debug driver and most
    likely the block layer issues were the probable culprits
  - rebase against lk 5.18.0-rc1
  - introduce 'struct block_device *dummy_bdev' in struct
    sg_device to circumvent the block API shut-out of char
    devices using bio_poll(). bio_poll() was formerly called
    blk_poll(). The dummy block_device object is only associated
    with a sg_device the first time a SGV4_FLAG_POLLED flag is
    set on a pass-through command. So only sg devices that
    actually use bio_poll() are burdened with carrying a
    block_device object. The dummy block_device object only holds
    parameters like the request_queue that were formerly given
    directly to blk_poll(). The NVMe pass-through will face the
    same problem if it tries to use bio_poll()

Changes since v20 (sent to linux-scsi list on 20210915)
  - apply changes requested by Damien Le Moal to
    '[PATCH v21 00/46] sg: add statistics similar to st'
    patch. Drop comp_stats option; statistics always gathered
  - fix broken usage of scsi_cmd_allowed() introduced in
    lk 5.15.0-rc1

Changes since v19 (sent to linux-scsi list on 20210523)
  - add statistics gathering similar to that found in st driver.
    The tapestat utility in the sysstat package can be used to
    display those statistics; similar arrangement for the sg
    driver. Make changes suggested by Damien Le Moal.
  - rebase on 5.16/scsi-queue branch [lk 5.15.0-rc1]
    - gendisk dependency removed
    - various other Christoph Hellwig cleanups

Changes since v18 (sent to linux-scsi list on 20210407)
  - a request queue's QUEUE_FLAG_POLL flag can be cleared via
    sysfs, overriding the ability to use blk_poll() even when the
    associated LLD allows it. Check that flag and, only when it
    is set and the sg user gives SGV4_FLAG_HIPRI, set REQ_HIPRI
    on a request.
  - simplify the functions supporting ioctl(SG_SET_RESERVED_SIZE)
  - replace blk_rq_append_bio() calls with the simpler
    blk_rq_bio_prep() calls
    [see lk: a4fe2d3afe3ce77edeadb567c0d0a8d102c6b159]
  - rebase on 5.14/scsi-queue branch [lk 5.13.0-rc1]
    - unchecked_isa_dma removed
    - BIO_MAX_PAGES renamed to BIO_MAX_VECS

Changes since v17 (sent to linux-scsi list on 20210407)
  - make clearer distinction between user pollable (i.e. async)
    requests and (user) non-pollable requests (e.g. those injected
    with ioctl(SG_IO), IOWs sync requests)
  - fix crash is sg_start_req() when blk_get_request() yields an
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

Changes since v14 and earlier
 - see: the v18 patchset sent to linux-scsi on 20210427


Douglas Gilbert (44):
  sg: move functions around
  sg: remove typedefs, type+formatting cleanup
  sg: sg_log and is_enabled
  sg: remove typedefs, type+formatting cleanup
  sg: bitops in sg_device
  sg: make open count an atomic
  sg: move header to uapi section
  sg: speed sg_poll and sg_get_num_waiting
  sg: sg_allow_if_err_recovery and renames
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
  sg: move procfs objects to avoid forward decls
  sg: protect multiple receivers
  sg: first debugfs support
  sg: rework mmap support
  sg: defang allow_dio
  sg: warn v3 write system call users
  sg: add mmap_sz tracking
  sg: track lowest inactive and await indexes
  sg: remove unit attention check for device changed
  sg: no_dxfer: move to/from kernel buffers
  sg: add bio_poll support
  sg: add statistics similar to st
  sg: rework command completion when removed device
  sg: bump version to 4.0.14

 drivers/scsi/sg.c      | 5607 ++++++++++++++++++++++++++++------------
 include/scsi/sg.h      |  301 +--
 include/uapi/scsi/sg.h |  408 +++
 3 files changed, 4358 insertions(+), 1958 deletions(-)
 create mode 100644 include/uapi/scsi/sg.h

-- 
2.37.3

