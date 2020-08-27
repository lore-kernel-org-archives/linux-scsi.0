Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D326C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 21:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F197420737
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 21:33:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hM5cZ8Ea"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgH0Vdl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 17:33:41 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27294 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726073AbgH0Vdl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Aug 2020 17:33:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598564020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=V90qwBEBqDErL+Ye1i9qb9gZIBE4Ek+2IynS8wkdapM=;
        b=hM5cZ8EaI9VNYAbeIMLqwe1nIM/iu7xQe1MyDXSn4Mz+ge3rgkIn+YH2ghaOXlJ9K38euG
        ZK7vEZ8qmOey7czDpeQgO1ihx/bLY3eDRoXw159yBh9Bp3lnYFstQk+T4/iHy+2xbG8N5k
        ozXJSn6pH75nksDW5yy8jvlBnkOnuaI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-xEdgCy9LORqTiHNF11F9bA-1; Thu, 27 Aug 2020 17:33:38 -0400
X-MC-Unique: xEdgCy9LORqTiHNF11F9bA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E458425D3;
        Thu, 27 Aug 2020 21:33:37 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-221.rdu2.redhat.com [10.10.114.221])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8109B1C4;
        Thu, 27 Aug 2020 21:33:36 +0000 (UTC)
From:   John Pittman <jpittman@redhat.com>
To:     martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, djeffery@redhat.com,
        linux-scsi@vger.kernel.org, John Pittman <jpittman@redhat.com>
Subject: [PATCH 2/2] scsi: scsi_debug: sdebug_build_parts() respect virtual_gb
Date:   Thu, 27 Aug 2020 17:33:27 -0400
Message-Id: <20200827213327.25537-3-jpittman@redhat.com>
In-Reply-To: <20200827213327.25537-1-jpittman@redhat.com>
References: <20200827213327.25537-1-jpittman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index 3d9db1e8b781..e6b57cead316 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5270,7 +5270,7 @@ static void sdebug_build_parts(unsigned char *ramp, unsigned long store_size)
 		sdebug_num_parts = SDEBUG_MAX_PARTS;
 		pr_warn("reducing partitions to %d\n", SDEBUG_MAX_PARTS);
 	}
-	num_sectors = (int)sdebug_store_sectors;
+	num_sectors = (int)get_sdebug_capacity();
 	max_part_secs = sectors_per_part = (num_sectors - sdebug_sectors_per)
 			   / sdebug_num_parts;
 	heads_by_sects = sdebug_heads * sdebug_sectors_per;
-- 
2.17.2

