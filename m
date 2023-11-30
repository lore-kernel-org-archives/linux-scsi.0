Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8982ED54;
	Thu, 30 Nov 2023 11:31:58 -0800 (PST)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6cdcd790f42so1338349b3a.3;
        Thu, 30 Nov 2023 11:31:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701372718; x=1701977518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=10WDQOMbLhwr6X7mmZ2uFxLynqBDtNMaAveAhuigAVA=;
        b=KSRLqBTI3UTMg5dFuzVGqf8XG7yD/U1tRkvkqws3aCnIYJ3mSnAVAnWDOZ1hQkTwQi
         2tpqjjZDOgz9R0hSw+vgqnDwt5a6jBAUAv1m+oAmcurykC1C/HJ4WDUS8xGGamlEaoEC
         3Pmzs7VkB71WcEJ0WHAaMlBN21v9Ly/erGJ+YAGHeIf+SAmbzEFt5SvARcjh7s7kiMr6
         Tf5wm/TSGvAMJUZPakp6XYotd/6Szi3doKtanCMQDYMkjmMeYLo6qyoUsU37J4kX81wE
         NSukJbVk/iKRPwUJNOCUBeb6VyWXVs3lLQ9tcnbIuZfBsccCo4awP36g9nLMf6pSMU0n
         9lhQ==
X-Gm-Message-State: AOJu0Ywf0irzUJbNSPXy5mGi2jj7SmUiwBqWNp/jf2s1ZB8NNPm5jFqi
	jKIgImRCQS8nSv6OX1atVHBtpv9EeTY=
X-Google-Smtp-Source: AGHT+IGUDVQtLXtXVTHcyYfbMADFBjfcpSbUp4Gwbjn7IWLspKOkJWzQerfbCR4mDOIMmJNdkXJOJg==
X-Received: by 2002:a05:6a20:3d85:b0:187:dd5f:93b6 with SMTP id s5-20020a056a203d8500b00187dd5f93b6mr24017855pzi.43.1701372717894;
        Thu, 30 Nov 2023 11:31:57 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:8572:6fe3:eaf0:3b9d])
        by smtp.gmail.com with ESMTPSA id m127-20020a632685000000b005c606b44405sm1635365pgm.67.2023.11.30.11.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 11:31:57 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	Ming Lei <ming.lei@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Yu Kuai <yukuai1@huaweicloud.com>,
	Ed Tsai <ed.tsai@mediatek.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Can Guo <quic_cang@quicinc.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v6 4/4] scsi: ufs: Disable fair tag sharing
Date: Thu, 30 Nov 2023 11:31:31 -0800
Message-ID: <20231130193139.880955-5-bvanassche@acm.org>
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

Disable the block layer fair tag sharing algorithm because it
significantly reduces performance of UFS devices with a maximum queue
depth of 32.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Ed Tsai <ed.tsai@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8b1031fb0a44..a2219cbb9720 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8973,6 +8973,7 @@ static const struct scsi_host_template ufshcd_driver_template = {
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
 	.skip_settle_delay	= 1,
+	.disable_fair_tag_sharing = 1,
 	.sdev_groups		= ufshcd_driver_groups,
 	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
 };
