Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0891C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 19:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66B1E613FB
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 19:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhEMT3k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 15:29:40 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:44448 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230309AbhEMT3k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 May 2021 15:29:40 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9F8A741339;
        Thu, 13 May 2021 19:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1620934107; x=
        1622748508; bh=N0OIeACEXus3MdtjW8P9hqZEB1TLbMvkJzDapKB/C6I=; b=k
        yM8Vp+HpmmeCLGLq3pAkA02TlruKIV8P9e6BV72dwjISf4m4GnN2A9lxncI+LfGg
        w474GLRolDXcyaKLhxtnY7s+yZ7wqz+7Z4at7jLAdhDJt/aIroONRscVb1I1ngL8
        pJApSZtAFqEInRjEqkJ3uQG0QwSjkJOv/tROi0c1P4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NOcHvCGT_pVs; Thu, 13 May 2021 22:28:27 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 898D64131C;
        Thu, 13 May 2021 22:28:27 +0300 (MSK)
Received: from yadro.com (10.199.0.46) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 13
 May 2021 22:28:17 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: [PATCH 0/2] scsi: target: Introduce the version descriptors
Date:   Thu, 13 May 2021 22:28:02 +0300
Message-ID: <20210513192804.1252142-1-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.46]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series adds the VERSION DESCRIPTOR fields to the standard INQUIRY
data. The SCSI primary command set standard bumped to SPC-4 for consistency
since the version descriptor values for SBC-3 and some other standards are not
defined in SPC-3.

While not essential for normal operation, the version descriptors values are
often queried as an additional sanity check. For example, Windows Server
requires proper SCSI transport protocol standard during the iSCSI qualification
tests.

The layout follows SPC-4:

  SCSI architecture standard
  SCSI transport protocol standard
  SCSI primary command set standard
  SCSI device type command set standard

The physical transport standard is not reported because it requires
driver-specific probing to be accurate and I'm not aware of any use-case
to justify the additional complexity.

The values are reported "unclaimed" because I faced several issues with the
specific ones during the interoperability testing. For example, Windows Server
2016 fails to parse recent iSCSI standards, libiscsi failed to recognize the
final SBC-3 standard (however this is fixed now) and so on. Plus both FreeBSD
and SCST use (or were using) the same values, so the chance of breaking
something is much smaller.

Konstantin Shelekhin (2):
  scsi: target: Bump INQUIRY VERSION to SPC-4
  scsi: target: Add the VERSION DESCRIPTOR fields to the INQUIRY data

 drivers/target/target_core_spc.c | 36 ++++++++++++++++++++++++++++++--
 include/scsi/scsi_proto.h        | 12 +++++++++++
 2 files changed, 46 insertions(+), 2 deletions(-)

-- 
2.31.1

