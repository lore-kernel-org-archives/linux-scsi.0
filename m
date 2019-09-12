Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86691C49ED6
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 00:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 450682082C
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 00:39:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="fru8xbLO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbfILAjp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Sep 2019 20:39:45 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:56088 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbfILAjp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Sep 2019 20:39:45 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 199AB435D1;
        Thu, 12 Sep 2019 00:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1568248782; x=
        1570063183; bh=fHvihKOHj1qbemTeTqK/LE+pZRsoDI9HMxQg4y6g8Hk=; b=f
        ru8xbLOgxgRr0yzGlvBBBTSTM6s5sJxVDSQ9XfcITWLxfy2Y0nKHxH4z/KdwmTHE
        PqEslVAjyhMEKV+8ur5ip8VahmGIzNfPBctIAHL6UD+Y8d+rRqugbjpAdvzYXqV1
        xuuWlnmDxgcpU6C/0OYm2rkIJi+Mh87sIf0gFO8SDs=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gBxYp8q9squ5; Thu, 12 Sep 2019 03:39:42 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id F36FF412D6;
        Thu, 12 Sep 2019 03:39:41 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 12
 Sep 2019 03:39:41 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qtran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4] scsi: qla2xxx: Bug fixes
Date:   Thu, 12 Sep 2019 03:39:15 +0300
Message-ID: <20190912003919.8488-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This series has a few bug fixes for the driver.

Note, #1 only fixes the crash in the kernel. The complete fix for clean
ACL deletion from initiator side is in works and requires a discussion.

As of now initiator is not aware that target no longer wants talking to
it, that implies unneeded timeout. It might be fixed by making LOGO
explicit on session deletion but it's an issue I want to raise first
before making the change. Whether we need implicit LOGO in qla2xxx,
explicit or use both.

Also, an unsolicited ABTS from a port without session would still result
in BA_RJT response instead of frame discard and LOGO ELS, as specified
in FCP (12.3.3 Target FCP_Port response to Exchange termination):

   When an ABTS-LS is received at the target FCP_Port, it shall abort
   the designated Exchange and return one of the following responses:

   a) the target FCP_Port shall discard the ABTS-LS and transmit a LOGO
      ELS if the Nx_Port issuing the ABTS-LS is not currently logged in
      (i.e., no N_Port Login exists);

FWIW, the target driver can receive ABTS as part of ABORT TASK/LUN
RESET/CLEAR TASK SET TMFs and in case of failed sequence retransmission
requests, exchange or sequence errors. IIRC, some initiators requeue
SCSI commands if BA_RJT is received. Therefore, a timely LOGO will
prevent a perceived session freeze on the initiators.

Thanks,
Roman

Roman Bolshakov (4):
  scsi: qla2xxx: Ignore NULL pointer in tcm_qla2xxx_free_mcmd
  scsi: qla2xxx: Initialize free_work before flushing it
  scsi: qla2xxx: Drop superfluous INIT_WORK of del_work
  scsi: qla2xxx: Change discovery state before PLOGI

 drivers/scsi/qla2xxx/qla_init.c    | 2 ++
 drivers/scsi/qla2xxx/qla_target.c  | 2 --
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.22.0

