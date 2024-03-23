Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EE0C129
	for <linux-scsi@vger.kernel.org>; Sat, 23 Mar 2024 08:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711183321; cv=none; b=XafdvnsbyFiyOKCWdC31Bfcp8u95/x3tJWgJ4+Z+2V/2gQ/7w0S4w6gKQWuT6igcFd4AXgPGAJdAXksO5A8f5Z34ZStHBSIB38fdQlVNFuAwowu0nIP3vXz4sRMLRr+CO7dAkgT/wmG2mlqUz48Vft7xD+yr2Jj6fSG87E+VXR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711183321; c=relaxed/simple;
	bh=yzdatOzbK5jAVysB4vnA/Qr23mXuCspz74PGCE9kn9M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pXGEKhnXqEaXdN+Dw39w0ozMVIkSPjn1n0qGf0vzblBC+U20plX1Eh5V+WM2/YdG6tbgic7uTvu/V/srdFapcZlLomAPGIlM5fMtmug3lwzoTs97W6C4rEDqRw5o5vkJ3D1oo4gPu/gJJblSwu618eQcjwFceezNfu/Quu3VPUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fzlw5r5X; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fzlw5r5X"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1711183319; x=1742719319;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yzdatOzbK5jAVysB4vnA/Qr23mXuCspz74PGCE9kn9M=;
  b=fzlw5r5Xc5Bh7oonYcjI3zhs1K9rovrHS4XMgH1LYhILgE6V0FfRr3Iw
   cIYMzzjTUAiKMzOJZEk9OECso5HC+hVid/Q6AylDIUvxMQn0FTQYx9v8s
   j5Tcr+kwRmNVSRba8/D0dpKzevFFZXH9tVGBw5NMyBApfxaq8HUzQaLVg
   mNdKnzH860+17G8pMidvbPbOGHLBIjojHwpHwCDicmsentcCGO9H8H4+Q
   qqkNt7neZkSpitfddHbys/nr7rdFsPSxOGoiizDkbmBuW1lCsPvL3/2QE
   Z3qu7rB7sGYk2qOyNTQiq/J7txOosQoOJ/b+ENICD4WttMV7AoPJ9eGqJ
   A==;
X-CSE-ConnectionGUID: 3F7PJO/WTNe3wEPvmJpUzQ==
X-CSE-MsgGUID: oPFhDDHQQIy8pyJQUOpz9g==
X-IronPort-AV: E=Sophos;i="6.07,148,1708358400"; 
   d="scan'208";a="12142737"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 23 Mar 2024 16:41:58 +0800
IronPort-SDR: ruw563/EGIw6lfQ8MotVTKIXY0Au0l1yX7z8kDL9fCEWL66j4xUbkEh/PkoHCRoRxMHopl7hcc
 /8EqihtRdJFw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Mar 2024 00:50:46 -0700
IronPort-SDR: apZKEeyooHHu1AVGishG+i0kbmEAi4uelt4+D8h+Q67EHUcwQ4OphXVQy2Zpn7xOVkNnaFDPWf
 jxMgfUhFVY4w==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 23 Mar 2024 01:41:56 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2] scsi: mpi3mr: Avoid memcpy field-spanning write WARNING
Date: Sat, 23 Mar 2024 17:41:55 +0900
Message-ID: <20240323084155.166835-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the "storcli2 show" command is executed for eHBA-9600, mpi3mr
driver prints this WARNING message:

  memcpy: detected field-spanning write (size 128) of single field "bsg_reply_buf->reply_buf" at drivers/scsi/mpi3mr/mpi3mr_app.c:1658 (size 1)
  WARNING: CPU: 0 PID: 12760 at drivers/scsi/mpi3mr/mpi3mr_app.c:1658 mpi3mr_bsg_request+0x6b12/0x7f10 [mpi3mr]

The cause of the WARN is 128 bytes memcpy to the 1 byte size array
"__u8 replay_buf[1]" in the struct mpi3mr_bsg_in_reply_buf. The array is
intended to be a flexible length array, then the WARN is a false
positive. To suppress the WARN, remove the constant number '1' from the
array declaration and clarify that it has flexible length. Also, adjust
the memory allocation size to match the change.

Suggested-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
Changes from v1:
* Modify the array declaration for flexible length instead of two memcpy calls

 drivers/scsi/mpi3mr/mpi3mr_app.c    | 2 +-
 include/uapi/scsi/scsi_bsg_mpi3mr.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 0380996b5ad2..55d590b91947 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1644,7 +1644,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	if ((mpirep_offset != 0xFF) &&
 	    drv_bufs[mpirep_offset].bsg_buf_len) {
 		drv_buf_iter = &drv_bufs[mpirep_offset];
-		drv_buf_iter->kern_buf_len = (sizeof(*bsg_reply_buf) - 1 +
+		drv_buf_iter->kern_buf_len = (sizeof(*bsg_reply_buf) +
 					   mrioc->reply_sz);
 		bsg_reply_buf = kzalloc(drv_buf_iter->kern_buf_len, GFP_KERNEL);
 
diff --git a/include/uapi/scsi/scsi_bsg_mpi3mr.h b/include/uapi/scsi/scsi_bsg_mpi3mr.h
index c72ce387286a..30a5c1a59376 100644
--- a/include/uapi/scsi/scsi_bsg_mpi3mr.h
+++ b/include/uapi/scsi/scsi_bsg_mpi3mr.h
@@ -382,7 +382,7 @@ struct mpi3mr_bsg_in_reply_buf {
 	__u8	mpi_reply_type;
 	__u8	rsvd1;
 	__u16	rsvd2;
-	__u8	reply_buf[1];
+	__u8	reply_buf[];
 };
 
 /**
-- 
2.44.0

