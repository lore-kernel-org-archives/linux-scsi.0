Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10BC366569;
	Fri,  3 Apr 2026 18:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775241716; cv=none; b=UyzCy/TI8ciaW0TBrYt3qTHSpOj+3gVBcMIDdxPzg6CdmCWdciii2IyHCrlVk298weMJUrLOzOtmuo7zyeCd3O4z+ELQXkQuc2YAmmlC0uIKUPYMw5Xp3uOX5oUg0wkFP7f4LI+/eBzVsU1Yw8vNrrtsMGbcX7EgYtqfLF3+L5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775241716; c=relaxed/simple;
	bh=LTpgvjDTvnDYR+cwlogUnudh7Wf9ZpTOUqEltp/6TDk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=XBK9gJ0lHMrQAr10lBUefSLP1fP8JYpLv9sq++qj60+jQb+EPppGqbX7bDaowkxVFv7A/78ixM77FSU/l+iD6ni+hldlJBhiLczdETOdMTzrRJpFk/RRnEXg5ShTvDLYhjsnvvGNx5mEB4kODhsu1twl+A8DR3mH/F5cYCsKLeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dLyl0dpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dLyl0dpk"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36831C19424;
	Fri,  3 Apr 2026 18:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775241716;
	bh=LTpgvjDTvnDYR+cwlogUnudh7Wf9ZpTOUqEltp/6TDk=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=dLyl0dpkgPdKBNOKg7g5Jryo7KCjWZm4SjLw4fbFkzkNH6ptDd0DIZ91dbWFsR4Py
	 PN5dOtV2NTbekMqKWvlhuiV4yXeKhqHQ/dh3TaFD0S0UJdecF3fko1UOowXaEnN1ri
	 TVpF+QbWHg3nDdBQHv5BShlcBHas9RqreQ3AQvJKQ3hlFRVce0u5Iao12VHZzczoYc
	 qs7Arp6BRbgKlg+iqV1aMja69wWqFDaZ/qMZBJVWS0OxGFKem1ZtB17v/j8P7OQBK2
	 Jh6kUqBprdTpcQ4WMbx77oHcv6GVe/oTeoRKfop8f7bdiLyVoi/Y6sBiqquJFwMNPt
	 WWqN+RVVTZWjw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28437E85389;
	Fri,  3 Apr 2026 18:41:56 +0000 (UTC)
From: Aaron Kling via B4 Relay <devnull+webgeek1234.gmail.com@kernel.org>
Date: Fri, 03 Apr 2026 13:41:34 -0500
Subject: [PATCH] scsi: ufs: core: Disable timestamp for Kioxia
 THGJFJT0E25BAIP
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260403-thgjfjt0e25baip-no-timestamp-v1-1-1ddb34225133@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQqAIBAAwK/EnlvYLCP6SnSwWmuDTFQiiP6ed
 JzLPBA5CEfoiwcCXxLldBlVWcC8GbcyypINilRLDdWYtnW3eyJWejLi0Z2Y5OCYzOGRukrZdtY
 NaYJc+MBW7r8fxvf9AJ3FIpJuAAAA
X-Change-ID: 20260403-thgjfjt0e25baip-no-timestamp-0812f6c54050
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Aaron Kling <webgeek1234@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775241715; l=1083;
 i=webgeek1234@gmail.com; s=20250217; h=from:subject:message-id;
 bh=VUWuY9f9Hf6f2pny+U0MoADHfXbA8keKg9Eblgl1y5k=;
 b=RhJw/4rmpQ5Akk2QQ3JjlxqANiUNTcI3QnhkiLfcK03EJdB3bLDkejInolM+3NpMe20krQo+r
 z78hc0/WO6eAOGXdDwL93vYaGr+aZPWaCXgJWI36IW47PTXLugwZ8T7
X-Developer-Key: i=webgeek1234@gmail.com; a=ed25519;
 pk=TQwd6q26txw7bkK7B8qtI/kcAohZc7bHHGSD7domdrU=
X-Endpoint-Received: by B4 Relay for webgeek1234@gmail.com/20250217 with
 auth_id=342
X-Original-From: Aaron Kling <webgeek1234@gmail.com>
Reply-To: webgeek1234@gmail.com

From: Aaron Kling <webgeek1234@gmail.com>

Kioxia has another product that does not support the qTimestamp
attribute.

Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
---
 drivers/ufs/core/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5c3518f1f97c7f85854b66bf87c86d00b539fba6..4805e40ed4d78cd4b0c07cda0df6bb0f7e172cb1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -315,6 +315,9 @@ static const struct ufs_dev_quirk ufs_fixups[] = {
 	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
 	  .model = "THGLF2G9D8KBADG",
 	  .quirk = UFS_DEVICE_QUIRK_PA_TACTIVATE },
+	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
+	  .model = "THGJFJT0E25BAIP",
+	  .quirk = UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT },
 	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
 	  .model = "THGJFJT1E45BATP",
 	  .quirk = UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT },

---
base-commit: 2febe6e6ee6e34c7754eff3c4d81aa7b0dcb7979
change-id: 20260403-thgjfjt0e25baip-no-timestamp-0812f6c54050

Best regards,
-- 
Aaron Kling <webgeek1234@gmail.com>


