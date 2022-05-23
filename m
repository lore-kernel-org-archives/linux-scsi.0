Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC62C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 09:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbiEWJ7Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 05:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbiEWJ7Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 05:59:24 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA6B41F88;
        Mon, 23 May 2022 02:59:20 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 0D95548300;
        Mon, 23 May 2022 09:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1653299957; x=
        1655114358; bh=7rXJ0DDphcGgWOELdgckwE2qKMwTKkFogaA+BTE92mI=; b=h
        xolevEx/GSz22BXmL7T6vciYFiprSxbO8Ey5EMOiUFMkMSLqzDbTrvd+IEdyfCxA
        yYT7te83fmwnNM4jTfzdqcKoNxcgoIvr3O2EcT0jdwNDoBH12UR70tj1jKmCxB4B
        aAzqfDJ8845Yzk97Ge6O1yU2zQSn3tLnwZBnkDUd6U=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kWs_9dbcLQtN; Mon, 23 May 2022 12:59:17 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BCF6647EBC;
        Mon, 23 May 2022 12:59:17 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 23 May 2022 12:59:17 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-09.corp.yadro.com (172.17.11.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.22; Mon, 23 May 2022 12:59:16 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v5 0/3] target: iscsi: control authentication per ACL
Date:   Mon, 23 May 2022 12:59:02 +0300
Message-ID: <20220523095905.26070-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
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

v5:
 rebase on latest scsi-staging

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

