Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063229;
	b=PpTDMR32lNjlVOpg9JZ76ce8DfK3LZcGvhlRTuoNAcNkZ6VtacaIf4EQr36ichr+Dr+7
	 CAtZVoEukxzglIZVoHtcT7JMsORU2kdFAAq+L63lGeiiPeUhohE0QcNRGAETYK1dlUqGz
	 w4hy/2SurW8Q3nfkO9TuVVNo21PWKHV8P1AWi4cRZRek0h2DiGgieOx1u6E223ZdX5nIB
	 ITfgUUO1ojmC0rahCTV+zpbJjhcuMalh3t18knAW1ahn4XL/r30bHgXH3LlBp0bRgIiZj
	 9TAyUtfCuixQGgDqGe7pGAKpLuvns5RFo3Tdv774c+j0MshIh4mYHHpVUSoz0QPO53A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063229;
	h=DMARC-Filter:Received:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Date:Message-ID:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=4tt86FCQ5N/HbiDjMdFoKYx1zelFuUaOakryIwNyq5o=;
	b=IH+Hnf96tdJDtaRX9mYZH1dUDQ/PZdNmW08YAePLOVdjsL5Tgj8nG5oRsTakDqbGLQxB
	 KTpqiPJxJ5Hue3eygA1JZu73Q+e/8R2nJyQWmjzz0p+V+YIngeQ2P3nACXYw7ih0L36xp
	 N7+DW7xspWDGXpXtlycwa0IommWn52AcGpvfL59I+kiDD8fcZu69pH4J+gmeCP5dsObL/
	 IQ0niGgrYg84GFd+4ra7oUHVp4EPn6W7wKB47KUkV8CYr5p1hJYCpHLV5v/hGE/522gS2
	 yq+Mb2LSxdh7JTXZpdsClByCptUiQD6IO/KYJ03KNjknxr//XgBbG+TVKXQ19c2jZBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2900606A33B;
	Sat,  7 Nov 2026 14:53:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2900606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [172.100.0.8] (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowAAnLI1nO+9qUWiAAA--.2843S2;
	Sat, 07 Nov 2026 22:53:28 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: John Garry <john.garry@linux.dev>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
 Dan Williams <djbw@kernel.org>,
 Martin K. Petersen <martin.petersen@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org,
 vulab@iscas.ac.cn
Subject: [PATCH v2] scsi: libsas: Fix use-after-free in sas_eh_handle_resets()
In-Reply-To: <085fcc2e-112f-4d4c-a07d-9d0962936e44@linux.dev>
References: <20260917143946.2157366-1-vulab@iscas.ac.cn>
 <085fcc2e-112f-4d4c-a07d-9d0962936e44@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Date: Sat, 07 Nov 2026 14:53:23 +0000
Message-ID: <20261107145323.314159-1-vulab@iscas.ac.cn>
X-CM-TRANSID:rQCowAAnLI1nO+9qUWiAAA--.2843S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr17CF17GrWUuF4UKr1kAFb_yoW8Ww4kpr
	WkGa1akrWUGa1v9a1Duw18uFy5ta1kt3y8Gay8Gay8G3WFv34j9F4v9FWjqF18JrWkWFZI
	vr4Ut39Yq3WUArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUva1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
	x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Cr1j6rxdMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
	ACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vI
	r41l42xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s
	026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_
	Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20x
	vEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE
	14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyT
	uYvjfU7TmhDUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgcEA2rvBClZ-wAAsI

sas_eh_handle_resets() drops the reference it took on the domain device
with sas_put_device() and then accesses dev->state again while holding
ha->lock. The put may release the last reference, so the clear_bit()
can touch freed memory.

Clear the pending flag before dropping the reference.

The candidate was found with static analysis tools; DeepSeek and GPT-6.1
Sol were used to audit it and to help prepare this fix.

Fixes: 5db45bdc87ce ("[SCSI] libsas: enforce eh strategy handlers only in eh context")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
Changes in v2:
- Adopt John's suggestion: clear SAS_DEV_EH_PENDING before
  sas_put_device(), so the locked section is back to just ha->eh_active--.
  Sorry for the late reply.
- Rebuilt on v7.4-rc1 with W=1; drivers/scsi/libsas/ builds cleanly.
- Link to v1: https://lore.kernel.org/all/20260917143946.2157366-1-vulab@iscas.ac.cn/

 drivers/scsi/libsas/sas_scsi_host.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 76517c8f0684..448f35de67fb 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -695,9 +695,9 @@ static void sas_eh_handle_resets(struct Scsi_Host *shost)
 		if (test_and_clear_bit(SAS_DEV_RESET, &dev->state))
 			i->dft->lldd_I_T_nexus_reset(dev);
 
+		clear_bit(SAS_DEV_EH_PENDING, &dev->state);
 		sas_put_device(dev);
 		spin_lock_irq(&ha->lock);
-		clear_bit(SAS_DEV_EH_PENDING, &dev->state);
 		ha->eh_active--;
 	}
 	spin_unlock_irq(&ha->lock);

