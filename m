Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24144C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDD3A20885
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592446954;
	bh=IYJNKOK5cBTrSDuxAQOv5bJd8WQAogwI6p6Osfy88qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bYBDYzO4Nx8BjC82jz5N6RG5bxdxggAcTDu0BVt0+IAqXpq+t+5IPpASMYNrEzu4U
	 RXsszboivgwDw69lYKp+UvLactClA5ywLgt6IXqzkDvuBAsqLdKsxJIsk3+uCTW759
	 CuTvc2m5ZyWW2z5tYGTwK1x0B+B8kv7vk/gCcJrk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbgFRCW1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 22:22:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729915AbgFRBSY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 21:18:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3433121D80;
        Thu, 18 Jun 2020 01:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443104;
        bh=IYJNKOK5cBTrSDuxAQOv5bJd8WQAogwI6p6Osfy88qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0T+f9RVVmOfgFhXirxqXB0bjab4QwfK8kgO1AgHQkmy32g6DIFDyc1RXzsKsdi9bz
         xX4UzbhMddKb9df2DBbD/pjPo8N0jF8sQB3PNESSryze2EID7JY+ult60LNfL+zQO9
         4QVa4L6RHSUurnOYPZ+wuOaq89767Gk31et5faUE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 082/266] scsi: ibmvscsi: Don't send host info in adapter info MAD after LPM
Date:   Wed, 17 Jun 2020 21:13:27 -0400
Message-Id: <20200618011631.604574-82-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit 4919b33b63c8b69d8dcf2b867431d0e3b6dc6d28 ]

The adapter info MAD is used to send the client info and receive the host
info as a response. A persistent buffer is used and as such the client info
is overwritten after the response. During the course of a normal adapter
reset the client info is refreshed in the buffer in preparation for sending
the adapter info MAD.

However, in the special case of LPM where we reenable the CRQ instead of a
full CRQ teardown and reset we fail to refresh the client info in the
adapter info buffer. As a result, after Live Partition Migration (LPM) we
erroneously report the host's info as our own.

[mkp: typos]

Link: https://lore.kernel.org/r/20200603203632.18426-1-tyreld@linux.ibm.com
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 59f0f1030c54..c5711c659b51 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -415,6 +415,8 @@ static int ibmvscsi_reenable_crq_queue(struct crq_queue *queue,
 	int rc = 0;
 	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
 
+	set_adapter_info(hostdata);
+
 	/* Re-enable the CRQ */
 	do {
 		if (rc)
-- 
2.25.1

