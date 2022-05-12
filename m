Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD43C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 10:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352776AbiELKpa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 06:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352763AbiELKp0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 06:45:26 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D199229FF3;
        Thu, 12 May 2022 03:45:25 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id CCFCC4145E;
        Thu, 12 May 2022 10:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1652352322; x=
        1654166723; bh=E+K6v7cNE+LjWURavFz0CgRMxAEG6t5IERZF4zuwD4w=; b=u
        Bf93Pqo0PAa16RtN/hVHNFLHSF36Jwfe8D9IvvSXmKGFeIUccT8P4K7OYP6i5mSO
        GNvcONx4SNGgNKQHgM6ttiVeWHnRlOATRB85XZS2dxQkNgi21K40Rg60pmrWnAw4
        GTnpfXUFRd0nozb9u+e9YR3/J9BblzSZCrOC9XPCEY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Pax8ySmYA19t; Thu, 12 May 2022 13:45:22 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id B5E5941452;
        Thu, 12 May 2022 13:45:22 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 12 May 2022 13:45:22 +0300
Received: from NB-591.corp.yadro.com (10.178.114.42) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.22; Thu, 12 May 2022 13:45:21 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v4 0/3] target: iscsi: control authentication per ACL
Date:   Thu, 12 May 2022 13:45:05 +0300
Message-ID: <20220512104508.8680-1-d.bogdanov@yadro.com>
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

Add acls/{ACL}/attrib/authentication attribute that controls authentication
for the particular ACL. By default, this attribute inherits a value of
authentication attribute of the target port group to keep a backward
compatibility.

authentication attribute has 3 states:
"0" - authentication is turned off for this ACL
"1" - authentication is required for this ACL
"-1" - authentication is inherited from TPG

This patchset is intended for scsi-queue.

v4:
 rebase on latest scsi-queue

v3:
 fix warning: no previous prototype for function 'iscsi_conn_auth_required'

v2:
 show effective value (-1) for inherited mode

Dmitry Bogdanov (3):
  scsi: target: iscsi: Add upcast helpers
  scsi: target: iscsi: extract auth functions
  target: iscsi: control authentication per ACL

 drivers/target/iscsi/iscsi_target_configfs.c  | 116 +++++++-------
 drivers/target/iscsi/iscsi_target_nego.c      | 148 ++++++++++++------
 .../target/iscsi/iscsi_target_nodeattrib.c    |   1 +
 drivers/target/iscsi/iscsi_target_tpg.c       |   3 +-
 include/target/iscsi/iscsi_target_core.h      |  14 ++
 5 files changed, 176 insertions(+), 106 deletions(-)

-- 
2.25.1

