Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A182F5A12
	for <linux-scsi@vger.kernel.org>; Sun,  8 Feb 2026 18:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770574120; cv=none; b=UBga+aWP+HLKn7PUEJoRGdGqWjsHeQHg63ZGGHVRyEu71j1edOLQ0ccPljOiFTyV0NWd9pQa7wVcDiNH7ErPlykKPfngIU7x08PcQdk8yOBhEneTRn4r5La6furrYO8yo6WGbRU5qrS42llcWRNA/wSi5h3QXdu2d0ame85MPdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770574120; c=relaxed/simple;
	bh=z2nZIn/lKd9/xiLIoQoYgj5ASvUun5JZ/MR0z9Iq9XM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OM3hP5wY5fovAwEjVYZOgQfcjhArDWNeW1mx4+Po+Edg0RXOf3hnBvIvxPsllFnJgLI2jDQ9RZ7iO5mmvrVwTPOmpvbxSizUmwze8CUexB8d+fN0ZQN13TUD0SXfbxj/gZtsL941GFnmLuuBlnpdDp7V+tgHVg9fsuVB8xODUX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FjSsftZa; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FjSsftZa"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4806fbc6bf3so26471245e9.2
        for <linux-scsi@vger.kernel.org>; Sun, 08 Feb 2026 10:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770574118; x=1771178918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cWY3Id1ZHVwSpLqfM0mispwmQOKUmeewbvlv34YZKKc=;
        b=FjSsftZaYb1jRkJretrvVMGpBi6EhawOe6tJqZfAe9PxL0U3bonxAUlvuDlU1thB5I
         O46u2135LSpOa9GBink5mpsJI1rrJGu6wPdAea1v5uIpsVl8ZOOBI1+iXW0TBpOlxklL
         AZ7zhO8RVObQbN9UtqBVjqmn6nHGg0taFIG2iEyPFClJ2LP839cwCWg4H0VRfNJBn/n5
         zLzNaBtZsAGfzpqpLyxWfW7xsXISLBFwUOApJTXcGFjxvanaH3MJ0IJyVc7EBxzY36oA
         I/qxdxRdW9Q7sucLkCyEZiiB/IjofxaxnD2GLQwMjqXYiCwKkLVUFd/U4eNwl6gGQgdK
         mAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770574118; x=1771178918;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cWY3Id1ZHVwSpLqfM0mispwmQOKUmeewbvlv34YZKKc=;
        b=tdrTVoaSlp7nrTpXllmdx8axui7OeodMAzNzqwzZuWLgzBRTTy8SNSQ3PETjBPbQfb
         rimDuQJF3IUNDkw/t0540vVSA3iW96A9H9PyY5JtNeWJnAFHn1qKUq6CYRsbmrTT1fne
         YZQa5VwooBemmwjyRHnAVq0Gc0+HPPYsp4CS0AiFe7lTPX+aIz64tUJFjKpi0ZNLY6xw
         TejoFZ6sTQTXdMhuL+KumSz8NgBnUgTwFotigrWEr06qu4nOXuCK/EOUzJvK4YK9k+4a
         QongJu7zKTXc0Vu8Bi984THmeL3knVOFPQB03HnVOrKAPG0ysAY11syGN2R+JaWiIanq
         JCsg==
X-Forwarded-Encrypted: i=1; AJvYcCXySD95TW4Agpxd0RdvqK6UCx+K/C62R/p6SiV/RjgIr+p+rOc0vorW+77hPaMh0R8lxkvYAGaZRjQY@vger.kernel.org
X-Gm-Message-State: AOJu0YxsFRTifSQ0RLlx91lqpEixdUlQ7TjwiKkYFdK1U5l86DdF95eB
	iKPP+0LJjdOn8r9rCGOG75kDF2l+f6XV3GX6dY9KK2zoDPVE/tGFb0f+yMALWZp4
X-Gm-Gg: AZuq6aIvjihLS1gaDYscsJQ88ZVrLhqs7RUnRP9dHf7SA4J6MQ98j9ryZL7Ze73ezjw
	jkDv+kJfIUawe73CDmPLAShAZx4SgJuJqbaUcCdPlR+uIteXrdeIlESYOvrTk2rQTSxCpNd2b8y
	1n+Lk51GFrzy4OOC3qWq6CJnJhNTi9ggffzYiSSyl1WF5J4e/PA+xGBLxoqcv8DkgphG9kMb7XB
	lnjyfRnh5xz2FEegcgeCSIw5Rc7uC0MQjXP1UZtn64Em8J1kAuo0L+ssX41+o9eKvJN9MwuPmfK
	vMjU6uqQbItNXXKKZJL3uEHbD4IxHYNJfyltyV4Ps4x/fgUqKzE5nZZrsjavirpIZpn4t59b3LZ
	E7UJctPYGHm7OsOZrJOOvdWpBgSyFsJoguYTjEfkbur9dzOsoomB6G6mwUHcYL/3PoxziHV4IkF
	zD2gSQfMAXPxSEt1jG54fHMsR2OhAO8ZIzBN88M9NQOA2lhECDzQ==
X-Received: by 2002:a05:600c:6094:b0:483:a21:7744 with SMTP id 5b1f17b1804b1-4832021e967mr135337885e9.26.1770574118339;
        Sun, 08 Feb 2026 10:08:38 -0800 (PST)
Received: from ionutnechita-arz2022.local ([2a02:2f0e:c504:f100:6cf3:85b2:823f:2bff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48317d2bab2sm469877835e9.3.2026.02.08.10.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 10:08:37 -0800 (PST)
From: "Ionut Nechita (Sunlight Linux)" <sunlightlinux@gmail.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ionut Nechita <ionut_n2001@yahoo.com>,
	Ionut Nechita <ionut.nechita@windriver.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: megaraid_sas: return DID_SOFT_ERROR on zero-byte DONE_WITH_ERROR
Date: Sun,  8 Feb 2026 20:06:04 +0200
Message-ID: <20260208180603.568353-2-sunlightlinux@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ionut Nechita <ionut_n2001@yahoo.com>

When the MegaRAID firmware returns MFI_STAT_SCSI_DONE_WITH_ERROR (0x2d)
with zero bytes transferred on a data-bearing command, the driver
currently returns DID_OK to the SCSI midlayer. This causes the I/O to
appear complete with no data, leading to hung tasks that block
indefinitely.

Production systems show the following repeated pattern:

  sd 0:0:9:0: [sdb] tag#24 BRCM Debug mfi stat 0x2d, data len
      requested/completed 0x1000/0x0

  INFO: task systemd-udevd:267 blocked for more than 245 seconds.
  INFO: task modprobe:296 blocked for more than 246 seconds.

When the firmware reports DONE_WITH_ERROR with no data transferred and
no CHECK_CONDITION sense data, return DID_SOFT_ERROR instead of DID_OK.
This causes the SCSI midlayer to retry the command up to cmd->allowed
times (default 5), matching the established pattern used by mpt3sas and
smartpqi for similar conditions.

Commands with CHECK_CONDITION sense data are not affected -- they
continue to be completed immediately with the sense data intact.

Fixes: 9c915a8c99bc ("[SCSI] megaraid_sas: Add 9565/9285 specific code")
Cc: stable@vger.kernel.org
Signed-off-by: Ionut Nechita <ionut_n2001@yahoo.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 16 ++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 14 +++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index abbbc4b36cd1d..de35b7d5094d7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3682,6 +3682,22 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 				       hdr->sense_len);
 			}
 
+			/*
+			 * MFI firmware does not report actual bytes
+			 * transferred, so we cannot compute residuals.
+			 * If data was expected and no CHECK_CONDITION,
+			 * retry via DID_SOFT_ERROR. The SCSI midlayer
+			 * retries up to cmd->allowed times (default 5).
+			 */
+			if (hdr->scsi_status != SAM_STAT_CHECK_CONDITION &&
+			    scsi_bufflen(cmd->scmd) > 0) {
+				cmd->scmd->result = DID_SOFT_ERROR << 16;
+				dev_warn(&instance->pdev->dev,
+					"megaraid_sas: DONE_WITH_ERROR (stat 0x%x) on cmd 0x%x to tgt %d, retrying\n",
+					hdr->cmd_status, hdr->cmd,
+					hdr->target_id);
+			}
+
 			break;
 
 		case MFI_STAT_LD_OFFLINE:
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index a6794f49e9fae..6021f1363ef4c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2066,7 +2066,19 @@ map_cmd_status(struct fusion_context *fusion,
 		resid = (scsi_bufflen(scmd) - data_length);
 		scsi_set_resid(scmd, resid);
 
-		if (resid &&
+		/*
+		 * If data was expected but zero bytes were transferred
+		 * and there is no CHECK_CONDITION sense data, retry via
+		 * DID_SOFT_ERROR. The SCSI midlayer retries up to
+		 * cmd->allowed times (default 5).
+		 */
+		if (data_length == 0 && scsi_bufflen(scmd) > 0 &&
+		    ext_status != SAM_STAT_CHECK_CONDITION) {
+			scmd->result = DID_SOFT_ERROR << 16;
+			scmd_printk(KERN_WARNING, scmd,
+				"megaraid_sas: zero data on DONE_WITH_ERROR (stat 0x%x, bufflen 0x%x), retrying\n",
+				status, scsi_bufflen(scmd));
+		} else if (resid &&
 			((cmd_type == READ_WRITE_LDIO) ||
 			(cmd_type == READ_WRITE_SYSPDIO)))
 			scmd_printk(KERN_INFO, scmd, "BRCM Debug mfi stat 0x%x, data len"
-- 
2.52.0

