Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53C6C77B75
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 14:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbjEQOQA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 10:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbjEQOP6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 10:15:58 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0C37A92;
        Wed, 17 May 2023 07:15:56 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id A774734272B;
        Wed, 17 May 2023 17:15:53 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:message-id:mime-version:reply-to:subject:subject:to
        :to; s=mta-01; bh=lMlVeTRDPLY8EPwx2SWtmtS1OR3ABI2xT6L2C4L7h0Q=; b=
        XjTW5AbO9KGJl8QQinEm/Rnch+Jc1JkHAvE2sS3UN5hswzDbRW4ppD0RM/+coPOz
        RwC/humVPRY+audxJxQbbssQcqPQfxqDpTt+cMMzSrBMPhW7vCg7RafnnwW5aT4+
        p3oCjrVG0qJk+SNnYoETuq+1q2LNf2pXPNjGWdmCESc=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 9E603342727;
        Wed, 17 May 2023 17:15:53 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.9; Wed, 17 May 2023 17:15:52 +0300
Received: from yadro.com (172.22.1.19) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 17 May
 2023 17:15:51 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>
CC:     <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: [PATCH 0/2] scsi: target: iblock: Report space allocation errors
Date:   Wed, 17 May 2023 17:15:35 +0300
Message-ID: <20230517141537.80936-1-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.22.1.19]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently iblock terminates failed requests with TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE
regardless of the reason. It makes it impossible to distinguish the lack
of free LBA from a hardware failure on thin provisioned devices without
analyzing target logs. This series teaches iblock to report the
appropriate sense reason according to the failed bio's status.

Konstantin Shelekhin (2):
  scsi: target: core: Add sense reason for space allocation errors
  scsi: target: iblock: Report space allocation errors

 drivers/target/target_core_iblock.c    | 28 +++++++++++++++++++-------
 drivers/target/target_core_iblock.h    |  2 +-
 drivers/target/target_core_transport.c |  6 ++++++
 include/target/target_core_base.h      |  1 +
 4 files changed, 29 insertions(+), 8 deletions(-)

-- 
2.40.1


