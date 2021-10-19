Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050F2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 07:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2E77611EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 07:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbhJSHVN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 03:21:13 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:33710 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234461AbhJSHVJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Oct 2021 03:21:09 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7B90941750;
        Tue, 19 Oct 2021 07:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1634627934; x=
        1636442335; bh=MrL0k6YlgIwHqVieVgKBnfFJI+l+vywppzFITntK+7g=; b=n
        9fsWnHHwnAlHkAAmIVx5D+cPZ72OZG9s6O1eGgnEP+lyhv501l5ntaxN3OTL7cSg
        NPDNVaZ4ucRRyXPrKxgzblcyVMYey5/XfTwGUW2X62SlUdsqqzcX68I2rXjFew4r
        UzXKmawvXUWCNFj3cuPBdTuixRCNm0FYgklmVr/k9g=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xE0ZPqEdO6iT; Tue, 19 Oct 2021 10:18:54 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7DEFF416D4;
        Tue, 19 Oct 2021 10:18:53 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.178.112.183) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 19 Oct 2021 10:18:53 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v3 0/3] target: iscsi: control authentication per ACL
Date:   Tue, 19 Oct 2021 10:18:40 +0300
Message-ID: <20211019071843.14890-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.178.112.183]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

dd acls/{ACL}/attrib/authentication attribute that controls authentication
for the particular ACL. By default, this attribute inherits a value of
authentication attribute of the target port group to keep a backward
compatibility.

authentication attribute has 3 states:
"0" - authentication is turned off for this ACL
"1" - authentication is required for this ACL
"-1" - authentication is inherited from TPG

This patchset is intended for scsi-queue.

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

