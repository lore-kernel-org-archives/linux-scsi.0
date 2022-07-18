Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8F2CCA486
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 15:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235376AbiGRP0O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 11:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbiGRP0M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 11:26:12 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAD328E26;
        Mon, 18 Jul 2022 08:26:11 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9ABA341239;
        Mon, 18 Jul 2022 15:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1658157969; x=
        1659972370; bh=qfjlOOHgy+rOsES9el+0S9l32s+UHl69L49XGl250Hw=; b=Y
        7hOqH4Mtoh2IwnWEE9O+OK2qesdp5zOYvsvo+SZWvemJtOe44cvLT/pseQZtRTEV
        vkYfT8lyrWJumYl6ahLHFt3UkGwHDY2thsuws9hOC5eCrQn0DTnPecSa1i/kMakd
        Z+DUiXckYqZ3SaTrpTepFYvJj71sESqbhpCsir1lnE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id U83YD00tkfbb; Mon, 18 Jul 2022 18:26:09 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C359941241;
        Mon, 18 Jul 2022 18:26:08 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 18 Jul 2022 18:26:08 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 18 Jul 2022 18:26:07 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 0/4] Improve iSCSI target code
Date:   Mon, 18 Jul 2022 18:25:51 +0300
Message-ID: <20220718152555.17084-1-d.bogdanov@yadro.com>
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

This patchset adds few improvements of iSCSI target that mostly
required by tests in Window HLK.

Dmitry Bogdanov (4):
  scsi: target: iscsi: add support extended CDB AHS
  scsi: target: iscsi: support base64 in CHAP
  target: iscsi: allow negotiate AuthMethod=None
  target: iscsi: not require target authentication

 drivers/target/iscsi/iscsi_target.c       |  55 +++++++++-
 drivers/target/iscsi/iscsi_target_auth.c  | 122 +++++++++++++++++-----
 drivers/target/iscsi/iscsi_target_login.c |  13 +++
 drivers/target/iscsi/iscsi_target_nego.c  |  15 +--
 drivers/target/iscsi/iscsi_target_nego.h  |   3 +-
 5 files changed, 173 insertions(+), 35 deletions(-)

-- 
2.25.1

