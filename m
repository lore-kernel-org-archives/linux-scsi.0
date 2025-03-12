Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8391F4E59;
	Wed, 12 Mar 2025 07:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741765456; cv=none; b=fnSN6Q6npbAjV0rSK6V3vCq8CwW7h2Cl7H8Eskxj6UcrQ37mLkoYoD5lmLiJ9qycEMGABJSt5YYoZkD24VHCRqzwGwpKEMFtnRrcctSVOfAFiprrAbRGIQC4GKRrZDYJ4oOzAbZtjiFMU9YwC978XMiV3nxiRA7Joly7AQzbAEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741765456; c=relaxed/simple;
	bh=Cyo9tjCjexIlydA6S9GkYP/NMqyLRkxul3n6aO2tyLg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bpO6mh7ibq/8Gfrl6kQTubaxLp6ix32K/MHc2ZATExWK+UiZ53QH0mJ16qst7qEcMMLjzdCtvkkHxXK0+QzmVHNbAtGBVz6L1kHw2zmsULOHvVrFrAIcaPART+zK2yuG9npk/3w8KrbxiYdkt+AwcuLl1ALNT4wyPUvOWX6IfHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-01 (Coremail) with SMTP id qwCowAAnr_hEO9FnpZt9FA--.4136S2;
	Wed, 12 Mar 2025 15:44:04 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: satishkh@cisco.com,
	sebaddel@cisco.com,
	kartilak@cisco.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] scsi: fnic: Remove redundant 'flush_workqueue()' calls
Date: Wed, 12 Mar 2025 15:43:20 +0800
Message-Id: <20250312074320.1430175-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAnr_hEO9FnpZt9FA--.4136S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKF1xZFy7tr1DuryrtFyxZrb_yoWkCrg_Wr
	WxtFnFkrWUtw1IkryUtr4rZFZ3Za9FvFnxKF4Fga4fAryUZwn0yF1DuFs5ZrWUXw4UCF17
	u34qq34Yvr47CjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbV8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r1q6r43MxkIecxEwVAFwVW8CwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x0JUHuWLUUUUU=
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

'destroy_workqueue()' already drains the queue before destroying it, so
there is no need to flush it explicitly.

Remove the redundant 'flush_workqueue()' calls.

This was generated with coccinelle:

@@
expression E;
@@
- flush_workqueue(E);
  destroy_workqueue(E);

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 drivers/scsi/fnic/fnic_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 0b20ac8c3f46..3dd06376e97b 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -1365,10 +1365,9 @@ static void __exit fnic_cleanup_module(void)
 	if (pc_rscn_handling_feature_flag == PC_RSCN_HANDLING_FEATURE_ON)
 		destroy_workqueue(reset_fnic_work_queue);
 
-	if (fnic_fip_queue) {
-		flush_workqueue(fnic_fip_queue);
+	if (fnic_fip_queue)
 		destroy_workqueue(fnic_fip_queue);
-	}
+
 	kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
 	kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
 	kmem_cache_destroy(fnic_io_req_cache);
-- 
2.25.1

