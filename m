Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A311C433E9
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 17:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0769520775
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 17:41:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="PNVQv4FR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgICRlh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 13:41:37 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.65]:41936 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726368AbgICRlf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 13:41:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1599154891; i=@ts.fujitsu.com;
        bh=4RIsLPHU4AME3Y8HW0+PEJNOcg70CDDdkhkrpylEmzo=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=PNVQv4FR5aM7VnHYQEoQPweEg+Olgf+m67haL/zs49LbIkUxraC5rYDhVtbD4Z/Q0
         QWLkJe69UV9BCXmcvOq1CQS5iZ5c1ewSEHZSLwGEnbRL6a4CP5pZKqS326JAXaD2Fd
         hj48yfsbGOYjVs02Ob8pw5zsaDhTLbWyPaC5k2/jF6Dtec71diWUMwmwMPUb3gG/X3
         xjD6nGTs+yOfO8IF95fOWxXa95gwIOGrq1pYefgNKT1mCKHQRIddyKo6rhwFtGZGfc
         SC7ASuiMsqu45qJsU0d8va69zR/wWZMQuSOS3WEnVEgkwyZj+rb20G/bZT0Wzd7nMM
         u5rOsyh2wptPA==
Received: from [100.112.196.208] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-b.eu-west-1.aws.symcld.net id 74/75-01492-ACA215F5; Thu, 03 Sep 2020 17:41:30 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRWlGSWpSXmKPExsViZ8MxRfeUVmC
  8wfQ7ChYb+zksuq/vYLNYfvwfk8XfSTdYLVqXvmVyYPWYNukUm8fHp7dYPD5vkgtgjmLNzEvK
  r0hgzdj/6AtjQWt0RedqtQbGk95djFwcQgKTGCV2LXnFDuFMZ5RoXLSYpYuRk4NNwEBixaT7L
  CAJEYG3jBJrDsxhBEkwC+hJTPu3jh3EFhaIlvh79AEriM0ioCrx5+9cZhCbV8BW4sbiZWC2hI
  C8RMeBySwTGDkXMDKsYrRIKspMzyjJTczM0TU0MNA1NDTSNbQ01zU0NtdLrNJN0kst1S1PLS7
  RNdRLLC/WK67MTc5J0ctLLdnECAyElIKjnTsYf736oHeIUZKDSUmUV0EjMF6ILyk/pTIjsTgj
  vqg0J7X4EKMMB4eSBC8rMLSEBItS01Mr0jJzgEEJk5bg4FES4WUBaeUtLkjMLc5Mh0idYtTl2
  Hl03iJmIZa8/LxUKXHeJE2gIgGQoozSPLgRsAi5xCgrJczLyMDAIMRTkFqUm1mCKv+KUZyDUU
  mYVxtkCk9mXgncpldARzABHXHGwRfkiJJEhJRUAxPf+9hnLSnOor8fPmH3ftKekM6QO1ctp2t
  5wjvVUxumzl+5u/LxiW9Ld2Rb5Mx+zPhjc8bBra61D2MyK2wnTZ58a4WmtOrL68vaWnQesGg8
  zXTi3yOzXijrnNy+DpWLSd/ZDpxb9S+679Cm8oIGZ+61by993ssYU6jzqLeEaeazHTePHT/3x
  fah8Jz0+Lj3a+f7fo/qvZrBUjY/N/W8z7rXH8we9e1+3Hmy+n/M+tX9R7eUsF0QfLDAQnbevV
  ez+lr+HnrY+VArI85AWrb5ZcvfOAHr2a/EDvt9yHZ4WpvMm1OktjNlxZJrO0XDl/0uu7/pyrp
  4zngHMcUNX5L32tlUfpkq+nPyyi0CEbeZq99tUWIpzkg01GIuKk4EAHRfGyoLAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-17.tower-291.messagelabs.com!1599154889!1591829!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 2802 invoked from network); 3 Sep 2020 17:41:30 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-17.tower-291.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 3 Sep 2020 17:41:30 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 083HfKTl014919;
        Thu, 3 Sep 2020 18:41:20 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 7FA4B204D1;
        Thu,  3 Sep 2020 19:41:20 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v2] scsi: target: tcmu: add compat mode for 32bit userspace on 64bit kernel
Date:   Thu,  3 Sep 2020 19:41:05 +0200
Message-Id: <20200903174105.4571-1-bstroesser@ts.fujitsu.com>
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
---
 drivers/target/target_core_user.c | 170 +++++++++++++++++++++++++++++++++-----
 1 file changed, 149 insertions(+), 21 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9b7592350502..5fe73e5ab5a7 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -24,6 +24,15 @@
 #include <net/genetlink.h>
 #include <scsi/scsi_common.h>
 #include <scsi/scsi_proto.h>
+
+#if defined(CONFIG_COMPAT) && defined(CONFIG_64BIT)
+#define TCMU_COMPAT
+#endif
+
+#ifdef TCMU_COMPAT
+#include <linux/compat.h>
+#endif
+
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 #include <target/target_core_backend.h>
@@ -136,6 +145,11 @@ struct tcmu_dev {
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
@@ -193,6 +207,30 @@ struct tcmu_tmr {
 	uint32_t tmr_cmd_cnt;
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
 
 /*
  * To avoid dead lock the mutex lock order should always be:
@@ -671,6 +709,26 @@ static inline size_t iov_tail(struct iovec *iov)
 	return (size_t)iov->iov_base + iov->iov_len;
 }
 
+#ifdef TCMU_COMPAT
+static inline void compat_new_iov(struct iovec **iov, int *iov_cnt)
+{
+	struct compat_iovec **c_iov = (struct compat_iovec **)iov;
+
+	if (*iov_cnt != 0)
+		(*c_iov)++;
+	(*iov_cnt)++;
+
+	memset(*c_iov, 0, sizeof(struct compat_iovec));
+}
+
+static inline size_t compat_iov_tail(struct iovec *iov)
+{
+	struct compat_iovec *c_iov = (struct compat_iovec *)iov;
+
+	return (size_t)c_iov->iov_base + c_iov->iov_len;
+}
+#endif
+
 static void scatter_data_area(struct tcmu_dev *udev,
 	struct tcmu_cmd *tcmu_cmd, struct scatterlist *data_sg,
 	unsigned int data_nents, struct iovec **iov,
@@ -705,13 +763,41 @@ static void scatter_data_area(struct tcmu_dev *udev,
 			to_offset = get_block_offset_user(udev, dbi,
 					block_remaining);
 
+			copy_bytes = min_t(size_t, sg_remaining,
+					block_remaining);
+			if (copy_data) {
+				offset = DATA_BLOCK_SIZE - block_remaining;
+				memcpy(to + offset,
+				       from + sg->length - sg_remaining,
+				       copy_bytes);
+			}
+			sg_remaining -= copy_bytes;
+			block_remaining -= copy_bytes;
+
 			/*
 			 * The following code will gather and map the blocks
 			 * to the same iovec when the blocks are all next to
 			 * each other.
 			 */
-			copy_bytes = min_t(size_t, sg_remaining,
-					block_remaining);
+#ifdef TCMU_COMPAT
+			if (udev->compat) {
+				struct compat_iovec *c_iov;
+
+				if (*iov_cnt != 0 &&
+				    to_offset == compat_iov_tail(*iov)) {
+					c_iov = (struct compat_iovec *)*iov;
+					c_iov->iov_len += copy_bytes;
+				} else {
+					compat_new_iov(iov, iov_cnt);
+					c_iov = (struct compat_iovec *)*iov;
+					c_iov->iov_base =
+						(compat_uptr_t)to_offset;
+					c_iov->iov_len = copy_bytes;
+				}
+				continue;
+			}
+#endif
+
 			if (*iov_cnt != 0 &&
 			    to_offset == iov_tail(*iov)) {
 				/*
@@ -730,16 +816,6 @@ static void scatter_data_area(struct tcmu_dev *udev,
 				(*iov)->iov_base = (void __user *)to_offset;
 				(*iov)->iov_len = copy_bytes;
 			}
-
-			if (copy_data) {
-				offset = DATA_BLOCK_SIZE - block_remaining;
-				memcpy(to + offset,
-				       from + sg->length - sg_remaining,
-				       copy_bytes);
-			}
-
-			sg_remaining -= copy_bytes;
-			block_remaining -= copy_bytes;
 		}
 		kunmap_atomic(from - sg->offset);
 	}
@@ -879,8 +955,15 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	return tcmu_get_empty_blocks(udev, cmd);
 }
 
-static inline size_t tcmu_cmd_get_base_cmd_size(size_t iov_cnt)
+static inline size_t tcmu_cmd_get_base_cmd_size(struct tcmu_dev *tcmu_dev,
+						size_t iov_cnt)
 {
+#ifdef TCMU_COMPAT
+	if (tcmu_dev->compat) {
+		return max(offsetof(struct tcmu_compat_cmd_entry, req.iov[iov_cnt]),
+				sizeof(struct tcmu_compat_cmd_entry));
+	}
+#endif
 	return max(offsetof(struct tcmu_cmd_entry, req.iov[iov_cnt]),
 			sizeof(struct tcmu_cmd_entry));
 }
@@ -1016,7 +1099,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	 * The size will be recalculated later as actually needed to save
 	 * cmd area memories.
 	 */
-	base_command_size = tcmu_cmd_get_base_cmd_size(tcmu_cmd->dbi_cnt);
+	base_command_size = tcmu_cmd_get_base_cmd_size(udev, tcmu_cmd->dbi_cnt);
 	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
 
 	if (!list_empty(&udev->qfull_queue))
@@ -1049,7 +1132,15 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 
 	/* Handle allocating space from the data area */
 	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
-	iov = &entry->req.iov[0];
+#ifdef TCMU_COMPAT
+	if (udev->compat) {
+		struct compat_iovec *c_iov;
+
+		c_iov = &((struct tcmu_compat_cmd_entry *)entry)->req.iov[0];
+		iov = (struct iovec *)c_iov;
+	} else
+#endif
+		iov = &entry->req.iov[0];
 	iov_cnt = 0;
 	copy_to_data_area = (se_cmd->data_direction == DMA_TO_DEVICE
 		|| se_cmd->se_cmd_flags & SCF_BIDI);
@@ -1061,7 +1152,12 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	/* Handle BIDI commands */
 	iov_cnt = 0;
 	if (se_cmd->se_cmd_flags & SCF_BIDI) {
-		iov++;
+#ifdef TCMU_COMPAT
+		if (udev->compat)
+			iov = (struct iovec *)((struct compat_iovec *)iov + 1);
+		else
+#endif
+			iov++;
 		scatter_data_area(udev, tcmu_cmd, se_cmd->t_bidi_data_sg,
 				  se_cmd->t_bidi_data_nents, &iov, &iov_cnt,
 				  false);
@@ -1089,7 +1185,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	 * Recalaulate the command's base size and size according
 	 * to the actual needs
 	 */
-	base_command_size = tcmu_cmd_get_base_cmd_size(entry->req.iov_cnt +
+	base_command_size = tcmu_cmd_get_base_cmd_size(udev, entry->req.iov_cnt +
 						       entry->req.iov_bidi_cnt);
 	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
 
@@ -1098,7 +1194,14 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	/* All offsets relative to mb_addr, not start of entry! */
 	cdb_off = CMDR_OFF + cmd_head + base_command_size;
 	memcpy((void *) mb + cdb_off, se_cmd->t_task_cdb, scsi_command_size(se_cmd->t_task_cdb));
-	entry->req.cdb_off = cdb_off;
+
+#ifdef TCMU_COMPAT
+	if (udev->compat)
+		((struct tcmu_compat_cmd_entry *)entry)->req.cdb_off = cdb_off;
+	else
+#endif
+		entry->req.cdb_off = cdb_off;
+
 	tcmu_flush_dcache_range(entry, command_size);
 
 	UPDATE_HEAD(mb->cmd_head, command_size, udev->cmdr_size);
@@ -1729,6 +1832,8 @@ static const struct vm_operations_struct tcmu_vm_ops = {
 	.fault = tcmu_vma_fault,
 };
 
+static void __tcmu_reset_ring(struct tcmu_dev *, u8);
+
 static int tcmu_mmap(struct uio_info *info, struct vm_area_struct *vma)
 {
 	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
@@ -1742,6 +1847,23 @@ static int tcmu_mmap(struct uio_info *info, struct vm_area_struct *vma)
 	if (vma_pages(vma) != (udev->ring_size >> PAGE_SHIFT))
 		return -EINVAL;
 
+#ifdef TCMU_COMPAT
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
+#endif
+
 	return 0;
 }
 
@@ -1752,6 +1874,9 @@ static int tcmu_open(struct uio_info *info, struct inode *inode)
 	/* O_EXCL not supported for char devs, so fake it? */
 	if (test_and_set_bit(TCMU_DEV_BIT_OPEN, &udev->flags))
 		return -EBUSY;
+#ifdef TCMU_COMPAT
+	udev->new_open = true;
+#endif
 
 	udev->inode = inode;
 	kref_get(&udev->kref);
@@ -2209,14 +2334,12 @@ static void tcmu_block_dev(struct tcmu_dev *udev)
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
@@ -2265,7 +2388,12 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
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

