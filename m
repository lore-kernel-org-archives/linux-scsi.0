Received: from mail-m3276.qiye.163.com (mail-m3276.qiye.163.com [220.197.32.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560B71BDAA6;
	Tue,  6 Aug 2024 09:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722934811; cv=none; b=gp3EoOM0dROsFTKEa0FVqnygmGSYmB0GsyxxBcZft5ZObp9m6MpiTP4zYCJ+xYZDZgfMj+i4xhd7wuNherjvA9PJl5NSRfaz7neJ3XcWoaWU/l6tExJ4tCfrqCXn2HdPpqzlZLICC4JoUeDRjcr7iSPTJZPYy+oo2ptikIte0Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722934811; c=relaxed/simple;
	bh=kMdWiSf/1boSmTUNkizBwwGriN3drglDRJ9RHmZOWBo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=cLSG/MG9qQ1/RjeOAin0k62BOx2szO4tLMrjx0xkSwjybDSVGbpMNRcDJNPj87FsVsHN1GCByb/YIe1PacFTpi96VL3xI2ZmjAXtEKyajsiiyT5oO0VWgHkAgHbyX4Q/Oy5zjROnnTjAF2hkD2nu8Up8Qy6wMVEFe/5Ngtg7iP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=a7+pmduT; arc=none smtp.client-ip=220.197.32.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="a7+pmduT"
DKIM-Signature: a=rsa-sha256;
	b=a7+pmduTfaZo0RXuqTOAD3tak+CNX30MER8fidFZ0XQAtSkmwBR0zgW6aeldCe751FPR+pcN8DnQzDgHun5M3GRPDkNVxhbY0hKiyUp3vZ3DBfAsbWOmKK+u1PoG+E6emaUCc7tzxX7sLaY0Kwa8U3af6qZfNXrAfqIjaT3h2Qk=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=oO6QiV9LFiusHne5Uw00k4qSuVf5cRytxrG80x+Kk2c=;
	h=date:mime-version:subject:message-id:from;
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTPA id E04A64604F7;
	Tue,  6 Aug 2024 15:20:15 +0800 (CST)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: Rob Herring <robh+dt@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Heiko Stuebner <heiko@sntech.de>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	YiFeng Zhao <zyf@rock-chips.com>,
	Liang Chen <cl@rock-chips.com>,
	linux-scsi@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	devicetree@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH v1 1/3] scsi: ufs: core: Export ufshcd_dme_link_startup() helper
Date: Tue,  6 Aug 2024 15:19:58 +0800
Message-Id: <1722928800-137042-2-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1722928800-137042-1-git-send-email-shawn.lin@rock-chips.com>
References: <1722928800-137042-1-git-send-email-shawn.lin@rock-chips.com>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZQ0MZGVYdGUsfSEpNGUlJGRpWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSUhCSE
	NVSktLVUpCS0tZBg++
X-HM-Tid: 0a91268f617403aekunme04a64604f7
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NDo6Ayo*NDIxCxIvCjgrSgod
	A0saCQFVSlVKTElJQklDQ0pMT09KVTMWGhIXVQgTGgwVVRcSFTsJFBgQVhgTEgsIVRgUFkVZV1kS
	C1lBWU5DVUlJVUxVSkpPWVdZCAFZQUhKTE43Bg++
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Export it for host drivers.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

 drivers/ufs/core/ufshcd.c | 4 +++-
 include/ufs/ufshcd.h      | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8f4abc5..e09f004 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4019,7 +4019,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
  *
  * Return: 0 on success, non-zero value on failure.
  */
-static int ufshcd_dme_link_startup(struct ufs_hba *hba)
+int ufshcd_dme_link_startup(struct ufs_hba *hba)
 {
 	struct uic_command uic_cmd = {
 		.command = UIC_CMD_DME_LINK_STARTUP,
@@ -4032,6 +4032,8 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 			"dme-link-startup: error code %d\n", ret);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufshcd_dme_link_startup);
+
 /**
  * ufshcd_dme_reset - UIC command for DME_RESET
  * @hba: per adapter instance
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index cac0cdb..8bc28c1 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1432,6 +1432,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 void ufshcd_hold(struct ufs_hba *hba);
 void ufshcd_release(struct ufs_hba *hba);
 
+int ufshcd_dme_link_startup(struct ufs_hba *hba);
 void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value);
 
 int ufshcd_get_vreg(struct device *dev, struct ufs_vreg *vreg);
-- 
2.7.4

