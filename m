Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2724C04A6A
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 14:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbjHJOWG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 10:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbjHJOWF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 10:22:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACFD26BD;
        Thu, 10 Aug 2023 07:22:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47E6965D5E;
        Thu, 10 Aug 2023 14:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD67C433C7;
        Thu, 10 Aug 2023 14:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691677322;
        bh=Pw5U4R34UHo1qa7FlbT6kKqWNZNNPz53PW/3LnYPzmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmE6w9ZangEwJyl0bzL8nVZ6jjDHA5th1gO/E9ADy/Y1nZ75eRfOWyryiExAFP9pA
         ja9lflXZ0jCaVYmfWfhNuhWgIx/Vm+0GLyWIYL3F9sYVWjy+q3rTsDzqCy9ltZURDH
         jV8gflzc0nvW9glXOMtVeeDSHEdhTNjGWxSY7uOyMUUkTpeWRQRkJCSoIA0TvOAwO+
         /yt00dCblwGj1tHgh0BhYZ441q/nReP8wvFhAJAYbKe2axRSbhSJRJ7NxP7bQaPFDY
         GpXf8uYqnqoVZehsfNcueXe4cgdWCB3sNK2RygVCQuhX3x1IAH1RMAfW+Et/uJXNnB
         qLwUD30C9dadQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Jack Wang <jinpu.wang@ionos.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 07/17] scsi: qlogicpti: mark qlogicpti_info() static
Date:   Thu, 10 Aug 2023 16:19:25 +0200
Message-Id: <20230810141947.1236730-8-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230810141947.1236730-1-arnd@kernel.org>
References: <20230810141947.1236730-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The qlogicpti_info() function is only used in this file and should
be static to avoid a warning:

drivers/scsi/qlogicpti.c:846:13: error: no previous prototype for 'qlogicpti_info' [-Werror=missing-prototypes]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/qlogicpti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index f88a5421c483f..3b95f7a6216fe 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -843,7 +843,7 @@ static int qpti_map_queues(struct qlogicpti *qpti)
 	return 0;
 }
 
-const char *qlogicpti_info(struct Scsi_Host *host)
+static const char *qlogicpti_info(struct Scsi_Host *host)
 {
 	static char buf[80];
 	struct qlogicpti *qpti = (struct qlogicpti *) host->hostdata;
-- 
2.39.2

