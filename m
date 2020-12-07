Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71145C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 19:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3720C238E2
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 19:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgLGTC3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 14:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgLGTC3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 14:02:29 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43E3C061793;
        Mon,  7 Dec 2020 11:01:48 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id lt17so21095431ejb.3;
        Mon, 07 Dec 2020 11:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=osJhQAuVO8b11VDFQVjcqnqkVR0O6okwybVxHv1uYvE=;
        b=PWtjw9f2DJ6SzwPmrI8FcpgtfOkpz29eu5aa3Z8VppcEYRd7mefR4tKG629JTCQES/
         tL4HflrcFWtalp3MyVjX4+qi+1O6A8axMt3DEAIrKRaTX+5+7jAMogTvRyg/TzE2FuIO
         AWaFliDICi1FI4J6KJdkc06XeKx1hubXMVBGk+TnoSuw4tHMYl71ukhR+XGsA09crWaL
         n+nAb7Loui8t6Jg4iwBfPqJrcvSH2W/W/hp38mS3PTKC5bIwgFgWJ/mlFmHUpEGliys/
         lU+Q52d7VujYpMHFwcxi1kzroENnu2ZiNjbGua3CDzCt4oD9jaKYkumi+z1R49b+slrr
         Kfhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=osJhQAuVO8b11VDFQVjcqnqkVR0O6okwybVxHv1uYvE=;
        b=VmU1xGY97GdgGROOoKfHZg5n4Zsfa9D2iDyMwFfQ4fymajfwYC8ridSj9cws6SwF3K
         rWj40rlTBFPyk/FW2Xm5a+H9dVBwQvd553sDpNT15wuCtyZ7TNUvHJgENEhacNwTKzol
         rqt7SIXAcbHI8+GmVRnLiCq+b/ETwhGbjgJcIxKI/U88FAD/oCtqSxpt58WNrojpKR8y
         KjnVy9qjEhKWUy7WAwVd/wXeY91E856Bl13x1fdjCpaK9BaKBTFDrecSjGyyChdgQrEc
         tFbvAMXBcwvnK+iF89p81RSopxG8UAhWxtPAzOo3CL1vBSBhEf9o9NrB87UfTQav4kbu
         i4RQ==
X-Gm-Message-State: AOAM533kooLVW9ALAKy5oZttrwCqhHNZwL1T1rnsD5U+LhWQyln9BmtO
        oNYaTcuhvGU3sp6fYqRPJbg=
X-Google-Smtp-Source: ABdhPJx+6j64MF1SdroyM9YlqnE+pfA50E520CsWGvMc5QudGT00jjUcsZfQ8v5ir/X03I1NlkH/AA==
X-Received: by 2002:a17:906:ae41:: with SMTP id lf1mr20581627ejb.369.1607367707530;
        Mon, 07 Dec 2020 11:01:47 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id b9sm13479631eju.8.2020.12.07.11.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 11:01:47 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] two UFS changes
Date:   Mon,  7 Dec 2020 20:01:35 +0100
Message-Id: <20201207190137.6858-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>



Bean Huo (2):
  scsi: ufs: Remove an unused macro definition POWER_DESC_MAX_SIZE
  scsi: ufs: Fix wrong print message in dev_err()

 drivers/scsi/ufs/ufs.h    | 1 -
 drivers/scsi/ufs/ufshcd.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

-- 
2.17.1

