Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 976E7C433F4
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C32761969
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhCVIGe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 04:06:34 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39582 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229893AbhCVIGR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 04:06:17 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B690F412DB;
        Mon, 22 Mar 2021 08:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1616400375; x=1618214776; bh=jUqQJgIjhKblpFe/c/f4S0BagJN1clz0gAW
        zNPlVlhg=; b=CTTPArBXNiYLybrMN4n9xdUrDyWG5yRNthrnna7yWzqOZlJjWwf
        2GMBZWSagxuyMU2RyWPz2ikQeJefMUG9PjWpKIiyrVtjVBIdf4OjsrfYejjqQkN4
        w1c3HSO9zH6ldMO9hGMHTV/A+3o/07wGrm8y7VATvvVJq5BknNUCrjXw=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7_jI9HwZHLjF; Mon, 22 Mar 2021 11:06:15 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 46792411FB;
        Mon, 22 Mar 2021 11:06:13 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.0.33) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 22
 Mar 2021 11:06:12 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 7/7] target: usb: replace enable attr to ops.enable
Date:   Mon, 22 Mar 2021 11:05:54 +0300
Message-ID: <20210322080554.7611-8-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322080554.7611-1-d.bogdanov@yadro.com>
References: <20210322080554.7611-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.33]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove tpg/enable attribute.
Add fabric ops enable_tpg implementation instead.

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/usb/gadget/function/f_tcm.c | 31 ++++++-----------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 410fa89eae8f..6cfa5362bc8d 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1499,42 +1499,24 @@ static struct configfs_attribute *usbg_wwn_attrs[] = {
 	NULL,
 };
 
-static ssize_t tcm_usbg_tpg_enable_show(struct config_item *item, char *page)
-{
-	struct se_portal_group *se_tpg = to_tpg(item);
-	struct usbg_tpg  *tpg = container_of(se_tpg, struct usbg_tpg, se_tpg);
-
-	return snprintf(page, PAGE_SIZE, "%u\n", tpg->gadget_connect);
-}
-
 static int usbg_attach(struct usbg_tpg *);
 static void usbg_detach(struct usbg_tpg *);
 
-static ssize_t tcm_usbg_tpg_enable_store(struct config_item *item,
-		const char *page, size_t count)
+static int usbg_enable_tpg(struct se_portal_group *se_tpg, bool enable)
 {
-	struct se_portal_group *se_tpg = to_tpg(item);
 	struct usbg_tpg  *tpg = container_of(se_tpg, struct usbg_tpg, se_tpg);
-	bool op;
-	ssize_t ret;
-
-	ret = strtobool(page, &op);
-	if (ret)
-		return ret;
-
-	if ((op && tpg->gadget_connect) || (!op && !tpg->gadget_connect))
-		return -EINVAL;
+	int ret;
 
-	if (op)
+	if (enable)
 		ret = usbg_attach(tpg);
 	else
 		usbg_detach(tpg);
 	if (ret)
 		return ret;
 
-	tpg->gadget_connect = op;
+	tpg->gadget_connect = enable;
 
-	return count;
+	return 0;
 }
 
 static ssize_t tcm_usbg_tpg_nexus_show(struct config_item *item, char *page)
@@ -1677,11 +1659,9 @@ static ssize_t tcm_usbg_tpg_nexus_store(struct config_item *item,
 	return count;
 }
 
-CONFIGFS_ATTR(tcm_usbg_tpg_, enable);
 CONFIGFS_ATTR(tcm_usbg_tpg_, nexus);
 
 static struct configfs_attribute *usbg_base_attrs[] = {
-	&tcm_usbg_tpg_attr_enable,
 	&tcm_usbg_tpg_attr_nexus,
 	NULL,
 };
@@ -1734,6 +1714,7 @@ static const struct target_core_fabric_ops usbg_ops = {
 	.fabric_make_wwn		= usbg_make_tport,
 	.fabric_drop_wwn		= usbg_drop_tport,
 	.fabric_make_tpg		= usbg_make_tpg,
+	.fabric_enable_tpg		= usbg_enable_tpg,
 	.fabric_drop_tpg		= usbg_drop_tpg,
 	.fabric_post_link		= usbg_port_link,
 	.fabric_pre_unlink		= usbg_port_unlink,
-- 
2.25.1

