Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4B2C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 10:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CCAC60F8F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 10:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhINKFC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 06:05:02 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:38784 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230045AbhINKE5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 06:04:57 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 78AF441E0F;
        Tue, 14 Sep 2021 10:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1631613818; x=
        1633428219; bh=qO8qPoI7jrvQe4xYpg/iVask1hK1jR4oL7JHBWDwct4=; b=G
        chW7Uw5qCOk1SWDVHF8x+3PZlx8E5iDeu4/NfqDhG/OacrMztnLzWWUWJgpmyeXb
        K8XDJ8O6XgNv8MofmLtwyJlCuoU74teQvS4gcOSYgMBgzgXwD+oTNtlrSEwexl/A
        f3G/YXvYq/tvCz03nd9jQslsaqCRGST+lvqpm6BBVk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id j1ObKhiEozac; Tue, 14 Sep 2021 13:03:38 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 940D841E07;
        Tue, 14 Sep 2021 13:03:38 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.9) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 14
 Sep 2021 13:03:37 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 0/3] target: iscsi: control authentication per ACL
Date:   Tue, 14 Sep 2021 13:03:11 +0300
Message-ID: <20210914100314.492-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.9]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add acls/{ACL}/attrib/authentication attribute that controls authentication
for the particular ACL. By default, this attribute inherits a value of
authentication attribute of the target port group to keep a backward
compatibility.

authentication attribute has 3 states:
"0" - authentication is turned off for this ACL
"1" - authentication is required for this ACL
"" - authentication is inherited from TPG

This patchset is intended for scsi-queue.

Dmitry Bogdanov (3):
  scsi: target: iscsi: Add upcast helpers
  scsi: target: iscsi: extract auth functions
  target: iscsi: control authentication per ACL

 drivers/target/iscsi/iscsi_target_configfs.c  | 126 ++++++++-------
 drivers/target/iscsi/iscsi_target_nego.c      | 148 ++++++++++++------
 .../target/iscsi/iscsi_target_nodeattrib.c    |   1 +
 drivers/target/iscsi/iscsi_target_tpg.c       |   3 +-
 include/target/iscsi/iscsi_target_core.h      |  14 ++
 5 files changed, 186 insertions(+), 106 deletions(-)

-- 
2.25.1

