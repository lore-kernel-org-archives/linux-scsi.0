Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CC9C43470
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A362613E6
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344867AbhELVXY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 17:23:24 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:42618 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385591AbhELUKL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 16:10:11 -0400
Received: by mail-pg1-f173.google.com with SMTP id z4so1763985pgb.9
        for <linux-scsi@vger.kernel.org>; Wed, 12 May 2021 13:09:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zneIuWKx5plbkVRnqUaXhx2tWvAwP5VCwlHKgsx7wvc=;
        b=USscm2SEfmugMjTs7sKDnS0pZjUPyh2Xp0i5BaviHxa7N7NZ+gQYpb4hTIxpPHk/I8
         h9EMBEdwocGvA+iB9xCC2AlVrgaklJxY9JfuTIO6I6lSZjRZyh6KfX4Q3Sv4cvSAz0FB
         85SGivSxK2FDZboTOm5A/fB3NwwPrFKzppEDuPEYWPhr/IVkAwbkftT+GINrrbJJ9I2K
         Q4jtW7/EoaO5zg53y6rnihGo8wr+tGvYH9MuILYUHnfdyA6FLegi9EauygGqSxNh2CDE
         cscsyT6BpgkuaWFN7u8Kb7WaA1zoxM6UtNIrLzcY3ZkfaH0uKrd98Pq00pg2N5m4V4Yw
         jRhw==
X-Gm-Message-State: AOAM532l+/Buc7J550duk8alBh1esxGhYZNifijPyCvgkeaqHqLtvvRx
        jyo309Ec1f1LqV6+Qo1Bihw=
X-Google-Smtp-Source: ABdhPJyamml6Ey56saKuH6hhOL3smOcA7MK/a6BFYkGq2mKvYf1qtgHfoIzYQASZnp4lqDOpU3yYYQ==
X-Received: by 2002:a17:90a:17c5:: with SMTP id q63mr26789477pja.136.1620850141476;
        Wed, 12 May 2021 13:09:01 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:993e:1516:b2ba:76fe])
        by smtp.gmail.com with ESMTPSA id l21sm513948pfc.114.2021.05.12.13.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 13:09:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>
Subject: [PATCH v2 3/7] zfcp: Use scsi_get_pos() instead of scsi_get_lba()
Date:   Wed, 12 May 2021 13:08:45 -0700
Message-Id: <20210512200849.9002-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512200849.9002-1-bvanassche@acm.org>
References: <20210512200849.9002-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_get_pos() instead of scsi_get_lba() since the name of the latter
is confusing. Additionally, use lower_32_bits() instead of open-coding it.
This patch does not change any functionality.

Cc: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/s390/scsi/zfcp_fsf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 2e4804ef2fb9..ae308ef06714 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2600,7 +2600,7 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 
 	if (scsi_get_prot_op(scsi_cmnd) != SCSI_PROT_NORMAL) {
 		io->data_block_length = scsi_cmnd->device->sector_size;
-		io->ref_tag_value = scsi_get_lba(scsi_cmnd) & 0xFFFFFFFF;
+		io->ref_tag_value = lower_32_bits(scsi_get_pos(scsi_cmnd));
 	}
 
 	if (zfcp_fsf_set_data_dir(scsi_cmnd, &io->data_direction))
