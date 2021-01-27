Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F826C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1056C207BC
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235801AbhA0PYd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 10:24:33 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:51782 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbhA0POV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 10:14:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611760460; x=1643296460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pYqNFpWu5gdPAJjbMMciUgh9gaj1oKk/cLrxHPOh+G8=;
  b=QpuCXwWra1axa5mmSilLb3WVeC9awCyru0dLvVjjTMkphhw9n0rW/aCp
   6zEw/rqj74XauWFc56QoRlKCuBJYzMymidnQMyvAoHOzlV3Ft6pu+qDCn
   HTMZIqauxKGvxozfCz4dg69YeVNBTziTQsblhiyHj1mrNkToyatD951pq
   EfvVr+LyCs41aKZISdlH49E4j+024BtlT212OuWvamj6LzeFUCNQS9+yZ
   ggXBhMFVZILVtzBPPiBLO+NM7mhPwZsP7CLcWMA1NNSXefZQSupSec0lc
   Hn+yxksNfpICrzhrtLNHANwatZhv+HgGb+WM+vu8aG7+hVv7Z4puqz5sq
   w==;
IronPort-SDR: DM3vvhmWQPZ22e0speaI34nn/kafJkycYudWC5F0GCDsr3nkj2SySXuEfTFXMNhnDVRR+2cY4y
 FdWTbYXH5O1JT1zj47tIF3X9FGVkjxBgq4YXcjvS256/RfK3Sm61vj58SriQrXhw+kJHGvFBot
 2XrWcqy2aLmwF2G9Orj0dib3HAymusvHAU5vs0UD0TuLWR7kkWiXWCKq72QtxyYxElph0ZJenj
 d8Uqrg9+LC82fnr1SY7QZHe6JTTGeIySsIBRGiErnyqDC32Trh6FRuH1oR1beBrJasXFDY5T6B
 Q9M=
X-IronPort-AV: E=Sophos;i="5.79,379,1602518400"; 
   d="scan'208";a="158454188"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 23:12:50 +0800
IronPort-SDR: j9uaeg9ovkYwmvKrEmEgQK442LzxJQ6vVZugPyksY8DbenSeuhqTvkkPE0VEBGFNWVwBGtFKaH
 EKCPGk1hUqoQtR0pfl9HC8gJs7ozpTfoRd0IthWRJpsFZbg7K5nLF6gTSB5869nvB5m63bjrRz
 Vj6Iq5HEFq34QBkh32UpDhkz01cYJ0hmR80IKHX8q1zgTrOapdkutddYkg3XjipVg3kuZL1cUl
 rihoztpYY7Fdss/o5SAon52hexqQrRZTrwWvRjG5qrDdXAZjRa7IaotwTNziuwewGnJLiVeMrO
 QDgwlgvqzCjLFTnhmo/Kh7hG
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 06:57:10 -0800
IronPort-SDR: OoREcpqAz05j/2BjvIBTgK++qemH9rDka295k2VVoMO+Qei8qKNmtT3C30E+Y4pGEjjB8NYgNi
 AckljoYNl9XRWGFtMXZFB8aR2DjhenFG1070ZobvUhcVm5DaRVF0E+nRXlvCGLFs6LQQE9czZu
 fl/ufdYjO441BWlnLsQmvsXnvP3GlQ9ayiSjQ2bzgV4hX+0F8bs/eEwkIm21dq7tHnvMG4c34e
 1BDcTsAyDfz3AvA4Hvt8PV3JpLNwIJP9D4L7nRImmz4d6DYUdxfGcct5ZLBLC8kpxGE2VwwOMi
 E44=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 07:12:46 -0800
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com, Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 1/8] scsi: ufshpb: Cache HPB Control mode on init
Date:   Wed, 27 Jan 2021 17:12:10 +0200
Message-Id: <20210127151217.24760-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127151217.24760-1-avri.altman@wdc.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We will use it later, when we'll need to differentiate between device
and host control modes.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index d3e6c5b32328..183bdf35f2d0 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -26,6 +26,8 @@ static int tot_active_srgn_pages;
 
 static struct workqueue_struct *ufshpb_wq;
 
+static enum UFSHPB_MODE ufshpb_mode;
+
 bool ufshpb_is_allowed(struct ufs_hba *hba)
 {
 	return !(hba->ufshpb_dev.hpb_disabled);
@@ -1690,10 +1692,9 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 {
 	struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
 	int version;
-	u8 hpb_mode;
 
-	hpb_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
-	if (hpb_mode == HPB_HOST_CONTROL) {
+	ufshpb_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
+	if (ufshpb_mode == HPB_HOST_CONTROL) {
 		dev_err(hba->dev, "%s: host control mode is not supported.\n",
 			__func__);
 		hpb_dev_info->hpb_disabled = true;
-- 
2.25.1

