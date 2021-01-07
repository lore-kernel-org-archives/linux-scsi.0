Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05AA7C4332D
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 18:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB17A23428
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 18:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbhAGSyH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 13:54:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbhAGSyH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 13:54:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B758233FD;
        Thu,  7 Jan 2021 18:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610045606;
        bh=WCW1zUgM8CscS/yuhzaFDE7+JUy+hzzVU3S0ROR6HbA=;
        h=From:To:Cc:Subject:Date:From;
        b=AsXhsRNR1eNTR0LZIzMOaVNOtLsRtZxPakzrVPDeOyLqnT88IEfZdtyu2lN3CGlKW
         MwBxdDptbn1wsB6dEc2TKVBfzd125RzNaY4Ypnj9BCx7PjZZwbsydhomxvgqS8Y3Jp
         sRfdGOyhprGr2wbk3x3bTazI6+/o4QdK0PhOWaM3SHVwNDamBGnjp7yNpQwfolcbz3
         BX+BHJe6GSAStnC/ivsM83WoquRMqSSuKIdypSXJ8UMs4MpkoI1ZNOuvsXnDsTzN/+
         gSq0iNT2/4oc+BCp5NvntE03aL0obtMHcVlNLpwDb7tgWOwIgFXTchE+5X+qFNKWC/
         qm7G+djodgrSA==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com
Subject: [PATCH v5 0/2] Two UFS fixes
Date:   Thu,  7 Jan 2021 10:53:14 -0800
Message-Id: <20210107185316.788815-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change log from v4:
 - remove RESERVE tag for tm command
 - remove waiting IOs and let full reset handle it
 - avoid verbose error log which causes cpu lock up


