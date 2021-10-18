Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED354C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 18:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA53961212
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 18:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbhJRSeI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 14:34:08 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:36988 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231590AbhJRSeH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 14:34:07 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 4BA8041272;
        Mon, 18 Oct 2021 18:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1634581914; x=
        1636396315; bh=tPVV5xj/l+joOpm0URE0exCTSzeqSTQI3DXQU2W/CWs=; b=D
        XEwbzLe2Vn3A24Bwhr4ieF1U7dAeMZWko8K7p+3A2HRtHbDXDJ+OlU293qeQ4rop
        +fuoZyQg696y4YcZq0m+8vL4Ml+IZpz5+Nn2yGrhCYQH70j8V/seLQVz0TTaUhiP
        09R1m4fCvih+68KoMst3NrE+7N6yrMDfH2yFbXrEQg=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PxPZPU4YETku; Mon, 18 Oct 2021 21:31:54 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 62B0541263;
        Mon, 18 Oct 2021 21:31:54 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.178.120.180) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 18 Oct 2021 21:31:53 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v2 0/3] target: iscsi: control authentication per ACL
Date:   Mon, 18 Oct 2021 21:31:41 +0300
Message-ID: <20211018183144.8428-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.178.120.180]
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
"-1" - authentication is inherited from TPG

This patchset is intended for scsi-queue.

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

