Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0832EC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 23:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDFC164F54
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 23:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhBBXwG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 18:52:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230128AbhBBXwD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Feb 2021 18:52:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6F5964E38;
        Tue,  2 Feb 2021 23:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612309881;
        bh=bqlmAkMhKva2byst9LEVKv4NYTOjwULo7/hJYHFBF14=;
        h=Date:From:To:Cc:Subject:From;
        b=eJvrM6PiBK2LVNDfT4u3CtMm5eWGtaUNYimeH0yG1PazE22rtGpB8Fn68q+UaUAUh
         U9nvuCIU0rr3FhWzcpgUVwWPnQ0IYUKb7nNo1OiAfu6X1cmKzDuOAdZ/dpRq5ySm8I
         hjnmKsb6Alk5wZd7umxAEyu3Ef76h01lC1wTTHDJ8tSn2YoGmOvZF/Ej5CJBeQdbZt
         8HUOf/v/qafG8O5MsWmHQCgdiehKIH8TsKXTzVOEBNs7EdXj2gcUr/UH4eTDgDpX9k
         suyhGTtJWAXJl27j5rfmgdAhQBGK6w/OeCqR8cj+j13HHlT3aWaBluImagQgmgkLJb
         jgIFxErjTVubg==
Date:   Tue, 2 Feb 2021 17:51:18 -0600
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
Subject: [PATCH v2][next] scsi: mpt3sas: Replace one-element array with
 flexible-array in struct _MPI2_CONFIG_PAGE_IO_UNIT_3
Message-ID: <20210202235118.GA314410@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code according to the use of a flexible-array member in
struct _MPI2_CONFIG_PAGE_IO_UNIT_3, instead of a one-element array,
and use the struct_size() helper to calculate the size for the
allocation.

Also, this helps the ongoing efforts to enable -Warray-bounds and fix the
following warnings:

drivers/scsi/mpt3sas/mpt3sas_ctl.c:3193:63: warning: array subscript 24
is above array bounds of ‘U16[1]’ {aka ‘short unsigned int[1]’}
[-Warray-bounds]

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.9/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - Fix format specifier: use %zu for size_t type.

 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 11 +----------
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |  6 +++---
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 43a3bf8ff428..908b0ca63204 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -987,21 +987,12 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_1 {
 
 /*IO Unit Page 3 */
 
-/*
- *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
- *one and check the value returned for GPIOCount at runtime.
- */
-#ifndef MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX
-#define MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX    (1)
-#endif
-
 typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_3 {
 	MPI2_CONFIG_PAGE_HEADER Header;			 /*0x00 */
 	U8                      GPIOCount;		 /*0x04 */
 	U8                      Reserved1;		 /*0x05 */
 	U16                     Reserved2;		 /*0x06 */
-	U16
-		GPIOVal[MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX];/*0x08 */
+	U16			GPIOVal[];		 /*0x08 */
 } MPI2_CONFIG_PAGE_IO_UNIT_3,
 	*PTR_MPI2_CONFIG_PAGE_IO_UNIT_3,
 	Mpi2IOUnitPage3_t, *pMpi2IOUnitPage3_t;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index c8a0ce18f2c5..ffb21f873058 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3143,7 +3143,7 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	Mpi2ConfigReply_t mpi_reply;
 	u16 backup_rail_monitor_status = 0;
 	u16 ioc_status;
-	int sz;
+	size_t sz;
 	ssize_t rc = 0;
 
 	if (!ioc->is_warpdrive) {
@@ -3157,11 +3157,11 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 		goto out;
 
 	/* allocate upto GPIOVal 36 entries */
-	sz = offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);
+	sz = struct_size(io_unit_pg3, GPIOVal, 36);
 	io_unit_pg3 = kzalloc(sz, GFP_KERNEL);
 	if (!io_unit_pg3) {
 		rc = -ENOMEM;
-		ioc_err(ioc, "%s: failed allocating memory for iounit_pg3: (%d) bytes\n",
+		ioc_err(ioc, "%s: failed allocating memory for iounit_pg3: (%zu) bytes\n",
 			__func__, sz);
 		goto out;
 	}
-- 
2.27.0

