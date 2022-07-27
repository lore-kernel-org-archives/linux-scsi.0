Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F6EC3F6B0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jul 2022 21:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbiG0Vlj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jul 2022 17:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiG0Vli (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2022 17:41:38 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5481840BD7;
        Wed, 27 Jul 2022 14:41:37 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id BC089412E3;
        Wed, 27 Jul 2022 21:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1658958094; x=
        1660772495; bh=t7EhrIoyEZSQcV06FqUI1RHbm/vZ0Y2rSUerUxU+STM=; b=t
        O2tQMFk4WyqPa3SCi7e57mslm7/ch/ZKrERaQ4MpviKT7L+5x8wPJaEDX9Em7j7T
        T0YYUw+ipOGIjzLo2dxEv76/rM8RNRZDGBcYUm2ypgC0w5pFa0erLfFPEN5SU1Up
        2KkvQzOqkFf/l6WtG+iZSfDjcv+UNmJY7DPBcXRZW8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3fCOkFaeaPky; Thu, 28 Jul 2022 00:41:34 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BABD9412DB;
        Thu, 28 Jul 2022 00:41:33 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 28 Jul 2022 00:41:33 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Thu, 28 Jul 2022 00:41:32 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v2 0/2] target: core: fix race during ACL removal
Date:   Thu, 28 Jul 2022 00:41:23 +0300
Message-ID: <20220727214125.19647-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset fixes a race condition due to incorrect usage of RCU
for se_dev_entry.se_lun variable when ACL is being removed.

Based on 5.20/scsi-queue.

v2:
  add more details in commit message
  fix misformatting

Dmitry Bogdanov (2):
  target: core: fix race during ACL removal
  target: core: de-RCU of se_lun and se_lun acl

 drivers/target/target_core_alua.c   |  3 +--
 drivers/target/target_core_device.c | 32 ++++++++++-------------------
 drivers/target/target_core_pr.c     | 28 ++++++++-----------------
 drivers/target/target_core_stat.c   | 10 ++++-----
 drivers/target/target_core_xcopy.c  |  2 +-
 include/target/target_core_base.h   |  4 ++--
 6 files changed, 27 insertions(+), 52 deletions(-)

-- 
2.25.1

