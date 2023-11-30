Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5ADD40;
	Thu, 30 Nov 2023 11:31:48 -0800 (PST)
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6d8481094f9so815123a34.3;
        Thu, 30 Nov 2023 11:31:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701372707; x=1701977507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Knd+D/6CKXR/8iQUqXcUYuGkJf1PZfGEypA0Hhb5DIQ=;
        b=Rdyv9zZ2cKREV6jXa4nDvJWNNzxzVi141MoxwtYuaQGAt3fEAqmCrZjxDeIQ0YGD8v
         hGuXMRwjalTeMeQMGOPiA3XrX3zORVAAhGeXVo7k9V8+47ydfdcuJFUVkci7yz9VeJJM
         /wXVq9hUJ0sqBtfIXEhv6gCP61Ri0ywV/P9ed6G280u/j+Nmr5R9sYvW/qRnWlC1P5gV
         /PkZtKHldy9xlgU1iDCBKo0mipQ3YmTj6Sn8qVa2MTfo8qHHlcfNq3PeduyAuAvJ83Op
         JzUA11h7q1B2YUwROL6po/RgsScEYL4iJmvumvXR89uQ1ElOqd8En0qR1QdKLoEXN/DE
         Udkw==
X-Gm-Message-State: AOJu0Yz05TxljHCLj0ifHu+PmdSqofQfbQC8kRjEm7wUYZHbE0SJ3WpE
	RKyFIWVCqKBH+44A5PIG1LY=
X-Google-Smtp-Source: AGHT+IFvYeLxnu/TGvO2d+HR4KaIz1AKQMwZM1qpOwewR85uplugeqmOrHNFgg9Xtl4MJQi3+sBiaA==
X-Received: by 2002:a05:6830:2b11:b0:6d8:542a:9c70 with SMTP id l17-20020a0568302b1100b006d8542a9c70mr514779otv.16.1701372707454;
        Thu, 30 Nov 2023 11:31:47 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:8572:6fe3:eaf0:3b9d])
        by smtp.gmail.com with ESMTPSA id m127-20020a632685000000b005c606b44405sm1635365pgm.67.2023.11.30.11.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 11:31:46 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Ming Lei <ming.lei@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Yu Kuai <yukuai1@huaweicloud.com>,
	Ed Tsai <ed.tsai@mediatek.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH v6 2/4] scsi: core: Make fair tag sharing configurable in the host template
Date: Thu, 30 Nov 2023 11:31:29 -0800
Message-ID: <20231130193139.880955-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
In-Reply-To: <20231130193139.880955-1-bvanassche@acm.org>
References: <20231130193139.880955-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow SCSI drivers to disable the block layer fair tag sharing algorithm
via the SCSI host template.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Ed Tsai <ed.tsai@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c     | 1 +
 drivers/scsi/scsi_lib.c  | 2 ++
 include/scsi/scsi_host.h | 6 ++++++
 3 files changed, 9 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index d7f51b84f3c7..872f87001374 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -442,6 +442,7 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
 	shost->no_write_same = sht->no_write_same;
 	shost->host_tagset = sht->host_tagset;
 	shost->queuecommand_may_block = sht->queuecommand_may_block;
+	shost->disable_fair_tag_sharing = sht->disable_fair_tag_sharing;
 
 	if (shost_eh_deadline == -1 || !sht->eh_host_reset_handler)
 		shost->eh_deadline = -1;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cf3864f72093..291fbfacf542 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1984,6 +1984,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
 	if (shost->queuecommand_may_block)
 		tag_set->flags |= BLK_MQ_F_BLOCKING;
+	if (shost->disable_fair_tag_sharing)
+		tag_set->flags |= BLK_MQ_F_DISABLE_FAIR_TAG_SHARING;
 	tag_set->driver_data = shost;
 	if (shost->host_tagset)
 		tag_set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 3b907fc2ef08..04238ae9e22c 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -464,6 +464,9 @@ struct scsi_host_template {
 	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
 	unsigned queuecommand_may_block:1;
 
+	/* See also BLK_MQ_F_DISABLE_FAIR_TAG_SHARING. */
+	unsigned disable_fair_tag_sharing:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
@@ -662,6 +665,9 @@ struct Scsi_Host {
 	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
 	unsigned queuecommand_may_block:1;
 
+	/* See also BLK_MQ_F_DISABLE_FAIR_TAG_SHARING. */
+	unsigned disable_fair_tag_sharing:1;
+
 	/* Host responded with short (<36 bytes) INQUIRY result */
 	unsigned short_inquiry:1;
 
