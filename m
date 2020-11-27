Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7CFC63798
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 18:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94FD822244
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 18:29:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EMzMy8Hl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbgK0S3P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Nov 2020 13:29:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727339AbgK0S3P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Nov 2020 13:29:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606501754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=KRF8S0dPX/GnO/XcafgjJXGQUweQMcg89DFReh4493Y=;
        b=EMzMy8Hludnbz33rXmrYo7GQQUuf1VDGZ9Co0yoTWcbL2Nk2h1bIZGQO4457N68BwNbKK7
        6BNwT5ckFq1PNBUy6HxyEQ0JtHL1uFvnQTsXFruG/w4qQLDfXXxsXx8gJVzk0PkFtpjydP
        WiUAN/Pw9oT48cujssT75jwzGd1w1Ro=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-zutbXGVGPSSEMDCMbJWudQ-1; Fri, 27 Nov 2020 13:29:12 -0500
X-MC-Unique: zutbXGVGPSSEMDCMbJWudQ-1
Received: by mail-qv1-f69.google.com with SMTP id 12so1559257qvk.23
        for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2020 10:29:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KRF8S0dPX/GnO/XcafgjJXGQUweQMcg89DFReh4493Y=;
        b=RglCb/vmy0GY8IkZCJXGKeZoKF1mMrt4UeJs9D0gOB9yysNJOgpC1WMUKXBffH3i4B
         gyMMl841n540dat8lMnHYWQyyaYVfXzWlhR0ZhF9Ww97xNN9rW464EtHyVHZDGlFIfdo
         5EOKDkgi/O8efPKzbAw2rJw4a7V43lfKuvZIs8EIqCfkp+cirde9/DXggINPElQ17Koo
         dz1aMUnGqWLx21qwofVdB1Y3ceohFbQUWJKTOGYGuv37UQynJpHy04Vg18QX1xoyUrs+
         LO3q1OcfogI+0hkB985qMX0cog0J/i4wRCYSD9xc4Bb7P6V0bQ07U2USv05OwlLULIVn
         10DQ==
X-Gm-Message-State: AOAM533Pve8hKfpmVSIiesTtiCGER6HpLrHalOIzSictdHVYhQTfP0OJ
        TYhv+gz7BH2eNR55hnlUrz9PWOiDmqzx53YmiBYbfQt+Laooq+ReLlU82Xqq/W0I9GxqX+ExN1i
        WOKdUNRRRPEVKNrn86arrcw==
X-Received: by 2002:a37:a70e:: with SMTP id q14mr9726576qke.337.1606501751590;
        Fri, 27 Nov 2020 10:29:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhGu1WOKP8stMJVEMLMTtWyPaoBWByx3eRAF69XSEmQNhq8pMQl84V5cYetxnsIlV6rRdJCw==
X-Received: by 2002:a37:a70e:: with SMTP id q14mr9726560qke.337.1606501751419;
        Fri, 27 Nov 2020 10:29:11 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id y44sm7437555qtb.50.2020.11.27.10.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 10:29:10 -0800 (PST)
From:   trix@redhat.com
To:     willy@infradead.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] [SCSI] sym53c8xx: remove trailing semicolon in macro definition
Date:   Fri, 27 Nov 2020 10:29:06 -0800
Message-Id: <20201127182906.2804973-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d9a045f9858c..f3b3345c1766 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1001,12 +1001,12 @@ static int is_keyword(char *ptr, int len, char *verb)
 #define SKIP_SPACES(ptr, len)						\
 	if ((arg_len = sym_skip_spaces(ptr, len)) < 1)			\
 		return -EINVAL;						\
-	ptr += arg_len; len -= arg_len;
+	ptr += arg_len; len -= arg_len
 
 #define GET_INT_ARG(ptr, len, v)					\
 	if (!(arg_len = get_int_arg(ptr, len, &(v))))			\
 		return -EINVAL;						\
-	ptr += arg_len; len -= arg_len;
+	ptr += arg_len; len -= arg_len
 
 
 /*
-- 
2.18.4

