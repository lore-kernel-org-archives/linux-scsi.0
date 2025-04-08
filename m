Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC0326563B
	for <linux-scsi@vger.kernel.org>; Tue,  8 Apr 2025 10:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744108226; cv=none; b=R+E7fHwKQ8ayA761sWIvI72bt4JN2O/IBWqWWiF6GZ0zGXJYMcLTOAOXuEzyH3jGSn9gjDg0JbKBPoaEx8wSo9sXi97FC78iWUYvSYg7z4naQjSpmW/dEaK1zqU8cgv/le6IXEghedUaaRI2IZjABTex5U4AOdlvzBLiyowroo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744108226; c=relaxed/simple;
	bh=aRMWSg8X0oBFHmCqDJWVHgqDLlV+JdZbwSNHQo6deEk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ukQIB4KS/ldeu6AWEcb2CKf8n7PCiK1lD7Ue3bAdgzIaBLNq5USgA8EoioqPd1AkiZgaBRb+Vz8m+heL7JTvYsEizo65hw82lb840kdVM/s+9x/3jhdaKvZN3Fz19E8F4yqlt9tHUiMuGmS5T7B2YAAsYn4YTB+BZ/O3FLCRTCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o/rCN22r; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o/rCN22r"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744108212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FLHb/ouI/NPQuiKkjHhPMowLOAqffxplBiQcA/sQ2k0=;
	b=o/rCN22rmT7HcLQgjjPzVar7cA/2eXphkm9XO2KwmYVIrnOOAtBHaaj+tfC6s31D3QSCAB
	n5T2v59c9bu467J+nsT3bJIPkJzJeZKmbpL0Axh7yRpjKJGAmDJimmTWhpb3fDP/Bv3IvG
	1M2I9ojKHe2Axx4qUfbk8G9PUwAKDtI=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: James Smart <james.smart@broadcom.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kees Cook <kees@kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	linux-hardening@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: elx: sli4: Replace deprecated strncpy() with strscpy()
Date: Tue,  8 Apr 2025 12:28:40 +0200
Message-ID: <20250408102843.804083-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

strncpy() is deprecated for NUL-terminated destination buffers; use
strscpy() instead.

Since sli_config_cmd_init() already zeroes out the destination buffers,
the potential NUL-padding by strncpy() is unnecessary. strscpy() copies
only the required characters and guarantees NUL-termination.

And since all three destination buffers have a fixed length, strscpy()
automatically determines their size using sizeof() when the argument is
omitted. This makes any explicit sizeof() calls unnecessary.

The source strings are also NUL-terminated and meet the __must_be_cstr()
requirement of strscpy().

No functional changes intended.

Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Update patch description as suggested by Kees
- Link to v1: https://lore.kernel.org/lkml/20250226185531.1092-2-thorsten.blum@linux.dev/
---
 drivers/scsi/elx/libefc_sli/sli4.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
index 5e7fb110bc3f..d9a231fc0e0d 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.c
+++ b/drivers/scsi/elx/libefc_sli/sli4.c
@@ -3804,7 +3804,7 @@ sli_cmd_common_write_object(struct sli4 *sli4, void *buf, u16 noc,
 	wr_obj->desired_write_len_dword = cpu_to_le32(dwflags);
 
 	wr_obj->write_offset = cpu_to_le32(offset);
-	strncpy(wr_obj->object_name, obj_name, sizeof(wr_obj->object_name) - 1);
+	strscpy(wr_obj->object_name, obj_name);
 	wr_obj->host_buffer_descriptor_count = cpu_to_le32(1);
 
 	bde = (struct sli4_bde *)wr_obj->host_buffer_descriptor;
@@ -3833,7 +3833,7 @@ sli_cmd_common_delete_object(struct sli4 *sli4, void *buf, char *obj_name)
 			 SLI4_SUBSYSTEM_COMMON, CMD_V0,
 			 SLI4_RQST_PYLD_LEN(cmn_delete_object));
 
-	strncpy(req->object_name, obj_name, sizeof(req->object_name) - 1);
+	strscpy(req->object_name, obj_name);
 	return 0;
 }
 
@@ -3856,7 +3856,7 @@ sli_cmd_common_read_object(struct sli4 *sli4, void *buf, u32 desired_read_len,
 		cpu_to_le32(desired_read_len & SLI4_REQ_DESIRE_READLEN);
 
 	rd_obj->read_offset = cpu_to_le32(offset);
-	strncpy(rd_obj->object_name, obj_name, sizeof(rd_obj->object_name) - 1);
+	strscpy(rd_obj->object_name, obj_name);
 	rd_obj->host_buffer_descriptor_count = cpu_to_le32(1);
 
 	bde = (struct sli4_bde *)rd_obj->host_buffer_descriptor;
-- 
2.49.0

