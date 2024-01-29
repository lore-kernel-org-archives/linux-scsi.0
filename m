Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0629B55762
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jan 2024 09:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706519067; cv=none; b=Ia2mdm1CTtHF1YocRptEz3c3tDK9xE33hSrD5+3E/cVexpJADMox18xjlfYG5lj/nVVT6CQ0nEtBlb/HI2z18ghFcOJQXawIUr8g7PL50t2FlGtqApmDCw1VTsl62tTEFnQDfmjofYLMrF7oi8PQXxCIdEz45eVhu8mvsS8lgzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706519067; c=relaxed/simple;
	bh=GUKAziNr3WHtj8MXomRT04Lq++O8jVcm1r3x3ibNR+U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hC8eihFdswSN8K+b+FDVnXKcEPbCU3emDY4bLZ/PIt/5DS+tLS5WDiQdPspk268kYyvtphTZUo+BCr3tFR6wNqywW2o7ysbjP9r6tVoT9/6xwFBxRK2rFBFXuyWcL4I0teoxzyGgdrWH6dfl34rGQUQ9pRB1+lJHhFOjXUReBxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=sZyEIK9F; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="sZyEIK9F"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706519056; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=/4+SFAl9k1kyhq71fMevh6I7MBMX7wv9Z7VLkRhJl28=;
	b=sZyEIK9FjnQnfszXWa0wnl1BiI0UwDQ0C6XKroWtz+Am4aOunyhyDDc87ODjlkohpgwaiyi7XBSoTTq/8xd9wua8/VW/tajtthFIplxz5ckcvVCA3n2GwB4z6kEzvGwFG8MOPilXFtW7iBGeXOKlC8OWOB+kQfpCaxyy0bxNIQY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=kanie@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0W.ZJdHP_1706519050;
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0W.ZJdHP_1706519050)
          by smtp.aliyun-inc.com;
          Mon, 29 Jan 2024 17:04:16 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: iscsi: fix iscsi ida memory leak
Date: Mon, 29 Jan 2024 17:04:10 +0800
Message-ID: <20240129090410.11105-1-kanie@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The iscsi_sess_ida should be destroy when the iscsi module exit.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 3075b2ddf7a6..3c5b42390c47 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -5046,6 +5046,7 @@ static void __exit iscsi_transport_exit(void)
 	class_unregister(&iscsi_endpoint_class);
 	class_unregister(&iscsi_iface_class);
 	class_unregister(&iscsi_transport_class);
+	ida_destroy(&iscsi_sess_ida);
 }
 
 module_init(iscsi_transport_init);
-- 
2.43.0

