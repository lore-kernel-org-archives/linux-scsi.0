Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E33FC55191
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E823320700
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587731345;
	bh=QpfX3JTibHDMAjB4NRzfy85HK0q7fBbBFotvXBCEJJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=pPhHb4QP8E42GztW7yYUdsZA/SO2jHb+qY08d+lPOTV9H8weC33zAqDVFXQ1rrUUk
	 kZgnlrAXps4uvAdsiwKrNT9T7nUDIitv65qHxFbEt1G0IOfjINZhbcpp2SokSg2pHF
	 rq/ZJNGt4bo4Ms6GdyOh89haG36P0kl0VBmjYgEQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgDXMYG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 08:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbgDXMYE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 08:24:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A266821582;
        Fri, 24 Apr 2020 12:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731044;
        bh=QpfX3JTibHDMAjB4NRzfy85HK0q7fBbBFotvXBCEJJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWDBx+JgiRInv48NlKaovoV/NwVAqyK/49A7sih/5uBQHDuFUgvb/UBkUd5WURlGL
         ZO2dI6M5NYb7RjzFKSbbh4qm3Dy5K4oBgv970v/1pM4ikxXQL7ixgyz+wndkvpz0Pj
         n5lpNjtGG71PuBAPha8m2fEya6gnVLn+Vs6zH+cA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        Mike Christie <mchristi@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/18] scsi: target: fix PR IN / READ FULL STATUS for FC
Date:   Fri, 24 Apr 2020 08:23:44 -0400
Message-Id: <20200424122355.10453-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122355.10453-1-sashal@kernel.org>
References: <20200424122355.10453-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

[ Upstream commit 8fed04eb79a74cbf471dfaa755900a51b37273ab ]

Creation of the response to READ FULL STATUS fails for FC based
reservations. Reason is the too high loop limit (< 24) in
fc_get_pr_transport_id(). The string representation of FC WWPN is 23 chars
long only ("11:22:33:44:55:66:77:88"). So when i is 23, the loop body is
executed a last time for the ending '\0' of the string and thus hex2bin()
reports an error.

Link: https://lore.kernel.org/r/20200408132610.14623-3-bstroesser@ts.fujitsu.com
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Reviewed-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_fabric_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 10fae26b44add..939c6212d2ac5 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -76,7 +76,7 @@ static int fc_get_pr_transport_id(
 	 * encoded TransportID.
 	 */
 	ptr = &se_nacl->initiatorname[0];
-	for (i = 0; i < 24; ) {
+	for (i = 0; i < 23; ) {
 		if (!strncmp(&ptr[i], ":", 1)) {
 			i++;
 			continue;
-- 
2.20.1

