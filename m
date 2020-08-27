Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 363B1C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 21:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1499F20737
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 21:33:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A5VO1rsF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgH0Vdk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 17:33:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41840 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726073AbgH0Vdj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2020 17:33:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598564018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Jfd9y05XPInLD6OvcmTltLi3LeccDk5KisBp82mptvE=;
        b=A5VO1rsFzKWqdKsGK+T8iBZZGIbur8GsSwnnXgwhs5zWxN7YAJD9KEyhzd3186+9ixxN3D
        q3SBZEhUHOTguvmYHSFZseHPBdfDRhl0m4+eN+eTOBMj1puUVI6sYvh3+Vgyqf/Ft3iKAO
        /w7brUINYmj5qRNcnGMd3M7YQhpCLlE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-ExopctPANGmgCLTvBtVF3A-1; Thu, 27 Aug 2020 17:33:36 -0400
X-MC-Unique: ExopctPANGmgCLTvBtVF3A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57BF1425D3;
        Thu, 27 Aug 2020 21:33:35 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-221.rdu2.redhat.com [10.10.114.221])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B74778401;
        Thu, 27 Aug 2020 21:33:34 +0000 (UTC)
From:   John Pittman <jpittman@redhat.com>
To:     martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, djeffery@redhat.com,
        linux-scsi@vger.kernel.org, John Pittman <jpittman@redhat.com>
Subject: [PATCH 1/2] scsi: scsi_debug: adjust num_parts to create equally sized partitions
Date:   Thu, 27 Aug 2020 17:33:26 -0400
Message-Id: <20200827213327.25537-2-jpittman@redhat.com>
In-Reply-To: <20200827213327.25537-1-jpittman@redhat.com>
References: <20200827213327.25537-1-jpittman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
 drivers/scsi/scsi_debug.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 139f0073da37..3d9db1e8b781 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5259,7 +5259,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
 static void sdebug_build_parts(unsigned char *ramp, unsigned long store_size)
 {
 	struct msdos_partition *pp;
-	int starts[SDEBUG_MAX_PARTS + 2];
+	int starts[SDEBUG_MAX_PARTS + 2], max_part_secs;
 	int sectors_per_part, num_sectors, k;
 	int heads_by_sects, start_sec, end_sec;
 
@@ -5271,13 +5271,16 @@ static void sdebug_build_parts(unsigned char *ramp, unsigned long store_size)
 		pr_warn("reducing partitions to %d\n", SDEBUG_MAX_PARTS);
 	}
 	num_sectors = (int)sdebug_store_sectors;
-	sectors_per_part = (num_sectors - sdebug_sectors_per)
+	max_part_secs = sectors_per_part = (num_sectors - sdebug_sectors_per)
 			   / sdebug_num_parts;
 	heads_by_sects = sdebug_heads * sdebug_sectors_per;
 	starts[0] = sdebug_sectors_per;
-	for (k = 1; k < sdebug_num_parts; ++k)
+	for (k = 1; k < sdebug_num_parts; ++k) {
 		starts[k] = ((k * sectors_per_part) / heads_by_sects)
 			    * heads_by_sects;
+		if (starts[k] - starts[k - 1] < max_part_secs)
+			max_part_secs = starts[k] - starts[k - 1];
+	}
 	starts[sdebug_num_parts] = num_sectors;
 	starts[sdebug_num_parts + 1] = 0;
 
@@ -5286,7 +5289,7 @@ static void sdebug_build_parts(unsigned char *ramp, unsigned long store_size)
 	pp = (struct msdos_partition *)(ramp + 0x1be);
 	for (k = 0; starts[k + 1]; ++k, ++pp) {
 		start_sec = starts[k];
-		end_sec = starts[k + 1] - 1;
+		end_sec = starts[k] + max_part_secs - 1;
 		pp->boot_ind = 0;
 
 		pp->cyl = start_sec / heads_by_sects;
-- 
2.17.2

