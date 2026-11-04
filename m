Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.71.155.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759629;
	b=zeuuyUIgD/xycxtx7+7j4nPaSsAZ/reP8/O32MR1E1o/vXu5x5s+rAYRVsJ8+xG0+WBZ
	 ZkfhSfvg1isyZpoR9Im4Z2A9S4mvb/1K195SAwtPVOeujzE8fccMJJ5LojrUFwIN/LqM+
	 svRyLs1vilLtG5q0QLv42KLXBzgJG+EQpvFYLUpwJb/uD2pOrDTqVwfsYyGTet1LWRzV7
	 yBGYtijQA2RjSvnXJ6w7EbEQt+HAClEjhC1Nuo4Mf6E/GGzP2UFYVR7OBx6zkqzGfBzBT
	 96huX+Gn7k56t9lUdULvgJBjsyci1mIw3KJmRfMUJDqyD3m0H/h0ylsefu3XfgENDBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759629;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-HM-Tid:X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=n8FC+Qn6Qlj3nN2Gcvt4qw5dYKTjMMS9AmK8c9IblsI=;
	b=De0Ni5oZ55158FRwbf8LMn5YZa7lySL4YojuS4IqXS6VDz3LD7xcg+qtsgSG6rSt7OK5
	 XO5ZY29ciOco/9xU37Qu69yECDbsk9AeJ/4gq9C+dwHklNST9eDWMcV4ORCp3oAqAteEX
	 OkzFm4DB8XdVxecVHNmh8L8Eeb79Y5T2gWWLnoxgeygXufiWqob7cZv7Mj4QymMNqiwug
	 oI/+MpzOv94nWfyCnNy14JQB8DFXdxeBSXS+ri+oXPUC/agx/8qs9Ov+MhsQPRwxD6+mk
	 4be5arJ1nHrWjnwXM1CLOI4j6Hwv/BKELyN56VVJl1uFmJcsD092MHcMFtCasqXQPGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	arc=none smtp.remote-ip=101.71.155.101
Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C53606A32F;
	Wed,  4 Nov 2026 02:33:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12C53606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5367d073d;
	Wed, 4 Nov 2026 10:33:39 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] scsi: aic79xx: Fix potential critical section table leak
Date: Wed,  4 Nov 2026 10:33:36 +0800
Message-ID: <20261104-db9e3c75b3-scsi-aic7xxx-2@mail.sdu.edu.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104-db9e3c75b3-scsi-aic7xxx-0@mail.sdu.edu.cn>
References: <20261104-db9e3c75b3-scsi-aic7xxx-0@mail.sdu.edu.cn>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1a467ab2703a1kunm4ff2f44e1636e6
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSUNNVklJTU8dQ04aTBlITVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVKS0hKTE
	1DVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=HeiF4OO7YZ19go173iRKrEVo5K8uJb7p+OmfITpJjeOyY+E/WmksnWivzFMYRUTjGFwLjDjIFJdcYvUQ78KQCc5skbJs3QinGz1A49GNb3Wa3RlpdZDBJYoVB6qIbQPegPaMdDouNaU9mN1vHTB8bVQSo+wlgNx+1nrLVPIp+lg=; s=default; c=relaxed/relaxed; d=mail.sdu.edu.cn; v=1;
	bh=n8FC+Qn6Qlj3nN2Gcvt4qw5dYKTjMMS9AmK8c9IblsI=;
	h=date:mime-version:subject:message-id:from;

ahd_loadseq() allocates a critical section table, but ahd_free()
does not release it. Free the table after shutting down the
controller and releasing its platform resources.

This issue was found by our static analysis tool under development.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
Build-tested the changed object with x86_64 GCC W=1, using defconfig
with the driver dependencies enabled. No hardware/kernel runtime test or full linked-kernel
build.
OpenAI Codex assisted with source review, patch implementation and
commit-message drafting. The submitter has reviewed the changes.

 drivers/scsi/aic7xxx/aic79xx_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 3602a1fc40e4..1ef088b54a28 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -6167,6 +6167,7 @@ ahd_free(struct ahd_softc *ahd)
 	kfree(ahd->name);
 	kfree(ahd->seep_config);
 	kfree(ahd->saved_stack);
+	kfree(ahd->critical_sections);
 	kfree(ahd);
 	return;
 }
