Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE35CCA480
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jul 2022 11:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiGTL3t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jul 2022 07:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240751AbiGTL3g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2022 07:29:36 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EE872EEE;
        Wed, 20 Jul 2022 04:29:06 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 961AE41283;
        Wed, 20 Jul 2022 11:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1658316544; x=
        1660130945; bh=RW1ryzJdQppDna0pg6+tBr+uGSoa6ovlEntkbiyfGgQ=; b=d
        8Eitc+zvi0QcjnsjfzzTouSgSfgAqqm41q7242UIyrGDT0TNHUjnqqpFKD92Autd
        vQDEVuSqYB9/7Jvc+SgexmDS45cZmlmlIT2vb/YzDig0h9MO8lBMW6GAUf+mv2wm
        nzCX2Ujw3+tR6pYGpLiO8Gc06GeQ0p7SQ02AGD7FdM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QQsJBeU96x56; Wed, 20 Jul 2022 14:29:04 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8C73241259;
        Wed, 20 Jul 2022 14:29:04 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 20 Jul 2022 14:29:04 +0300
Received: from NB-591.corp.yadro.com (10.178.114.42) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 20 Jul 2022 14:29:03 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 0/2] target: core: fix race during ACL removal
Date:   Wed, 20 Jul 2022 14:28:50 +0300
Message-ID: <20220720112852.11440-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset fixes a race condition due to incorrect usage of RCU
for se_dev_entry.se_lun variable when ACL is being removed.

Based on 5.20/scsi-queue.

Dmitry Bogdanov (2):
  target: core: fix race during ACL removal
  target: core: de-RCU of se_lun and se_lun acl

 drivers/target/target_core_alua.c   |  3 +--
 drivers/target/target_core_device.c | 32 ++++++++++-------------------
 drivers/target/target_core_pr.c     | 30 ++++++++-------------------
 drivers/target/target_core_stat.c   | 10 ++++-----
 drivers/target/target_core_xcopy.c  |  2 +-
 include/target/target_core_base.h   |  4 ++--
 6 files changed, 28 insertions(+), 53 deletions(-)

-- 
2.25.1

