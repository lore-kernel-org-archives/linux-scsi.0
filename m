Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1525AC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 02:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiCCCHa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 21:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbiCCCH3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 21:07:29 -0500
X-Greylist: delayed 906 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 02 Mar 2022 18:06:44 PST
Received: from mail-m972.mail.163.com (mail-m972.mail.163.com [123.126.97.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E479108742
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 18:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=zQiqJ
        MMK3nLRrtLWwk0/n0GVF6Y3EScFNSuSayheZUw=; b=JZ/RQWOo4LkyI9KS8H0Bz
        yVctZZxQEKmaazdKVi9m8U2bYd8R0h5/sTpwqAVKb4+Akj8581HPCBiWx+RURmxL
        yJtrQT8sWLN3mCxF4e+V1U10ci16fiBfimSpVZSn9R2b35TBeA3/9ci43s2GHIPN
        /3uA0G+/ojrMLmLVOl3UVc=
Received: from localhost.localdomain (unknown [218.106.182.227])
        by smtp2 (Coremail) with SMTP id GtxpCgDn708VHyBiSEeUAA--.9337S4;
        Thu, 03 Mar 2022 09:51:26 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     hare@suse.de, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] scsi: libfc: Fix use after free in fc_exch_abts_resp()
Date:   Thu,  3 Mar 2022 09:51:15 +0800
Message-Id: <20220303015115.459778-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GtxpCgDn708VHyBiSEeUAA--.9337S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrKrWkJF4DWrW5urWrZr1rtFb_yoWDJrc_ua
        9rGr17Gr1UtrWxWw18GF4fZrWa934DXFnakrn2qF1fuay5urWkZF1UZr95ury5Ww4UKFZx
        Gr4DWryrAF1avjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREzuWtUUUUU==
X-Originating-IP: [218.106.182.227]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiQx64jFc7XpxpwwAAst
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

fc_exch_release(ep) will decrease the ep's reference count. When the
reference count reaches zero, it is freed. But ep is still used in the
following code, which will lead to a use after free.

We should return the function after the call of fc_exch_release() to
avoid use after free.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/scsi/libfc/fc_exch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 841000445b9a..aa223db4cf53 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1701,6 +1701,7 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 	if (cancel_delayed_work_sync(&ep->timeout_work)) {
 		FC_EXCH_DBG(ep, "Exchange timer canceled due to ABTS response\n");
 		fc_exch_release(ep);	/* release from pending timer hold */
+		return;
 	}
 
 	spin_lock_bh(&ep->ex_lock);
-- 
2.25.1

