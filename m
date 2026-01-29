Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E2F2BD0B
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 15:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769702092; cv=none; b=VayCkenGZhujfojgd8SHxLAcliqKUjO96+olwWbRLwDlCcszSrMhO0z5FjUg3oTTsGNMWqIDcrTVl9mPi9CPiiMZp9MUWHffWImL8ZLUEPSmvoRQyfq3IE9XckyiJZonNPzQcU356eGEmddLSZ23SPpDX31M9FCKgwcRcdIE+Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769702092; c=relaxed/simple;
	bh=Q4L9DM+YHHs0NooWoD0Qmd+HVUl64DDZt5vhvmO5zS8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OEPcHjKfTJAcQmLef2RLtrXVeSR5b0RrnHDox4kJVti4tKMC4ufJXmyicMBEW7Ic/+0xRCXdVbU7Uk955u+dCrykJ7gOMekvYoIaPeUAsJgFVwHccQDI0XU3HCKLF4jxEdge3LrxIjI4iyH9WXUx6DktI7vLzuiVY4B/wqjlJxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FT7dzVsn; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FT7dzVsn"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4806f9e61f9so6320005e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 07:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769702088; x=1770306888; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rgSIXDM9Q8jFQpsfIVGKAZMTSqvcnmD4Z2E/dsepmqI=;
        b=FT7dzVsn/AAOHeaUC8tsHFnanWQTYd/29NKwgz4z42MmHqoHyQk4H/xW0jYK0zGHfS
         CmJm/JC2lE8qQMznjCdUCSHOsO9GscmCu48PkkmkTML7CpstX+IERMpKEpAB0eQ4NigO
         afMBjbw+GKbBMp4nQECEj5tzIBYBdAFgulkROmS9QHLWF76jSLK1eYC0FAPGy0IRJkMH
         VS6FYF79f1o2hZtIJWtvFHlXffvzCkeAET5EiQO/oTCcB8gXE5QxhwMXXOxLXSp72C+U
         OYVdu+OjwLT5wbDsm7rGbgzuQlv7JzSAbt9tEJ1u0b+UpNbw8mMkReZJ9Iuxiua7SXtl
         xdOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769702088; x=1770306888;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rgSIXDM9Q8jFQpsfIVGKAZMTSqvcnmD4Z2E/dsepmqI=;
        b=MtL9p2RxvigECG26tCnibA971/jYqbvJk1g94IWl7bdfDQVPEdWv86gF8wH+bQW6yx
         9/2fU0n6y9BLQS+sQEn7Rzz6AbWEgsYQehKV9F+R+h4hs7ikLrmGgoCBoHNuoiKZpIZG
         poxAmFNBbfRyEmhJfnmM5vWvMIIN/Cag5oW1VYCOwXD7Pp48fMyz64iTuveoPHi0X4/U
         Oq3QlUjw/OeiPpeqCWTmr72N6ua8Kt7S64Acw6DVMmwUhBo4LTOrNN8i5NcLXr6wcV9G
         5UDykeo2Z/JTcrgmFwsjqLgImo2/fZT2e6Q0Mn54bI/3haQqMjVZ74snUJD7YdcOZdJw
         AWbA==
X-Forwarded-Encrypted: i=1; AJvYcCWcJoxkqLV7HMoEKi7PHtFM1ZYI69Infau7j+fgjFfpJeKFhPVG3e40QXiqYXU3uElE4bC/Hd0TcB+k@vger.kernel.org
X-Gm-Message-State: AOJu0YzskgHukMOq+6TmiN+Kc62t+/MmIaOfz6zcO1WVzTm5+j3eydiO
	tQ6uw9PPL4bqiNHe7M82xSHhdZpn+ZZ8L0JcSUvYM8dMeVbGh+rC9sH9
X-Gm-Gg: AZuq6aK+A3n7C2w7Ujo4yfjlwTSSTF8ccV0qAtR2tqGFf8YeWlzz6hi870VR7nsaOSc
	UVYsIeQzDOfTpyF32NDIoQ5vCtkKq2J5XVxDMbnyUh9yE2pEi504iVXmPgenlH889M+tkSN9BvI
	nWe2RwM15SSQTw27dy1FLRvkgpElOSJawpDkl5d7wyr9NjyzsJa9jXpINXqYxNl4WMZ702mc8Vy
	d/prkUhxF/iK7BGpFvb+JsWHVfQ2G639pukp0SjHGtE7QeYXH1ak66pu9zHBdWgYpQgtFztaxjZ
	se7iXdvcc1jOBzXutJILMcC7aainpiQEKjg0yC3+vPoH/4eHdEslxctsnrEnnzYZvU093lZVxjf
	PSOhr4IUNhLhxrpMvQVRrysFwJMFtABQNzs3dUvKcQnGyWEgIe6mIKL9KRWTeIL8ZW8aUEyzA8Z
	MX/lj26hUnsA==
X-Received: by 2002:a05:600c:4ed0:b0:480:4a90:1b00 with SMTP id 5b1f17b1804b1-48069c69584mr113197125e9.20.1769702088044;
        Thu, 29 Jan 2026 07:54:48 -0800 (PST)
Received: from localhost ([87.254.0.129])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-481a5e18429sm6767465e9.16.2026.01.29.07.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 07:54:47 -0800 (PST)
From: Colin Ian King <colin.i.king@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Naresh Kumar Inna <naresh@chelsio.com>,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: csiostor: Fix dereference of null pointer rn
Date: Thu, 29 Jan 2026 15:53:32 +0000
Message-ID: <20260129155332.196338-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

The error exit path when rn is NULL ends up deferencing the null
pointer rn via the use of the macro CSIO_INC_STATS. Fix this by
adding a new error return path label after the use of the macro
to avoid the deference.

Fixes: a3667aaed569 ("[SCSI] csiostor: Chelsio FCoE offload driver")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/scsi/csiostor/csio_scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index c29bf2807e31..05137784f369 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2074,7 +2074,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	struct csio_scsi_level_data sld;
 
 	if (!rn)
-		goto fail;
+		goto fail_ret;
 
 	csio_dbg(hw, "Request to reset LUN:%llu (ssni:0x%x tgtid:%d)\n",
 		      cmnd->device->lun, rn->flowid, rn->scsi_id);
@@ -2220,6 +2220,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	csio_put_scsi_ioreq_lock(hw, scsim, ioreq);
 fail:
 	CSIO_INC_STATS(rn, n_lun_rst_fail);
+fail_ret:
 	return FAILED;
 }
 
-- 
2.47.3

