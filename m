Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 188A4C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3246613EB
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343850AbhELVXT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 17:23:19 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:35358 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385585AbhELUKH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 16:10:07 -0400
Received: by mail-pg1-f175.google.com with SMTP id m190so19116991pga.2
        for <linux-scsi@vger.kernel.org>; Wed, 12 May 2021 13:08:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mJZYWH9yk25ZJ51MkT46y0+IvXSfa3ymNmao1fovA5o=;
        b=pOPzfMgSPdjqIWXs0z1B3IRSUL/BHDoQt/MZvmdAIcLzurVZ9kKNL9FMIMeT6NfABU
         nktIO8Qmju8xpbXk9Ed5cFrGm08VRQZiuFkDiL29zQA7dCVaQgaIdmOi2NSATy8z/CEw
         MD5QcnLbO8qDLj5P2qCTo5XD/s0VswmP7KS5L5rsotKkF5ASNzE/rm+2RyKcmBC9YgZi
         gzf7teNdtymJZn0UzdMkxNBiA16gJ9j/7clLEEjGxoQ11gQ3MqfTGCR0A/KhpzHBEpJ/
         tViHUcAvnGSEx9tDMwXnWnPYdSE/IJsr2mggqYwmUIFFvCFDojRP0rUm3OqNVaL0N7n0
         qepw==
X-Gm-Message-State: AOAM532KkZaBm0rHyQumUWwjhe5IKJ/P30H8dYc2SJa4NjVf9VoSPnQR
        7Xx7K8Rck4YiY69y4reUz9Y=
X-Google-Smtp-Source: ABdhPJzJbJ2ItLDculAZPzb+1dR9m8xxuZ0ycbOxdH65XefGmTYCQGS6tf07g/q+zaK8S9NKFrWnZA==
X-Received: by 2002:a17:90a:94c2:: with SMTP id j2mr275244pjw.92.1620850138088;
        Wed, 12 May 2021 13:08:58 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:993e:1516:b2ba:76fe])
        by smtp.gmail.com with ESMTPSA id l21sm513948pfc.114.2021.05.12.13.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 13:08:57 -0700 (PDT)
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
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 1/7] Introduce scsi_get_pos()
Date:   Wed, 12 May 2021 13:08:43 -0700
Message-Id: <20210512200849.9002-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512200849.9002-1-bvanassche@acm.org>
References: <20210512200849.9002-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since scsi_get_lba() returns a sector_t value instead of the LBA, the name
of that function is confusing. Introduce an identical function
scsi_get_pos(). A later patch will remove scsi_get_lba().

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index adb8df40b942..8147b1c0f265 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -290,6 +290,11 @@ static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
 	return blk_rq_pos(scmd->request);
 }
 
+static inline sector_t scsi_get_pos(struct scsi_cmnd *scmd)
+{
+	return blk_rq_pos(scmd->request);
+}
+
 static inline unsigned int scsi_prot_interval(struct scsi_cmnd *scmd)
 {
 	return scmd->device->sector_size;
