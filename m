Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F441E493;
	Thu, 13 Mar 2025 08:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741853732; cv=none; b=ioDQZJa+XK9RKgC87d4MJ0wV/Zq7RFaR091G09WjENi+LJZu/M9mWNlujrQymMhj0UUO0JR0NRXpgKmhUOW2ni8Xs2VUEkw594A9cBijRDD1Sm6f3AlBLnCi8HqMy0rxJe3SdwL7dw/d/aqsNvtSPt9eOY2nXik6npAI6BdKLvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741853732; c=relaxed/simple;
	bh=U9cHiEZ2UlFacIMIB70jtsKQGRGFuOhEZ5no/PBzaHM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NeuAzF2slrNjYP1dE0omchUErY1sSe87jRGsZ3KHGxSnoKmP5LlFDzP127m+Z/JjcUILuDCoMe5NJc5YS8fWv33MVN3lQnuUJZvsuqKJcZFF0pbotvjAKToV7CLmahjwYn25d30rqZgUyyJ7AKXMW5XoNQsdPt2yQw8F+2KubvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from icess-ProLiant-DL380-Gen10.. (unknown [183.174.60.14])
	by APP-03 (Coremail) with SMTP id rQCowACHjw8MlNJnAWfVFA--.3279S2;
	Thu, 13 Mar 2025 16:15:16 +0800 (CST)
From: Ma Ke <make24@iscas.ac.cn>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	James.Bottomley@SteelEye.com
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ma Ke <make24@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] [SCSI] iscsi: fix error handling in iscsi_add_session()
Date: Thu, 13 Mar 2025 16:15:07 +0800
Message-Id: <20250313081507.306792-1-make24@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACHjw8MlNJnAWfVFA--.3279S2
X-Coremail-Antispam: 1UD129KBjvdXoW7GF13GrWUGF4kuFW8CF1xZrb_yoWkCFb_Cr
	WSvryxWr18tws7tw4fWF95Zryq9ryqgrZ3uF4SqayrZa4rXF9Fyr98Wr4vvw4UGw4Du34r
	t3WDtw48Cr1vgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbSxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWlnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
	648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6x
	kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUF0eHDUUUU
X-CM-SenderInfo: ppdnvj2u6l2u1dvotugofq/

Once device_add() failed, we should call put_device() to decrement
reference count for cleanup. Or it could cause memory leak.

As comment of device_add() says, 'if device_add() succeeds, you should
call device_del() when you want to get rid of it. If device_add() has
not succeeded, use only put_device() to drop the reference count'.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 8434aa8b6fe5 ("[SCSI] iscsi: break up session creation into two stages")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
---
 drivers/scsi/scsi_transport_iscsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 9c347c64c315..74333e182612 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2114,6 +2114,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 release_dev:
 	device_del(&session->dev);
 release_ida:
+	put_device(&session->dev);
 	if (session->ida_used)
 		ida_free(&iscsi_sess_ida, session->target_id);
 destroy_wq:
-- 
2.25.1

