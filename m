Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88CFBC432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 15:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EA4760F51
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 15:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbhGZOgz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 10:36:55 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:44206 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234941AbhGZOgy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jul 2021 10:36:54 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1E06A46169;
        Mon, 26 Jul 2021 15:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1627312640; x=
        1629127041; bh=mwkYi8+lEBsrM4/D2o1xt/YV+mLTsFqLxpB6vBgpD/A=; b=W
        fpjCT6I1odg+2GL1wfW2M7GirEFMSkB5ErnLLIFdgoOH5UZH/SuXifA47DSxnM8q
        /H73SB5BvUOV1lsFMzBFVAj2RhMk45rKPDbduJkiVvooQ+GOGB7x+eoZwpocWAYR
        zKmT61EYnb1HAh5dzN/eVoD18vEL+drbP6p2ubSIqg=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AKMVHgCWRvVt; Mon, 26 Jul 2021 18:17:20 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 57531412C6;
        Mon, 26 Jul 2021 18:17:19 +0300 (MSK)
Received: from yadro.com (10.199.0.6) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 26
 Jul 2021 18:17:18 +0300
From:   Sergey Samoylenko <s.samoylenko@yadro.com>
To:     <martin.petersen@oracle.com>, <michael.christie@oracle.com>,
        <ddiss@suse.de>, <bvanassche@acm.org>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Sergey Samoylenko <s.samoylenko@yadro.com>
Subject: [v2 0/2] target: core: Fix sense key for invalid XCOPY request
Date:   Mon, 26 Jul 2021 18:16:44 +0300
Message-ID: <20210726151646.32631-1-s.samoylenko@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.6]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

EXTENDED COPY tests in libiscsi [1] show that TCM doesn't
follow SPC4 when detects invalid parameters in a XCOPY
command or IO errors. The replies from TCM contain wrong sense
key or ASCQ for incorrect request.

The series fixes the following tests from libiscsi:

  SCSI.ExtendedCopy.DescrType
  SCSI.ExtendedCopy.DescrLimits
  SCSI.ExtendedCopy.ParamHdr
  SCSI.ExtendedCopy.ValidSegDescr
  SCSI.ExtendedCopy.ValidTgtDescr

1. https://github.com/sahlberg/libiscsi

Sergey Samoylenko (2):
  target: allows backend drivers to fail with specific sense codes
  target: core: Fix sense key for invalid XCOPY request

 drivers/target/target_core_transport.c | 21 ++++++++++++++++++---
 drivers/target/target_core_xcopy.c     | 26 +++++++++++++++-----------
 include/target/target_core_backend.h   |  1 +
 include/target/target_core_base.h      |  2 ++
 4 files changed, 36 insertions(+), 14 deletions(-)

-- 
2.25.1

