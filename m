Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044D63B8948;
	Mon,  8 Jun 2026 09:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912548; cv=none; b=a+2nZ1k4syonFyksw6ZrJP3niXXnXVW08TA8ZpUnD38APYK/pFTCiM1Os3Q8RJJ458pMtRNv3Lgmi+F11Lvy+av0Ucv7fmuq4E+s/hNeWlg8a6RWiu1HZjtN7kg3BQxC+BI2cpr4RTlBt98AI/cO06VIu+Rffpjs8eKt/G2l4Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912548; c=relaxed/simple;
	bh=wz8XEsY3kJvOSryhfHZlc/eFu9yoBoFSN2PD5F8zRpA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iu0UrUki4hP6uVV4PGOEQhmITHzMJrxmRQuwggUeLRVc/S4d88kMN9NpClcoTeKzVx57oBLt7cYgiXGpW+RJy0G1LVrNpKHYnnIsIyCvq6TAEwJdTQ4KMo+7U4gxqV7zGWIdL5n9OytbfKCmhvxzdY1qGKkKaisR6dVTzI3007k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=L3pZv2Cz; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="L3pZv2Cz"
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWhm-00Br7v-Jk; Mon, 08 Jun 2026 11:55:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=g+VTKhbN/6tees8YPIaQJkfwcrtiigF1OfLz8IHB57c=; b=L3pZv2
	CzHxv1vHmf6IMa+vsMQfgnE04LeNq2X29Qrv0UZgeN/DGAuqjIFgXPw4xhS98x8A4YNCs++sJb0n9
	1K8X8hKDazq6eMPm69OwOogjV7FX6Fic3IRK57L0rfn41UF4BOtVsFyyRUDT0kZc5QAc8II0pX1R3
	l+ef4mlCj4DAulp9YspOtNqrIqOL1DAiH+47MdXbztuFW8nbi+BQhZeataBKk0a9Dw+GrAvUtmdJx
	ukp+KoE9zy2eX+9ZDT+jikMk21ep3PbuhwoeUfUOjxagH9depryO/vxbpJxcmqgO6b9hsyO5/zrXu
	9CTJXfGgYWqf7oRH3qDZ35SK5iTA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWhl-0003bI-NT; Mon, 08 Jun 2026 11:55:38 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wWWhd-00Ag6G-0r;
	Mon, 08 Jun 2026 11:55:29 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Arnd Bergmann <arnd@kernel.org>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH next] drivers/scsi/qla4xxx/ql4_mbx: Use strscpy() to copy strings into arrays
Date: Mon,  8 Jun 2026 10:54:53 +0100
Message-Id: <20260608095523.2606-9-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

Replacing strcpy() with strscpy() ensures that overflow of the target
buffer cannot happen.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
This is one of a group of patches that remove potentially unbounded
strcpy() calls.

They are mostly replaced by strscpy() or, when strlen() has just been
called, with memcpy() (usually including the '\0').

Calls with copy string literals into arrays are left unchanged.
They are safe and easily detected as such.

The changes were made by getting the compiler to detect the calls and
then fixing the code by hand.

Note that all the changes are only compile tested.

Some Makefiles were changed to allow files to contain strcpy().
As well as 'difficult to fix' files, this included 'show' functions
as they really need to use sysfs_emit() or seq_printf().

All the patches are being sent individually to avoid very long cc lists.
Apologies for the terse commit messages and likely unexpected tags.
(There are about 100 patches in total.)

 drivers/scsi/qla4xxx/ql4_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 7febc0baa9d6..cb0dc2908582 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1370,7 +1370,7 @@ int qla4xxx_about_firmware(struct scsi_qla_host *ha)
 	       sizeof(about_fw->fw_build_date));
 	memcpy(ha->fw_info.fw_build_time, about_fw->fw_build_time,
 	       sizeof(about_fw->fw_build_time));
-	strcpy((char *)ha->fw_info.fw_build_user,
+	strscpy(ha->fw_info.fw_build_user,
 	       skip_spaces((char *)about_fw->fw_build_user));
 	ha->fw_info.fw_load_source = le16_to_cpu(about_fw->fw_load_source);
 	ha->fw_info.iscsi_major = le16_to_cpu(about_fw->iscsi_major);
@@ -1379,7 +1379,7 @@ int qla4xxx_about_firmware(struct scsi_qla_host *ha)
 	ha->fw_info.bootload_minor = le16_to_cpu(about_fw->bootload_minor);
 	ha->fw_info.bootload_patch = le16_to_cpu(about_fw->bootload_patch);
 	ha->fw_info.bootload_build = le16_to_cpu(about_fw->bootload_build);
-	strcpy((char *)ha->fw_info.extended_timestamp,
+	strscpy(ha->fw_info.extended_timestamp,
 	       skip_spaces((char *)about_fw->extended_timestamp));
 
 	ha->fw_uptime_secs = le32_to_cpu(mbox_sts[5]);
-- 
2.39.5

