Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4653AC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 11:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbiFHL7O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 07:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238473AbiFHL7M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 07:59:12 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4E310C4
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 04:59:09 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2581X4Ne020925
        for <linux-scsi@vger.kernel.org>; Wed, 8 Jun 2022 04:59:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=G8PQvmyM79CFV+5Xy7OgTVd2Hp4AW40dBzn0PaIjIDE=;
 b=AesZIjYIQBhW/DBG8zHCoRUNnoVInTLPslWEub3to8s1gm2792o/oNFzHq4LAbHUt1Wk
 3e/Oig8C2c0kIj+TzS4PsFi/FIGCNU3VcT82j9tqkV8Ska6eggWx6EXfZoynCDMhh4hZ
 feaO6g8C9iN7zz+2i4dL0MY6f4sai3a8kisMGy4HB6gORFgl0gZsi2mB0wf4GBztAtB/
 PGIc2yw4P1ZKmlTvCY3lEvC7qVEiZcX7qnU8B3zBSsWiZ7YFDt7qmhg3J71gcwgPM1ii
 66fw9r9PlzWLs8aaXh6rLI/qVtuZ5a5LbfsDxn4pHqKAFnTxYf5mtIVBspucUd6lQNHy aA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gjb7pbsag-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jun 2022 04:59:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Jun
 2022 04:58:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 8 Jun 2022 04:58:55 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 80F273F704B;
        Wed,  8 Jun 2022 04:58:55 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 00/10] Additional EDiF bug fixes
Date:   Wed, 8 Jun 2022 04:58:39 -0700
Message-ID: <20220608115849.16693-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: gBavoJK9It2PA70TRh9Y6pwbTaroMZOc
X-Proofpoint-ORIG-GUID: gBavoJK9It2PA70TRh9Y6pwbTaroMZOc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_03,2022-06-07_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver additional EDiF bug fixes to the scsi
tree at your earliest convenience.

Thanks,
Nilesh

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.07.600-k

Quinn Tran (9):
  qla2xxx: edif: Fix IO timeout due to over subscription
  qla2xxx: edif: send logo for unexpected IKE message
  qla2xxx: edif: reduce disruption due to multiple app start
  qla2xxx: edif: fix no login after app start
  qla2xxx: edif: tear down session if keys has been removed
  qla2xxx: edif: fix session thrash
  qla2xxx: edif: Fix no logout on delete for n2n
  qla2xxx: edif: Reduce N2N thrashing at app_start time
  qla2xxx: edif: Fix slow session tear down

 drivers/scsi/qla2xxx/qla_def.h     |  5 ++
 drivers/scsi/qla2xxx/qla_edif.c    | 80 +++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_edif.h    |  4 ++
 drivers/scsi/qla2xxx/qla_fw.h      |  2 +-
 drivers/scsi/qla2xxx/qla_init.c    | 10 +++-
 drivers/scsi/qla2xxx/qla_iocb.c    |  3 ++
 drivers/scsi/qla2xxx/qla_isr.c     | 35 +++++++------
 drivers/scsi/qla2xxx/qla_version.h |  4 +-
 8 files changed, 107 insertions(+), 36 deletions(-)


base-commit: 3fd3a52ca672fea71ff6ebaded2e2ddbbfb3a397
-- 
2.19.0.rc0

