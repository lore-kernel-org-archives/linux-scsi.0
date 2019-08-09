Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC59C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BA63216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405170AbfHIDDM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:12 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36555 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404934AbfHIDDL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:11 -0400
Received: by mail-pf1-f196.google.com with SMTP id r7so45225162pfl.3
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TVeYMUnIoAy4ZdJR7qBlNg3tHJNEmhT4ut1zKjVfldw=;
        b=JHNbL8op7GU0dN81+PqrcZ7W9Gk0m12b6qOCzr3XWHvWIvY9kvTjk71GPlQSeTOp+y
         6u/fMypBNvCvkI4ZsPIwmW8QnaA2L6/Yx6fzC2o06pEWM+SeqlT6XUoOTMumQ6b3wdMJ
         A+HZBa64oGyQC8BU0rJsCzKNSDB5zoHQTX5X1M6FiezQKXfWfn1Sl3zA7JmJncYixjo/
         GdOhGjHBM5bxvNHa7YB3JfwTDL4QOR4s0oWzyGqpK+Y9XzHCoFfy1EZqA9+FbJrYqMbX
         VsXfvu+6syfWhIC13vfZnd4BoEIw3NDzb739kSikOfBcQzCs0IMDzL+izgZ/IABOAAlY
         g53w==
X-Gm-Message-State: APjAAAU625DhSFUz+dgU/SU0+EnuMZirr69P/yYR+r4RJVGEYLWr4o/3
        TC4GtLHJN8NXf/lo3MEBbeU=
X-Google-Smtp-Source: APXvYqy5K4myq7G66GSMRj25MEe7MEV2OVJFheTNSLzRFMTlB+R8VmZVbTS+m+H/CrN+qcAe4NCvNQ==
X-Received: by 2002:a62:ae02:: with SMTP id q2mr18523573pff.1.1565319790976;
        Thu, 08 Aug 2019 20:03:10 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 26/58] qla2xxx: Simplify a debug statement
Date:   Thu,  8 Aug 2019 20:01:47 -0700
Message-Id: <20190809030219.11296-27-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Read the FC port state once instead of twice. This patch fixes the
following Coverity complaint:

Unchecked return value (CHECKED_RETURN)
check_return: Calling atomic_read without checking return value (as is
done elsewhere 80 out of 92 times).

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e8ce57cb897e..55eb51539cb0 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2726,7 +2726,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 				"Port to be marked lost on fcport=%02x%02x%02x, current "
 				"port state= %s comp_status %x.\n", fcport->d_id.b.domain,
 				fcport->d_id.b.area, fcport->d_id.b.al_pa,
-				port_state_str[atomic_read(&fcport->state)],
+				port_state_str[FCS_ONLINE],
 				comp_status);
 
 			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
-- 
2.22.0

