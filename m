Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D504CC07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 09:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD90F613AA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 09:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238489AbhGNJUx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 05:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238647AbhGNJUx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 05:20:53 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67AFC06175F
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 02:18:01 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id l11-20020a056902072bb029055ab4873f4cso1743832ybt.22
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 02:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Vw5Peyqjj1pTkLi4sY9bT/AGnFeqZYNI1XSYVd+RsmA=;
        b=vEVz9LPDXksWBMgvmxxNMwihjbHLL1vGRZYjpyEfgf/xEP04YwhwoNkyro9FOPrA9h
         m0DC1lp5A1Q6ziw4xfUah+lIF6GorCBw3UUo7qPxo1s3ZQ3WIZGs3jNNWjSxiWIYRzml
         AWAH3df/S4/Blvb4qxkq/DGqCtn28lP/ZT0XP6lNhFO8vGaMuKAScSFcf2Ef1KX4lgOO
         /RiJhtOUoI9uU6TeMgaRYg5+MmbL+sHZY31+20vxgNjnqAaQ9PeR0agSkYEDeGHXXXe4
         LVVo1TKeIfZW1MfQNihKotMRnUF/eyciQ6tRmdfjnMWD6SQMSh9rjh3YfImZKKgu0hC0
         OYZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Vw5Peyqjj1pTkLi4sY9bT/AGnFeqZYNI1XSYVd+RsmA=;
        b=Dlz7IAnQc+oUqr9fOxqQr/y6ZNpZU7mWtmh5J3k5SLT+DAnXEB6GBETKOvBBn7E6yh
         5WPYixUJETcRphBtfhHGB9FaETuzEW4FhcagZgu6FWO0UHPt7r0xQnE7A4GL0BX5c3iN
         ox/LXKghx+uJAxj2Dr33WPpoNFPtgyv0nb5BVCiB769L5EvvkQKvhjUoPU/G5SCeQaAH
         ZfRsbrnyuBIcd/n1ImJDqaJNU0g8Qcs2v+FsbNaqStieU1x/m3pUlhbCbPa3W1KquBJq
         Q7uEvRoRs2GpDg06EoEwt5CU/GHAY9haI0R0o77cSn0pCbf9Sgs2JCPBGHL2xoU8iBIY
         8Jvw==
X-Gm-Message-State: AOAM530iCRyeYI66hej+lx1Ec5/tSVlarDTJ3nhbxZvu2ZvfY7QUwlAx
        hXkBG7xBPZEhXydrUBEnsxdD7QxR
X-Google-Smtp-Source: ABdhPJz1WFvQywevhWQJFJ+A0J4TTNUvbo7lLR4oqZ9RDSgByA2ep3BckRZ/icB8EbiiIRgWsXPI/bbFnQ==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:c569:463c:c488:ac2])
 (user=morbo job=sendgmr) by 2002:a25:7ec4:: with SMTP id z187mr12297784ybc.136.1626254280973;
 Wed, 14 Jul 2021 02:18:00 -0700 (PDT)
Date:   Wed, 14 Jul 2021 02:17:45 -0700
In-Reply-To: <20210714091747.2814370-1-morbo@google.com>
Message-Id: <20210714091747.2814370-2-morbo@google.com>
Mime-Version: 1.0
References: <20210714091747.2814370-1-morbo@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 1/3] base: remove unused variable 'no_warn'
From:   Bill Wendling <morbo@google.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following build warning:

  drivers/base/module.c:36:6: error: variable 'no_warn' set but not used [-Werror,-Wunused-but-set-variable]
        int no_warn;

Signed-off-by: Bill Wendling <morbo@google.com>
---
 drivers/base/module.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/base/module.c b/drivers/base/module.c
index 46ad4d636731..81d84a066a38 100644
--- a/drivers/base/module.c
+++ b/drivers/base/module.c
@@ -33,7 +33,6 @@ static void module_create_drivers_dir(struct module_kobject *mk)
 void module_add_driver(struct module *mod, struct device_driver *drv)
 {
 	char *driver_name;
-	int no_warn;
 	struct module_kobject *mk = NULL;
 
 	if (!drv)
@@ -59,12 +58,11 @@ void module_add_driver(struct module *mod, struct device_driver *drv)
 		return;
 
 	/* Don't check return codes; these calls are idempotent */
-	no_warn = sysfs_create_link(&drv->p->kobj, &mk->kobj, "module");
+	sysfs_create_link(&drv->p->kobj, &mk->kobj, "module");
 	driver_name = make_driver_name(drv);
 	if (driver_name) {
 		module_create_drivers_dir(mk);
-		no_warn = sysfs_create_link(mk->drivers_dir, &drv->p->kobj,
-					    driver_name);
+		sysfs_create_link(mk->drivers_dir, &drv->p->kobj, driver_name);
 		kfree(driver_name);
 	}
 }
-- 
2.32.0.93.g670b81a890-goog

