Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8172EC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 19:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 637992082F
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 19:18:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hHsqE9Yz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387527AbgFWTSJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 15:18:09 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54878 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387518AbgFWTSJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Jun 2020 15:18:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592939888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H1ShwfQ/jwFEqVsmbSMX+mrCeDuorCzonQ7UJ1/zhw8=;
        b=hHsqE9YzLxeYW0RQ1+SMe+/AyWeh3v0Ar26XW2htfjWu/sTQi+HdfpxM6+MrrO9Vs79TdF
        3V8Qi52iMg/dqyYmBEQV3+qTRwCyHuTBL2pHHeMUh4YcfLNsNsVtUcsWUfBU3LEodnziu5
        9XV5T37nx+D6y9qPoIE6yZ5G65a7ImE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-146-zBuTM42psyn7Tn6OUw-1; Tue, 23 Jun 2020 15:18:03 -0400
X-MC-Unique: 146-zBuTM42psyn7Tn6OUw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2AF0107ACCA;
        Tue, 23 Jun 2020 19:18:02 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5A577168D;
        Tue, 23 Jun 2020 19:18:01 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: [RFC PATCH v3 8/8] dev_vprintk_emit: Increase hdr size
Date:   Tue, 23 Jun 2020 14:17:49 -0500
Message-Id: <20200623191749.115200-9-tasleson@redhat.com>
In-Reply-To: <20200623191749.115200-1-tasleson@redhat.com>
References: <20200623191749.115200-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With the addition of the device persistent id we have the possibility
of adding 154 more bytes to the hdr.  Thus if we assume the previous
size of 128 was sufficent we can simply add the 2 amounts and round
up.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 drivers/base/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 964690572a89..c2439d12608d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3814,7 +3814,7 @@ create_syslog_header(const struct device *dev, char *hdr, size_t hdrlen)
 int dev_vprintk_emit(int level, const struct device *dev,
 		     const char *fmt, va_list args)
 {
-	char hdr[128];
+	char hdr[288];
 	size_t hdrlen;
 
 	hdrlen = create_syslog_header(dev, hdr, sizeof(hdr));
-- 
2.25.4

