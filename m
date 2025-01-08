Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F33187550
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jan 2025 09:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736327788; cv=none; b=WM10lkAEzvgHzbziA2BU7dtcSew+5jKmhCwBrPNEuXl3nQO7sjxVaVvPgWgUSBdMEYxDtohaL6tNVUD6KzB0ctr6uhvk4HYxr2dXLqdF4ArM8RHS8+YKnJ8n1p+6gavX7ub2OdlxzP9dJPysaxteg55CzacL7nnVgiumRYjz6Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736327788; c=relaxed/simple;
	bh=6fEqdrjg45C/fj+t5/mAi2jKTpDwP2K1L9DsWLhE3bM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=alTtLiJ+2Ig27WTO/QsuQC2MMJUStpZHhpze9ofbGYXoQQEnxuxs3kHA0Nwa0OL+PgN+kGQlcmYjvdHfnUcSeJex06ScqNRhFYNkPAa+U+ACe45yplE+8VRzKRngnv9TRRD+d9VUZFkq9pWdg13GKC2tNVSFZPKokjVZwGRY3nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=shc0tX46; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="shc0tX46"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43625c4a50dso113556665e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jan 2025 01:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736327785; x=1736932585; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fn//Ft/rrO4h6PGoNs5D2RI0tSKQdOI4bkl3jeswABw=;
        b=shc0tX46fUbk5fVgv/IiMygXViap8imLidwrQfmrABBtxCoZ+OEbQfrfz+4qBVij56
         2UDsZnjm4poVM+Tq9j951jnXiruoLzo528Z6Lh7l9mvk+PMZJTRoYIWnhq+O8QXnSTqZ
         1y272lM5+55mWcLqUCd+Zmu18UR35ZvbFLwI3FmkwBsBxv2k92b7+JMGZfHHN9pHbHbA
         aQ148+JawVj1x1mO1yboryx/qGp4o5G5gkUy5Gzf8Wgmwg1nDizmEqrMr76XBy247I8X
         4MycLO+gnIzeuEC4+9tHiTimwR4lrexgO3xgVCZdJi+fvbiXDKYaazGlLR46BoVheZTR
         JAFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736327785; x=1736932585;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fn//Ft/rrO4h6PGoNs5D2RI0tSKQdOI4bkl3jeswABw=;
        b=YeXg07jTD+mum5iQiOKcMi7v6A4STMLaVzWNnM5YGnPqfGJzo7DTAAnwObReECdhaA
         jWtzIlV3XLd9lgWLSuojnog3tD2hNCPhDtNjZ7r6z3PTzKT9E8RjTjSzGIW0Qv6LllhK
         ADJcAtw81DYlY/0hKUcZNREvSOd9OvYkrc9RDSfQdCU4yTEzLUbLnWrmzswaZUooQk2B
         Mb/EEWZkCw/vANt0K3YLic8t2zCEoxsB8rWK/nDezM/TwFikIqxjjhndHWPnH30jjkKy
         i2mr3pHUwJWWrNaWgg7ImC9nS93LaeRSgCXaHPh45n3e3k7Bv56JfonNTwTPhNJxFVaB
         qxzA==
X-Forwarded-Encrypted: i=1; AJvYcCUj+35ih9NVBXvzkAftXF+6U9dE9R+n2DxcyZ2VdvxrPR3EIQZ3bjBjqh7KP6ReZ0NZCajwqjSxNJJB@vger.kernel.org
X-Gm-Message-State: AOJu0YxVgLdCzmZw4Dc8FJRmxxUH2jm6OeJptmHkt/3rw3o1+67OnLQd
	aG1qTd1FgyH7xjfTMiTDUcIJYUybS4pYBE1XSXcUoP+PL/NiEkodjseLQL8ksds=
X-Gm-Gg: ASbGncvFwSnpTecajiXsxxoeYJ8P9wO63rHNtVaMMGm8U+GjnOeFAXxTCPSRDTfrxP/
	z1eOz2Qbi2xlRt3YEltWup8ydQLpWEV7N3Aop78tkm1eIOX5qKpuyi+YFyCjLbnE8DSON+SvioA
	VdI7kKfO7UAff+Og+Fty0XchBSQEQ23hhZTsIDdFxO6dwn64DEgFSC8LtG6WBuRyXh0tN8kBCb+
	ZSVbwjIhO0yoxrd9fbB1Jb3d1KbV1OUAl/n89jnSZved4qnk4ysXV+FbdIpAg==
X-Google-Smtp-Source: AGHT+IEV+g5tBiCUOowMcZ4bkWs6MfAgQFbEsVW0/O0O+m+/43gKa1QD/RB8+ayhAPAWM8ZrbexWnA==
X-Received: by 2002:a05:6000:1a88:b0:38a:5557:7685 with SMTP id ffacd0b85a97d-38a872f6ee0mr1454922f8f.5.1736327785001;
        Wed, 08 Jan 2025 01:16:25 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8a6ca5sm53652859f8f.86.2025.01.08.01.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 01:16:24 -0800 (PST)
Date: Wed, 8 Jan 2025 12:16:21 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Arulprabhu Ponnusamy <arulponn@cisco.com>,
	Gian Carlo Boffa <gcboffa@cisco.com>, Arun Easi <aeasi@cisco.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH next] scsi: fnic: silence uninitialized variable warning
Message-ID: <99df3555-6763-4870-9af3-fbfa4fbd5268@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The debug code prints "oxid" but it isn't always initialized.

Fixes: f828af44b8dd ("scsi: fnic: Add support for unsolicited requests and responses")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/scsi/fnic/fdls_disc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 2534af2fff53..7928f94d3202 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -3904,7 +3904,7 @@ fdls_process_abts_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
 	uint8_t *frame;
 	struct fc_std_abts_ba_acc *pba_acc;
 	uint32_t nport_id;
-	uint16_t oxid;
+	uint16_t oxid = 0;
 	struct fnic_tport_s *tport;
 	struct fnic *fnic = iport->fnic;
 	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
-- 
2.45.2

