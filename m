Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E44C0C433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 20:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B597264F69
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 20:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237929AbhCDUjS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 15:39:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237421AbhCDUjG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Mar 2021 15:39:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0145264F69;
        Thu,  4 Mar 2021 20:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614890305;
        bh=q1dX3Hi+OwK+jYFTQTAsaP1ihODfw930XsDaWm5dqCk=;
        h=Date:From:To:Cc:Subject:From;
        b=iXjAKh4kh9nXEnJYsCIoam/Nx7mQLfyWx8AB/8VPht5OpDleaPdgcQpEMmHfqLevF
         TRsrVRp8n6z9XkWyZkNlxpcRFfJKDv43yLz3h+UKzcSaMMbQrLlBO1oEkU/ib5MLsb
         8Meo5eryjTSaSzfGJ2ozBr6f7K4FTt992hlE3aYsMhpEcuyKVpAADI6Z6js+AYdIYz
         tQaVED4gDDEYZPDUjuDOugE/YpU0ZiDcHhkH1smVdi1FWxmVBrpNdVwzut4p+FA4An
         +Dkxo6ZAk4BD9nH6vo3El791U6bHD22DImvdaAavNH7iXGvsW73B+zbmcePS0l3VMq
         8a7g89yCKpY6Q==
Date:   Thu, 4 Mar 2021 14:38:22 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] scsi: aacraid: Replace one-element array with
 flexible-array member
Message-ID: <20210304203822.GA102218@embeddedor>
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
struct_size() and flex_array_size() helpers.

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
 drivers/scsi/aacraid/aachba.c  | 13 +++++++------
 drivers/scsi/aacraid/aacraid.h |  2 +-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 4ca5e13a26a6..0f5617e40b94 100644
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
@@ -4003,7 +4003,7 @@ static int aac_convert_sgraw2(struct aac_raw_io2 *rio2, int pages, int nseg, int
 	if (aac_convert_sgl == 0)
 		return 0;
 
-	sge = kmalloc_array(nseg_new, sizeof(struct sge_ieee1212), GFP_ATOMIC);
+	sge = kmalloc_array(nseg_new, sizeof(*sge), GFP_ATOMIC);
 	if (sge == NULL)
 		return -ENOMEM;
 
@@ -4020,7 +4020,8 @@ static int aac_convert_sgraw2(struct aac_raw_io2 *rio2, int pages, int nseg, int
 		}
 	}
 	sge[pos] = rio2->sge[nseg-1];
-	memcpy(&rio2->sge[1], &sge[1], (nseg_new-1)*sizeof(struct sge_ieee1212));
+	memcpy(&rio2->sge[1], &sge[1],
+	       flex_array_size(rio2, sge, nseg_new - 1));
 
 	kfree(sge);
 	rio2->sgeCnt = cpu_to_le32(nseg_new);
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

