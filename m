Return-Path: <SRS0=CaZB=WP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67EE1C3A59B
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Aug 2019 07:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35D8120989
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Aug 2019 07:50:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XaZrQgJf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfHSHuc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Aug 2019 03:50:32 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41385 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfHSHuc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Aug 2019 03:50:32 -0400
Received: by mail-pf1-f194.google.com with SMTP id 196so687898pfz.8
        for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2019 00:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l95RPm6IpCR8DTMdNFta5bF1nR/qtU4mpZTAKNC+0mc=;
        b=XaZrQgJfn1Bd1primKz9wfrler2an2+i2I0w9GlHCH1wkvyh3S8mREwqKDX6TfWLhG
         zDjh0i3uaR2osYxd+ET4rVbdU5Z3CkPI7fG+304v6112UbNqfFtEzzp8xaGJNc3H2qDL
         9wuIIFcm3qRbSf82yoLU3IhMMHZMWo+pddcJsmnG/48pc3jga6OICEeFIyZgT/+YHsbO
         kGQ+qlSc5Jjl6cmOLDtN6SB/vssSGqBj1btNa0g6e5nOinB39Ar0j7CWmJAYAZjvJQQT
         4UaD1Ojc+4Zdy6rBYaVWxH/IaCF2aJnFGedHZPmnrWtSm0feAxgkfSR/Xl41eeOMrRf6
         bHNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l95RPm6IpCR8DTMdNFta5bF1nR/qtU4mpZTAKNC+0mc=;
        b=Sejam1V+Hwk/6dEL33QdvRgEKXSO1ZK0v0En3FVXEzsu4z+3oUsmhebuyaDZrdzbbU
         vX6VbCm9NQWd5Rldh0gT1UzaLD6tmURwt1HpR3IFKPvEgk20WfN+TcHEvfJEURkd2Xzj
         bhkiw/48bvZtlz9DFTChUNpY4Q/tv2QA1cXGJ2n8pbi+b/SpghOYtb+K6uFF2iX+NhJ4
         8Y7j3xNKfmB87kJtB1ZTo3O/EcdyQiInYMARaw19wmmWZQyLBFUSUlUIuDv4x/yKaxmx
         gW+p4iGdInjj/KJxSprN7bwuS5GOXAgWlgsQ82BKXC6A5oh6+3Tk5SSuB03Zv0FOMfDG
         AB7w==
X-Gm-Message-State: APjAAAVykRBiyMl9BdB0GM2MLVmptHKy2DOEqjsypqpoBymaJfhdX5GQ
        Gde8JsTb2P3OaJkKYge6yI7hFPYD
X-Google-Smtp-Source: APXvYqxN4eQix1w/Mu+Qaa8AlzwONL1FmPs7mbzuKaBGD2c6RRSNVic9p4WWsKDyNQleH6SMNBSybg==
X-Received: by 2002:a63:de43:: with SMTP id y3mr18883489pgi.211.1566201031898;
        Mon, 19 Aug 2019 00:50:31 -0700 (PDT)
Received: from localhost.localdomain ([110.225.16.165])
        by smtp.gmail.com with ESMTPSA id y14sm26629899pfq.85.2019.08.19.00.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 00:50:31 -0700 (PDT)
From:   Nishka Dasgupta <nishkadg.linux@gmail.com>
To:     linuxdrivers@attotech.com, jejb@linux.ibm.com,
        martin.peterson@oracle.com, linux-scsi@vger.kernel.org
Cc:     Nishka Dasgupta <nishkadg.linux@gmail.com>
Subject: [PATCH] SCSI: esas2r: Make structure default_sas_nvram constant
Date:   Mon, 19 Aug 2019 13:20:19 +0530
Message-Id: <20190819075019.692-1-nishkadg.linux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Static structure default_sas_nvram, of type esas2r_sas_nvram, is used
only when copied to a local variable; it is never modified itself. Hence
make it constant to protect it from unintended modification.
Issue found with Coccinelle.

Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
---
 drivers/scsi/esas2r/esas2r_flash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_flash.c b/drivers/scsi/esas2r/esas2r_flash.c
index 7bd376d95ed5..f8414b5a26fa 100644
--- a/drivers/scsi/esas2r/esas2r_flash.c
+++ b/drivers/scsi/esas2r/esas2r_flash.c
@@ -54,7 +54,7 @@
 
 #define ESAS2R_FS_DRVR_VER 2
 
-static struct esas2r_sas_nvram default_sas_nvram = {
+static const struct esas2r_sas_nvram default_sas_nvram = {
 	{ 'E',	'S',  'A',  'S'			     }, /* signature          */
 	SASNVR_VERSION,                                 /* version            */
 	0,                                              /* checksum           */
-- 
2.19.1

