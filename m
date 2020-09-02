Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A9EC433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 21:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B21F208C7
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 21:14:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bSL/Pt1a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgIBVOt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 17:14:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55558 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726269AbgIBVOr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 17:14:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599081286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=33opjgLrh2ZsUn/nG1tz2yuZ7Nvimue9R8d5qrdj7+U=;
        b=bSL/Pt1aIlRGagD+7sqTP3gjEuglA+dHofIxmHjDex7SfjhN53CyqZQpQQKbX/HNtw4hSl
        2PKdTIy+Yp1ioVhfL4gwgj6SyN6soocvM7H6RDexmcfoNe95CoX0C6OTa7/OVZV5iCN4S2
        PrCucCTb3JzLv1FEQvaKlaZQ0eKZ4kI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-k2RG6qnmMA2OhVFiWhrPWQ-1; Wed, 02 Sep 2020 17:14:44 -0400
X-MC-Unique: k2RG6qnmMA2OhVFiWhrPWQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BFE01DE00;
        Wed,  2 Sep 2020 21:14:43 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-115-53.rdu2.redhat.com [10.10.115.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B9C6B5C22D;
        Wed,  2 Sep 2020 21:14:42 +0000 (UTC)
From:   John Pittman <jpittman@redhat.com>
To:     martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, dgilbert@interlog.com, djeffery@redhat.com,
        loberman@redhat.com, linux-scsi@vger.kernel.org,
        John Pittman <jpittman@redhat.com>
Subject: [PATCH v2 2/2] scsi: scsi_debug: sdebug_build_parts() respect virtual_gb
Date:   Wed,  2 Sep 2020 17:14:34 -0400
Message-Id: <20200902211434.9979-3-jpittman@redhat.com>
In-Reply-To: <20200902211434.9979-1-jpittman@redhat.com>
References: <20200902211434.9979-1-jpittman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If virtual_gb is passed while using num_parts, when creating the
partitions, virtual_gb is not respected.  Set num_sectors using
get_sdebug_capacity() to pull virtual_gb if set.

Signed-off-by: John Pittman <jpittman@redhat.com>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ada0361eac83..a36652d41314 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5268,7 +5268,7 @@ static void sdebug_build_parts(unsigned char *ramp, unsigned long store_size)
 		sdebug_num_parts = SDEBUG_MAX_PARTS;
 		pr_warn("reducing partitions to %d\n", SDEBUG_MAX_PARTS);
 	}
-	num_sectors = (int)sdebug_store_sectors;
+	num_sectors = (int)get_sdebug_capacity();
 	sectors_per_part = (num_sectors - sdebug_sectors_per)
 			   / sdebug_num_parts;
 	heads_by_sects = sdebug_heads * sdebug_sectors_per;
-- 
2.17.2

