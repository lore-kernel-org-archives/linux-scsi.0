Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7A5C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 04:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F13F24676
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 04:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgAWEXz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 23:23:55 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37317 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgAWEXy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 23:23:54 -0500
Received: by mail-pf1-f195.google.com with SMTP id p14so907822pfn.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2020 20:23:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7o+BNm/IzRdivKrs0RtluJbnTOMycONXvD6+28zFVxg=;
        b=P7ryl+LJeLZRqgUOJBYvfIPCYXiXD+kWgwC2z3a6o+GrSYhwNSv3BpdklVT3za8ovJ
         W69I2SWb7kRMi5JOvf9t1hLpqTliVMG6BBynmWnfcAY37fCELbjCsPUpGu3+zccyvPt/
         q1nSjycpXoDurY6zzB6ZFM41je2Tdz4IX7PwCbckmtgThb4c1e67P5iNlqmThsFiLcTm
         YIAQVvq0+L6wHfzt6eyvTR9Hkn6eyhWEht5VA7lYJqrGrX2WSC+dQ7LS97Hl1K0S0Dta
         TiH5Bm6BVo7pvMxsq/Vs6RLM0WNhKiZ2x5oVZPL/MpsbW9pms7QbT+QmS3UrwomWY5Zb
         0Mhg==
X-Gm-Message-State: APjAAAW2akyU20LKizeMYCsLc3bEREcV0o26Ta+l2SwxDZh5le3dff1X
        SvHzNlv+ENTEULPj27mJ6fk=
X-Google-Smtp-Source: APXvYqzV75qjVpjo6BbZi2dp8dUY0LcGQOFNbDDjGMJwe7ETEVji/1TbJocvJ1YQrIVSIq4+WUhLKQ==
X-Received: by 2002:a63:78c:: with SMTP id 134mr1803678pgh.279.1579753434121;
        Wed, 22 Jan 2020 20:23:54 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:d957:4568:237a:bc62])
        by smtp.gmail.com with ESMTPSA id p16sm492879pfq.184.2020.01.22.20.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 20:23:53 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v2 1/6] qla2xxx: Check locking assumptions at runtime in qla2x00_abort_srb()
Date:   Wed, 22 Jan 2020 20:23:40 -0800
Message-Id: <20200123042345.23886-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123042345.23886-1-bvanassche@acm.org>
References: <20200123042345.23886-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Document the locking assumptions this function relies on and also verify these
locking assumptions at runtime.

Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b520a980d1dc..79387ac8936f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1700,6 +1700,8 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 	bool ret_cmd;
 	uint32_t ratov_j;
 
+	lockdep_assert_held(qp->qp_lock_ptr);
+
 	if (qla2x00_chip_is_down(vha)) {
 		sp->done(sp, res);
 		return;
