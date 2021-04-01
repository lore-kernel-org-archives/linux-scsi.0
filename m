Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B1EC43462
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 17:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9151B6137B
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 17:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbhDARpv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234611AbhDARiY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Apr 2021 13:38:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33371613CD;
        Thu,  1 Apr 2021 17:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617297649;
        bh=vvuJdzxokTaxuYnDd9Lr/maD/CXJhrGhm8gULeHd2GU=;
        h=Date:From:To:Cc:Subject:From;
        b=kqKdmkdvHLZAPshcw/MqgFez0gtfecFkLB42Uv9NV+sN7FxzzC2pwE27yorA1s18K
         Z/vH+2x+otungsAgYRQanbKCF8BrmgC4b41LNigzHKooMBj+GrVQlaYwkevCrf/nbG
         mgI8JyJda/d6AelhFqoNHg+Lnv9bKS/1vFdQijmd4go0qibSzMh/Xa+7hc6Lnki4BX
         ITJSeHPApwN1RKEgaDfXTggBVr+BJq9K7xYnQsMKjaKfwGefg20fSZeBK+NT1JCA8O
         zLkrN6xyndbMTDo51I/DA2kQNPqJp/75FcB22o+WqJQXCE/pcudruJFGU5GuaGEcdq
         vNQ3U0dysPiNw==
Date:   Thu, 1 Apr 2021 11:20:54 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] scsi: mpt3sas: Fix out-of-bounds warnings in
 _ctl_addnl_diag_query
Message-ID: <20210401162054.GA397186@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following out-of-bounds warnings by embedding existing
struct htb_rel_query into struct mpt3_addnl_diag_query, instead
of duplicating its members:

include/linux/fortify-string.h:20:29: warning: '__builtin_memcpy' offset [19, 32] from the object at 'karg' is out of the bounds of referenced subobject 'buffer_rel_condition' with type 'short unsigned int' at offset 16 [-Warray-bounds]
include/linux/fortify-string.h:22:29: warning: '__builtin_memset' offset [19, 32] from the object at 'karg' is out of the bounds of referenced subobject 'buffer_rel_condition' with type 'short unsigned int' at offset 16 [-Warray-bounds]

The problem is that the original code is trying to copy data into a
bunch of struct members adjacent to each other in a single call to
memcpy(). All those members are exactly the same contained in struct
htb_rel_query, so instead of duplicating them into struct
mpt3_addnl_diag_query, replace them with new member rel_query of
type struct htb_rel_query. So, now that this new object is introduced,
memcpy() doesn't overrun the length of &karg.buffer_rel_condition,
because the address of the new struct object _rel_query_ is used as
destination, instead. The same issue is present when calling memset(),
and it is fixed with this same approach.

Below is a comparison of struct mpt3_addnl_diag_query, before and after
this change (the size and cachelines remain the same):

$ pahole -C mpt3_addnl_diag_query drivers/scsi/mpt3sas/mpt3sas_ctl.o
struct mpt3_addnl_diag_query {
	struct mpt3_ioctl_header   hdr;                  /*     0    12 */
	uint32_t                   unique_id;            /*    12     4 */
	uint16_t                   buffer_rel_condition; /*    16     2 */
	uint16_t                   reserved1;            /*    18     2 */
	uint32_t                   trigger_type;         /*    20     4 */
	uint32_t                   trigger_info_dwords[2]; /*    24     8 */
	uint32_t                   reserved2[2];         /*    32     8 */

	/* size: 40, cachelines: 1, members: 7 */
	/* last cacheline: 40 bytes */
};

$ pahole -C mpt3_addnl_diag_query drivers/scsi/mpt3sas/mpt3sas_ctl.o
struct mpt3_addnl_diag_query {
	struct mpt3_ioctl_header   hdr;                  /*     0    12 */
	uint32_t                   unique_id;            /*    12     4 */
	struct htb_rel_query       rel_query;            /*    16    16 */
	uint32_t                   reserved2[2];         /*    32     8 */

	/* size: 40, cachelines: 1, members: 4 */
	/* last cacheline: 40 bytes */
};

Also, this helps with the ongoing efforts to globally enable
-Warray-bounds and get us closer to being able to tighten the
FORTIFY_SOURCE routines on memcpy().

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Build-tested-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/60659889.bJJILx2THu3hlpxW%25lkp@intel.com/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c |  5 ++---
 drivers/scsi/mpt3sas/mpt3sas_ctl.h | 12 ++++--------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index e7582fb8a93f..b66140e4c370 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -2507,7 +2507,7 @@ _ctl_addnl_diag_query(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		    __func__, karg.unique_id);
 		return -EPERM;
 	}
-	memset(&karg.buffer_rel_condition, 0, sizeof(struct htb_rel_query));
+	memset(&karg.rel_query, 0, sizeof(karg.rel_query));
 	if ((ioc->diag_buffer_status[buffer_type] &
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0) {
 		ioc_info(ioc, "%s: buffer_type(0x%02x) is not registered\n",
@@ -2520,8 +2520,7 @@ _ctl_addnl_diag_query(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		    __func__, buffer_type);
 		return -EPERM;
 	}
-	memcpy(&karg.buffer_rel_condition, &ioc->htb_rel,
-	    sizeof(struct  htb_rel_query));
+	memcpy(&karg.rel_query, &ioc->htb_rel, sizeof(karg.rel_query));
 out:
 	if (copy_to_user(arg, &karg, sizeof(struct mpt3_addnl_diag_query))) {
 		ioc_err(ioc, "%s: unable to write mpt3_addnl_diag_query data @ %p\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.h b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
index d2ccdafb8df2..8f6ffb40261c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
@@ -50,6 +50,8 @@
 #include <linux/miscdevice.h>
 #endif
 
+#include "mpt3sas_base.h"
+
 #ifndef MPT2SAS_MINOR
 #define MPT2SAS_MINOR		(MPT_MINOR + 1)
 #endif
@@ -436,19 +438,13 @@ struct mpt3_diag_read_buffer {
  * struct mpt3_addnl_diag_query - diagnostic buffer release reason
  * @hdr - generic header
  * @unique_id - unique id associated with this buffer.
- * @buffer_rel_condition - Release condition ioctl/sysfs/reset
- * @reserved1
- * @trigger_type - Master/Event/scsi/MPI
- * @trigger_info_dwords - Data Correspondig to trigger type
+ * @rel_query - release query.
  * @reserved2
  */
 struct mpt3_addnl_diag_query {
 	struct mpt3_ioctl_header hdr;
 	uint32_t unique_id;
-	uint16_t buffer_rel_condition;
-	uint16_t reserved1;
-	uint32_t trigger_type;
-	uint32_t trigger_info_dwords[2];
+	struct htb_rel_query rel_query;
 	uint32_t reserved2[2];
 };
 
-- 
2.27.0

