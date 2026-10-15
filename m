Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBB126FA60
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792023547; cv=none; b=oS/EntniXZt9VSwUg2Xmepe95sXKFIHrZsotGp9FFOV1UyBK6YFIP6j3tJI4CLvtyk41Sufm80Ky9hx6agcv/h1TbVtcTTuznvsv4IoedAKGq0Gm6LyXTCcVyoZzHfZESoNe1Ngdd5eAtz6rFfCz0BEtiJwtLEK9m3joZ//OwIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792023547; c=relaxed/simple;
	bh=DkbK1hCyZBsi9bL1EMrWhf7s+M+Xm+ZYde9iyTpAEvk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lR+JlR79fruTnmnua/waNba4Y19dgf0R6oUgAwn6DzRBW34Fb4+a5wlYqy9AMQf/u+ahdeO55N5y9VH8H4Ux5VfHYOjQBSmoz1iVmUuWkZTA155IC5InzzufMfVZqsh+G7CBn3O6R/pwTyvSIysY2ETNod3TP9OOc56yfKGKSA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JgymWTCy; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JgymWTCy"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-88c76888646so1641967b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792023545; x=1792628345; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q7vaOB2E95aQO/eMkL0Ew2CWV5P3KfBjRVcUeuca+9w=;
        b=JgymWTCyTpiuOXF7AIaCCdb/HF2gjLkqGLuk5z+RT9BKLPG6W4Zu5rp/OMWQnY4N0V
         IOOFNW3gNDeJSauotmOQdtWkQiOc0e2AuOG0SA/LlUqnXOMH0tvKGB5Lc+/P2zASit/f
         XKsazJCfrM68n7cnpfpgkThlUQcZOuCB6rhMsXRKwlMp+DXP+ym4Mg4NqrkBo5egT9PE
         PkqUX3yVoqYMgUO19pEAFRvhUgL3LNZK0H2a09tSccpYqIYlNwAMPsUnIRWQieNxjgJa
         wmzGHDkzIdg2vHfrooaVirtmzJLX+9htbuqOclIkqT4VewnqGI73YnbWPmmUj0Ri/MCZ
         rg8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792023545; x=1792628345;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q7vaOB2E95aQO/eMkL0Ew2CWV5P3KfBjRVcUeuca+9w=;
        b=dnXM7WGy0qVcXdI2M0ILC9GwTCd9ATLNMICWsoXdl3nw3z1+A8gZXM+2s65rD9pMWr
         HZylv/jggnrsKFL3yUfuf3DTo8kIrqx5TTr1qfv2KAmjc/qa/yqPVOOHEkktV0YUBfDZ
         aJyAdGbCTRQFqDN81eVFFJLlyFJYQnY3WcDe9UHFGdh3R8OZBHj6+eqtdTzLtCTslhlS
         ijunwx08wGgNre5HjsTiFZ8In0hCdmTE+V5CDy38B/fs40EKKYbWjrwR03NiMTQjGyAK
         GIAZeF6G7Ozm49M+mIzuVH9N7wHRmbZ4pyRzn9/hYnzbeih+fJq5/B5m7yt6dykxfvBw
         0HBw==
X-Forwarded-Encrypted: i=1; AKwUvBx6U6Drv3zLmpmQyZRvXUvEQkoNACpB1L8Vy9s+podXGzo6t7nkXlWvsOGSJFmCufUoo/vK7Ki8XiPV@vger.kernel.org
X-Gm-Message-State: AFq9FYLe2y1w8Fh47qNOxaoME0kpQhV0uS34lNBxQStCzq48vi6T18A4
	TyqayNFFZG8B7YoJQSfl/cFtmAImJ6MISK2DPnnTqXVC+e+CQ9bKVaJqE6ajFTI0d2+iWrDdw8n
	+wckWLnX6ER8o7Ra4UkaVog==
X-Received: from pfblh20.prod.google.com ([2002:a05:6a00:7114:b0:88b:aa59:d8ef])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:6c90:b0:89e:584:bb77 with SMTP id d2e1a72fcca58-89e0584be02mr2041770b3a.58.1792023545218;
 Wed, 14 Oct 2026 17:19:05 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:18:54 +0800
In-Reply-To: <20261015001855.3450573-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261015001855.3450573-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015001855.3450573-5-stanleyjhu@google.com>
Subject: [PATCH v2 4/5] scsi: ufs: bsg: Reject UIC commands with a non-zero
 result byte
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Brian Kao <powenkao@google.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ufs_bsg_request() passes the user-supplied UIC argument2 unchanged,
including the result byte (bits 7:0) that only the host controller
writes. A non-zero value triggers the WARN_ON_ONCE() in
ufshcd_dispatch_uic_cmd() and corrupts the reported result. Found by
syzkaller.

Reject UIC commands that have the result byte set with -EINVAL.

Fixes: e77044c5a842 ("scsi: ufs-bsg: Add support for uic commands in ufs_bsg_request()")
Fixes: 9fb4c793223b ("scsi: ufs: core: Complain if UIC argument 2 is invalid")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
Changes in v2:
- Reject a non-zero result byte with -EINVAL instead of clearing it,
  as suggested by Bart Van Assche. Dropped Peter's and Bean's
  Reviewed-by as the behavior changed.

 drivers/ufs/core/ufs_bsg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 0db830e54ef0..cadde515f040 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -179,6 +179,10 @@ static int ufs_bsg_request(struct bsg_job *job)
 		break;
 	case UPIU_TRANSACTION_UIC_CMD:
 		memcpy(&uc, &bsg_request->upiu_req.uc, UIC_CMD_SIZE);
+		if (uc.argument2 & MASK_UIC_COMMAND_RESULT) {
+			ret = -EINVAL;
+			break;
+		}
 		ret = ufshcd_send_bsg_uic_cmd(hba, &uc);
 		if (ret)
 			dev_err(hba->dev, "send uic cmd: error code %d\n", ret);
-- 
2.56.0.385.gd3acb90ef8-goog

