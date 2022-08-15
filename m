Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3215ECAAD3
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Sep 2022 17:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiIERjk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Sep 2022 13:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiIERji (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Sep 2022 13:39:38 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8101116F;
        Mon,  5 Sep 2022 10:39:36 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 92ED0439D6;
        Mon,  5 Sep 2022 17:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1662399573; x=
        1664213974; bh=oe/IsoM3nHqGHxB5xiFyAF7ImJSOEjaCKK4XEoBEPJ0=; b=C
        CMtSyenqzCycOIWVaQvcym+lFC7lRsjp+Nhos1LCTnaPoH8V2q/HuotdESx40D1p
        24zJHDXbdzzSZQBtCG/QYvHUgONATKNKok0FRrBZ39V/6zuacwSltK9Yj4X4l5Gi
        7Ju3y6UBjclDLvUPIjYBURT71Kp47AyNDqL/gAKplA=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ooImvmImLxVG; Mon,  5 Sep 2022 20:39:33 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C6C1E43B3E;
        Mon,  5 Sep 2022 20:38:49 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 5 Sep 2022 20:38:45 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 5 Sep 2022 20:38:44 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v2 0/6] add support of RSOC command
Date:   Mon, 15 Aug 2022 10:17:47 +0300
Message-ID: <20220905173837.2383-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset is based on 6.1/scsi-queue.

The patchset adds support of REPORT SUPPORTED OPERATION CODES command
according to SPC4. Including CDB USAGE DATA and timeout descriptors.
Timeout descriptors are zeroed currently, meaning that no time is
indicated, but an encoding of it there is.
Opcode support and Usage Data are dynamically generated - reflects
the backstore configuration.
libiscsi tests for RSOC and tests that uses RSOC command are all PASSED.

v2:
  fix sparse warnings
  remove extra space
  remove XDWRITEREAD_*
  fix tcm_is_ws_enabled

Dmitry Bogdanov (6):
  scsi: target: core: add support of RSOC command
  scsi: target: core: add list of opcodes for RSOC
  scsi: target: core: dynamic opcode support in RSOC
  scsi: target: core: add emulate_rsoc attribute
  scsi: target: check emulate_3pc for RECEIVE COPY
  scsi: target: core: dynamicaly set dpofua in usage_bits

 drivers/target/target_core_configfs.c |  20 +
 drivers/target/target_core_device.c   |   1 +
 drivers/target/target_core_spc.c      | 920 ++++++++++++++++++++++++++
 drivers/target/target_core_xcopy.c    |   6 +
 include/scsi/scsi_proto.h             |  10 +
 include/target/target_core_base.h     |  18 +
 6 files changed, 975 insertions(+)

-- 
2.25.1

