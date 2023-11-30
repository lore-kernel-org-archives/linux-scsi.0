Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B2310E5;
	Thu, 30 Nov 2023 11:31:49 -0800 (PST)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6cb55001124so1946734b3a.0;
        Thu, 30 Nov 2023 11:31:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701372709; x=1701977509;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x2fc05+XY37VuqJxsuOR+Mro4zuIHs7obA90Z7kwdNo=;
        b=QU/MY8tlT/vQNRPy6bKzzoztzlDxZ/AzAhrC6LoOIzX2hF4PngeqtAxd2VVP1kFnJa
         NCwx3aKKEaLLeCPGWnL1o217ob/BBvTZ/wj5PipsWxpuewE9u5kbh8M+YjaNOW1Ak8eh
         Ut6b9hkeuB8sQ4/JXOvhoS/bmbZ9lDJBWiuXGhYDDi3VnZP9Oq1Sa+PK9KVqyffWSJ8N
         QXr2s8MCUAlabS60DIil2DeMs47YjBD2Msrp3W5/a2EbKeShzxoGNXitqkOtD9TxHKyM
         PkFxbS9F7BrVy2nkl3/w4N4hTpn8xpwYbF8Rg1RvSLDPSnucn1rBhKzwIjQvg7Wljq7c
         6VuA==
X-Gm-Message-State: AOJu0YxMx3fFf+pSlRn8JI/1Q46IsYwRosAfSqGhxQZ6rqTodi6j7YLf
	nb7oBOCTRmog2dVzx+XXJ5g=
X-Google-Smtp-Source: AGHT+IGVYUDB4OZHnQwPgKveJyEF57PrruZoIL7R1g1UXgRr7jeBWC4/QRtEiTLajrmD/pUy6d98dA==
X-Received: by 2002:a05:6a20:7d88:b0:18c:3199:7174 with SMTP id v8-20020a056a207d8800b0018c31997174mr30699516pzj.19.1701372709003;
        Thu, 30 Nov 2023 11:31:49 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:8572:6fe3:eaf0:3b9d])
        by smtp.gmail.com with ESMTPSA id m127-20020a632685000000b005c606b44405sm1635365pgm.67.2023.11.30.11.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 11:31:48 -0800 (PST)
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
Subject: [PATCH v6 3/4] scsi: core: Make fair tag sharing configurable via sysfs
Date: Thu, 30 Nov 2023 11:31:30 -0800
Message-ID: <20231130193139.880955-4-bvanassche@acm.org>
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

Add a sysfs attribute to SCSI hosts for configuring fair tag sharing.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Ed Tsai <ed.tsai@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_sysfs.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 24f6eefb6803..58f0aba50566 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -403,6 +403,35 @@ show_nr_hw_queues(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR(nr_hw_queues, S_IRUGO, show_nr_hw_queues, NULL);
 
+static ssize_t show_fair_sharing(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct blk_mq_tag_set *tag_set = &shost->tag_set;
+
+	return sysfs_emit(buf, "%d\n",
+		!(tag_set->flags & BLK_MQ_F_DISABLE_FAIR_TAG_SHARING));
+}
+
+static ssize_t store_fair_sharing(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct blk_mq_tag_set *tag_set = &shost->tag_set;
+	bool enable;
+	int res;
+
+	res = kstrtobool(buf, &enable);
+	if (res < 0)
+		return res;
+	blk_mq_update_fair_sharing(tag_set, enable);
+
+	return count;
+}
+
+static DEVICE_ATTR(fair_sharing, 0644, show_fair_sharing, store_fair_sharing);
+
 static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_use_blk_mq.attr,
 	&dev_attr_unique_id.attr,
@@ -421,6 +450,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_host_reset.attr,
 	&dev_attr_eh_deadline.attr,
 	&dev_attr_nr_hw_queues.attr,
+	&dev_attr_fair_sharing.attr,
 	NULL
 };
 
