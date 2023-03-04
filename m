Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4472C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjCDAd6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjCDAda (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:33:30 -0500
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89ED76A1E6
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:09 -0800 (PST)
Received: by mail-pj1-f52.google.com with SMTP id x20-20020a17090a8a9400b00233ba727724so6670299pjn.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cQk/3RH/O3rdmcLxCxnQwypnwRP+bkVFL+TTmjyYx3c=;
        b=2zEyC7w6cNOFjV6Xi1Jj4iixsnHAzqXscflCLIZp2YUEdtJMCY2g6YPYBnIZBCF3On
         qRESsMuGMtYs3d1eCwMwsRSP+eAw4SRV5gUmaZHJ0a+L/S6P9Yt7f5lSXQbL4WKGnE6l
         FCskcNZGvcpZe1Lib0La2rqsHS8hG4CXXoCediuTuURJL8a34O4AzLhUPMVBVsUsBwhP
         JuPplqFQArtobyZscZzOI3Mt4w7dMR8GNyfKGWPI48/TGS8ui6BGgacYnT4MbPtQbPZg
         PonaWDKgh01KRbvMV5iyjmWE3k7+VPwvArxUXKIkHKPSVMYEdsCvPtSJIX5tsCh5zYUe
         6WEA==
X-Gm-Message-State: AO0yUKUhTRHVRz8xtCT/TYgz8F73g0U5KykmunAwoQeF54CLh05FmzhF
        P7GNuNKf851sFEhsXTTEgDMVxN9hFLFCiQ==
X-Google-Smtp-Source: AK7set8AsVOmkNwfVJ+RTWqKvtaYHgtiUvfjmRgcpvah8QTbk4IuBVH6pqAtkdstp0OTU7B8cw/6rw==
X-Received: by 2002:a17:902:7d88:b0:19d:1d32:fc7 with SMTP id a8-20020a1709027d8800b0019d1d320fc7mr2880291plm.51.1677889988962;
        Fri, 03 Mar 2023 16:33:08 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:08 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 40/81] scsi: gvp11: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:22 -0800
Message-Id: <20230304003103.2572793-41-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/gvp11.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 7d56a236a011..d2eddad099a2 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -222,7 +222,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	}
 }
 
-static struct scsi_host_template gvp11_scsi_template = {
+static const struct scsi_host_template gvp11_scsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "GVP Series II SCSI",
 	.show_info		= wd33c93_show_info,
