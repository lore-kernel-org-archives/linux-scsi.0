Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67E15BAC7
	for <linux-scsi@vger.kernel.org>; Tue, 20 Feb 2024 09:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708420141; cv=none; b=WBXeVcVwUS8xdX7ehC+KfxomSTxZEQyJIvZ1It5bpmikOT9+dV9Sws8TrQFQY6xf+yHMLmGtV/2G8Q2BqF8S/RJ5SyFxmcE45cmo1+hDlj9cpfEsU00raBIRGKTPADy9CY3j2oaB7xFKuFui8jqCgqjzLedbseu8FeJmMawIigw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708420141; c=relaxed/simple;
	bh=mjn6EXTmSJZ+lGndYlrFuihk9Yh0VIx3guEcNtjlNRU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=AtHEzxHNJpkuH+SDGXCSa7NOqQWsRYv0UsLDTvuf3x5+sleYGZAhpp4O5BNTmtoz8T6/nONbUPeDoM98f4W/Hgn+tN8gGJn/Z8maVuEQ6bUwtsuiHoYWY+bgnBPg2CSoXefTPWgWrFhh/0ushxWNfn2nqQZFX2Prjzr6QHp4HtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rohitner.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4vxtFVh8; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rohitner.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4vxtFVh8"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26ce0bbso10935855276.1
        for <linux-scsi@vger.kernel.org>; Tue, 20 Feb 2024 01:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708420139; x=1709024939; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C5TIghhj81XJMhc6wHnIWYfJQESzheU3Zzvlzz3ZRZI=;
        b=4vxtFVh8jPunlq+rWV7bLChCNXukLTnUydEE7dP0gV2nheoPUSexQGr40fAt2fqwUv
         HkVE5L4Nex9dh1YhLFgpJ4HB6gZcjA7TW8s5D+z+bFwRnW21+l7MjVld/fcnY3Vnf+M8
         IZAVe6ziJIYPfYLE3+mVBnvB2SHoKHXR+kZDt3phDKTz1SECxZq+GSdixTaI3BdBj/Og
         YlM2p+nt7iysA8aFpslTPj8oA3+VNDJksnck56ojBMSzppBE5Uc3N1IWHMggKPM94pZS
         XJNk3Q+NM4rHHMpU+h28TCJwsnDW2pebdd/5zMGz3BfEYA6cHJ/PH6WcaaNl03tv9c3L
         +SGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708420139; x=1709024939;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C5TIghhj81XJMhc6wHnIWYfJQESzheU3Zzvlzz3ZRZI=;
        b=OtwtompqiL6TIUCnZncge4kVsoiKO3mjvi9KH9HfPCtpaGIIKMqYnm9LdSfRgx1SOU
         HHyTC7EQtO4d4V8KXYjzi1Ok416+4nPVRKtBbvmqPIZrBeEzoWJn72UV9XYV0nD1wDaW
         Dy9ffVhIqbF32aPmwXSHUlURh/97gyBvFsDDS+PFTYDsy34XsVwpDUwET+z+m1FYQB5H
         uyK9/7pvNODYDKYdURYsSn5M68WMKqQCDDe/nj3RXR8ynYcW6R7jDEPbUjrZQhP+fuio
         aeg6Q8/LYgk2jVf9JXBg7idVCPj4vbr3nkCZM3ST+MQAUhiW3rTH8+/qo0Yb9H1NcbCS
         xZGw==
X-Forwarded-Encrypted: i=1; AJvYcCWRSM1AHUJICt5zW4oRo7LGiVu8SY3lJFFmjdEi0sOo0PXkCEsSGKpXLC0E3vlDuHYTwk/stvjp26qY14JZ8lZQ+gkXzG7VYTQ/Zw==
X-Gm-Message-State: AOJu0Yx8Av3v6uIH6Bdo6kq29k/QP+WczHG9v00iSwBhqkQ+sH/oo3cI
	ImvKCLX06b2LHjJ9OYMGoFrmo+KyThLoy3fe+/dee/+2d9Ic0G2EkhJZ7Ndx8W6I7Pojg6LL2C8
	Ni/3EZaEI5A==
X-Google-Smtp-Source: AGHT+IG16iYdwxjPu/OP7dYqpZzB3tGlLp7EWwI4fD6O1OWTy+dVK7SW8+z/9+vVjUDhz5eQsyy1nZQ7Tt/vmQ==
X-Received: from rohitner.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:413])
 (user=rohitner job=sendgmr) by 2002:a05:6902:706:b0:dc6:fa35:b42 with SMTP id
 k6-20020a056902070600b00dc6fa350b42mr4323086ybt.2.1708420138874; Tue, 20 Feb
 2024 01:08:58 -0800 (PST)
Date: Tue, 20 Feb 2024 01:08:05 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240220090805.2886914-1-rohitner@google.com>
Subject: [PATCH] scsi: ufs: core: Fix setup_xfer_req invocation
From: Rohit Ner <rohitner@google.com>
To: Can Guo <quic_cang@quicinc.com>, Bean Huo <beanhuo@micron.com>, 
	Stanley Chu <stanley.chu@mediatek.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Rohit Ner <rohitner@google.com>
Content-Type: text/plain; charset="UTF-8"

Allow variant callback to setup transfers without
restricting the transfers to use legacy doorbell

Signed-off-by: Rohit Ner <rohitner@google.com>
---
 drivers/ufs/core/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d77b25b79ae3..91e483dd3974 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2280,6 +2280,9 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag,
 		ufshcd_clk_scaling_start_busy(hba);
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 		ufshcd_start_monitor(hba, lrbp);
+	if (hba->vops && hba->vops->setup_xfer_req)
+		hba->vops->setup_xfer_req(hba, lrbp->task_tag,
+						!!lrbp->cmd);
 
 	if (is_mcq_enabled(hba)) {
 		int utrd_size = sizeof(struct utp_transfer_req_desc);
@@ -2293,9 +2296,6 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag,
 		spin_unlock(&hwq->sq_lock);
 	} else {
 		spin_lock_irqsave(&hba->outstanding_lock, flags);
-		if (hba->vops && hba->vops->setup_xfer_req)
-			hba->vops->setup_xfer_req(hba, lrbp->task_tag,
-						  !!lrbp->cmd);
 		__set_bit(lrbp->task_tag, &hba->outstanding_reqs);
 		ufshcd_writel(hba, 1 << lrbp->task_tag,
 			      REG_UTP_TRANSFER_REQ_DOOR_BELL);
-- 
2.44.0.rc0.258.g7320e95886-goog

