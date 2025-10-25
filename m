Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741102475E3;
	Sat, 25 Oct 2025 16:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409337; cv=none; b=DNa57bU8ptIptUkgU5iQsVUBb/72zivDnyPZzQyexiMYQOVemx7aI9AFFzPZCv/u1qku4oC4vVjc+MdyDxe7Hy8gMEHiZNjmcu8J8Bte4UAbjl1FNQBpmLFx3my/lBqk1XJPpNpAva6XgVKj6mBYGLQYgaJ1sD2zRw+xzlTJ+LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409337; c=relaxed/simple;
	bh=WNajpbc6UeE5CA1T7IoxhrEbXQRquMQp1b6mZ0IcdWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkxQ7RBkV9lRM3d2e6SsV+I0gHjQ6TLPpO9Fx3N/BS++U7HiOE8Y3ltBZJBg4i/IYZTPtrsDj5AeJtf/jdhuwxEDR00WVsbzONGsaR0Ihmf9nbcK2e8n1BiIYQtquzmaWSkmne0uLjEi/X1J+Ob1z3YpY6jwbcWkEarFj+2nX9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T3wZv4iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3wZv4iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116F1C4CEFB;
	Sat, 25 Oct 2025 16:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409337;
	bh=WNajpbc6UeE5CA1T7IoxhrEbXQRquMQp1b6mZ0IcdWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3wZv4iyUF9OGipuUBM9+K5MAdV+8+vYG1Ah5ppVbF9dtwDKGVGuOrVqyrwGpwUom
	 ajI8RT52mKOm4TwmPYpClEJnCRVjA5PM4Z1l1mBgiNgORiutUAPIV/3r/TfzhLZ9A+
	 HKLP84NNnmiiykVD+Q+OQvPZYoYvaRGpJyt8FvmwEFnZif8pm6ZxLIJEG2YeLrZZfc
	 J0GLFZFXhUmpGKm2MRdTX43XJIGkQcEYHYUg7gXxqwOpVDZzCyC0sQLaypn5Yjn+JW
	 BHg2nlx0anxiIjACuDHfIytKhjAUcmabK1SpvEOu4DhAdUSUZBO5ZF1KTG0T4tLRsX
	 kHEAnM9JMjEPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	beanhuo@micron.com,
	alexandre.f.demers@gmail.com,
	adrian.hunter@intel.com,
	quic_mapa@quicinc.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.6] scsi: ufs: core: Disable timestamp functionality if not supported
Date: Sat, 25 Oct 2025 11:58:34 -0400
Message-ID: <20251025160905.3857885-283-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit fb1f4568346153d2f80fdb4ffcfa0cf4fb257d3c ]

Some Kioxia UFS 4 devices do not support the qTimestamp attribute.  Set
the UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT for these devices such that no
error messages appear in the kernel log about failures to set the
qTimestamp attribute.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Tested-by: Nitin Rawat <quic_nitirawa@quicinc.com> # on SM8650-QRD
Reviewed-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Message-ID: <20250909190614.3531435-1-bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES. The change adds a targeted quirk for the Kioxia `THGJFJT1E45BATP`
device (`drivers/ufs/core/ufshcd.c:316`) that prevents the core driver
from issuing the qTimestamp write when the device advertises that the
attribute is unsupported (`drivers/ufs/core/ufshcd.c:8799`). Without it,
every link bring-up or reset hits `ufshcd_set_timestamp_attr()` and
emits a `dev_err` because the write reliably fails, so users see
recurring kernel log noise on affected hardware. Introducing
`UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT` (`include/ufs/ufs_quirks.h:117`)
is mechanically simple, does not alter behaviour for other devices, and
cleanly gates the existing code path via the existing quirk plumbing,
making the risk of regression very low. Because it fixes a user-visible
malfunction (persistent error messages) on shipping UFS 4 hardware and
is tightly scoped with no architectural fallout, it fits stable backport
criteria well. A natural follow-up is to validate on the affected
hardware that the spurious log entries disappear after backporting.

 drivers/ufs/core/ufshcd.c | 6 +++++-
 include/ufs/ufs_quirks.h  | 3 +++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 78d3f0ee16d84..1907c0f6eda0e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -316,6 +316,9 @@ static const struct ufs_dev_quirk ufs_fixups[] = {
 	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
 	  .model = "THGLF2G9D8KBADG",
 	  .quirk = UFS_DEVICE_QUIRK_PA_TACTIVATE },
+	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
+	  .model = "THGJFJT1E45BATP",
+	  .quirk = UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT },
 	{}
 };
 
@@ -8794,7 +8797,8 @@ static void ufshcd_set_timestamp_attr(struct ufs_hba *hba)
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 	struct utp_upiu_query_v4_0 *upiu_data;
 
-	if (dev_info->wspecversion < 0x400)
+	if (dev_info->wspecversion < 0x400 ||
+	    hba->dev_quirks & UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT)
 		return;
 
 	ufshcd_dev_man_lock(hba);
diff --git a/include/ufs/ufs_quirks.h b/include/ufs/ufs_quirks.h
index f52de5ed1b3b6..83563247c36cb 100644
--- a/include/ufs/ufs_quirks.h
+++ b/include/ufs/ufs_quirks.h
@@ -113,4 +113,7 @@ struct ufs_dev_quirk {
  */
 #define UFS_DEVICE_QUIRK_PA_HIBER8TIME          (1 << 12)
 
+/* Some UFS 4 devices do not support the qTimestamp attribute */
+#define UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT	(1 << 13)
+
 #endif /* UFS_QUIRKS_H_ */
-- 
2.51.0

