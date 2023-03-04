Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA02C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjCDAeQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjCDAdu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:33:50 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B8CBB8D
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:19 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id h8so4511867plf.10
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MFd7OEytCze0u5XL5op+H8sbsT2Mg/pBWrkNJAZR/H8=;
        b=Q3k1piaLnodJidzYrFftnXyL98M0xzaY+9BNYPujhiiFGA5E89E6eYRXBYDJy3MR1J
         13Bx7ZO3YfaIGm6CpM4khGO91V07Op2NjGylo+lIYvkCP1q2P5sJ4LM3cyfGJk6NPF0d
         G6vPWt0pGY7RxJua6QOKpslJgTL9IGFgdnUfJRC+FSYP60YIUufhKPQCK+8F+Lwu+OGA
         9VuBrCAr4+NHvCSYLxUGpMM38WMjRN49MCajkK1O/RrQLSYVKiif2T+KvYhkCIxTRyiq
         gIaA6vBoe0pZD4u0d7UvbqnucvwlWOpnDYS3NxE5NkzVmK0AFxLikrsJHIRPp5rKs+5M
         JJYw==
X-Gm-Message-State: AO0yUKXdUKe6oPmKplJ4p1j6VdvbmJEOg0dyj2OArcqksMXZPplq7K+d
        2LMIFNp2XA/dJP+6b+p2NFXr+nlrYrDPJQ==
X-Google-Smtp-Source: AK7set8pNhiHm0fbuzWXX6N1+u/kKCPKo+laY7irds4nhwU+YPvn00xTTiCCmX4LdS9BEP4oc+9waw==
X-Received: by 2002:a17:902:f7cb:b0:19c:ba57:a869 with SMTP id h11-20020a170902f7cb00b0019cba57a869mr3314766plw.13.1677889999184;
        Fri, 03 Mar 2023 16:33:19 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:18 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 46/81] scsi: initio: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:28 -0800
Message-Id: <20230304003103.2572793-47-bvanassche@acm.org>
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
 drivers/scsi/initio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 375261d67619..2a50fda3a628 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2788,7 +2788,7 @@ static void i91uSCBPost(u8 * host_mem, u8 * cblk_mem)
 	initio_release_scb(host, cblk);	/* Release SCB for current channel */
 }
 
-static struct scsi_host_template initio_template = {
+static const struct scsi_host_template initio_template = {
 	.proc_name		= "INI9100U",
 	.name			= "Initio INI-9X00U/UW SCSI device driver",
 	.queuecommand		= i91u_queuecommand,
