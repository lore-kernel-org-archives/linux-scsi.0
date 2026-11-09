Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794229795;
	b=ptiL2d152h0ryWf0aV0RZ4E66XkHoNt6ONz9kpyBKedGQBZzIvqaw/914t8AAls3+I7Z
	 dMwmdNqcO2lu6UU7ygNjJh9erirnCOk6KYjr2RCXVN0tavbuEtMERySzPak7HuTvZ/cmm
	 gGGKJ/K5sYjQzA1rvJlDnQ5UYqJzg3jsi+eoGaw0BZbSIRTtfkfQt2ouwJVX6kuRIe2Bw
	 moJ8myVF5dJJTBQBn6Azhte99/gFLnCojTwOX6pxOIQXVTHDyj37wJj+WHs/QOypbireH
	 NacnTRyQlclzVbRjSbhMAOUM/BY5yoswNiJNNl7uU/pDfMQhvVkG2kykm5RTfHw3jjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794229795;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-HM-Tid:
	 X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=Ue+uIgq/4+dyp+keflAou883DOyQs/QqnUJeeKUiPMM=;
	b=NYNchLpt7eUL512KAZo/ZsbjxHdZ65o+ktz+a43eZOKedfEsUuEd88wn4v3eYC4+6m7i
	 YbaMLLpWkrS9vM6cpfKEjBKSrHoS5fezvmUusDUxpWV2OBdfeAr+jfZ9nu5XbutBHCzjv
	 m29MMAez4nJZsPk9pzMXOST3c9q+QQMNXzTjXFU0BwF3he+Mccj3/Ryocxpn7iaWOu+Du
	 8iSO6F3ZpBq8tFz3j7VrbeiQhHxpDLsOSBIkTGUQCn+zyhq4wmbHKd/Rre+QHeQJ9LuOw
	 l+GTA+SfAaWpww+L8XK7pJalThTWqN3lwprJ8oQ4uxoVnOkMqtDFFxaBm/sXnn+3MjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=f3g7HtQ0;
	arc=none smtp.remote-ip=45.254.49.198
Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A48606A332;
	Mon,  9 Nov 2026 13:09:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08A48606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=f3g7HtQ0
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 54050f33d;
	Mon, 9 Nov 2026 21:09:42 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: fc: Fix potential workqueue leak on rport creation failure
Date: Mon,  9 Nov 2026 21:09:41 +0800
Message-ID: <20261109-21df1234b2-scsi-fc@mail.sdu.edu.cn>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1c06dc93203a1kunm7480828e121479
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZGUJNVk9OSUhMQ0gYSxkYTFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ0
	NMVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=f3g7HtQ0v9ppXaA1tJewf8hW1IdWY6TYMm+xUiVVXqfNDhXYYaoSUgN+1urVHr80FGw+S8OcWNJWWtOWoS9Ne9YYyZa0RcCZdONbdCXVxqDVHPG5HWMortT5/72lh6ZSYyWFN4cMVv8Zefpm/HTUGPTdXXPodt7y7gjOyQi54wA=; s=default; c=relaxed/relaxed; d=mail.sdu.edu.cn; v=1;
	bh=Ue+uIgq/4+dyp+keflAou883DOyQs/QqnUJeeKUiPMM=;
	h=date:mime-version:subject:message-id:from;

The remote-port devloss workqueue is allocated before device_add().
If registration fails, the error path frees the rport without destroying
the queue. Destroy it before releasing the rport.

This issue was found by our static analysis tool under development.

Fixes: 25236d4844ad ("scsi: scsi_transport_fc: Change to use per-rport devloss_work_q")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
 drivers/scsi/scsi_transport_fc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index bec6ca38375b..f7d0947bf312 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3180,6 +3180,7 @@ fc_remote_port_create(struct Scsi_Host *shost, int channel,
 	return rport;
 
 delete_rport:
+	destroy_workqueue(rport->devloss_work_q);
 	transport_destroy_device(dev);
 	spin_lock_irqsave(&shost->host_lock, flags);
 	list_del(&rport->peers);

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
