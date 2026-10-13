Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0746051EE1F
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 15:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904422; cv=none; b=i2ykBZjPorAgtCWRr+v1NjPhzkc/Cw/m+i6KW8/57Nne7IzrB+YmL1VcSKaUqLwY2ROjn4ocZTjC2lzJatdSCrGENDsyu+yNRmU8+d+RRQ+BM55m8ttqUJGeas1YIpue77aKIzTK6isqbAXMaIpfV5WmmKajbSU2AbWXXIqIXPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904422; c=relaxed/simple;
	bh=fxKrLbuOEmB5AkcOmcb4Fp+IPQhQ9N+SgUmQy4QU0js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibUU2cz70HqlfPlxsnMyE9wAYOjFltuzfrKXd9YrMtrJb2OGUJtO4uWEL6tvgc9Z3N3YyuxNWg3Eys58OyB8g4+R1PUyJV2tuF4lq5GeYxmNAE+n2Cqo+Gahi7z6owmhOxOC1TUeJ4YiozWBY4Y83ttrJ1ix/gqZZ7bheAwyVrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=FI/GVrVI; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="FI/GVrVI"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8935f42e8f0so1170643b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 08:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791904420; x=1792509220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XdGTvBWv6RVTx72b2QrJCUkExOa8bBmrCbj+7tkLEbw=;
        b=FI/GVrVIB/dt/amjEfe1yg+FQbFN6bOtBbUqyzHY15VOPNsHlvdRuE2VD2tET8XmDC
         fuFirRUUEI2AfHJX2q53aRByAYZsn394CP0+ccPIrpsysN7yfjLmEsBzVLDYl66qX29x
         rMoUciauobi5YpeHz1IWdlNNsEL55kTzh3AG4p5ZEPqc+L1h9UbAGhhpUERKte826n/J
         xZqgYrvOzIyEDrv3GAWlhKInH/qW/o7DOiEntyTT/amesX04b/X+ycSiye+ZS6VPY2Md
         60m8Hs7zGD0QLmBBqAepotZSvwUNu912+VCKeF4BhYEswLaMB9EeyCAj8eiz3L2gGKbA
         niBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791904420; x=1792509220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XdGTvBWv6RVTx72b2QrJCUkExOa8bBmrCbj+7tkLEbw=;
        b=OXeXow1oV0r1QeWL378dLNlRS7BCQUtxFqNYXcA0kL1ztM7Pg2ygYdWSgqugAW7zrd
         CENhUn+n5cOBz+6llY6/33YddfZpTjszvDlHctKhZ55Xgg5pW8ZoTh3xAPslSeIndCXR
         Pkwaykcz9oHPUSZm9c1h23jHKgt3aYc5TB0yzW/1ydQcA17XJpOVe5vh85z8V4db7cXX
         P9qrg9SJntRCB3nZnzD3gBTFOix83Ryv2THscrMNGOGOvTjr4sMkBu8/UhDjWHUFvGT+
         9fR+hiXpKxe6DJ25meCPdxrgMXx6cq4ohDwb3TPX7m9/OeGMUTtwYY2D3ZsciJ+yBecR
         Rp4w==
X-Gm-Message-State: AFq9FYL1H14ZQLJQHmZj/T4qUx9trzLWKjyx30JbZA/m3efmKz82hWeA
	qhhK7rWibI3qFhJxWvUjcCClXBpJ85df2FGQDofwyzR0PfjgOlc1bPr3VAc8R35gZXs=
X-Gm-Gg: AYBFou1j5OMXRmAJ5Kf75qMkofR0R+QkREBJpIfELQQX0wDSGnxB8pEdyxVU+qmUInU
	ukunUjBpqiN658dQjKkkvWZAhMl7cncgSjRMpSRQnNmvZ/BVulwgmg9o9rUL8BBeZFdahCP1H+q
	AYVT7212TvOMMTcjezO7T/Yt+Gl68R1o4UIAzSSnpl3G3YPX/tLMIdFcHaSfrJTDMkWcED8g/7m
	K9D8irH0pblsSQbZRrNJ5PQggQl4FP5/2lXDnMwEQjytRbi5P3cbNUUqzI8y4Weun5UWmG7u+fI
	2cndXNg9vWF3lMybjjCUmLY1DclgtlXsVC7bAnzhlN9KvtiIRouLJPl8hbx+wmLPB+WR/hLnk1C
	Nt2sZQaRB7r9H3ATK9f5y+KzhLhGsnOJec4ZFyWOtWcMP4hpEMrFKCM0vnjONFGD3xnhDYDVnG+
	326rvyoltxZCR2HCK1W4CC1mwnS//MM++AYjspI5RQ6hYvDm76LFPJb1nCgzQapDFHX0JrYOb+x
	zLVLGsVtDVUHO3+LhsZ
X-Received: by 2002:a05:6a00:2e95:b0:874:708d:b620 with SMTP id d2e1a72fcca58-897c6e1be95mr10797802b3a.30.1791904418255;
        Tue, 13 Oct 2026 08:13:38 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c51c:be8a:c517:276])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c37e267csm5363547b3a.27.2026.10.13.08.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 08:13:36 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-bot@kernel.org,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	aacraid@microsemi.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH 2/2] scsi: aacraid: bound the HBA sense response copy to the source buffer
Date: Wed, 14 Oct 2026 00:13:25 +0900
Message-ID: <20261013151325.3169759-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-169893@kernel.org>
References: <20261013140214.3156938-1-yhlee@isslab.korea.ac.kr> <20261013140214.3156938-3-yhlee@isslab.korea.ac.kr> <sashiko-outbox-169893@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

You are right.  struct aac_native_hba backs err with a 512-byte union
(resp.err / resp_bytes[FW_ERROR_BUFFER_SIZE]), so the copy stayed within
that buffer -- it is not an out-of-bounds read -- and capping the length
to the 32-byte sense_response_buf would have truncated valid sense data.
I have dropped this patch; v2 keeps only the SRB bound:
https://lore.kernel.org/linux-scsi/20261013150420.3168223-1-yhlee@isslab.korea.ac.kr/
