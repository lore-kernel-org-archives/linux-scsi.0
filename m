Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7583C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B626761974
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCVIG1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 04:06:27 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39522 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229548AbhCVIGM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 04:06:12 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id F3592412D0;
        Mon, 22 Mar 2021 08:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1616400369; x=
        1618214770; bh=h7ZQeKRC8uEUhOFQhJ73rESpL+IF/5FJwfcYQ5LU7qs=; b=a
        DeFgiQKYFHWDKkoOzwk8YdWQubojyXU2oYij9asN6tFLjcF0Ab3bizUhe7J9DNfF
        d9TcO3gswiJp8Ycy3XrPDAJLxgaVlEP/9Ug9WBgwOqT4sUeLQCXITS57dBjCF/Sn
        K/WUNwKGW1yyUO0hry3hl1g0fXBDZhAYJ6MDURLKoQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vWk2oIL00HWI; Mon, 22 Mar 2021 11:06:09 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id CC2D6411D9;
        Mon, 22 Mar 2021 11:06:08 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.33) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 22
 Mar 2021 11:06:07 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v2 0/7] target: make tpg/enable attribute
Date:   Mon, 22 Mar 2021 11:05:47 +0300
Message-ID: <20210322080554.7611-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.33]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Many fabric modules provide their own implementation of enable
attribute in tpg.
The change set removes the code duplication and automatically adds "enable"
attribute for fabric modules that has an implementation of
fabric_enable_tpg() ops.

This patchset is intended for scsi-queue.

v2:
    create enable atribute only for modules with enable_tpg ops
    add patches for srpt, usb and ibmvscsi

Dmitry Bogdanov (7):
  target: core: add common tpg/enable attribute
  target: iscsi: replace enable attr to ops.enable
  target: qla2xx: replace enable attr to ops.enable
  target: sbp: replace enable attr to ops.enable
  target: srpt replace enable attr to ops.enable
  target: ibm_vscsi: replace enable attr to ops.enable
  target: usb: replace enable attr to ops.enable

 drivers/infiniband/ulp/srpt/ib_srpt.c        | 38 +-------
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     | 42 +--------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           | 73 +++-------------
 drivers/target/iscsi/iscsi_target_configfs.c | 91 +++++++-------------
 drivers/target/sbp/sbp_target.c              | 30 ++-----
 drivers/target/target_core_configfs.c        |  1 +
 drivers/target/target_core_fabric_configfs.c | 40 ++++++++-
 drivers/target/target_core_internal.h        |  1 +
 drivers/target/target_core_tpg.c             | 41 +++++++++
 drivers/usb/gadget/function/f_tcm.c          | 31 ++-----
 include/target/target_core_base.h            |  1 +
 include/target/target_core_fabric.h          |  1 +
 12 files changed, 146 insertions(+), 244 deletions(-)

-- 
2.25.1

