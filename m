Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D8BAC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 18:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 573E861459
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 18:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245331AbhDUS4Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 14:56:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245327AbhDUS4Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 14:56:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52F4661264;
        Wed, 21 Apr 2021 18:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619031351;
        bh=Rpf9EV6lcFhlHOby4l6rUlq8CdkLZ1ihMEKI8ZupP3c=;
        h=Date:From:To:Cc:Subject:From;
        b=iewTMmCaI7rtZ+QF/QkPnhPis8rEycMdibHBJRU9HUYnl6RHRRnnFklzPTX/LpPXZ
         n8NmpfMNV1NErOL52eDsLYMK4yjcNJm2ubfCsKkkYAHrAogv+uVBuqtlHXgtfnk0NJ
         TO99mkAI28/QZwSGGky5WiJ02+xhGoFzZswO4YDkF/x3Lab4jKFfWmWeLTk/DA7axK
         cPspMMD/zhRIr1Xnd7l62eTNqgiTQkv91fC/wSaaFuLJAGK9JBLDWgNdfUgun2uiEs
         pewR770aifYR7dJQQ2Sd1rb5Hr1tfeZLMHJ4esGQTrSl+nxAIIkrg+UKNvy8eETxLF
         9xhJdzzdLmTyA==
Date:   Wed, 21 Apr 2021 13:56:11 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH v3][next] scsi: aacraid: Replace one-element array with
 flexible-array member
Message-ID: <20210421185611.GA105224@embeddedor>
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
struct aac_raw_io2 instead of one-element array, and use the
struct_size() helper.

Also, this helps with the ongoing efforts to enable -Warray-bounds by
fixing the following warnings:

drivers/scsi/aacraid/aachba.c: In function ‘aac_build_sgraw2’:
drivers/scsi/aacraid/aachba.c:3970:18: warning: array subscript 1 is above array bounds of ‘struct sge_ieee1212[1]’ [-Warray-bounds]
 3970 |     if (rio2->sge[j].length % (i*PAGE_SIZE)) {
      |         ~~~~~~~~~^~~
drivers/scsi/aacraid/aachba.c:3974:27: warning: array subscript 1 is above array bounds of ‘struct sge_ieee1212[1]’ [-Warray-bounds]
 3974 |     nseg_new += (rio2->sge[j].length / (i*PAGE_SIZE));
      |                  ~~~~~~~~~^~~
drivers/scsi/aacraid/aachba.c:4011:28: warning: array subscript 1 is above array bounds of ‘struct sge_ieee1212[1]’ [-Warray-bounds]
 4011 |   for (j = 0; j < rio2->sge[i].length / (pages * PAGE_SIZE); ++j) {
      |                   ~~~~~~~~~^~~
drivers/scsi/aacraid/aachba.c:4012:24: warning: array subscript 1 is above array bounds of ‘struct sge_ieee1212[1]’ [-Warray-bounds]
 4012 |    addr_low = rio2->sge[i].addrLow + j * pages * PAGE_SIZE;
      |               ~~~~~~~~~^~~
drivers/scsi/aacraid/aachba.c:4014:33: warning: array subscript 1 is above array bounds of ‘struct sge_ieee1212[1]’ [-Warray-bounds]
 4014 |    sge[pos].addrHigh = rio2->sge[i].addrHigh;
      |                        ~~~~~~~~~^~~
drivers/scsi/aacraid/aachba.c:4015:28: warning: array subscript 1 is above array bounds of ‘struct sge_ieee1212[1]’ [-Warray-bounds]
 4015 |    if (addr_low < rio2->sge[i].addrLow)
      |                   ~~~~~~~~~^~~

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.9/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Build-tested-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/60414244.ur4%2FkI+fBF1ohKZs%25lkp@intel.com/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v3:
 - Use (nseg_new-1)*sizeof(struct sge_ieee1212) to calculate
   size in call to memcpy() in order to avoid any confusion.

Changes in v2:
 - Add code comment for clarification.

 drivers/scsi/aacraid/aachba.c  | 10 +++++-----
 drivers/scsi/aacraid/aacraid.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index f1f62b5da8b7..46b8dffce2dd 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1235,8 +1235,8 @@ static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
 		if (ret < 0)
 			return ret;
 		command = ContainerRawIo2;
-		fibsize = sizeof(struct aac_raw_io2) +
-			((le32_to_cpu(readcmd2->sgeCnt)-1) * sizeof(struct sge_ieee1212));
+		fibsize = struct_size(readcmd2, sge,
+				     le32_to_cpu(readcmd2->sgeCnt));
 	} else {
 		struct aac_raw_io *readcmd;
 		readcmd = (struct aac_raw_io *) fib_data(fib);
@@ -1366,8 +1366,8 @@ static int aac_write_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
 		if (ret < 0)
 			return ret;
 		command = ContainerRawIo2;
-		fibsize = sizeof(struct aac_raw_io2) +
-			((le32_to_cpu(writecmd2->sgeCnt)-1) * sizeof(struct sge_ieee1212));
+		fibsize = struct_size(writecmd2, sge,
+				      le32_to_cpu(writecmd2->sgeCnt));
 	} else {
 		struct aac_raw_io *writecmd;
 		writecmd = (struct aac_raw_io *) fib_data(fib);
@@ -3998,7 +3998,7 @@ static int aac_convert_sgraw2(struct aac_raw_io2 *rio2, int pages, int nseg, int
 	if (aac_convert_sgl == 0)
 		return 0;
 
-	sge = kmalloc_array(nseg_new, sizeof(struct sge_ieee1212), GFP_ATOMIC);
+	sge = kmalloc_array(nseg_new, sizeof(*sge), GFP_ATOMIC);
 	if (sge == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index e3e4ecbea726..3733df77bc65 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1929,7 +1929,7 @@ struct aac_raw_io2 {
 	u8		bpComplete;	/* reserved for F/W use */
 	u8		sgeFirstIndex;	/* reserved for F/W use */
 	u8		unused[4];
-	struct sge_ieee1212	sge[1];
+	struct sge_ieee1212	sge[];
 };
 
 #define CT_FLUSH_CACHE 129
-- 
2.27.0

