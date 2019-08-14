Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32433C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06E6820866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kg91ut7b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbfHNX5w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:52 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40628 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729815AbfHNX5w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:52 -0400
Received: by mail-pf1-f194.google.com with SMTP id w16so333406pfn.7
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6qiwnv49dFNxAsfRrtiqnpS/2rvReRZqlprCxUOCOME=;
        b=Kg91ut7bHfbz15XasjHI8TJAxa79wXmofXtgQB+2ddnSnabfUoJMVy0SrDPJ6wy5xk
         1OJO6QrB29SR16e5a/hxmQuIesbgqoKIII54XZpoMXw0W4hYgJrzq9e5Y7T43vJDzWd9
         YnMUIzPTc3iUiz/v/LQsWJzcSG00cNcoJijIL8ah4CqgWuPSW08aFH8O5T7e8TgmR64l
         t2T3yjGa8XdM+bcp0uogdq1/nj5tHybq+DAx7PQcGHs0QsWOiJKIeLGY3yEIMMOo8tZz
         Lfp0p9IzMyhCemEexVFu6GMp7srbGFOCHmalYLfNK9Jd4DwRLS4wm3MbzefVwplxVlyD
         r34A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6qiwnv49dFNxAsfRrtiqnpS/2rvReRZqlprCxUOCOME=;
        b=L+qr+oF6HhMZuyE0AnjYHpv9Cbg23UhIhlwJVFtzbJs/RJz1wH70q2YRAErnPrdKVL
         s0cfj/iXyXSvArL1pd+CnvqrDtHdiXuAmd9vkO8ZfPrDW5fY9Lj/EaIsYuNw361JYiJb
         qq2JcBrRC2wYyqYefXcK7daFwv+28QZSOMkT4x6VpryL7+8gyxQrIrwyjfJowevccGAN
         KaCTXUvqAYztGkM5BKIlmc2fj9VENK/NrCoPkc2LuJ2uYGjboYF8RHoZOQU6P+WvFdb0
         PCWsm3DPcpohsN1EndM9V92Lz1PDxMNOXDYTeDzMmVYVI0h31VymxhoNeOxfBDg5QL7Y
         R8ug==
X-Gm-Message-State: APjAAAXyfo/B/OU6u1aRxoO7XGKhLZZh1ilVG6nN/9XBWWFLLnoZyJ5d
        Mlix0I8v7HrAIszumpw4deHpUAg3
X-Google-Smtp-Source: APXvYqxD6lwGwSm9XK2FVLqnaujsW0AklP4i+PlTHl/W7Xxt+K7VIE9NgZYXqpMCLLrCaOgjhLqd9Q==
X-Received: by 2002:a17:90a:c24e:: with SMTP id d14mr419190pjx.129.1565827071230;
        Wed, 14 Aug 2019 16:57:51 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:50 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 37/42] lpfc: Add first and second level hardware revisions to sysfs reporting
Date:   Wed, 14 Aug 2019 16:57:07 -0700
Message-Id: <20190814235712.4487-38-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To aid better hardware detection when there are issues, report the
first and second level hardware revisions from the READ_REV command.
Add the elements to the existing hardware id string.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index a851bf557dba..f4f1291ec1ba 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -841,7 +841,8 @@ lpfc_hdw_show(struct device *dev, struct device_attribute *attr, char *buf)
 	lpfc_vpd_t *vp = &phba->vpd;
 
 	lpfc_jedec_to_ascii(vp->rev.biuRev, hdw);
-	return scnprintf(buf, PAGE_SIZE, "%s\n", hdw);
+	return scnprintf(buf, PAGE_SIZE, "%s %08x %08x\n", hdw,
+			 vp->rev.smRev, vp->rev.smFwRev);
 }
 
 /**
-- 
2.13.7

