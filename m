Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC4DC4363A
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 17:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9792D2463F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 17:29:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="RM6PKBan"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900093AbgJVR3f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Oct 2020 13:29:35 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:35602 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2900086AbgJVR3e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Oct 2020 13:29:34 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E5C38413A9;
        Thu, 22 Oct 2020 17:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1603387238; x=
        1605201639; bh=HDZlMufEP/yC58GquWf5r/1ONNuadF1IWKD21UCWG64=; b=R
        M6PKBanfnOzyz4Mf3kfaCwIkx4TWVQk2eT9YEy3lspWMflS/uGs+QMA6GGwnLpbf
        vSdy3wMtLzk6CRhIJ651S8+xI05ZMag5eDwjpo9+FQJo2orX/yMUmmSDmjLSnRox
        RBvYtX9fGTGYNIICucN2UDLbMln0Yx5Pq4Rvie8CRw=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qphMz5fPcl7Y; Thu, 22 Oct 2020 20:20:38 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 3D68141383;
        Thu, 22 Oct 2020 20:20:38 +0300 (MSK)
Received: from localhost (172.17.204.63) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 22
 Oct 2020 20:20:37 +0300
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Anastasia Kovaleva <a.kovaleva@yadro.com>
Subject: [PATCH 0/3] scsi: target: Set correct residual data
Date:   Thu, 22 Oct 2020 20:20:08 +0300
Message-ID: <20201022172011.42367-1-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.63]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,
Please apply the changes to 5.10/scsi-queue at your earliest
convenience.

Tne series changes the behavior of the target in regard to processing
commands with overflow/underflow in accordance with the standarts.

The target driver used to process the DMA_TO_DEVICE commands with
residuals (in particular, WRITE command) incorrectly. The target
response contained neither a residual count, nor an OVERFLOW/UNDERFLOW
bit. Such behavior did not comply with the RFC 7143. Also the
returned ASC and ASCQ were incorrect according to FCP-4,
and residuals were not set for the 4Kn devices.

This patches fix the major inconsistances in processing these kind of
commands.

This patch series has been tested with a modified libiscsi testing
library.
The link to the pull request:
https://github.com/sahlberg/libiscsi/pull/345

Write10Residuals, Write12Residuals, Write16Residuals tests have passed.

Thanks,
Anastasia

Anastasia Kovaleva (2):
  scsi: target: core: Signal WRITE residuals
  scsi: target: core: Change ASCQ for residual write

Roman Bolshakov (1):
  scsi: target: core: Set residuals for 4Kn devices

 drivers/target/target_core_transport.c | 53 +++++++++++++-------------
 include/target/target_core_base.h      |  1 +
 2 files changed, 28 insertions(+), 26 deletions(-)

-- 
2.24.3 (Apple Git-128)

