Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81214C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 10:51:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D9A964EAA
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 10:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhBKKuZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:50:25 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:59461 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhBKKsP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 05:48:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613040495; x=1644576495;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NjwxuvWr0oM+PPdY3/S16g2G39NbLZJsXin0D+Xy6DI=;
  b=p8EC41/L6WP+5HwnAjMhAMvg9p4JaMc/PftjOS39xntf765c56X/+tuj
   2h3OLDQ8q0+kwREFBo/Blaplb4bQJ8+YBhQckblWh2QFTxlDF3cLH44kL
   kiKuZBRZwtdqGUhDWZLcVd5poy28i/aELT0r7651WQpjOGzWBlELdoUMp
   5+P23tGRaFwwPJYm46Wbowub+j7or+85Ig1MU2AyaF3Ornf1Uc0ar2Qtt
   nMol0f2yqA6gBrz/C2uw/ZSQnXxt13MdyKr0Jan9/8Bc0PnbEqGiNcYzt
   DKv6tP66A8MSbu7RaZyr9U8NBWLVB2JmIQG7jJdJPVHdE/DiPcUTBl07h
   Q==;
IronPort-SDR: 4gobFUIXTEENKK8YIPMNy1ZaBybJkVpG0ejp2VhQCPe3Ei1JeBBelegUI4RNZDHKhfB0UXoG0e
 xvxv3gc8jzS9168HZopDT44JqknZhLF1jSdjXPc35meK4zerHyndSDTTPg3c7smC6NMJ+cZnHX
 sRd2HbaOC+MP/tJkUoWEN6X8q20A7U85VOiuWW7ryyaPxk2V+P6VahKlCs7Ux24Smg/fJfs98b
 cG3+Uuc19ZxJuCtSRHwoLwp/jmIgPL32ALmRCrdTChBUl0nNGlzoMsihuSjtXXSK5fZcZxMNTz
 IVI=
X-IronPort-AV: E=Sophos;i="5.81,170,1610380800"; 
   d="scan'208";a="160915498"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2021 18:47:10 +0800
IronPort-SDR: /MfYy5YXQ0R9Nio7ueIpp3z4EQ83T4mHoNpnup9A5PyMgrg8LP6JkDX1uTXuQcuvFeTl8ds4PJ
 Y+uAOfTnbjjO964akxzC2yiw6YxN5DIvDBtEowkACfB3B/WQwiLg8CHfnWuslZ7rVKAaZjMFrW
 OzJ1o0Oqiq2x4Cm7ksvxRRa/UNGxO6dJLqYvL1puwIr/Dqwou9X2VuYr9Cv7Zu4BndYQDZJ16v
 8Cn1yL6t2ndFfV1Ba3OKiG1VFAIeuYdjdEgQV9jTcIYYvyr5amVF6wi3Bb8f5gtbQo3H2oqlQp
 +zguczIB7TetI0KlbrOkc5/C
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 02:29:01 -0800
IronPort-SDR: MjBnQt4zUXrQDfE1UL5FNloy9BivWQJ4Uy/vXXTZRvuTAWHKuCyGBALZMZwjScj9mq6MzSnw+A
 WNd15bhIl4GREUJtZaPqgEYuaONc64a11asZuGmBlt2/GW3ven/043ZYdJyWb+/dJUmVUdfjYq
 n5lYP6CSdXC5Pp9mPjSZV/609pFwIdH4nzxZzDT1RRUqV9xNLJSTqOPJ3xVTFm9lJ8+R+YcAX8
 Niy5foz66NwxrwZ6ifZI2oT0kyY8LMqi00xChZN4N4yKWQSafvekuxrvimArorSXTiQiWmG7bA
 0Y4=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 11 Feb 2021 02:47:08 -0800
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alim.akhtar@samsung.com, Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs: Fix a duplicate dev quirk number
Date:   Thu, 11 Feb 2021 12:46:38 +0200
Message-Id: <20210211104638.292499-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

fixes: 2b2bfc8aa519 (scsi: ufs: Introduce a quirk to allow only
page-aligned sg entries)

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index ee61f821f75d..18e56c1c1b30 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -570,7 +570,7 @@ enum ufshcd_quirks {
 	/*
 	 * This quirk allows only sg entries aligned with page size.
 	 */
-	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		= 1 << 13,
+	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		= 1 << 14,
 };
 
 enum ufshcd_caps {
-- 
2.25.1

