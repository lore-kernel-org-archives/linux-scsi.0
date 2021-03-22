Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6E4C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 20:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C80C86198E
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 20:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhCVUKX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 16:10:23 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:33766 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229771AbhCVUKA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 16:10:00 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 2784F41241;
        Mon, 22 Mar 2021 20:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1616443798; x=
        1618258199; bh=Eo8NzvTI0JpVuMWJEC88TNXK9BbNf8g0phv16kBufYw=; b=k
        8/5S0fYUwy39VMehTz3J+JvRg7/hHjyTUfWdZ+4UPpBCPRYFHYDltN7rgdJdC2mq
        TDK0qM6MMQhHKglhScvROPLYbq7fQBmrgsKE4X3/1G6tjtD7QIxrbJho0axSmMVc
        ALfazH+REaBgZAwLbjrZTIX9h3UJ51EJxMjV7CuzwE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FMMjXLmS4qgs; Mon, 22 Mar 2021 23:09:58 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E8FF441220;
        Mon, 22 Mar 2021 23:09:57 +0300 (MSK)
Received: from yadro.com (10.199.0.64) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 22
 Mar 2021 23:09:57 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, <linux-scsi@vger.kernel.org>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: [PATCH v2 0/2] target: Introduce dummy devices
Date:   Mon, 22 Mar 2021 23:09:36 +0300
Message-ID: <20210322200938.53300-1-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.64]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series (inspired by SCST) adds support for the dummy devices
via the new DUMMY flag of rd_mcp. The rationale behind the change is to
give a user the ability to create conifgurable devices for LUN 0 with
custom WWN values (like vendor, product or revision) as some tools like
QConvergeGUI use LUN 0 to identify the whole storage.

The advantage over simply creating a NULLIO rd_mcp device is that the
DUMMY device will not be seen as a block device, hence less confusion
for the system administrator.

Konstantin Shelekhin (2):
  target: Add the DUMMY flag to rd_mcp
  target: Make the virtual LUN 0 device dummy

 drivers/target/target_core_device.c |  2 +-
 drivers/target/target_core_rd.c     | 27 +++++++++++++++++++++++----
 drivers/target/target_core_rd.h     |  1 +
 drivers/target/target_core_spc.c    |  6 +-----
 4 files changed, 26 insertions(+), 10 deletions(-)

-- 
2.31.0

