Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A074C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjCITbG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjCITaY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:30:24 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D67DB4A5
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:37 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so7277169pjg.4
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D8ne1LFtZC0aI46uW+Rpyylv80/ucvjDGf+JX18Z6oo=;
        b=u2i9bcHK4AxPzLQUJdZygDn/ab7zuJng7364P4VTK1LTnv+mRHKVXI3j9DNa9g3E+P
         ZpPNC002FKtLJVcCiTSCcXCwaUK52twW0sFNw+zR1UCjZn6Vffkw1hEuVnkKapHP7QZo
         8Fmt8QfIXac1KWEOBdfQRywow2R9ALwE2pu5x816F7ik0gEFboI+g262gabWlYHn4r8d
         VqfJ5UUiJLnLVpUEgz2HOmGrVRwI5vojgbwkfUDllnKzAfjZUGhFl2++mtWxf8FU+6BH
         zrfG/WCTQrFdwpK3SOZgkns0PG2FFOAcCVPh1An/hJUfxSKzDO/6tvqioQBB7SsFdGrv
         toog==
X-Gm-Message-State: AO0yUKWsYvwrxFIRV+ZcuJ4p/+68Qg2naidIbUIRUmYg7Z43AcB7/osA
        MkKka6tWWiD8eigVkQXWytA=
X-Google-Smtp-Source: AK7set/tMl6cxjCYM8zCUpxo8AbkaUXK4gX+I+/qGUOXjHEmIDpRMB1KxDFDj5+8Hn0YvBBZfoVr1A==
X-Received: by 2002:a05:6a20:160c:b0:bf:58f4:beaf with SMTP id l12-20020a056a20160c00b000bf58f4beafmr22556971pzj.7.1678390176983;
        Thu, 09 Mar 2023 11:29:36 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:36 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        GOTO Masanori <gotom@debian.or.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 61/82] scsi: nsp32: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:53 -0800
Message-Id: <20230309192614.2240602-62-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/nsp32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 75bb0028ed74..b7987019686e 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -259,7 +259,7 @@ static void nsp32_dmessage(const char *, int, int,    char *, ...);
 /*
  * max_sectors is currently limited up to 128.
  */
-static struct scsi_host_template nsp32_template = {
+static const struct scsi_host_template nsp32_template = {
 	.proc_name			= "nsp32",
 	.name				= "Workbit NinjaSCSI-32Bi/UDE",
 	.show_info			= nsp32_show_info,
