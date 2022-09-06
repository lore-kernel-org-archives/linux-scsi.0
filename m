Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C1EC6FA9B
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 10:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239740AbiIFKr1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 06:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239834AbiIFKqd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 06:46:33 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEB07C19A;
        Tue,  6 Sep 2022 03:45:27 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 2071856578;
        Tue,  6 Sep 2022 10:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1662461110; x=
        1664275511; bh=37T4DMFSfoz0Cm0Uqq4HUSCmLa5RwyTOfxC+zsm45C0=; b=H
        ySvunSqq2+Duwx/vg0JUXjjo5uAUPAB4Y5mF9d+o3J+YFMoA2+qQ8iebB9l3+eGT
        odyG7MsxTWOft/otA5wyHwSQelTvlr3gJTlFyUQMJSLyM9dNIko7VaxAKmQy6L7/
        J7wfdjwN4KrVYdUkqwKgzwEc8wdVlCirLE0c8A6Bm4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id r1FMOl1kB60o; Tue,  6 Sep 2022 13:45:10 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 913B8445A5;
        Tue,  6 Sep 2022 13:34:43 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 6 Sep 2022 13:34:43 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 6 Sep 2022 13:34:40 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v2 0/6] add support of RSOC command
Date:   Tue, 6 Sep 2022 13:34:15 +0300
Message-ID: <20220906103421.22348-1-d.bogdanov@yadro.com>
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

Resending with a current datetime. Sorry for the experiment with a date
of the patch creation.

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

