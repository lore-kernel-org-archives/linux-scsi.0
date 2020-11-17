Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478E6C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 004C024654
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:59:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="k06mG3Z9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgKQQ6p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 11:58:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgKQQ6p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 11:58:45 -0500
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0AF824248;
        Tue, 17 Nov 2020 16:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605632325;
        bh=O7bo5z9gbbXy6FNriFXXCnw95EyqHpZFFz9y6rXlNiM=;
        h=From:To:Cc:Subject:Date:From;
        b=k06mG3Z9cBZwjvD/PTgsGaPdh2XIqqfT/icP1nXMQk4KYY1QoBIUNtp9WlYVX0Gf0
         j1nIM0r9LVhgTlA5dBcLHFE9HRDWAMTkOK7mdpKpqjYbk08vPUR0Ai21whm6AoPivj
         w3gXWBPf+VjZ/8IBDQXcTc1EqAoUUQWIqtTHLuwg=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com
Subject: [PATCH v5 0/5] scsi: ufs: add some fixes
Date:   Tue, 17 Nov 2020 08:58:32 -0800
Message-Id: <20201117165839.1643377-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change log from v4:
 - add more fixes

Change log from v3:
 - use __ufshcd_release with a fix in __ufshcd_release

Change log from v2:
 - use active_req-- instead of __ufshcd_release to avoid UFS timeout

Change log from v1:
 - remove clkgating_enable check in __ufshcd_release
 - use __uhfshcd_release instead of active_req.


