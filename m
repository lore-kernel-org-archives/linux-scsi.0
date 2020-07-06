Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E797C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 09:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C5B62073E
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 09:19:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qBxefRx9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgGFJTU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 05:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728024AbgGFJTU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 05:19:20 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC3EC061794;
        Mon,  6 Jul 2020 02:19:19 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g20so33929686edm.4;
        Mon, 06 Jul 2020 02:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uJDsGDl+X2ZKKpTpyKbLqB34JLNShecgKArfkfRBOuY=;
        b=qBxefRx9tPHhfU+1Zb11sBZfxVz64rVd//oqIOptQevIkczC3RiKzomZDHElgWLKMy
         0eAtRM7tnCOLaNc6CLzs5z8YzCuF88k+BXDY6VMAyX8dXXvQ3T7jP+ushtZyh3jKLiM5
         nV8BbqzEl/jpCGjk4JKqU1fePHvEZJawqUse9tbz59tPmWBNdlzBv768/3jRPJblRL8E
         0kdJFaQn8Y4uDbbGP8KdsjLWD74+4DG/n3E/cIkWYjNkKTpbF1cUR8CncxJJ/XQ0XAP/
         iIg9ig7K25bO5rQz0wnkCr9ZcFFwdr67jTRobSCPMpxQZJt7ASNZXSvqK0+Da3x8GOgO
         RoYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uJDsGDl+X2ZKKpTpyKbLqB34JLNShecgKArfkfRBOuY=;
        b=m0gxO2VNalG+JlQ6x6DbXBAJofRLb3UHY/6HCJy5sFLjHidcaKbkYJ+ZRlkvxkEEKx
         y2Ah4Rb6dW47kpqiyC4kp1fUEN+mtCto+q1Q9TU7V1AX0w7Ub6whrufu6H6tKs0GR9wQ
         w/dlzdjP4BOe1Zw0sWQDJMbyGHif0EC9gDvBCllOxM+AkYzPvem/0bPQinHCEjxXzqE/
         gWQ8j/CrdAFOMoEuASkmNFtv2bgw7NTi0vddcFBvabFPr+L4DoRQTLVZFN8MUpTn+OlL
         s2eqiA0VbdLDUjpmvjgG/RnTz9ohCGdMuKg41gFb+waWHriqDp4fhpQ8Z88EBlpUNPS5
         T2Fg==
X-Gm-Message-State: AOAM532JBJ+JCy0sJu1QI8rlLu1gpwkNyV5Wv5rQLWzX+Jj6FNjwtiKF
        RCVsPgSBGnQ3ODCzgdBqyoQ=
X-Google-Smtp-Source: ABdhPJxl058d4i42jzDH9WOoApcArUEd6u/r9fZVDiaoK7X1Aziv18hS/pWpFKP9nRU3Uj7WZbD3oA==
X-Received: by 2002:aa7:c341:: with SMTP id j1mr57003950edr.197.1594027158353;
        Mon, 06 Jul 2020 02:19:18 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id d23sm15975386eja.27.2020.07.06.02.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 02:19:17 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/2] make UFS dev_cmd more readable
Date:   Mon,  6 Jul 2020 11:19:03 +0200
Message-Id: <20200706091905.12885-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>


Bean Huo (2):
  scsi: ufs: differentiate dev_cmd trace message
  scsi: ufs: change ufshcd_comp_devman_upiu() to
    ufshcd_compose_devman_upiu()

 drivers/scsi/ufs/ufshcd.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

-- 
2.17.1

