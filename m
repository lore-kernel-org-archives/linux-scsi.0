Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37579C433E7
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 21:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1015720758
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 21:14:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HUpNn4Gt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgIBVOs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 17:14:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43547 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726426AbgIBVOp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 17:14:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599081284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=tAVcZJdgsazLOJDp1DMlRXW8TsdCCCRWubdKFriO39Y=;
        b=HUpNn4Gtr6oRBkothoCzNzaoslbhSUSh6AzuREW89iD5oMsh6X/FUMUFpFYLnXjfVeHV2M
        YU2CypId14DKbSwdfnRDGN4MBde7SB2nj0AykDnNO6Bi9Rgo/7a+0EWmb5CUm6el/01m1B
        hDLTuRHInCCrDe+xwuUrePhcwPfIY2Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-UoTsSi3YNja1rFu6Jpdv7g-1; Wed, 02 Sep 2020 17:14:42 -0400
X-MC-Unique: UoTsSi3YNja1rFu6Jpdv7g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A06901DE00;
        Wed,  2 Sep 2020 21:14:41 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-115-53.rdu2.redhat.com [10.10.115.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E61775C22D;
        Wed,  2 Sep 2020 21:14:40 +0000 (UTC)
From:   John Pittman <jpittman@redhat.com>
To:     martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, dgilbert@interlog.com, djeffery@redhat.com,
        loberman@redhat.com, linux-scsi@vger.kernel.org,
        John Pittman <jpittman@redhat.com>
Subject: [PATCH v2 1/2] scsi: scsi_debug: adjust num_parts to create equally sized partitions
Date:   Wed,  2 Sep 2020 17:14:33 -0400
Message-Id: <20200902211434.9979-2-jpittman@redhat.com>
In-Reply-To: <20200902211434.9979-1-jpittman@redhat.com>
References: <20200902211434.9979-1-jpittman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently when using the num_parts parameter, partitions are aligned
and the end sector is one prior to the next start.  This creates
different sized partitions. Create instead equally sized partitions by
trimming the end of each partition to the size of the smallest
partition.  This aligns better with what one would expect from
automatically created partitions and can be helpful with testing
things such as raid which often expect legs of the same size.
Minimal space is lost as the initial partition starting size is
calculated by dividing num_sectors by sdebug_num_parts.

Signed-off-by: John Pittman <jpittman@redhat.com>
---
 drivers/scsi/scsi_debug.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1ad7260d4758..ada0361eac83 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5257,7 +5257,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
 static void sdebug_build_parts(unsigned char *ramp, unsigned long store_size)
 {
 	struct msdos_partition *pp;
-	int starts[SDEBUG_MAX_PARTS + 2];
+	int starts[SDEBUG_MAX_PARTS + 2], max_part_secs;
 	int sectors_per_part, num_sectors, k;
 	int heads_by_sects, start_sec, end_sec;
 
@@ -5273,9 +5273,13 @@ static void sdebug_build_parts(unsigned char *ramp, unsigned long store_size)
 			   / sdebug_num_parts;
 	heads_by_sects = sdebug_heads * sdebug_sectors_per;
 	starts[0] = sdebug_sectors_per;
-	for (k = 1; k < sdebug_num_parts; ++k)
+	max_part_secs = sectors_per_part;
+	for (k = 1; k < sdebug_num_parts; ++k) {
 		starts[k] = ((k * sectors_per_part) / heads_by_sects)
 			    * heads_by_sects;
+		if (starts[k] - starts[k - 1] < max_part_secs)
+			max_part_secs = starts[k] - starts[k - 1];
+	}
 	starts[sdebug_num_parts] = num_sectors;
 	starts[sdebug_num_parts + 1] = 0;
 
@@ -5284,7 +5288,7 @@ static void sdebug_build_parts(unsigned char *ramp, unsigned long store_size)
 	pp = (struct msdos_partition *)(ramp + 0x1be);
 	for (k = 0; starts[k + 1]; ++k, ++pp) {
 		start_sec = starts[k];
-		end_sec = starts[k + 1] - 1;
+		end_sec = starts[k] + max_part_secs - 1;
 		pp->boot_ind = 0;
 
 		pp->cyl = start_sec / heads_by_sects;
-- 
2.17.2

