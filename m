Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F78C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 18:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD48461ABB
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 18:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355667AbhJASWQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Oct 2021 14:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354947AbhJASWP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Oct 2021 14:22:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC71561A8E;
        Fri,  1 Oct 2021 18:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633112431;
        bh=ZpQ3v/oQy6E/gx68PLeo0lm9J70704RXg16PA6uMQJY=;
        h=From:To:Cc:Subject:Date:From;
        b=ogIywBCtO8M1L4chcR9sJZsYqZx4kPWgU4Xzj2ZYHT8J62qgoS0NEsWi7RXf28vfH
         jMIWoVgYLh5AzhuMfwC75NGQ+gI30HAdgtimBqCdaDuRAvkMZbTRs3JsXfPVr2olOb
         cFYHxc7nLWxwtC7EiLWfKnNOdcN3QbOPt6smh/23QpfBpR0v7oxFPZIA+dqqU1Fnne
         QqXltUYUb8OvsD0w6xB49+l/DepF/SmgWjDkbgWZcyXQxXsfKsy9zE5dqO/pSa6Vf2
         wFUEQSFOGirIPbM/G4hoZsxnbIaEj44zqU+O8PdAIIRSFkxtrK2nbFy6Ss938He0Pk
         OljZu1Bokl/gw==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 0/2 v2] kill clearing UA in UFS driver
Date:   Fri,  1 Oct 2021 11:20:13 -0700
Message-Id: <20211001182015.1347587-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are some issues reported and fixed when clearing UA on reset/PM flows.
Let's avoid any potential bugs entirely by letting user clear UA.

Bart Van Assche (1):
  scsi: ufs: Stop clearing unit attentions

Jaegeuk Kim (1):
  scsi: ufs: retry START_STOP on UNIT_ATTENTION

 drivers/scsi/ufs/ufshcd.c | 196 ++------------------------------------
 drivers/scsi/ufs/ufshcd.h |  14 ---
 2 files changed, 10 insertions(+), 200 deletions(-)

-- 
2.33.0.800.g4c38ced690-goog

