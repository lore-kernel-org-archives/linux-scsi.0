Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26628C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 18:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D15E61074
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 18:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhJTSpw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 14:45:52 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:36726 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230076AbhJTSpu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 14:45:50 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 8A47942B35;
        Wed, 20 Oct 2021 18:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1634755413; x=
        1636569814; bh=QHRGrUEb+H9KZ0xJgGEVAJtJB0Dg4QG1oOcBKz7CYXU=; b=B
        57uVnEY6SMqHH8x0e92oJUBufcuocCjIPsYhae/BVV7XGJULfOG0+RFmSOUTkuZc
        9+eWuBlGAeRve6k88y9ENTo5peaJpXwZAaFhoKS+6YfRYhGD5czoYMKtxe8hD3ZI
        JV8Fdg9j9yAb58A+KDz2JpH+I0CqNkNDms0RhGgai8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ab3MTRV6U_ep; Wed, 20 Oct 2021 21:43:33 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8C84F4278C;
        Wed, 20 Oct 2021 21:43:33 +0300 (MSK)
Received: from yadro.com (10.199.9.171) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 20
 Oct 2021 21:43:32 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: [PATCH 0/2] scsi: target: iblock: Report space allocation errors
Date:   Wed, 20 Oct 2021 21:43:17 +0300
Message-ID: <20211020184319.588002-1-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.9.171]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently iblock terminates failed requests with TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE
regardless of the reason. It makes it impossible to distinguish the lack of
free LBA from a hardware failure on thin provisioned devices without analyzing
target logs. This series teaches iblock to report the appropriate sense reason
according to the failed bio's status.

Konstantin Shelekhin (2):
  scsi: target: core: Add sense reason for space allocation errors
  scsi: target: iblock: Report space allocation errors

 drivers/target/target_core_iblock.c    | 24 ++++++++++++++++++++----
 drivers/target/target_core_iblock.h    |  2 +-
 drivers/target/target_core_transport.c |  6 ++++++
 include/target/target_core_base.h      |  1 +
 4 files changed, 28 insertions(+), 5 deletions(-)

-- 
2.33.0

