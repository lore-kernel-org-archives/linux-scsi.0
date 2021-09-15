Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A50DBC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 09:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78B4461242
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 09:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbhIOJNi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 05:13:38 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3810 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237170AbhIOJNe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 05:13:34 -0400
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H8ZDD3L38z6H7hQ;
        Wed, 15 Sep 2021 17:09:48 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 11:12:12 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 10:12:10 +0100
From:   John Garry <john.garry@huawei.com>
To:     <linux@armlinux.org.uk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 0/3] scsi: remove last references to scsi_cmnd.tag
Date:   Wed, 15 Sep 2021 17:07:12 +0800
Message-ID: <1631696835-136198-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is v2 of Hannes' series to fix the build errors from removing
scsi_cmnd.tag. Here is the original cover letter:

"with commit 4c7b6ea336c1 ("scsi: core: Remove scsi_cmnd.tag") drivers
cannot reference the SCSI command tag anymore.
Arguably these drivers would have stopped working since 2010 with
the switch to block layer tags in SCSI anyway, so chances are no-one
had been using tagging in these drivers.

This patchset fixes up these usage; for fas216 we're just switching
to use the appropriate wrapper.
For acornscsi the tagged queue handling is removed altogether as it
was broken in the first place, and no-one since the switch to git
could be bothered to fix it.
And the patchset has the nice side-effect that we can remove the
scsi_device.current_tag field."

AFAIK, only the arm rpc_defconfig build was broken.

I dropped the scsi_cmd_to_tag() patch as it was not strictly necessary here
and there was some doubt on its need.

The "scsi: remove 'current_tag'" patch is not needed as a fix.

Baseline is v5.15-rc1

Hannes Reinecke (3):
  fas216: kill scmd->tag
  acornscsi: remove tagged queuing vestiges
  scsi: remove 'current_tag'

 drivers/scsi/arm/Kconfig     |  11 ----
 drivers/scsi/arm/acornscsi.c | 103 ++++++++---------------------------
 drivers/scsi/arm/fas216.c    |  31 +++--------
 drivers/scsi/arm/queue.c     |   2 +-
 include/scsi/scsi_device.h   |   1 -
 5 files changed, 31 insertions(+), 117 deletions(-)

-- 
2.26.2

