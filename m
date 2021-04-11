Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2FD5C433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE5D761026
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbhDKG27 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 02:28:59 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:11090 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbhDKG26 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 02:28:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1618122523; x=1649658523;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ao9KGLtiOtOXMs3JVdpAkduZXjxNqr5ZEmzsn/ujCvI=;
  b=k3rwPB+JprapyB1aIMYbGjD+/jdcj47QrCJi87NZq7sEeUx31zkURg4D
   aKimkzcZQc9mP3iNIXeVxUR9MFGcHb1KTsRmlbVI/BBtCj4WNHgONp0l4
   9YiR8oDSk86+74hW5fb2zhP5CPs/y2be+bzrduReC3svxA/q78hm+Y+uw
   ekjMLIuk28P/fug/G5JdPpH9k0CjtxvhcpBn9cCs/rGv4h54p+DwqLJtQ
   0RZvbxE/wTT0ysvQQbRpRLbwps6JRU5yI+7CRQmdor2jeQIpiFFU+VGVx
   sVRvXLfIQ4TPGASZ9FMffGVMSOwvbFH2jGqMVbzHINXkiHYyW0mr27ol7
   w==;
IronPort-SDR: t/xg9quJFQ3C1mVEotuXyfSrMh9alcw1jWSheluQ/oQ17INjhiMtK/S9thtsmLbb4KfzAGlv+s
 1qYJhS+wxX85yL5i2xJU7y+lZ5Qqpd765E4doOQYh4xeYiI48lkgQzPOcQMGfRn8Ug/Gfy1Sgp
 3Iu+BpnoCYrsDa1ZC6rb+Y5J1KMCoqZAE4/ySEjEZbWN7CZh0kN5oEDptrtrDXD1MgwdImlsPU
 u8spNAicqcygmbP6OumL6HgQNe59n/O7RJZLpMcxrKQP7Zway8eibH4OComIygtFfhj89Wesis
 4cw=
X-IronPort-AV: E=Sophos;i="5.82,213,1613404800"; 
   d="scan'208";a="164405572"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2021 14:28:42 +0800
IronPort-SDR: yMJI9sM3IbxphBiym3u9uDW55Lny7xsrQiUdhebx7BIuKwLiHEWwjcTuJ14LQPCQ4isAgflzk6
 vmVGouq/am8hZYt1B4VdmO41+D3e2qQeDxDofg+B4TcWLo+3GuO5VsMPt/FR0JRt4tw/ijSYir
 sc3qDDzoIXsUCRSRp2lQtmdL40LWZa1lAqj1K4ose+WeivY60y1okCxlZbn9hmTq/uyZhrU32p
 ZWl7Ay6WO5pNv8xh2m9pot/7nXxMIUdXfBXZ7+nrvIZ/bT7CLq5473sam+R3lIIXAxBQKZmkis
 5fRaCNv1aDtlOCbdBXvY9pgx
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2021 23:09:50 -0700
IronPort-SDR: 87XWyqQF05GCLMz+d9rSV+5/ATvtE3UjFpwFtsNreeqaZSV6wAPRu9JIstVCd7fQYCznk9496I
 4BK71sO///uleBL1kKLsvNMjAZHOCwgsASxB2FGoKKM8j/XOQ060N0pPSRvseVsdkU4NXZ/nMA
 Z8u9ZChuZec0+DJ6qE92CIaB0rYw/f30RSFronryxxSaHTZ2obuph+oX2/6IXq853tRM6oGwBz
 9VvcyFRrbP8sCiiAZXLGFK3FUGsQLm4I95qbYOLd0eleo5lSz72HNaVgCKIFIpmQxw/aPBADDv
 DhI=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Apr 2021 23:28:38 -0700
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
Subject: [PATCH v8 10/11] scsi: ufshpb: Add support for host control mode
Date:   Sun, 11 Apr 2021 09:27:20 +0300
Message-Id: <20210411062721.10099-11-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210411062721.10099-1-avri.altman@wdc.com>
References: <20210411062721.10099-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Support devices that report they are using host control mode.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 0f72ea3f5d71..3c4001486cf1 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2587,12 +2587,6 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 	u32 max_hpb_single_cmd = HPB_MULTI_CHUNK_LOW;
 
 	hpb_dev_info->control_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
-	if (hpb_dev_info->control_mode == HPB_HOST_CONTROL) {
-		dev_err(hba->dev, "%s: host control mode is not supported.\n",
-			__func__);
-		hpb_dev_info->hpb_disabled = true;
-		return;
-	}
 
 	version = get_unaligned_be16(desc_buf + DEVICE_DESC_PARAM_HPB_VER);
 	if ((version != HPB_SUPPORT_VERSION) &&
-- 
2.25.1

