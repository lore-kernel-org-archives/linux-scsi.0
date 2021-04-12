Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404D6C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 22:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FD8661369
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 22:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbhDLWpA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 18:45:00 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:59388 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238085AbhDLWo7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 18:44:59 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 4E1654131A;
        Mon, 12 Apr 2021 22:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1618267479; x=
        1620081880; bh=N0OIeACEXus3MdtjW8P9hqZEB1TLbMvkJzDapKB/C6I=; b=A
        cfng/e6odDeBrnav3mgr5C9ZMjY5dcU3KAbv/k5ROyhchCRGlEknamMG8jGF4g6p
        VsDEC/fVcOLjrIKdxG9955u0TG0tOkwbOrXzF/4CKydOZJe6eQczPoS4x+DLKVFJ
        n79JGI06nGxH3wIqP8z8Zz0DFMRJ7xNiSAjX84JgUg=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7RarMUK5y5C9; Tue, 13 Apr 2021 01:44:39 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 4D1204131F;
        Tue, 13 Apr 2021 01:44:39 +0300 (MSK)
Received: from yadro.com (10.199.0.123) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 13
 Apr 2021 01:44:38 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: [PATCH 0/2] scsi: target: Introduce the version descriptors
Date:   Tue, 13 Apr 2021 01:44:25 +0300
Message-ID: <20210412224427.101167-1-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.123]
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

