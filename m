Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C6AC433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 02:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 859ED60200
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 02:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhCWC7V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 22:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhCWC7H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 22:59:07 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 317B4C061574;
        Mon, 22 Mar 2021 19:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=6nGflbw2M1
        nIAUTSCNcXju9H6GH0cycjGJaL9m/nRSQ=; b=j2XvpBSWRPZBPZvAHsLRH6+C1W
        fqDtDX3Z26z0fnwnPyDannxRz0TavFTWo8wG58SSkNH5QQrrYCAPnKvJMfuu8FWh
        Rpx0CaH4knOASrlqcWSw0M0zTzWs+hjY63uOpd9/C9dnslqtqoDNstrva1gK8u0r
        /dPkclKgSkvjXkX0s=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygBHTkpuWVlgfX4ZAA--.517S4;
        Tue, 23 Mar 2021 10:58:54 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] target: Fix a double put in transport_free_session
Date:   Mon, 22 Mar 2021 19:58:51 -0700
Message-Id: <20210323025851.11782-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygBHTkpuWVlgfX4ZAA--.517S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtF17tr1xtrW5uFyxJr15XFb_yoWkAFb_CF
        1F9wnrWF1Fgw4DKr47G3W3Xry2yF9Y9F1IvFs2k3yjgrykZF1rJrnrJFn3u34jkrWrZryF
        yrnFyr1Dur4UXjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbVxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
        rcIFxwCY02Avz4vE14v_Gr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjfUO6pBUUUUU
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In transport_free_session, se_nacl is got from se_sess
with the initial reference. If se_nacl->acl_sess_list is
empty, se_nacl->dynamic_stop is set to true. Then the first
target_put_nacl(se_nacl) will drop the initial reference
and free se_nacl. Later there is a second target_put_nacl()
to put se_nacl. It may cause error in race.

My patch sets se_nacl->dynamic_stop to false to avoid the
double put.

Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/target/target_core_transport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5ecb9f18a53d..c266defe694f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -584,8 +584,10 @@ void transport_free_session(struct se_session *se_sess)
 		}
 		mutex_unlock(&se_tpg->acl_node_mutex);
 
-		if (se_nacl->dynamic_stop)
+		if (se_nacl->dynamic_stop) {
 			target_put_nacl(se_nacl);
+			se_nacl->dynamic_stop = false;
+		}
 
 		target_put_nacl(se_nacl);
 	}
-- 
2.25.1


