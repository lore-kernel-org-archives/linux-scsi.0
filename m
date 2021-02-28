Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F471C433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 351C964E4A
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhB1F7J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 00:59:09 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:1366 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhB1F7F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 00:59:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614491945; x=1646027945;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WtNMMAgFJuO/rCrjBbOX1Y+YFKzRHWrQ6/oJa5ZpzLM=;
  b=Z/R1/Ss0RtrA/9J9KCWsAI7GiLmzAW7vRDoZdHLvroWtVYesCM8rf+z6
   f4E1G43MrC9Fa1Pobw+d+myQqESGAVL2ErrOT2OhEcXsShVIbuLJQFfiD
   jlArII964oct8Sn19bZPtAHlTRETo75ftrd1JOATIbx6Z5pNuqkQqId+M
   I2+0G0dtBNPiD91j5UK/pgJbRbfjLji4ofHW8jZbiWhrhsohz75epoEzZ
   8pFsjN1bSS37BrJcXov5+mNzQlWRdp+eq35MByw2FgE0CQ2st+SbzkQWd
   o1oNCrTHO8GVWpwb8RoUlfpY7kq62tKS/hQeG1hWclRc7Pgcsw8nNfhrE
   w==;
IronPort-SDR: EVxhdmjhwjgXFWTMOFcnCXtZgcDaaj+WIhAmQKOwuFDKKH1WsN9pjp0T8UopNTnEjzf4zegYv2
 QsZJ/G3wC5YsT+1++1ogpE/9QLPddfNvz+0ljC+BCQUrbyY4gS0FYn7qeICcdttAGXdAqInghc
 qlrcyH+0Gh/ZPFkDS0M49Hpr6QzVxxTQPytKgsxra97ElBprHOVXmr8p9goUIYo+3VIsbPEIV0
 p7lHOkzrazuoUCQ6rGeeumyOFIQ5chB0zPnd1tCIl8LjVKuaUTHHDSR5yW+SlgXt8Y7WgW2jZ9
 mF4=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="271564073"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 13:58:00 +0800
IronPort-SDR: OcYEG/mt8p57+78wXBYOMHPjyoC89uCM7onqPS16QRFZ0XqZyzZeS4y1ORJnNbFw0rA6bvEvMN
 yMv1fa1Y2irgyXLhnBGqKAUwjUyr2b+0ROZYLEL8ESWfSn8tyeHVeeW4lE3aBo0qqoX/+WcHIL
 5k3I/7bR1HDRl8M7ceCI8f4GebIfS1ss0azIDTx0dtK0jaf+dTmxd/SITPvRVxJ5hWZvx7vhY3
 oTzOHtYzHkRwlc812NinsDKOJGawI5JRx18g4gxqVaQ1ny55+KiuTWbupkTTK5ANBYbM3hPPQD
 5SpdIHIoqmLWkip+ft+DvnST
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:41:10 -0800
IronPort-SDR: GL/VQWbHLKGHW2/D8fYnwdqdRqdbdHUMEP90WLrQdbwPr1oKE7RGNwzVo06Xmcmc+eBgUxzMve
 eVAdxgoJvBeX91Xq+jm0fO/u+wh6FGipr64D6IR/5RvJVnNqeMiRd31uwzqqpU4haKf6J91yeN
 yGjnD0kdUiqIxj+LSzbF/FnSArpY9QAAD5f7WhpNS92w3yjx0YLAywZ7TyhxmJElfzYVzP//w8
 DQaqMXjS4XFF2OfFJIgFeLb4oehbBBkqgXjkP99IruqzBES/7NWyopu5Ic2BLGIlIehxYlA6sn
 xio=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:57:59 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 06/23] target/pscsi: remove unsed macro ISPRINT
Date:   Sat, 27 Feb 2021 21:56:28 -0800
Message-Id: <20210228055645.22253-7-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the unused macro that fixes the following compilation warning:-

drivers/target//target_core_pscsi.c:37: warning: macro "ISPRINT" is not used [-Wunused-macros]
 #define ISPRINT(a)  ((a >= ' ') && (a <= '~'))

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_pscsi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 689e503e3301..7b1035e08419 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -34,8 +34,6 @@
 #include "target_core_internal.h"
 #include "target_core_pscsi.h"
 
-#define ISPRINT(a)  ((a >= ' ') && (a <= '~'))
-
 static inline struct pscsi_dev_virt *PSCSI_DEV(struct se_device *dev)
 {
 	return container_of(dev, struct pscsi_dev_virt, dev);
-- 
2.22.1

