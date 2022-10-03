Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 802C7C43217
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 20:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiJCU1y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 16:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiJCU1v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 16:27:51 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF85B2FC28;
        Mon,  3 Oct 2022 13:27:49 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 8FA244120D;
        Mon,  3 Oct 2022 20:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1664828863; x=
        1666643264; bh=1FIneZs6A9TFfq8NSjda4CWASLhS7iRLGlo8VDjS3cY=; b=f
        dbWQlSzlHosd+ql3Tmr5RmC0K8hbrH9kwJgIoNCadrEqd0QSkmDq3m32S1JVLtwE
        amU5uCGumr41PIa2lRN1Osm5sYBjCsq+iL70YQCyqSZu0RxvcTMNpl+LEFnOts9G
        PShuYof0raFlGprq4zIuj0JsJ2o5g2tYHSrSmtS4+A=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hSl1PqL6Uv7z; Mon,  3 Oct 2022 23:27:43 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E0229411F8;
        Mon,  3 Oct 2022 23:27:36 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 3 Oct 2022 23:27:36 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 3 Oct 2022 23:27:35 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 0/3] fixes related to iSCSI Time2Retain timer
Date:   Mon, 3 Oct 2022 23:27:20 +0300
Message-ID: <20221003202723.22714-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The patchset based on 6.1/scsi-queue. It fixes two bugs in iSCSI about
Time2Retain timer handling - when a session has no connections and it is
waiting for new connection to recovery the session.

The first two patches fixes WARN due to wait_for_completion in timer
context and possible(in cxgbit actual) BUG due to some sleepable things
in the iscsi transport drivers.

The third patch fixes session hanging when the session witn Time2Retain
timer started is forced to close due to ACL removal or TPG disable/delete.

Dmitry Bogdanov (3):
  target: iscsi: schedule close_session at timeout
  target: iscsi: forbid call iscsit_close_session() from atomic context
  target: iscsi: close session without connections

 drivers/target/iscsi/iscsi_target.c       | 35 +++++++++++++++--------
 drivers/target/iscsi/iscsi_target.h       |  3 +-
 drivers/target/iscsi/iscsi_target_erl0.c  |  4 ++-
 drivers/target/iscsi/iscsi_target_login.c |  1 +
 drivers/target/iscsi/iscsi_target_util.c  |  5 +---
 drivers/target/iscsi/iscsi_target_util.h  |  2 +-
 include/target/iscsi/iscsi_target_core.h  |  1 +
 7 files changed, 32 insertions(+), 19 deletions(-)

-- 
2.25.1

