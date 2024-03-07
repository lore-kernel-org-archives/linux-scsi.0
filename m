Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4875F1FBB
	for <linux-scsi@vger.kernel.org>; Thu,  7 Mar 2024 04:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709785617; cv=none; b=QD6wLEbqiEMtvDEemQ+rz92e+PP1G5fBfrY/mjOmghFJ8MZRyoAXtlNP9i+SmH2NrvCQysjUC31k6qi3hStceecgaaqHtqpt8blKu/GQNhnMX0bL+PVQVvdODmKQ/iCcSYNKj0BEdkbIFZMmgUQGFAQnOHIymsvabgOxYBkCH5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709785617; c=relaxed/simple;
	bh=XvG2eyiUURCV7Yq/ZR4BglI3b7eXPRDL/cjIKrWcH5I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b5FxdboGY7DDMfbXr2XEAnfUI2k4qi21zudailIL0fZX376VqMEWJ0EHtRqH5pC/huDwo9a5NzqeME/nzjHBq1nZfxRWGUjsl0oPKIrodTI/8Gm6ejdKjtYvupcfFA19uMCiOAUksKBlGZzKdcOckZeKwiqurSSKfDWKQdXqxlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nJaK+2P5; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nJaK+2P5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709785614; x=1741321614;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XvG2eyiUURCV7Yq/ZR4BglI3b7eXPRDL/cjIKrWcH5I=;
  b=nJaK+2P5sPHah/YYGBGRniSJTm4NshZRT0flIETJnDZUXC+O5zVrjpfA
   SVo1C32dihWDWkwfQ6cxYxLPK+J/Z3KaTvaFmNydxJy+/L/aPoCkW4AYf
   JjHWuAoiZhsBbG8qZ2M5wfr82e3oieD18mwNtMrL64yTW3YboWPgSfqJw
   cWI+V24dgb7YfMHLTGvAWXVe7e4gVNi3Qoh3exJ6k2UqrATLjd7Yx7rQG
   ThVEvhsBLoSzXlmj6+2lNE0lZjK3aGZ0ptVnZ4dOgie35xHBi9T4XVNmq
   OvoobwwdP54dbyctwgP7VykPdTEWTboCM+DR4EJckeM2+leIlzO60ci7F
   g==;
X-CSE-ConnectionGUID: gBqvjzVAT2WS9oGWe6ME1Q==
X-CSE-MsgGUID: qZY3UE1GT0uO3TJFSQOBgw==
X-IronPort-AV: E=Sophos;i="6.06,209,1705334400"; 
   d="scan'208";a="11243710"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Mar 2024 12:26:47 +0800
IronPort-SDR: Xm0AEmTojxiWieNGy0Gp3FAKX92tRkHq31N3oAO02AoG+XhtA68Le/na7XpTQQVziNT8/R0wBs
 IvtGzsWUhJwQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Mar 2024 19:30:15 -0800
IronPort-SDR: cUv4T7L4spbm6/sTT2HKUAoIEvnDawnTZXmz4mcDIiRwwk2Wpe6dePprQeBguqFffgqMIpXYW6
 xeBHaYV/uJSw==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Mar 2024 20:26:45 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] scsi: mpi3mr: Avoid memcpy field-spanning write WARNING
Date: Thu,  7 Mar 2024 13:26:45 +0900
Message-ID: <20240307042645.2827201-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the "storcli2 show" command is executed for eHBA-9600, mpi3mr
driver prints this WARNING:

  memcpy: detected field-spanning write (size 128) of single field "bsg_reply_buf->reply_buf" at drivers/scsi/mpi3mr/mpi3mr_app.c:1658 (size 1)
  WARNING: CPU: 0 PID: 12760 at drivers/scsi/mpi3mr/mpi3mr_app.c:1658 mpi3mr_bsg_request+0x6b12/0x7f10 [mpi3mr]

This is caused by the 128 bytes memcpy to the 1 byte size struct field
replay_buf in the struct mpi3mr_bsg_in_reply_buf. The field is intended
to be a variable length buffer, then the WARN is a false positive.

One approach to suppress the WARN is to remove the constant '1' from the
replay_buf array declaration to clarify the array size is variable.
However, the array is defined in include/uapi/scsi/scsi_bsg_mpi3mr.h and
the change will break UAPI compatibility. As another approach, divide
the memcpy call into two memcpy calls: one call for the 1 byte size of
the array declaration, and the other call for the left over. While at
it, replace the magic number 1 with sizeof(bsg_reply_buf->reply_buf);

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 0380996b5ad2..7fa0710c7574 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1233,6 +1233,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	u8 *din_buf = NULL, *dout_buf = NULL;
 	u8 *sgl_iter = NULL, *sgl_din_iter = NULL, *sgl_dout_iter = NULL;
 	u16 rmc_size  = 0, desc_count = 0;
+	int declared_size;
 
 	bsg_req = job->request;
 	karg = (struct mpi3mr_bsg_mptcmd *)&bsg_req->cmd.mptcmd;
@@ -1643,9 +1644,11 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 
 	if ((mpirep_offset != 0xFF) &&
 	    drv_bufs[mpirep_offset].bsg_buf_len) {
+		declared_size = sizeof(bsg_reply_buf->reply_buf);
 		drv_buf_iter = &drv_bufs[mpirep_offset];
-		drv_buf_iter->kern_buf_len = (sizeof(*bsg_reply_buf) - 1 +
-					   mrioc->reply_sz);
+		drv_buf_iter->kern_buf_len = (sizeof(*bsg_reply_buf)
+					      - declared_size
+					      + mrioc->reply_sz);
 		bsg_reply_buf = kzalloc(drv_buf_iter->kern_buf_len, GFP_KERNEL);
 
 		if (!bsg_reply_buf) {
@@ -1655,8 +1658,13 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		if (mrioc->bsg_cmds.state & MPI3MR_CMD_REPLY_VALID) {
 			bsg_reply_buf->mpi_reply_type =
 				MPI3MR_BSG_MPI_REPLY_BUFTYPE_ADDRESS;
+			/* Divide memcpy to avoid field-spanning write WARN */
 			memcpy(bsg_reply_buf->reply_buf,
-			    mrioc->bsg_cmds.reply, mrioc->reply_sz);
+			       mrioc->bsg_cmds.reply,
+			       declared_size);
+			memcpy(bsg_reply_buf->reply_buf + declared_size,
+			       (u8 *)mrioc->bsg_cmds.reply + declared_size,
+			       mrioc->reply_sz - declared_size);
 		} else {
 			bsg_reply_buf->mpi_reply_type =
 				MPI3MR_BSG_MPI_REPLY_BUFTYPE_STATUS;
-- 
2.43.0

