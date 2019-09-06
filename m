Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CCDC43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 20:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB3F6208C3
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 20:39:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Y0/yOPia";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Y0/yOPia"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731614AbfIFUjP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 16:39:15 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60072 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727967AbfIFUjP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2019 16:39:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id C22E88EE19C;
        Fri,  6 Sep 2019 13:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1567802354;
        bh=hcVGBLtaOsktHGS5BOv4QufOiOoMvXVDeNN1mzvGHAw=;
        h=Subject:From:To:Cc:Date:From;
        b=Y0/yOPia4JaKjKPieqqEaozXGlcMbnHpFLwMar9YU0xOa3x2ZK1YjnRg/cbDvAwDO
         lroKYU6AjYMYykpzyhlYg2Zy88SFeFm2j+rTB4p8oBzHeoXdlxnpu777NDFfJWGEoj
         eOhWGNGBq+w4fGAo+chV5zYsAbS+KakiPH00uKcg=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pIzINMY06vUa; Fri,  6 Sep 2019 13:39:14 -0700 (PDT)
Received: from [9.232.197.57] (unknown [129.33.253.145])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id DF3D38EE088;
        Fri,  6 Sep 2019 13:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1567802354;
        bh=hcVGBLtaOsktHGS5BOv4QufOiOoMvXVDeNN1mzvGHAw=;
        h=Subject:From:To:Cc:Date:From;
        b=Y0/yOPia4JaKjKPieqqEaozXGlcMbnHpFLwMar9YU0xOa3x2ZK1YjnRg/cbDvAwDO
         lroKYU6AjYMYykpzyhlYg2Zy88SFeFm2j+rTB4p8oBzHeoXdlxnpu777NDFfJWGEoj
         eOhWGNGBq+w4fGAo+chV5zYsAbS+KakiPH00uKcg=
Message-ID: <1567802352.26275.3.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.3-rc7
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 06 Sep 2019 16:39:12 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just a single lpfc fix adjusting the number of available queues for
high CPU count systems.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

James Smart (1):
      scsi: lpfc: Raise config max for lpfc_fcp_mq_threshold variable

And the diffstat:

 drivers/scsi/lpfc/lpfc_attr.c | 2 +-
 drivers/scsi/lpfc/lpfc_sli4.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 8d8c495b5b60..d65558619ab0 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5715,7 +5715,7 @@ LPFC_ATTR_RW(nvme_embed_cmd, 1, 0, 2,
  *      0    = Set nr_hw_queues by the number of CPUs or HW queues.
  *      1,128 = Manually specify the maximum nr_hw_queue value to be set,
  *
- * Value range is [0,128]. Default value is 8.
+ * Value range is [0,256]. Default value is 8.
  */
 LPFC_ATTR_R(fcp_mq_threshold, LPFC_FCP_MQ_THRESHOLD_DEF,
 	    LPFC_FCP_MQ_THRESHOLD_MIN, LPFC_FCP_MQ_THRESHOLD_MAX,
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 329f7aa7e169..a81ef0293696 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -46,7 +46,7 @@
 
 /* FCP MQ queue count limiting */
 #define LPFC_FCP_MQ_THRESHOLD_MIN	0
-#define LPFC_FCP_MQ_THRESHOLD_MAX	128
+#define LPFC_FCP_MQ_THRESHOLD_MAX	256
 #define LPFC_FCP_MQ_THRESHOLD_DEF	8
 
 /* Common buffer size to accomidate SCSI and NVME IO buffers */


