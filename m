Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37851C77B78
	for <linux-scsi@archiver.kernel.org>; Wed,  3 May 2023 23:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjECXHK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 May 2023 19:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjECXHE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2023 19:07:04 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9146E6199
        for <linux-scsi@vger.kernel.org>; Wed,  3 May 2023 16:07:03 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-643846c006fso35585b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 03 May 2023 16:07:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683155223; x=1685747223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=STgA1yr1FLAJc2VW5s4ilhXq6DSlbETUkCvRmcjAIdg=;
        b=DWYemtxUQLw3cYQVOHG2R9mWDQJ83fkf9Q0G1t5FCdgVAWztQsdFJOrA2U1G3VSskH
         drgb9663umZxIK9Oz79VMBfsEGla2RmiXsT8IYANwJ/c4n2YXz3TykX7g3O6q5Am3mCC
         x0IoSxfBX68WFPgvYf+Rz7djA/AhKQi79AVSCHAYfv1djUVeu5y+I5SQ1hmjObx2QiLP
         jGNXWucjbZhOL/1S8cyt6Kmjv7XTQTO1ojsLlJn3bip9IgqP+uEdeuGJwhlcsGfDnBCS
         5VDuj8yXHOZDjQwZBOy73tBsIS696YoS7xlmImbL5ytHiV8G39ZjOBQNUfnXKTEIuKc2
         5X+Q==
X-Gm-Message-State: AC+VfDwdJw9biTS2fjveSt5vSMB6L8vRY2Op78A7iitFqBypXmtMg7Vr
        i32TJ4ycH/wnYSB7YgS8UwQ=
X-Google-Smtp-Source: ACHHUZ7pdVOOqJ1Ty2nqUxOAPCwA35aLQKk87hW69RwBQrn7H5Y7a89lf+fDdkwli0YaQ/jWhSKC7g==
X-Received: by 2002:a05:6a00:130a:b0:63a:75a4:b2d4 with SMTP id j10-20020a056a00130a00b0063a75a4b2d4mr143206pfu.24.1683155222888;
        Wed, 03 May 2023 16:07:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2c3b:81e:ce21:2437])
        by smtp.gmail.com with ESMTPSA id u3-20020a056a00158300b0063f3aac78b9sm19531603pfk.79.2023.05.03.16.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 16:07:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 2/5] scsi: core: Update a source code comment
Date:   Wed,  3 May 2023 16:06:51 -0700
Message-ID: <20230503230654.2441121-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
In-Reply-To: <20230503230654.2441121-1-bvanassche@acm.org>
References: <20230503230654.2441121-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The proc_name SCSI host template attribute is used for:
- The name of the /proc directory if CONFIG_SCSI_PROC_FS=y.
- The contents of the proc_name SCSI host sysfs attribute.

The current comment in include/scsi/scsi_host.h is not correct if
CONFIG_SCSI_PROC_FS=n. Hence, change that comment.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0f29799efa02..18632adca17e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -365,7 +365,7 @@ struct scsi_host_template {
 
 
 	/*
-	 * Name of proc directory
+	 * Name reported via the proc_name SCSI host sysfs attribute.
 	 */
 	const char *proc_name;
 
