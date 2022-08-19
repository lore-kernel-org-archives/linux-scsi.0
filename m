Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7916DC00140
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Aug 2022 01:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239019AbiHSBSS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Aug 2022 21:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbiHSBSQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Aug 2022 21:18:16 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F93CCDD
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2022 18:18:11 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id f4so2407208qkl.7
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2022 18:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=92o+rEXGNMD4nQyfbUugMGB+odPqfWIsb7XTD9K8WHs=;
        b=mUl2Cu0FsxqrYn5q9Rnv7kXnvWnLzD0y+htunV2cxijHZcoAjQ6k4+mh0MowxrH69G
         zPJJ9CS7bp/7+7duUnhIBHtdpqLPj85QEwHuMfP9yHRmViyol5EPwaRwNWHaG6x6QeiY
         sMeeBbQpNHyPPHXW67tE3asdMAqFZ/CRNV6olgvgYr+jOT5qW2S5tfNqFOwnYiDmeqGE
         bohXy6aYk7AZV+uyxwVaKyJCc+hKSx3PCjwYgl3iaJhKiw0QOYgxu/NKODPC5a7oe+Zt
         8/3MgGgApUnt7xzTYG7jcZ8dxdYLQmuKAfvw068UNXSSq2XAW2pZ9lHnW9MI/jZjEVy+
         09wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=92o+rEXGNMD4nQyfbUugMGB+odPqfWIsb7XTD9K8WHs=;
        b=6OQjqCFnk0tIq9LhedfqKmXuDliECHNZaxltyri5jAytIlo8EUFUMvOIhnM3Kxab05
         45jGuBTh53yyTqsIYFyzCHJH5z1K9uwfpu9upIHLZOXYWi4G06p84T7TXPEGTgQLO9yj
         EVsrT95GDX+/ZYeuItp1QmZwOahynb/xu+3OiFT33YHcY2GZeu2IiW+K7ZECx+tfUjFc
         +YbPB1os3/n2HLG1R9xLgADmfH/y1NDIe4RZUlQkyXd8Cb3bRAUflavEkPZPEw7qcAB3
         BpW1Sp1x12m4c2cu1ExWlu5LYXi7bz2JQuf2WJb3yiZOvH+ScWUfi+nmc67GxzPsj59n
         ahiA==
X-Gm-Message-State: ACgBeo352Ou/UT/lKzPKRBAxXj6fqsv2MKg6E9CfywjsamSDjhP3nHnE
        uQL7U8bSRRjbq7qBlapelPCTChg5VvM=
X-Google-Smtp-Source: AA6agR5X3X9C/gkZB6GPuHTdR/iGdaqRnJYsSKO6GT7J/s8lqRE2yQHYCj6tb9PSkJ3tdTWuQ7qe5Q==
X-Received: by 2002:a05:620a:298d:b0:6b9:bf26:c801 with SMTP id r13-20020a05620a298d00b006b9bf26c801mr3933789qkp.470.1660871890320;
        Thu, 18 Aug 2022 18:18:10 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id u5-20020a05620a0c4500b006b5e296452csm2612502qki.54.2022.08.18.18.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 18:18:10 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 1/7] lpfc: Fix unsolicited FLOGI receive handling during PT2PT discovery
Date:   Thu, 18 Aug 2022 18:17:30 -0700
Message-Id: <20220819011736.14141-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220819011736.14141-1-jsmart2021@gmail.com>
References: <20220819011736.14141-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During a stress offline/online test in PT2PT topology, target
rediscovery can fail with a specific target vendor array.

When the HBA transitions to online mode it is possible to receive an
unsolicited FLOGI before processing the Link Up event. The received
FLOGI will set the defer_flogi_acc_flag, which instructs the driver
to wait until it transmits its own FLOGI before ACKing the received
FLOGI.  In this failure scenario, the link up processing clears
the set defer_flogi_acc_flag before we have sent out the FLOGI.
As the target has the higher WWPN and is responsible for sending
the PLOGI, the target is stuck waiting for its FLOGI_ACC that the
driver will never send.

Remove the clear of defer_flogi_acc_flag from Link Up event
processing.  In this stress test case, the defer_flogi_acc_flag is
cleared during the Link Down event processing anyways.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2645def612e6..36090e21bb10 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1392,7 +1392,6 @@ lpfc_linkup(struct lpfc_hba *phba)
 
 	/* reinitialize initial HBA flag */
 	phba->hba_flag &= ~(HBA_FLOGI_ISSUED | HBA_RHBA_CMPL);
-	phba->defer_flogi_acc_flag = false;
 
 	return 0;
 }
-- 
2.26.2

