Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.243.164.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795076113;
	b=QDZHbz/i2R3WprjF6ythV1pwf5/Dn+Uj5WRKnHGj5zR6jO+Ow2v+MffnhdRmssKhjyuL
	 3g5og1PJBEoPPfpl3t0uIU7w/shpua08v55QAKf09D+MRPSvy3cHgbNMXkMgggJVDh7Jq
	 hZhFY5nMQ5bav4bWzUEs06OIZgyhryS8iFodtJe6oa49S7nVlmQrOjilbdG/R7gga7PuL
	 /nqxkjWYwoOHxab4px6BCVass5CXui48YsMK/iPBQ4ov5sbFJ3tO0dhihnmISp7wfV2BG
	 CYrREkX/V434aOv3wY+aOYHDrzQnCN2510SWgfSM4DgPoFsO2pkGRPl3NAV47RtOKhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795076113;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=1irIRjHKghdqAx6LNzlKrGBMmDetxdA7XJtHT0RzPew=;
	b=JrQCnnIawQ5IUGneqM6t6upK/oWBY5/T6CHy+i2dZLOQpFZXn8QBCypd5k6GN2Wjmksh
	 8/jjYXtPXlGQTN6RhsZoj8ShIZdAsz/lAmIsh+BJoAxPRuLWN3f5cr2K2QL6KbOzdjmtm
	 Xt4nvVc986tadZ1tBd6oXwo+xRpcTf88C+OYLewP7b1+LDPVvWc6/VzpI1woPYQogi67+
	 M8EILDGmDeDU/B9+NhjDEDEwln+7PIJOnVC8B3CFtpPjwVspNsGujzOBRfx31UmkgJVPW
	 ZiEAHLKCEqZVt1DLgkau16KiMnv03u7PCJRpCdHi+vGThjnOt56yYKpfwNWLnHevaYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.zgclab.edu.cn;
	spf=pass smtp.mailfrom=mail.zgclab.edu.cn;
	dkim=pass header.d=mail.zgclab.edu.cn header.i=@mail.zgclab.edu.cn header.a=rsa-sha256 header.s=dkim header.b=A5qcdM2K;
	arc=none smtp.remote-ip=162.243.164.118
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F38B60A5BCA;
	Thu, 19 Nov 2026 08:15:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F38B60A5BCA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mail.zgclab.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.zgclab.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.zgclab.edu.cn header.i=@mail.zgclab.edu.cn header.a=rsa-sha256 header.s=dkim header.b=A5qcdM2K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mail.zgclab.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
	Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1irIRjHKghdqAx6LNzlKrGBMmDetxdA7XJtHT0RzPew=; b=A5qcdM2KE+9pQ
	4aptEoW/+91qAcIQalcj4o/NGuLsBFeEBzIYptc24cHqRxEVnET/S+Xr4cRQo/R/
	8u/l+L2UBPpjBhmNW2agkLoZ8RJ3HIToje28GKOJ2cgfzb05KP1wwtU549Cliy3m
	0JAesnDrBQuQ7sNiKViM1ybUUrzrFI=
Received: from 13.eml (unknown [58.206.202.11])
	by web2 (Coremail) with SMTP id yQQGZQBHcmYLsP5qiyJLAQ--.56742S2;
	Thu, 19 Nov 2026 16:15:07 +0800 (CST)
From: Wang Haoran <wanghr2026@mail.zgclab.edu.cn>
To: James.Bottomley@HansenPartnership.com, mkp@kernel.org, orsonzhai@gmail.com, baolin.wang@linux.alibaba.com
Cc: zhang.lyra@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, wanghr2026@mail.zgclab.edu.cn
Subject: [PATCH] scsi: ufs: sprd: disable vdd-mphy on exit
Date: Thu, 19 Nov 2026 16:15:08 +0800
Message-ID: <1795076108324-13-67797508@mail.zgclab.edu.cn>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:yQQGZQBHcmYLsP5qiyJLAQ--.56742S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tw43JFW3WrW7Jw1fGF1fCrg_yoW8WrWkpF
	W5u397Cw1DGFWIkFZrZr1aya4rZws5G347GrW29w45Ja9Fyr1xXr97Kr1S93WqqrZ5XF1Y
	qayrJ34fGanrXFUanT9S1TB71UUUUjUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxV
	W8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x0
	82IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWrXw
	Av7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwAC
	jI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_Jw0_GFylc2xSY4AK67AK6r43Mx
	AIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1Y6r17
	MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67
	AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0
	cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4
	A2jsIE14v26F4j6r4UJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2Kfnx
	nUUI43ZEXa7VUjtEf5UUUUU==
X-CM-SenderInfo: pzdqwxbusqjlo62juzldeovvfxof0/1tbiAgUQD2r+rloDeAAAsD

ufs_sprd_n6_init() enables the vdd-mphy regulator but there is no matching
exit callback, so the rail stays on for the whole lifetime of the host and
every unbind, error recovery or host re-probe that runs init again
increments the enable count without ever decrementing it. This is not a
failure-path imbalance but a normal-operation one: the mphy rail is powered
from probe until shutdown and _regulator_put() warns on each release.

Add an exit callback for the n6 host variant that disables the regulator.

Signed-off-by: Wang Haoran <wanghr2026@mail.zgclab.edu.cn>
Fixes: df7320bac37e ("scsi: ufs: ufs-unisoc: Add support for Unisoc UFS host controller")
---

diff --git a/drivers/ufs/host/ufs-sprd.c b/drivers/ufs/host/ufs-sprd.c
index 8c0a13e95556..c812eb3e6b11 100644
--- a/drivers/ufs/host/ufs-sprd.c
+++ b/drivers/ufs/host/ufs-sprd.c
@@ -266,6 +266,13 @@ static int ufs_sprd_n6_init(struct ufs_hba *hba)
 	return 0;
 }
 
+static void ufs_sprd_n6_exit(struct ufs_hba *hba)
+{
+	struct ufs_sprd_priv *priv = ufs_sprd_get_priv_data(hba);
+
+	regulator_disable(priv->vregi[SPRD_UFS_VDD_MPHY].vreg);
+}
+
 static int ufs_sprd_n6_phy_init(struct ufs_hba *hba)
 {
 	int ret = 0;
@@ -394,6 +401,7 @@ static struct ufs_sprd_priv n6_ufs = {
 	.ufs_hba_sprd_vops = {
 		.name = "sprd,ums9620-ufs",
 		.init = ufs_sprd_n6_init,
+		.exit = ufs_sprd_n6_exit,
 		.hce_enable_notify = sprd_ufs_n6_hce_enable_notify,
 		.pwr_change_notify = sprd_ufs_pwr_change_notify,
 		.hibern8_notify = sprd_ufs_n6_h8_notify,

---

The vulnerability was found by static analysis.

