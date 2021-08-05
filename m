Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB5EC432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 23:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E43CD610CD
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 23:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238306AbhHEXfa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 19:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238061AbhHEXf3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 19:35:29 -0400
Received: from mail-oi1-x262.google.com (mail-oi1-x262.google.com [IPv6:2607:f8b0:4864:20::262])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE26C0613D5
        for <linux-scsi@vger.kernel.org>; Thu,  5 Aug 2021 16:35:14 -0700 (PDT)
Received: by mail-oi1-x262.google.com with SMTP id o185so9586784oih.13
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 16:35:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:dkim-signature:from:to:cc:subject:date
         :message-id:content-transfer-encoding;
        bh=0BiRSnRyB4JhIBd4KrAemXgLG/qgwW1qU26DhEQiEMc=;
        b=XwvYD7mrcFfiUbmyX+uqhCmigxF4bfW67uFs/r1NIfwJ2I9fJwPfK1QuOjqqwu73IO
         zpGDa5XZXHQZ6FmBUI1RmyU1Y+TyDgDM5NZpZ907tvf2FsQ7C30mvSe9/2gSQ/hLF1Zd
         sED3grCy3cqaBhxWxSKBebZuTRqr1h0OLPWvvK9saD9JFsD9KZDfbHlbnuaKnt4Tu7Hq
         oBprSmRWNNuthOnl+xNcYl5X3UcS+PXJD6vzBm4D4+JD/XfgZlsJOIdZu/KW1dQlnTdv
         l2o5LLew+J0i0o94XJ/G4aRB4x41sVxvUwGyThBVOYDFFCtvvsmyYquGslGJQY54ZvRc
         Q+Xw==
X-Gm-Message-State: AOAM532OLCk8vDxcGZrj5EGVnrv32yJOiKjWi5IS/6cwqznTEVGIScIQ
        hDVq0c0wn9fYyu5qJ48QV80k9fMQ+yqlRtYK+HvxkG9cpgGa
X-Google-Smtp-Source: ABdhPJwyX//2MoDU9UeEOedJObiuXZ+uyDBoVwDH580ISGdrBtm5hqypScQZZg77dz84IPBCplei90FbaYng
X-Received: by 2002:a05:6808:288:: with SMTP id z8mr4097191oic.148.1628206501832;
        Thu, 05 Aug 2021 16:35:01 -0700 (PDT)
Received: from smtp.aristanetworks.com (smtp.aristanetworks.com. [52.0.43.43])
        by smtp-relay.gmail.com with ESMTPS id x41sm12822otr.12.2021.08.05.16.35.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Aug 2021 16:35:01 -0700 (PDT)
X-Relaying-Domain: arista.com
Received: from chmeee (unknown [10.95.66.211])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id 7BCC63000243;
        Thu,  5 Aug 2021 16:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1628206500;
        bh=0BiRSnRyB4JhIBd4KrAemXgLG/qgwW1qU26DhEQiEMc=;
        h=From:To:Cc:Subject:Date:From;
        b=FZMcN1zB8kMKZGhMEzAzxSrNkL6qquhHgE3+e5Mxey66TnEUDM/lt3rq4bUoFFZi+
         a/2c+E0uVLtecI5N/wSGhBUaTn+hcrbF00Q8jM+Av5jg84SF/1y4DftsN44MSpE837
         gdY0prUrb0d/L46Lx3cOuLBX7fB91LMehcQDUkHfcB2CT4/BVa6aTp7F+o+C9Kiqz8
         /aoKN5+jpyIdZLS8yrcyNNRdb3KmSqWudLmeHYv9cuev4+0W5lV4yNjNzH8UoCIydR
         SAdl9cT6NCUMsh362ozABQVuHvqxTBaB32eiIIWpYmfoG9q85Oa2I5AN9cR3Hhe+2d
         gno82L67w+TBw==
Received: from kevmitch by chmeee with local (Exim 4.94.2)
        (envelope-from <kevmitch@chmeee>)
        id 1mBmt8-001gxM-81; Thu, 05 Aug 2021 16:34:58 -0700
From:   Kevin Mitchell <kevmitch@arista.com>
Cc:     Kevin Mitchell <kevmitch@arista.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mark scsi_dispatch_cmd as noinline
Date:   Thu,  5 Aug 2021 16:33:15 -0700
Message-Id: <20210805233315.403313-1-kevmitch@arista.com>
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When scsi_dispatch_cmd was moved to scsi_lib.c and made static, some
compilers (i.e., at least gcc 8.4.0) decided to compile this
inline. This is a problem for the lkdtm.ko, which needs to insert a
kprobe on this function for the SCSI_DISPATCH_CMD crashpoint.

Mark the function as noinline so as to guarantee the symbol can be found
by register_kprobe.

Fixes: 82042a2cdb55 ("scsi: move scsi_dispatch_cmd to scsi_lib.c")
Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7456a26aef51..dbe2d5053d6c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1443,7 +1443,7 @@ static void scsi_complete(struct request *rq)
  * Return: nonzero return request was rejected and device's queue needs to be
  * plugged.
  */
-static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
+static noinline int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	int rtn = 0;
-- 
2.32.0

