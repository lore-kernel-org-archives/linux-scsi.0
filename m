Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758479;
	b=r4DHE9Ph7Ol7w6eUt9mNh5D8KeGhyWVNITav5M7AbQ1VdFipPVpVH8/ups2X+nMqA4+b
	 XfAvDCfuy+HBXKs0jPa1DlSd/lJDDnp+Ktlb0/yZux6HWFD4d/LTbrNU/6WYaPmqR1MsB
	 7MhL/AVrXpmfMhXX+7AYnFWX3evzjFGaqDpozuBxSCE1ZDU0lX2+EAjBW7sokmZITV2aw
	 owp5jdCHef9oUOGdDsXuDhyl1QzS7DEBhEoxFkDc0ZOBHyS1jxIrezQvuDrlaiyCxp4cZ
	 zga59LLjPJHdbm0JcnkAQV1x5uZoycrYLd4BlrfdixBJ/hNJgAXoIOp9SvHAXAE7XTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758479;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=a3fsARwJVDmiUES9seWPogQS10Z5cZZxtPIAM2Ey03g=;
	b=B1Axuk3Pt3ynZF7aYA58B8ELswKzbEjjD7S6sdC2lsalwH2d4H/8TKxcppnXAmWKfK0m
	 9TVBwOY7SifR9CbiBkWfBsPhYLK/sOxUSzQQ8M+MlE24IDM0Gp/LC7epvY/i+TqjtqVuv
	 tsVS10kHLDG2IvQmLN8bAuuuJPjUTyQ5rh0Sf2TWfRfbDPvDGL0PTHKBH38mhatjPYvDF
	 yYZcm/AxdHsVRBXH0sLs4PXDAoA+2DRY7xAmkN+JeA0Pg0SRGJhVnMWA4r0MrUUmofykO
	 +OXMeyAWbcCi29GeNphVwFyMVzKf5q7uOAJWnV9w7pKRlcZoyOcOkgzRAalj8OiP2PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B133C606A328
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:14:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B133C606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAAnUfsJlepqfnU+AA--.41772S2;
	Wed, 04 Nov 2026 10:14:34 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: qla4xxx: tear down the session when the DDB setup fails
Date: Wed,  4 Nov 2026 02:14:42 +0000
Message-Id: <20261104021442.1468358-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
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
X-CM-TRANSID:qwCowAAnUfsJlepqfnU+AA--.41772S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF4UZw48Cw4fuw1rJr17GFg_yoW8tF15pF
	WkGayYkw4DA3y7GFW5Aw18ZFyYyFWSqryxGa17Gw1DZ3W5AFyjkF4jva40va4kWr1kJ3W3
	Xr4DXFs5WF4jyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvmb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xf
	McIj6xIIjxv20xvE14v26rWY6Fy7McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0E
	wIxGrwCF04k20xvE74AGY7Cv6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI
	8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AK
	xVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26ryj6F1UMIIF0xvE2Ix0cI
	8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
	87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnU
	UI43ZEXa7IUYbiStUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgcBA2rqY4K7bgAAs3

qla4xxx_sess_conn_setup() creates an iSCSI session with
iscsi_session_setup() and then a connection with iscsi_conn_setup().
Neither the connection setup failure nor the endpoint lookup failure
unwinds the partial setup: they return QLA_ERROR and leave the session
registered, holding its reference on the SCSI host and its command pool.
In the endpoint failure case the connection is leaked on top of that.

Tear the connection down first, then the session, on both paths.
iscsi_session_setup() takes a reference on the transport module that the
driver drops right after the session is created, so take it back before
iscsi_session_teardown() drops it again.

Fixes: 4a4bc2e90c1c ("[SCSI] qla4xxx: cleanup, make qla4xxx_build_ddb_list short")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/qla4xxx/ql4_os.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c9d9fc7c81fb..fd9d3f935a0f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6946,7 +6946,7 @@ static int qla4xxx_sess_conn_setup(struct scsi_qla_host *ha,
 
 	if (!cls_conn) {
 		ret = QLA_ERROR;
-		goto exit_setup;
+		goto destroy_session;
 	}
 
 	ddb_entry->conn = cls_conn;
@@ -6959,7 +6959,7 @@ static int qla4xxx_sess_conn_setup(struct scsi_qla_host *ha,
 	} else {
 		DEBUG2(ql4_printk(KERN_ERR, ha, "Unable to get ep\n"));
 		ret = QLA_ERROR;
-		goto exit_setup;
+		goto destroy_conn;
 	}
 
 	/* Update sess/conn params */
@@ -6977,6 +6977,21 @@ static int qla4xxx_sess_conn_setup(struct scsi_qla_host *ha,
 		set_bit(DF_RELOGIN, &ddb_entry->flags);
 	}
 
+	return ret;
+
+destroy_conn:
+	iscsi_conn_teardown(cls_conn);
+
+destroy_session:
+	/*
+	 * we have decremented the reference count of the driver
+	 * when we setup the session to have the driver unload
+	 * to be seamless without actually destroying the
+	 * session
+	 **/
+	try_module_get(qla4xxx_iscsi_transport.owner);
+	iscsi_session_teardown(cls_sess);
+
 exit_setup:
 	return ret;
 }
-- 
2.34.1

