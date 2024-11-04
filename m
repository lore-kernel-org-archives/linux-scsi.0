Received: from mail-m17245.xmail.ntesmail.com (mail-m17245.xmail.ntesmail.com [45.195.17.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F461CD02
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 17:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.195.17.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730742153; cv=none; b=MqN2HI0tvLj+2WazVkCwX+otC5uzHYNoZ8wUHGUaMQurPfEinYLqZrF7hPiOvUWyeByeyUtEZ2Nfb1GsJcAYDbWJxbLphRzgS+QCaBTijwqhbsvP1YEU3P7AhhsYUBUMIQoJhuGWCW2c80rydSSW4F0RLf0uSZ7M8JxGOvEUWRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730742153; c=relaxed/simple;
	bh=6o8KrqWNAQQuemevdB/TGbEXni51XVXB7kOgpglPJHI=;
	h=From:To:Cc:Subject:Date:Message-Id; b=OkBTwy6mWC4Ekm3j3MD1yZ4XSnT3heiZAnIoG6VerYlvVonHBMG0nZgNfhu9Fv/dc7rzJCDIwM5dcOLqcoC6nYIbOZ3v4st2Ev1rVaokJ19dMjK7nK3neK+c1EwX52UcQsMByu7G8c393+KpjzoZxzjMDPoLr6VCg7i+QTe20E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=VjZ9GAWh; arc=none smtp.client-ip=45.195.17.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="VjZ9GAWh"
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1b5d8947;
	Mon, 4 Nov 2024 15:32:23 +0800 (GMT+08:00)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: Rob Herring <robh+dt@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	"Rafael J . Wysocki" <rafael@kernel.org>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	YiFeng Zhao <zyf@rock-chips.com>,
	Liang Chen <cl@rock-chips.com>,
	linux-scsi@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH v4 0/7] Initial support for RK3576 UFS controller
Date: Mon,  4 Nov 2024 15:31:54 +0800
Message-Id: <1730705521-23081-1-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZQh9OSFZJQx8eS01NT09LQh9WFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0
	hVSktLVUpCS0tZBg++
X-HM-Tid: 0a92f616d1f809cckunm1b5d8947
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nhg6HBw*HjIoHjpKHitWCA4B
	TywaCTlVSlVKTEhLTEtOTk9OSk5MVTMWGhIXVQgTGgwVVRcSFTsJFBgQVhgTEgsIVRgUFkVZV1kS
	C1lBWU5DVUlJVUxVSkpPWVdZCAFZQUlMSE43Bg++
DKIM-Signature:a=rsa-sha256;
	b=VjZ9GAWhsJB+tA1g7U+LD0tEazG8JjVGeiRVc8krb7V0MtOZG9q9wqb5hOJWXWgUdR2criLYmbViMkh4iMJGs0XUJoXGffJtoEgEhzZIMB5aXknBCn+QqjVMmUWnNffdwlrpZcHmSxa2PZK48ohpurz3P46PWOSl67XwGh2nNYI=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=4QVkJH8tpr3nsaz5ziKzyPBT7b6uUdsNiuHpGkBl6UU=;
	h=date:mime-version:subject:message-id:from;
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

This patchset adds initial UFS controller support for RK3576 SoC.
Patch 1 adds new quirk and patch 2 is the dt-bindings. Patch 3-6 deal
with rpm and spm support in advanced suggested by Ulf. Final patch 5 is
the driver added.

Changes in v4:
- properly describe reset-gpios
- deal with power domain of rpm and spm suggested by Ulf
- Fix typo and disable clks in ufs_rockchip_remove
- remove clk_disable_unprepare(host->ref_out_clk) from
  ufs_rockchip_remove

Changes in v3:
- rename the file to rockchip,rk3576-ufshc.yaml
- add description for reset-gpios
- use rockchip,rk3576-ufshc as compatible
- reword Kconfig description
- elaborate more about controller in commit msg
- use rockchip,rk3576-ufshc for compatible
- remove useless header file
- remove inline for ufshcd_is_device_present
- use usleep_range instead
- remove initialization, reverse Xmas order
- remove useless varibles
- check vops for null
- other small fixes for err path
- remove pm_runtime_set_active
- fix the active and inactive reset-gpios logic
- fix rpm_lvl and spm_lvl to 5 and move to end of probe path
- remove unnecessary system PM callbacks
- use UFSHCI_QUIRK_DME_RESET_ENABLE_AFTER_HCE instead
  of UFSHCI_QUIRK_BROKEN_HCE

Changes in v2:
- rename the file
- add reset-gpios

Shawn Lin (6):
  scsi: ufs: core: Add UFSHCI_QUIRK_DME_RESET_ENABLE_AFTER_HCE
  dt-bindings: ufs: Document Rockchip UFS host controller
  soc: rockchip: add header for suspend mode SIP interface
  pmdomain: rockchip: Add smc call to inform firmware
  PM: wakeup: Add device_clr_wakeup_path()
  scsi: ufs: rockchip: initial support for UFS

Ulf Hansson (1):
  pmdomain: core: Introduce dev_pm_genpd_rpm_always_on()

 .../bindings/ufs/rockchip,rk3576-ufshc.yaml        | 105 +++++++
 drivers/pmdomain/core.c                            |  34 +++
 drivers/pmdomain/rockchip/pm-domains.c             |   7 +
 drivers/ufs/core/ufshcd.c                          |  17 ++
 drivers/ufs/host/Kconfig                           |  12 +
 drivers/ufs/host/Makefile                          |   1 +
 drivers/ufs/host/ufs-rockchip.c                    | 340 +++++++++++++++++++++
 drivers/ufs/host/ufs-rockchip.h                    |  51 ++++
 include/linux/pm_domain.h                          |   7 +
 include/linux/pm_wakeup.h                          |   7 +
 include/soc/rockchip/rockchip_sip.h                |   3 +
 include/ufs/ufshcd.h                               |   6 +
 12 files changed, 590 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml
 create mode 100644 drivers/ufs/host/ufs-rockchip.c
 create mode 100644 drivers/ufs/host/ufs-rockchip.h

-- 
2.7.4

