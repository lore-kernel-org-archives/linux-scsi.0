Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B43FC2D0C7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 15:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1724021556
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 15:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576078862;
	bh=dGre9w7qz8sedtvBmpAAZfZ49ZNF7hQmcKjamEcfsFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=h0gRG3KxMzpSyUmuXos7v24iNDC0Fe9ZQD8xXK8Bk9gL3QvGexWfWmQNMBqVNsBl4
	 iYR4TqWy177XyrR177O++lVdnkfU2INmFLKa5tEXnYcbnbs2Hu0X9wqez5XM34ysGA
	 25wiHki/w/CBNJpBI/uD7PTWyix8+PTh2Z2CTYCE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388535AbfLKPlA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 10:41:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:48714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388228AbfLKPiU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Dec 2019 10:38:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AD2C2077B;
        Wed, 11 Dec 2019 15:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078699;
        bh=dGre9w7qz8sedtvBmpAAZfZ49ZNF7hQmcKjamEcfsFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ioJIAG85ELk7t2nXsKB6GzPiPlKBAyO8Ktq6gA3C5S/6wUTvGhTYRG+A3yOXh55sY
         PutoGmNEdD6lt73n95iNJ2IGr97oSsAIjIttOrq9H2LEsNLkZl2Fcg44DZpcDxUOKg
         d6Dx7Vg49QO2lp1YwzmoWhdMw6qDUCQdVB/neCQM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Disseldorp <ddiss@suse.de>, Lee Duncan <lduncan@suse.com>,
        Mike Christie <mchristi@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 05/37] scsi: target: compare full CHAP_A Algorithm strings
Date:   Wed, 11 Dec 2019 10:37:41 -0500
Message-Id: <20191211153813.24126-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153813.24126-1-sashal@kernel.org>
References: <20191211153813.24126-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 9cef2a7955f2754257a7cddedec16edae7b587d0 ]

RFC 2307 states:

  For CHAP [RFC1994], in the first step, the initiator MUST send:

      CHAP_A=<A1,A2...>

   Where A1,A2... are proposed algorithms, in order of preference.
...
   For the Algorithm, as stated in [RFC1994], one value is required to
   be implemented:

       5     (CHAP with MD5)

LIO currently checks for this value by only comparing a single byte in
the tokenized Algorithm string, which means that any value starting with
a '5' (e.g. "55") is interpreted as "CHAP with MD5". Fix this by
comparing the entire tokenized string.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: David Disseldorp <ddiss@suse.de>
Link: https://lore.kernel.org/r/20190912095547.22427-2-ddiss@suse.de
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target_auth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 3184e023a0529..1dd6028eccb99 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -74,7 +74,7 @@ static int chap_check_algorithm(const char *a_str)
 		if (!token)
 			goto out;
 
-		if (!strncmp(token, "5", 1)) {
+		if (!strcmp(token, "5")) {
 			pr_debug("Selected MD5 Algorithm\n");
 			kfree(orig);
 			return CHAP_DIGEST_MD5;
-- 
2.20.1

