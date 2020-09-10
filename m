Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A1CC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 16:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04C0620BED
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 16:01:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="f73NKbXC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731362AbgIJP7L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 11:59:11 -0400
Received: from mail3.bemta25.messagelabs.com ([195.245.230.83]:53384 "EHLO
        mail3.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731532AbgIJP5Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Sep 2020 11:57:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1599753404; i=@ts.fujitsu.com;
        bh=U/aF3FG2XAPF8wja0g7uva1BEd2AVWFCUE3pFpqh684=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=f73NKbXC1JJUK0XBq/6WzN+NUwPco5mrbs804mH0b69t6QPZdn+yu5b1G+Zy1YLdg
         fiaQCVTv+OVT7gt+82zOP73c9eZ/Z0nECUrEOjmONTbs67bMoxBMcw5Ndv/ZmiMWOn
         YhrMYKkakIhgs7byCu15/FMTPT/kge+bG+ngWQAeaijxMnySxdWW834VHAJhJQiVn8
         V8rpcPUdzZ5nAVRXbWg6DASmW9n/M9dz1IXPNc9xJGZYhGZ/XUuR4kz1Nmft0CCaQ6
         kCq0CuL+YbDTESoyenMc01hpmXWBYKI4DqQxNg79CH2Nt4GniOPHdoiveA5Ij7QihS
         vXV6e6O4QezpA==
Received: from [100.112.196.208] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-b.eu-west-1.aws.symcld.net id 6B/6E-37769-CBC4A5F5; Thu, 10 Sep 2020 15:56:44 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRWlGSWpSXmKPExsViZ8MxVXe3T1S
  8wYEXphbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjEXHlzIV
  TA2u2PuhvoHxqGsXIxeHkMBkRolL15ayQjjTGSWWPZzN1MXIycEmYCCxYtJ9FpCEiMAaRomVd
  +YxgySYBfQkpv1bxw5iCwtES0xd/x3MZhFQlTi7YBtYDa+AncSm69vBBkkIyEt0HJjMMoGRcw
  EjwypGi6SizPSMktzEzBxdQwMDXUNDI11DSwtdQ2MDvcQq3SS91FLd8tTiEl1DvcTyYr3iytz
  knBS9vNSSTYxAv6cUHGvawXjy9Qe9Q4ySHExKorwCjlHxQnxJ+SmVGYnFGfFFpTmpxYcYZTg4
  lCR4jb2AcoJFqempFWmZOcAQhElLcPAoifAqeAOleYsLEnOLM9MhUqcYjTl2Hp23iJlj89yli
  5iFWPLy81KlxHkzQCYJgJRmlObBDYLFxiVGWSlhXkYGBgYhnoLUotzMElT5V4ziHIxKwrwOIA
  t5MvNK4Pa9AjqFCeiURvlIkFNKEhFSUg1MW9MK7u5gZP2u+my2ssi7pvItSzskDkbszFyqISG
  WW//wq8rbj+XVlnWb6+MXrmQ4Ge/Muu9Y+TwGJqGK90duM/754PP00POPElV3+Z4GXGmd/5Zn
  EeODL7xS9y6IrOuas3iN8DrG6WYG7NePSET+rrzDnVzwf9e5z2vdbtzsqH+VNvsY3+MNvk1xL
  Je/rbKcu1Nhktz/3ynFfqFLi9OUdea56pf5nnpZ8Wlxw+ISyWWTVrrVniw8u5Gv5f+RO2HJ+Y
  4Pu1K7NO7dPHN9vfjDtXmLXqbY7267VMfaa/Dyw/9HlfFlqpxH89aeOtZQOz3b3vvPBaYpi7e
  dKPyn0y6uf03GMCKhMX/Oy8ADcsY6HEosxRmJhlrMRcWJAMa1cDsIAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-34.tower-285.messagelabs.com!1599753403!166260!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.60.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 14987 invoked from network); 10 Sep 2020 15:56:43 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-34.tower-285.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 10 Sep 2020 15:56:43 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 08AFugbS011013;
        Thu, 10 Sep 2020 16:56:42 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 9D7D7202FA;
        Thu, 10 Sep 2020 17:56:42 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v3] scsi: target: tcmu: add compat mode for 32bit userspace on 64bit kernel
Date:   Thu, 10 Sep 2020 17:56:40 +0200
Message-Id: <20200910155640.19324-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When using tcmu it might happen, that userspace application cannot
be built as 64 bit program even on a 64 bit host due to existing
32 bit libraries that must be used, e.g. for compression, encryption,
deduplication, ...

Currently this only works with manual changes in userspace include
file target_core_user.h due to a missing padding field in
struct tcmu_cmd_entry. Additionally one has to change uio.h because
32-bit userspace interprets struct iovec to have 8 byte size while
64-bit kernel creates it with 16 byte size.

This patch adds CONFIG_COMPAT support for X86_64 in tcmu to avoid
header file editing.

During mmap() of the command ring and data area of tcmu_dev's
uio device, tcmu checks and saves the value returned from
in_compat_syscall(). That way it allows multiple tasks to mmap()
only if they are of same type (32-/64-bit).

During SCSI command processing tcmu now creates tcmu_cmd_entry
records according to the saved type of the userspace program.

Offset and size of data fields in tcmu_cmd_entry differ between
32-bit and 64-bit only in the req part.
The field cdb_off (__u64) is on a 4-byte boundary in 32-bit, while
in 64-bit it is on the next 8-byte boundary.
The same is true for the start of the "struct iovec iov[]" array.
It also contains 8 vs. 16 byte per array entry in 32-bit vs 64-bit
mode.

Since differences are not too many, I mostly inserted changes into
existing code where necessary instead of writing a full set of
compat_* functions.

This patch is tested on x86_64.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---

This patch is made on top of Martin's 5.10/scsi-queue tree

History:

- First attempt was a PATCH RFC that didn't compile correctly in
  32-bit kernel, but in 64bit kernel only.

- The first PATCH was fixed to compile in 32bit kernel and in
  64bit kernel with and without CONFIG_COMPAT.
  Additionally I changed it to support CONFIG_COMPAT for X86_64
  only, since I wasn't able to find out what field sizes and
  offsets if struct tcmu_cmd_entry userspace programs on other
  archs would expect in compat mode.

- V2:
  Meanwhile I found out, that the compat handling in the patch
  should be fine for all ARCHes:
  * see iovec vs. compat_iovec handling in fs/io_uring.c
  * see usage of "__attribute__ ((__packed__))" in
    struct btrfs_ioctl_send_args_32 in fs/btrfs/ioctl.c
    vs. struct btrfs_ioctl_send_args in include/uapi/linux/btrfs.h
  So I re-allowed COMPAT support for all ARCHes.

- V3:
  Now the patch is based on Martin's 5.10/scsi-queue branch plus
  the following 3 patches I wrote to make code easier to
  understand and speed up command handling for READ type commands:
    scsi: target: tcmu: join tcmu_cmd_get_data_length and tcmu_cmd_get_block_cnt
    scsi: target: tcmu: optimize queue_cmd_ring
    scsi: target: tcmu: optimize scatter_data_area
  The above small series already splits off iov creation from
  scatter_data_area and simplifies it. Based on that and according
  to Mike's comment on V2, I reworked the patch to no longer have
  multi line pieces of code in #ifdef TCMU_COMPAT.
---
 drivers/target/target_core_user.c | 137 +++++++++++++++++++++++++++++++++++---
 1 file changed, 128 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 18798c5422c7..1028383a7acf 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -24,6 +24,12 @@
 #include <net/genetlink.h>
 #include <scsi/scsi_common.h>
 #include <scsi/scsi_proto.h>
+
+#if defined(CONFIG_COMPAT) && defined(CONFIG_64BIT)
+#define TCMU_COMPAT
+#include <linux/compat.h>
+#endif
+
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 #include <target/target_core_backend.h>
@@ -136,6 +142,11 @@ struct tcmu_dev {
 	uint32_t max_blocks;
 	size_t ring_size;
 
+#ifdef TCMU_COMPAT
+	bool compat;
+	bool new_open;
+#endif
+
 	struct mutex cmdr_lock;
 	struct list_head qfull_queue;
 	struct list_head tmr_queue;
@@ -197,6 +208,31 @@ struct tcmu_tmr {
 	int16_t tmr_cmd_ids[0];
 };
 
+#ifdef TCMU_COMPAT
+struct tcmu_compat_cmd_entry {
+	struct tcmu_cmd_entry_hdr hdr;
+
+	union {
+		struct {
+			__u32 iov_cnt;
+			__u32 iov_bidi_cnt;
+			__u32 iov_dif_cnt;
+			__u64 cdb_off;
+			__u64 __pad1;
+			__u64 __pad2;
+			struct compat_iovec iov[0];
+		} __packed req;
+		struct {
+			__u8 scsi_status;
+			__u8 __pad1;
+			__u16 __pad2;
+			__u32 read_len;
+			char sense_buffer[TCMU_SENSE_BUFFERSIZE];
+		} rsp;
+	};
+} __packed;
+#endif
+
 /*
  * To avoid dead lock the mutex lock order should always be:
  *
@@ -585,6 +621,26 @@ static inline void tcmu_cmd_set_block_cnts(struct tcmu_cmd *cmd)
 	}
 }
 
+#ifdef TCMU_COMPAT
+static int handle_compat_iovec(struct tcmu_dev *udev, struct iovec **iov,
+			       int prev_dbi, int dbi, int len)
+{
+	struct compat_iovec **c_iov = (struct compat_iovec **)iov;
+
+	if (dbi != prev_dbi + 1) {
+		/* dbi is not next to previous dbi, so start new iov */
+		if (prev_dbi >= 0)
+			(*c_iov)++;
+		/* write offset relative to mb_addr */
+		(*c_iov)->iov_base = (compat_uptr_t)
+				(udev->data_off + dbi * DATA_BLOCK_SIZE);
+	}
+	(*c_iov)->iov_len += len;
+
+	return dbi;
+}
+#endif
+
 static int new_block_to_iov(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 			    struct iovec **iov, int prev_dbi, int *remain)
 {
@@ -598,6 +654,10 @@ static int new_block_to_iov(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	 * The following code will gather and map the blocks to the same iovec
 	 * when the blocks are all next to each other.
 	 */
+#ifdef TCMU_COMPAT
+	if (udev->compat)
+		return handle_compat_iovec(udev, iov, prev_dbi, dbi, len);
+#endif
 	if (dbi != prev_dbi + 1) {
 		/* dbi is not next to previous dbi, so start new iov */
 		if (prev_dbi >= 0)
@@ -886,8 +946,14 @@ static int tcmu_alloc_data_space(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	return iov_cnt + ret;
 }
 
-static inline size_t tcmu_cmd_get_base_cmd_size(size_t iov_cnt)
+static inline size_t tcmu_cmd_get_base_cmd_size(struct tcmu_dev *tcmu_dev,
+						size_t iov_cnt)
 {
+#ifdef TCMU_COMPAT
+	if (tcmu_dev->compat)
+		return max(offsetof(struct tcmu_compat_cmd_entry, req.iov[iov_cnt]),
+				sizeof(struct tcmu_compat_cmd_entry));
+#endif
 	return max(offsetof(struct tcmu_cmd_entry, req.iov[iov_cnt]),
 			sizeof(struct tcmu_cmd_entry));
 }
@@ -1029,7 +1095,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	 * Must be a certain minimum size for response sense info, but
 	 * also may be larger if the iov array is large.
 	 */
-	base_command_size = tcmu_cmd_get_base_cmd_size(iov_cnt);
+	base_command_size = tcmu_cmd_get_base_cmd_size(udev, iov_cnt);
 	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
 
 	if (command_size > (udev->cmdr_size / 2)) {
@@ -1068,7 +1134,13 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 
 	/* prepare iov list and copy data to data area if necessary */
 	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
-	iov = &entry->req.iov[0];
+#ifdef TCMU_COMPAT
+	if (udev->compat)
+		iov = (struct iovec *)
+			&((struct tcmu_compat_cmd_entry *)entry)->req.iov[0];
+	else
+#endif
+		iov = &entry->req.iov[0];
 
 	if (se_cmd->data_direction == DMA_TO_DEVICE ||
 	    se_cmd->se_cmd_flags & SCF_BIDI)
@@ -1080,7 +1152,13 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 
 	/* Handle BIDI commands */
 	if (se_cmd->se_cmd_flags & SCF_BIDI) {
-		iov++;
+#ifdef TCMU_COMPAT
+		if (udev->compat)
+			iov = (struct iovec *)((struct compat_iovec *)iov + 1);
+		else
+#endif
+			iov++;
+
 		tcmu_setup_iovs(udev, tcmu_cmd, &iov, tcmu_cmd->data_len_bidi);
 		entry->req.iov_bidi_cnt = iov_bidi_cnt;
 	}
@@ -1094,7 +1172,13 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	/* All offsets relative to mb_addr, not start of entry! */
 	cdb_off = CMDR_OFF + cmd_head + base_command_size;
 	memcpy((void *) mb + cdb_off, se_cmd->t_task_cdb, scsi_command_size(se_cmd->t_task_cdb));
-	entry->req.cdb_off = cdb_off;
+#ifdef TCMU_COMPAT
+	if (udev->compat)
+		((struct tcmu_compat_cmd_entry *)entry)->req.cdb_off = cdb_off;
+	else
+#endif
+		entry->req.cdb_off = cdb_off;
+
 	tcmu_flush_dcache_range(entry, command_size);
 
 	UPDATE_HEAD(mb->cmd_head, command_size, udev->cmdr_size);
@@ -1729,6 +1813,35 @@ static const struct vm_operations_struct tcmu_vm_ops = {
 	.fault = tcmu_vma_fault,
 };
 
+#ifdef TCMU_COMPAT
+static void __tcmu_reset_ring(struct tcmu_dev *, u8);
+
+static int tcmu_mmap_compat_check(struct tcmu_dev *udev)
+{
+	mutex_lock(&udev->cmdr_lock);
+	if (udev->new_open) {
+		if (in_compat_syscall() != udev->compat) {
+			udev->compat = !udev->compat;
+			__tcmu_reset_ring(udev, 1);
+		}
+		udev->new_open = false;
+	} else if (in_compat_syscall() != udev->compat) {
+		mutex_unlock(&udev->cmdr_lock);
+		return -EINVAL;
+	}
+	mutex_unlock(&udev->cmdr_lock);
+
+	pr_debug("mmap() successful on %s, compat = %d\n", udev->name, udev->compat);
+
+	return 0;
+}
+#else
+static inline int tcmu_mmap_compat_check(struct tcmu_dev *udev)
+{
+	return 0;
+}
+#endif
+
 static int tcmu_mmap(struct uio_info *info, struct vm_area_struct *vma)
 {
 	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
@@ -1742,7 +1855,7 @@ static int tcmu_mmap(struct uio_info *info, struct vm_area_struct *vma)
 	if (vma_pages(vma) != (udev->ring_size >> PAGE_SHIFT))
 		return -EINVAL;
 
-	return 0;
+	return tcmu_mmap_compat_check(udev);
 }
 
 static int tcmu_open(struct uio_info *info, struct inode *inode)
@@ -1755,6 +1868,9 @@ static int tcmu_open(struct uio_info *info, struct inode *inode)
 
 	udev->inode = inode;
 	kref_get(&udev->kref);
+#ifdef TCMU_COMPAT
+	udev->new_open = true;
+#endif
 
 	pr_debug("open\n");
 
@@ -2209,14 +2325,12 @@ static void tcmu_block_dev(struct tcmu_dev *udev)
 	mutex_unlock(&udev->cmdr_lock);
 }
 
-static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
+static void __tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 {
 	struct tcmu_mailbox *mb;
 	struct tcmu_cmd *cmd;
 	int i;
 
-	mutex_lock(&udev->cmdr_lock);
-
 	idr_for_each_entry(&udev->commands, cmd, i) {
 		pr_debug("removing cmd %u on dev %s from ring (is expired %d)\n",
 			  cmd->cmd_id, udev->name,
@@ -2265,7 +2379,12 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 	tcmu_remove_all_queued_tmr(udev);
 
 	run_qfull_queue(udev, false);
+}
 
+static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
+{
+	mutex_lock(&udev->cmdr_lock);
+	__tcmu_reset_ring(udev, err_level);
 	mutex_unlock(&udev->cmdr_lock);
 }
 
-- 
2.12.3

