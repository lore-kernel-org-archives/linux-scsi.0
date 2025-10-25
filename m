Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F00230C356;
	Sat, 25 Oct 2025 16:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409715; cv=none; b=CTPIWaClP7gsIujw3FhsOGU5ya+ghqu+jpQCqJsB5VjW+68gcI/jHEwvIaI6qyGkkE6plwihWiG3IF0vcd8E+vLmH4/GW7HJXUsWjrN6B0AWX6MhuNUfT+ZbST6ZjYnxdRanFrk1sCDB9v6/nxs9xBlnwCQ/24PBfGW7D9Stzz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409715; c=relaxed/simple;
	bh=CLqaQgkzPOzD3Ln+l6Amho4m8VJFOpbmgtpz+XkVQBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uieGB97L1Ate9ux99wu/D+KdjlD7byBw24MQSetYOo4w6Crxyn/Xsn4pEOVZ17dpe168AAIeAOocb+znvawGJzOLyLwNkammnFmxgMB/b+lgB9WB0qJR2DrXSqmqMbLO/wK7Ljn+BFPwWRtZbvNNOo+0t/CEsnBEWGp72TV1nXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sI8I5sEp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sI8I5sEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC38C4CEFB;
	Sat, 25 Oct 2025 16:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409715;
	bh=CLqaQgkzPOzD3Ln+l6Amho4m8VJFOpbmgtpz+XkVQBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sI8I5sEpCRbRf4U0WIm0d5NDV9eQOP6vnz8OTpiFO46aYwq5aoYouRvTXSTyxSkJy
	 Dvrq/YgF9i3oTRDKMbLhxxhHFnqvF2I8x5sU6GJ2LBr95c6iETyCCpokCo3kP/Yff9
	 PtwX+GTrzkq9EiuyUXNXRKrntZCGgSeVyL6DXNbkZkOBXUCVQ/+o4hnUaRRIvCDFjL
	 KxSoIMyI502KTbRB0cvuh/bCnBW2xRdkfN++wdkkHRiF5361CzwaloEa1ic7BmXKzY
	 4F+HLaaocsWhnNNeKQ2aczk0sbvpqp+MieA4cwAP4wyprNL9tTArk2opLjEeH2qkxe
	 bd9ZPDrI2uvvg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	jinpu.wang@cloud.ionos.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] scsi: pm8001: Use int instead of u32 to store error codes
Date: Sat, 25 Oct 2025 12:01:04 -0400
Message-ID: <20251025160905.3857885-433-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit bee3554d1a4efbce91d6eca732f41b97272213a5 ]

Use int instead of u32 for 'ret' variable to store negative error codes
returned by PM8001_CHIP_DISP->set_nvmd_req().

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Link: https://lore.kernel.org/r/20250826093242.230344-1-rongqianfeng@vivo.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Preserves negative errno from `set_nvmd_req()` by changing `ret`
    from `u32` to `int` in `pm8001_set_nvmd()`, avoiding silent
    conversion of negative errors to large positive values.
  - With `u32`, a failure such as `-ENOMEM` becomes a large positive
    integer, causing the sysfs store handler to return a non-error
    positive value instead of `-errno`.

- Where it changes
  - `drivers/scsi/pm8001/pm8001_ctl.c:685` changes the local variable
    declaration in `pm8001_set_nvmd()` to `int ret;` (was `u32 ret;`
    pre-change).
  - The function body uses `ret` as an error status:
    - Call site: `ret = PM8001_CHIP_DISP->set_nvmd_req(pm8001_ha,
      payload);` `drivers/scsi/pm8001/pm8001_ctl.c:705`
    - Error path check: `if (ret) { ... return ret; }`
      `drivers/scsi/pm8001/pm8001_ctl.c:706-713`
  - The return is propagated up to the sysfs store handler:
    - `pm8001_store_update_fw()` returns `ret` directly on error:
      `drivers/scsi/pm8001/pm8001_ctl.c:863-867`

- Why this matters (callers return negative errors)
  - `PM8001_CHIP_DISP->set_nvmd_req()` implementation returns negative
    error codes:
    - `return -ENOMEM;` and `return -SAS_QUEUE_FULL;` in
      `pm8001_chip_set_nvmd_req()` at
      `drivers/scsi/pm8001/pm8001_hwi.c:4468-4479`, with `rc` typed as
      `int` (`drivers/scsi/pm8001/pm8001_hwi.c:4460`).
  - Without the type fix, the sysfs store handler may return a positive
    value on error (misreporting failure as success or as a bogus
    positive byte count), violating sysfs semantics which require
    negative errno for errors.

- Scope and risk
  - Minimal, localized one-line type change in a driver’s firmware/NVMD
    sysfs path; no API/ABI or architectural changes.
  - Aligns with kernel conventions: error paths must return negative
    errno; the fix makes the function signature and return values
    consistent.
  - Touches only pm8001 control path, not I/O fast path.

- Stable backport criteria
  - Fixes an end-user-visible bug (wrong error reporting through sysfs).
  - Small, self-contained change with negligible regression risk.
  - No feature addition; strictly a correctness fix.
  - SCSI maintainer sign-off present.

- File references
  - drivers/scsi/pm8001/pm8001_ctl.c:680
  - drivers/scsi/pm8001/pm8001_ctl.c:685
  - drivers/scsi/pm8001/pm8001_ctl.c:705
  - drivers/scsi/pm8001/pm8001_ctl.c:863
  - drivers/scsi/pm8001/pm8001_hwi.c:4460
  - drivers/scsi/pm8001/pm8001_hwi.c:4468
  - drivers/scsi/pm8001/pm8001_hwi.c:4479

Given the clear correctness improvement, minimal risk, and user-facing
impact on error propagation, this is a good candidate for stable
backport.

 drivers/scsi/pm8001/pm8001_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 0c96875cf8fd1..cbfda8c04e956 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -682,7 +682,7 @@ static int pm8001_set_nvmd(struct pm8001_hba_info *pm8001_ha)
 	struct pm8001_ioctl_payload	*payload;
 	DECLARE_COMPLETION_ONSTACK(completion);
 	u8		*ioctlbuffer;
-	u32		ret;
+	int		ret;
 	u32		length = 1024 * 5 + sizeof(*payload) - 1;
 
 	if (pm8001_ha->fw_image->size > 4096) {
-- 
2.51.0

