Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CB0C432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8066961132
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242934AbhHETUe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:34 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:51960 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242925AbhHETUd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:33 -0400
Received: by mail-pj1-f42.google.com with SMTP id mt6so11334177pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:20:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TMLCx7WeEQe4ZBsSl0axnckf7a0fh04bRQwe8iGs0W4=;
        b=CD3uXbaIoKy6ARxAw/69blD0Z8TGCypcugAkne3dAlRUjQcDEVrqT+9GzbJJm5OZEF
         Q/nl6cF+cuasSuDYlcM4iwzmjxxKZt8j0p/M22/oRrtvINDxjvx+dKataigWOAVEZOOs
         Kw6zD0SkZM8aylnwf5Ko7JConuewl622ewmi4ucOTS3tqVrPZNmQH/oUuslchIawfDso
         Hm/RrQwUiXFa+3jOls8EmAwK2ozw71FhX9TgYpkkwQR7vu8sfeGQOHCSqxn2CT1LLwER
         TBnLMwTFbxlGWvVJWnLv8muYH+TFdRhlnVlgHJDJJyYqLElnKgyggspJDQaPXKTF5K/g
         nPUQ==
X-Gm-Message-State: AOAM533elUPvuV2a6ahAMrkE0YRs+oKJc5/0oHQI7bWE1MjxSZ/ghAnp
        tHMv8RxjBG72iJDxb5HrbnI=
X-Google-Smtp-Source: ABdhPJyOjHXbIXcDemPjdHym/DkLfaFtJZcE70d0EfeLTJZ1h+bXDvqdnIaV+0RTnMM7I4J3fc4Seg==
X-Received: by 2002:a65:6a0a:: with SMTP id m10mr312703pgu.145.1628191218250;
        Thu, 05 Aug 2021 12:20:18 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:20:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 49/52] xen-scsifront: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:25 -0700
Message-Id: <20210805191828.3559897-50-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/xen-scsifront.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index ec9d399fbbd8..0204e314b482 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -212,7 +212,7 @@ static int scsifront_do_request(struct vscsifrnt_info *info,
 	memcpy(ring_req->cmnd, sc->cmnd, sc->cmd_len);
 
 	ring_req->sc_data_direction   = (uint8_t)sc->sc_data_direction;
-	ring_req->timeout_per_command = sc->request->timeout / HZ;
+	ring_req->timeout_per_command = scsi_cmd_to_rq(sc)->timeout / HZ;
 
 	for (i = 0; i < (shadow->nr_segments & ~VSCSIIF_SG_GRANT); i++)
 		ring_req->seg[i] = shadow->seg[i];
