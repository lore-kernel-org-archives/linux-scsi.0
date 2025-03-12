Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5BA1DE3AF;
	Wed, 12 Mar 2025 20:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741809941; cv=none; b=b6kijFbs0niKb9/pgqMP6aJzLYFFJpGFaQQvbiJVVjHRmCa8XdMCePQYtsT4I3s/x14J7jTnaOJMk8bltciYfV/6fYW6QmtcK97pEMDaIl/hXOHADef9hOI1WlvU8oUJVhjlCTKHFRaGFSMx41S+zK44PPWGgRA9LvsHdSqMTKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741809941; c=relaxed/simple;
	bh=x0rT9NEiiYRX5MkFRJvYMmCV2JTVEDgBLYkWCR5UE2s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=h5nYpX1g5uwi2ds+3zUcBHa5AxGDKaKyieo6uMpDd41yKdx+UDD3ArBCOw3sguWB6oPWDRqg2C3CZ7t7nffnR6ygH53wynFskGvbHlRvO8oKzsimyrf2GS7o/VNtuA1I/Rd9NSKLnxVIdL9JTLpEW2kqCvroCzCo+e07yOl/G4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XsrwRrCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XsrwRrCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B00C4CEEA;
	Wed, 12 Mar 2025 20:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741809940;
	bh=x0rT9NEiiYRX5MkFRJvYMmCV2JTVEDgBLYkWCR5UE2s=;
	h=From:To:Cc:Subject:Date:From;
	b=XsrwRrCmBEHVV+lbD5wu78PeeixNX1nwJYlhdReSR5Ww3cDVenlhpv3LJkfHNW1sL
	 LUE58nPEkPadhdyACVgsijRCjjSvxXMr+xW+BGxM8VF9RX0ANbPYHfAthhcsYTUPPY
	 F0mujDm+LK67IzYL0cAPP4QYyk96qGe7rIDQ606QzDV2Tqk/LVa7G50UX5oBRmTmay
	 RFqmjMWemfszgozOoavFt1/isxUNE2k5zFWADN0KH6Ha81iswWTA5q2OtwreNPv+9S
	 XwTtguZBiq0D4KTFYZRMeANzSE1hPnf3cHdkpLdI64BCX/+dmdBjHJGt7fgRzMcOh9
	 XcJlqCc6heKrQ==
From: Kees Cook <kees@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: Kees Cook <kees@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v2] scsi: pm80xx: Use C String API for string comparisons
Date: Wed, 12 Mar 2025 13:05:36 -0700
Message-Id: <20250312200532.it.808-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2142; i=kees@kernel.org; h=from:subject:message-id; bh=x0rT9NEiiYRX5MkFRJvYMmCV2JTVEDgBLYkWCR5UE2s=; b=owGbwMvMwCVmps19z/KJym7G02pJDOkXXwp4zXjT+XJrvd0CZW7zC3LBV2/pHfsXrWj7K/7aU UcvkY2HO0pZGMS4GGTFFFmC7NzjXDzetoe7z1WEmcPKBDKEgYtTAC5SyPDftZeLK6VsR4Dksl3d zIH8r0Ob+nPvi9vonCi+F3iyRl+PkWH5gTkSKoYtLx8uM/x1+cbvH+7l91hb9j7a9tF1iydj8jZ WAA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

When a character array without a terminating NUL character has a static
initializer, GCC 15's -Wunterminated-string-initialization will only
warn if the array lacks the "nonstring" attribute[1]. There is no reason
for the command lookup logic to not use strcmp(), so grow the string
length and update the check to eliminate the warning:

../drivers/scsi/pm8001/pm8001_ctl.c:652:7: warning: initializer-string for array of 'unsigned char' truncates NUL terminator but destination lacks 'nonstring' attribute (9 chars into 8 available) [-Wunterminated-string-initialization]
  652 |      {"set_nvmd",    FLASH_CMD_SET_NVMD},
      |       ^~~~~~~~~~

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=117178 [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
In taking another look at this, I realize that actually strcmp() should be used,
so just grow the size of this character array and use strcmp().
 v1: https://lore.kernel.org/lkml/20250310222553.work.437-kees@kernel.org/
 v2: Use strcmp()
---
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/pm8001/pm8001_ctl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 85ff95c6543a..bb8fd5f0f441 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -644,7 +644,7 @@ static DEVICE_ATTR(gsm_log, S_IRUGO, pm8001_ctl_gsm_log_show, NULL);
 #define FLASH_CMD_SET_NVMD    0x02
 
 struct flash_command {
-     u8      command[8];
+     u8      command[9];
      int     code;
 };
 
@@ -825,8 +825,7 @@ static ssize_t pm8001_store_update_fw(struct device *cdev,
 	}
 
 	for (i = 0; flash_command_table[i].code != FLASH_CMD_NONE; i++) {
-		if (!memcmp(flash_command_table[i].command,
-				 cmd_ptr, strlen(cmd_ptr))) {
+		if (!strcmp(flash_command_table[i].command, cmd_ptr)) {
 			flash_command = flash_command_table[i].code;
 			break;
 		}
-- 
2.34.1

