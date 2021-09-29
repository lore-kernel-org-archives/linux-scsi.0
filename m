Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36062C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 02:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F11861350
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 02:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243785AbhI2DAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 23:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243259AbhI2DAf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 23:00:35 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EBCC06161C
        for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2021 19:58:54 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y63-20020a253242000000b005b6c5e3fb71so1614766yby.18
        for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2021 19:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=hqvQUZKEo+iLmUpX8FVbFDsz80BCvrjXe9w+cQoOnZU=;
        b=ozLqJWWD6a5RdzxqAQxPg0QYWLUOhtqJhDf/hHFWy2jiI1edoVqxa9L1nGcqr1llmM
         Rc/CGBN/RLW4yit613IJyBRA/yBrSG5eJ+ctoJUgsc7Z0b6RF0+me+VsnRUiiRZkQem1
         +iZKs7AL14JnMaORX8uWRCtiK873Qlzfr51I3XLogyDf7tJQzEYr+4ThoVzUUZ5AVviK
         LlThN1QVRQAdwECmC0Oe3+ftfWfOXWQzSfSvFn+biYjofL+62vS7twl0SpnBC9ieKKLv
         RN2BA1lrnin/d2N4mKm/5qKpVCy8nl3w8jR66hNFdg1oniTE1AzMP8jOjiXqwKBNosWn
         lekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=hqvQUZKEo+iLmUpX8FVbFDsz80BCvrjXe9w+cQoOnZU=;
        b=4+45drT58dXKVfz41ZiX4wqypzdhlRvEuQnl5G+8C7vKT+Oz/KoBa4lg874NqF7+x7
         V2LfQnpVL+c4PCmlznhnfFUol+Ji9deK4NfzMSMxXG5FB3AXfq5u1QEv8/XQGcJBrjnH
         IBOQ3IraNU5HPpZgm+VyraX9sjl+ssqQx/2QgoFTCJOh3+AkoDJ2L9+k48C/KusBImxW
         y1WnLCpmB6e0dvIie2lVqms3z+AzlqRDaUOQXvKb4YC0nEl9TwfekFWWK8KjnbzBJeTE
         5qrkmYVj6/VaH1F1A+/CxdUhI/Dxm6N0G7tpV+yG+JaWEc/NS5EyqfKnDiRZiZkJPzs0
         Z1Kw==
X-Gm-Message-State: AOAM531wqz3fpd93KSNgj9QGQK8bibdDN93KrhtpY763TLcVj7kNvYqi
        SFIjnp2N8uAaehK3iIzZYw232uy6sPR8Uw==
X-Google-Smtp-Source: ABdhPJy0zNVGYmPN5QvPQHFc7ezbVka6ipdzazuSwdsGw44Tbq9+fBEwuJa2pIkjXiIFOnk+TFMxBg6fT5iQKw==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:77ed:dda5:c808:3802])
 (user=ipylypiv job=sendgmr) by 2002:a05:6902:102e:: with SMTP id
 x14mr12104189ybt.31.1632884334181; Tue, 28 Sep 2021 19:58:54 -0700 (PDT)
Date:   Tue, 28 Sep 2021 19:58:47 -0700
Message-Id: <20210929025847.646999-1-ipylypiv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 2/2] scsi: pm80xx: Fix misleading log statement in pm8001_mpi_get_nvmd_resp()
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

pm8001_mpi_get_nvmd_resp() handles a GET_NVMD_DATA response, not
a SET_NVMD_DATA response, as the log statement implies.

Fixes: 1f889b58716a ("scsi: pm80xx: Fix pm8001_mpi_get_nvmd_resp()
race condition")

Reviewed-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index b73d286bea60..69e5f3db336b 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3169,7 +3169,7 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	 * fw_control_context->usrAddr
 	 */
 	complete(pm8001_ha->nvmd_completion);
-	pm8001_dbg(pm8001_ha, MSG, "Set nvm data complete!\n");
+	pm8001_dbg(pm8001_ha, MSG, "Get nvmd data complete!\n");
 	ccb->task = NULL;
 	ccb->ccb_tag = 0xFFFFFFFF;
 	pm8001_tag_free(pm8001_ha, tag);
-- 
2.33.0.685.g46640cef36-goog

