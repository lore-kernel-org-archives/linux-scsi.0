Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8B01A00DF;
	Thu, 11 Jul 2024 21:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720735060; cv=none; b=ZR86CSsU1dKUZ11u90Wh8pbVLJyGIQ1wdL6vQCU/dpuQxvxm9k8e/thVN1zHJ1DbxGjLGdsYnQZR1yyZp3wJ0EzFC5bl+qBB0hkh97KXB9aJQsJ5DhLxjhNZuJlgmezaMhhLV9Cjo5VDCKy2x0o3taRwrjCEs8rCEN/zfhgcy2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720735060; c=relaxed/simple;
	bh=1IRXyi/lRo/A/NE66PocxoxjSzmZ7a9GKAafH7Rhuqw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GqbVjE5yBALXROaEScQcxABXlGRY5rO4CjZOQyBw3yMysnmSSX3GoBC2Qejn1k1P4zSEW//lPRHVla2HX+P5I+b5D5Pl8RCD/gLUgd5p/OY0iu9ijCScqIadIaaqnZzJCT/NxtRPlg+AecCXc+GmXN1EMIbRCuiY2HuSDj7L3io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHrbjRov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHrbjRov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B69C4AF0A;
	Thu, 11 Jul 2024 21:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720735060;
	bh=1IRXyi/lRo/A/NE66PocxoxjSzmZ7a9GKAafH7Rhuqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHrbjRovV4DVToZfDdEVJ6P5myNFcdRn0MRsz3AL9XYYikhAIW30CVkM+mf+H4yOL
	 WkukyXiCao+VIWt7F8jkmnFY7tpjLA3GYOxhgH7AusLYUN2vkAC9VcCZxX8u+0QCh1
	 tx94Cfb6ehIuj6LJL38VwTnk8mQ8UmX+6+KhqfK1wSXgS1ue6nnCZrFkwc0HIxFLVy
	 +lzRMmkqx/9lrOKeIKwfizj4688KXCozvd3ycmrtKU/K37cM1zMVtHaaT7Sh2WuIYK
	 lp1F8TwjObJUGQwE0V0xqyFNHrCCyCDQCCm2Cejj3K8BX3Rn/DUYCUxOk+vH6Y6tAA
	 lHjnJI5IjPyNQ==
From: Kees Cook <kees@kernel.org>
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: Kees Cook <kees@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH 2/2] scsi: aacraid: struct {user,}sgmap{,64,raw}: Replace 1-element arrays with flexible arrays
Date: Thu, 11 Jul 2024 14:57:38 -0700
Message-Id: <20240711215739.208776-2-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240711212732.work.162-kees@kernel.org>
References: <20240711212732.work.162-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9550; i=kees@kernel.org; h=from:subject; bh=1IRXyi/lRo/A/NE66PocxoxjSzmZ7a9GKAafH7Rhuqw=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkFVSeO4OotIy2yFPrJ/hgkBtbPuoG4qpqHP2L Kgy6aEbcheJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpBVUgAKCRCJcvTf3G3A JnrXD/9G+frfTQSSE61nke4ZgullMSsS6L3uZzDaWk0ypajZMtlEeqmm/Ry0Dbo1BcoaQfVsqK6 0GUatVu9Cx4GHVB4usGeyUQj6xEYt+Sd6fMGkbadiaVG0jmOpEfER1bYDaxdtsr5HoQLvariaM4 oMonYR50nZ9n0SMiFg3cQbd2vZ5GZg9stJbRHWLuxUJr+t1GDFPQTKNKPXugZ5PEli0gku0Nz2F pxRtOpJ2fBlVqWbVSqtItlh/jSK8fQASKo1hh/0XpO02KbVy2lmj3jtL3y5luARmGwoWkOQf5Yl C/Lou4e9QhT51dE8fWj4nEoIwH2g+cpoGyx+4mOeSwZBUygzJgPkHmL9+OXy+r0wBPttUnvhec5 CueDAyCKOEBcqh2g2osr6vLvUT7ERKEd4f5E6JEU9L+Magv3PD5E7CSDkO3MCiYiO1WwtfQYbMe x7Fz/IS9k7fWgaeLdUWaWAdbhVXAF5fp8G2N40nzhHcR3rHvVw/SVFdJdgRulmr3DFM6xY/Efxa 94D4pGC2ChxE8Mbm6rf1PwchAjUNgb7OcQc224fNNkVS8zeaCRXc0xyjZY/+a692vpjjYtyPyQe yD/pv1Jvr6B6JHCk4XxKB/+SOIMGNwHvrfKJuDs6vkH4FXW01jNliryWg9X+3QBXa3hz5Nri9kc B8FvBM+dvlwMfVw==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] use of 1-element arrays in
struct sgmap, struct sgmap64, struct sgmapraw, struct user_sgmap,
and struct user_sgmap64 with modern flexible arrays. Additionally
remove struct user_sgmapraw as it is unused.

The resulting binary output differences from this change are limited
only to stack space consumption of the smaller "srbu" variable
in aac_issue_safw_bmic_identify() and aac_get_safw_ciss_luns(),
as well as the smaller associated pair of memcpy()s in
aac_send_safw_bmic_cmd(). Artificially growing the size of srbu back to
its prior size removes all binary differences[2].

As an aside, after studying the aacraid driver code I wonder how
aac_send_wellness_command() ever works. It is reporting a size 4 bytes
too small for what it has constructed in memory in the DMA region:
sgentry64 is size 12, whereas sgentry is size 8. Perhaps the hardware
doesn't care. (Regardless, it is unchanged by this patch.)

Link: https://github.com/KSPP/linux/issues/79 [1]
Link: https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=dev/v6.10-rc2/1-element&id=45e6226bcbc5e982541754eca7ac29f403e82f5e [2]
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/aacraid/aachba.c   | 26 ++++++++++++--------------
 drivers/scsi/aacraid/aacraid.h  | 15 +++++----------
 drivers/scsi/aacraid/commctrl.c |  4 ++--
 drivers/scsi/aacraid/comminit.c |  3 +--
 drivers/scsi/aacraid/commsup.c  |  5 +++--
 5 files changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 497c6dd5df91..ec3834bda111 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1267,7 +1267,7 @@ static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
 			return ret;
 		command = ContainerRawIo;
 		fibsize = sizeof(struct aac_raw_io) +
-			((le32_to_cpu(readcmd->sg.count)-1) * sizeof(struct sgentryraw));
+			(le32_to_cpu(readcmd->sg.count) * sizeof(struct sgentryraw));
 	}
 
 	BUG_ON(fibsize > (fib->dev->max_fib_size - sizeof(struct aac_fibhdr)));
@@ -1302,7 +1302,7 @@ static int aac_read_block64(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
 	if (ret < 0)
 		return ret;
 	fibsize = sizeof(struct aac_read64) +
-		((le32_to_cpu(readcmd->sg.count) - 1) *
+		(le32_to_cpu(readcmd->sg.count) *
 		 sizeof (struct sgentry64));
 	BUG_ON (fibsize > (fib->dev->max_fib_size -
 				sizeof(struct aac_fibhdr)));
@@ -1337,7 +1337,7 @@ static int aac_read_block(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u32
 	if (ret < 0)
 		return ret;
 	fibsize = sizeof(struct aac_read) +
-			((le32_to_cpu(readcmd->sg.count) - 1) *
+			(le32_to_cpu(readcmd->sg.count) *
 			 sizeof (struct sgentry));
 	BUG_ON (fibsize > (fib->dev->max_fib_size -
 				sizeof(struct aac_fibhdr)));
@@ -1401,7 +1401,7 @@ static int aac_write_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
 			return ret;
 		command = ContainerRawIo;
 		fibsize = sizeof(struct aac_raw_io) +
-			((le32_to_cpu(writecmd->sg.count)-1) * sizeof (struct sgentryraw));
+			(le32_to_cpu(writecmd->sg.count) * sizeof(struct sgentryraw));
 	}
 
 	BUG_ON(fibsize > (fib->dev->max_fib_size - sizeof(struct aac_fibhdr)));
@@ -1436,7 +1436,7 @@ static int aac_write_block64(struct fib * fib, struct scsi_cmnd * cmd, u64 lba,
 	if (ret < 0)
 		return ret;
 	fibsize = sizeof(struct aac_write64) +
-		((le32_to_cpu(writecmd->sg.count) - 1) *
+		(le32_to_cpu(writecmd->sg.count) *
 		 sizeof (struct sgentry64));
 	BUG_ON (fibsize > (fib->dev->max_fib_size -
 				sizeof(struct aac_fibhdr)));
@@ -1473,7 +1473,7 @@ static int aac_write_block(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
 	if (ret < 0)
 		return ret;
 	fibsize = sizeof(struct aac_write) +
-		((le32_to_cpu(writecmd->sg.count) - 1) *
+		(le32_to_cpu(writecmd->sg.count) *
 		 sizeof (struct sgentry));
 	BUG_ON (fibsize > (fib->dev->max_fib_size -
 				sizeof(struct aac_fibhdr)));
@@ -1592,9 +1592,9 @@ static int aac_scsi_64(struct fib * fib, struct scsi_cmnd * cmd)
 	/*
 	 *	Build Scatter/Gather list
 	 */
-	fibsize = sizeof (struct aac_srb) - sizeof (struct sgentry) +
+	fibsize = sizeof(struct aac_srb) +
 		((le32_to_cpu(srbcmd->sg.count) & 0xff) *
-		 sizeof (struct sgentry64));
+		 sizeof(struct sgentry64));
 	BUG_ON (fibsize > (fib->dev->max_fib_size -
 				sizeof(struct aac_fibhdr)));
 
@@ -1624,7 +1624,7 @@ static int aac_scsi_32(struct fib * fib, struct scsi_cmnd * cmd)
 	 *	Build Scatter/Gather list
 	 */
 	fibsize = sizeof (struct aac_srb) +
-		(((le32_to_cpu(srbcmd->sg.count) & 0xff) - 1) *
+		((le32_to_cpu(srbcmd->sg.count) & 0xff) *
 		 sizeof (struct sgentry));
 	BUG_ON (fibsize > (fib->dev->max_fib_size -
 				sizeof(struct aac_fibhdr)));
@@ -1693,8 +1693,7 @@ static int aac_send_safw_bmic_cmd(struct aac_dev *dev,
 	fibptr->hw_fib_va->header.XferState &=
 		~cpu_to_le32(FastResponseCapable);
 
-	fibsize  = sizeof(struct aac_srb) - sizeof(struct sgentry) +
-						sizeof(struct sgentry64);
+	fibsize = sizeof(struct aac_srb) + sizeof(struct sgentry64);
 
 	/* allocate DMA buffer for response */
 	addr = dma_map_single(&dev->pdev->dev, xfer_buf, xfer_len,
@@ -2267,7 +2266,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
 		dev->a_ops.adapter_bounds = aac_bounds_32;
 		dev->scsi_host_ptr->sg_tablesize = (dev->max_fib_size -
 			sizeof(struct aac_fibhdr) -
-			sizeof(struct aac_write) + sizeof(struct sgentry)) /
+			sizeof(struct aac_write)) /
 				sizeof(struct sgentry);
 		if (dev->dac_support) {
 			dev->a_ops.adapter_read = aac_read_block64;
@@ -2278,8 +2277,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
 			dev->scsi_host_ptr->sg_tablesize =
 				(dev->max_fib_size -
 				sizeof(struct aac_fibhdr) -
-				sizeof(struct aac_write64) +
-				sizeof(struct sgentry64)) /
+				sizeof(struct aac_write64)) /
 					sizeof(struct sgentry64);
 		} else {
 			dev->a_ops.adapter_read = aac_read_block;
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 8e7a0a5cb7aa..1d09d3ac6aa4 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -507,32 +507,27 @@ struct sge_ieee1212 {
 
 struct sgmap {
 	__le32		count;
-	struct sgentry	sg[1];
+	struct sgentry	sg[];
 };
 
 struct user_sgmap {
 	u32		count;
-	struct user_sgentry	sg[1];
+	struct user_sgentry	sg[];
 };
 
 struct sgmap64 {
 	__le32		count;
-	struct sgentry64 sg[1];
+	struct sgentry64 sg[];
 };
 
 struct user_sgmap64 {
 	u32		count;
-	struct user_sgentry64 sg[1];
+	struct user_sgentry64 sg[];
 };
 
 struct sgmapraw {
 	__le32		  count;
-	struct sgentryraw sg[1];
-};
-
-struct user_sgmapraw {
-	u32		  count;
-	struct user_sgentryraw sg[1];
+	struct sgentryraw sg[];
 };
 
 struct creation_info
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index e7cc927ed952..68240d6f27ab 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -523,7 +523,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		goto cleanup;
 	}
 
-	if ((fibsize < (sizeof(struct user_aac_srb) - sizeof(struct user_sgentry))) ||
+	if ((fibsize < sizeof(struct user_aac_srb)) ||
 	    (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr)))) {
 		rcode = -EINVAL;
 		goto cleanup;
@@ -561,7 +561,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		rcode = -EINVAL;
 		goto cleanup;
 	}
-	actual_fibsize = sizeof(struct aac_srb) - sizeof(struct sgentry) +
+	actual_fibsize = sizeof(struct aac_srb) +
 		((user_srbcmd->sg.count & 0xff) * sizeof(struct sgentry));
 	actual_fibsize64 = actual_fibsize + (user_srbcmd->sg.count & 0xff) *
 	  (sizeof(struct sgentry64) - sizeof(struct sgentry));
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index bd99c5492b7d..fee857236991 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -522,8 +522,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	spin_lock_init(&dev->iq_lock);
 	dev->max_fib_size = sizeof(struct hw_fib);
 	dev->sg_tablesize = host->sg_tablesize = (dev->max_fib_size
-		- sizeof(struct aac_fibhdr)
-		- sizeof(struct aac_write) + sizeof(struct sgentry))
+		- sizeof(struct aac_fibhdr) - sizeof(struct aac_write))
 			/ sizeof(struct sgentry);
 	dev->comm_interface = AAC_COMM_PRODUCER;
 	dev->raw_io_interface = dev->raw_io_64 = 0;
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 25cee03d7f97..47287559c768 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -2327,8 +2327,9 @@ static int aac_send_wellness_command(struct aac_dev *dev, char *wellness_str,
 	sg64->sg[0].addr[0] = cpu_to_le32((u32)(addr & 0xffffffff));
 	sg64->sg[0].count = cpu_to_le32(datasize);
 
-	ret = aac_fib_send(ScsiPortCommand64, fibptr, sizeof(struct aac_srb),
-				FsaNormal, 1, 1, NULL, NULL);
+	ret = aac_fib_send(ScsiPortCommand64, fibptr,
+			   sizeof(struct aac_srb) + sizeof(struct sgentry),
+			   FsaNormal, 1, 1, NULL, NULL);
 
 	dma_free_coherent(&dev->pdev->dev, datasize, dma_buf, addr);
 
-- 
2.34.1

