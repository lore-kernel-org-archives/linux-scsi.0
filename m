Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C184B0E4B
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 15:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791819859; cv=none; b=YJtm9W66UxYvYxtSJlS82dBPlg5874Nu7PhbQB8EDS275NN3pWe+9IYvRcGW8B8ZXq8F77J4tQZQQGq1qA3f1M2T1eiF//z8mrow9cpHeuHb1Ql8xkHnPWDp6Jq4A3m1aUMJIFgpmuzUsGsG/sd1bJFpwqMevVSO9tj7F8KJqhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791819859; c=relaxed/simple;
	bh=Q6ojckRBjYD3QiFvyFjmdXI4hG8QuqSOEgoyfAWTMMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYfDu/clSD6uiNso/SUHaXSPBbRRJpoq70MKwHW8cf9JJ5ms010kK1w5VfGC+SRi7CQJJQwnV1LDfEfAHZMUgZuoUHIJwlIVBtCYcJsx4iOz00dbzHbM0/9+MQAfVo9LkmM0+SrdHN7BLN5J+7m/SsnP7N5pynaC2NGY0elOp6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=x/s24oNx; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="x/s24oNx"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cd5cd8d89a7so625957a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 08:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791819857; x=1792424657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JhzmDkyNi5tXfQXog831HLqTAGZf7SGBLNEnHb+ghbA=;
        b=x/s24oNxvroLDDLAfp60YmQuPRLo1FIUJqN9c1HmGA5rKvWVm2VBbtuReZykyaxpzl
         gHjE3uJYVmtrjreKLo2B0f3VXz+UBJddpig53TRZG06+eFhnGIF9Q9zn7DGLb5n8+bvX
         jzhfa3XYnSRTNp1dw+Qd7vDhCG3xxgYUxlzASKZuIrtmm7DZMsB4LaWkvqpqEYGZSgOS
         ghrNoZdSJ6SpNmGnjyYxg/WIe3URGDtmItBhBlJbfn0WMQvMlga5lNkgF7NPxswTK0T+
         ZBBMJyDcGtleueDM4L8NncXH73dHu7RDDpkchWgVsRYrCifafj9D6pCRww+rXFXBSXc0
         bvZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791819857; x=1792424657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JhzmDkyNi5tXfQXog831HLqTAGZf7SGBLNEnHb+ghbA=;
        b=g1Og4KdoOhovt7jgbwABkHV7Ny5YM/xlOR/VJd9Nl1RJFsq6vePnrEsmDlXOByjt/w
         UCgQy6tnMYymEw6b9j6i8QB1CgPk/4WdLSf7nK4iGnPV7XNYFDLMEY27HBcY6oz7MIXH
         rF3n7u2O6lAlV/nIi4m0kv0IqQqTMcmn8PfhUADfZfJwEBVBvBHVr3L3VYj4ej95Thy5
         QGaVEfS9LxNMYM6NSRjmngygt1UyW+3/M/rPYKmLqFRmwGee0iXPoVK6BTG4yI7aO+Sk
         gtpSVcvukFHIVIP09V/QGLnxedFvngc4VYi1kgPi/OZFgbS0dvIbLjvJB5583X1BucpN
         CgAQ==
X-Gm-Message-State: AFq9FYKvwLoShQHAyPSizzEmMMcOFf8B2FDNoQtARqxzYBq7jC+vq0Qm
	EPlAVVtPIHJmhTK+8ZgaELUDmdWHZ3RDLNrNB60LncBVIzCpkjdTu7E0hSDTgZAsBde6Jy5FEaU
	38OG7H04=
X-Gm-Gg: AYBFou15IkXGn+6YD5nY6IGNiey+eNOgfqPPAoNk6D849OcQTw9RnRLwT72phudsLRR
	xQ9l/dW2WCv51xFRFP6aVVEW7vFVQSJYYrmHqUEolq0NRSzoeAzsnGaMmPR3nsyGIZq9sBOLISx
	ZRV6FtUf7eI+luNkfJuxQNS2VLjfJif33SFR3xdqNqWnT6fmOSH8JpmrM+TbzEYYQKXmVktzmVz
	MppZ/34gdOv1fdQGh+mA95Q+yC2cKsWU2L7wlspmi2zMEdTatBYFzxhPZM37k93lcF7mtpER+US
	VWeQp3F01t18xxmVKJkYjjSKaBRev+Slzui4IbE1i+KiuCbK6BfE3E+d91ykWJCjTvRNMlt71ay
	ZEXsjWvvkm6G1eEAdeKkIhLuA2l4SC9hoUjDQnR/xIZra1EzeZYcl8OWtKTTx/OQBodJ6esTjYs
	x6grPQf9ag58qJ45JNmBd/b7vTpgW0HuqJKC0XZV6i6+35FE8uIsBng405kFw73MweyeHi+f8hJ
	xHXrxWlCJ9XKaCYr0CcQQ==
X-Received: by 2002:a05:6300:68c8:20b0:3e1:7199:2309 with SMTP id adf61e73a8af0-3e171995951mr4822949637.64.1791819856742;
        Mon, 12 Oct 2026 08:44:16 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:7bd2:1202:246d:44ce])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd5dc37c2c1sm3342938a12.6.2026.10.12.08.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 08:44:16 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Cc: mkp@kernel.org,
	sashiko-reviews@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: tcm_fc: reject overlapping write-data frames
Date: Tue, 13 Oct 2026 00:44:03 +0900
Message-ID: <20261012154403.2436121-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-168243@kernel.org>
References: <506886f3051941899c26b3dd4d2a32a3c0cf9846.1791812937.git.yhlee@isslab.korea.ac.kr> <sashiko-outbox-168243@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks.  You are right - v1 extended a tracked range but didn't re-check
whether it had become adjacent to another, so a reordered write could fill
the small array with ranges that were really contiguous and then reject a
later frame as a repeat.  v2 coalesces adjacent ranges after each frame, so
that no longer happens; I reproduced the spurious drop with a reordered
16-frame write and confirmed v2 accepts it.  A write split into more
simultaneous gaps than the array holds is still dropped, but that is a
misbehaving initiator and the exchange just aborts.

v2: https://lore.kernel.org/linux-scsi/20261012153502.2435483-1-yhlee@isslab.korea.ac.kr/

Thanks,
Yehyeong
