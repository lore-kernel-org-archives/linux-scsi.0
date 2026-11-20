Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175002;
	b=cQlWbGyxZegeiEU61hfdlxQH0cHjw8t0F9AtNHXFbF/QUn+NkMKbSe5XN5G0lrFBtr5n
	 lxA81LTWmVaDyUjNZ4cczQ017kzzlhk6r+vJUz/QmeEtacx9lQk+pKAK5tFvVbd4oAqcy
	 +f2g6/2C1UJr6Q0Cj1ZqccIO/u37xl5qMN74UBiCsBrsGauMBSUCKsqRKupRBNkaO1Jwk
	 K2voznUzJRWPN9iPCCHtV2y3P7azJTuMxpHM77Z7tsRk0lgW/MY8UGV4NwuzRnJUSK4VX
	 F+WeT9jYIx0xfwqfZVvxBQgNsBZ2SrzXGrTz5zitOLkxAz5AGTLbPERHp6gNL6zxKtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175002;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eVgtKYkwPgYU4uayGBjffLSsBvG0HKLAfvNm2HOLvA0=;
	b=OOwsUoRy2s6sFUdC/3uF1GmLfuya01UA9RyYYgfraCrwYhjcIxUbMptxnkYFyrJSV25o
	 OeyyU8XObUNh4Xbbh/w0N6bews7LP2X5rN9RQhynmuqcU1bYniK7W6cIsoBjL1WfxM+Yr
	 Z6X+QfwmdbNJlXmWIwvgPvntcjusnfTZIGzRnZgu/jCxnyheSCobkIGys+eNmRu0NE3vE
	 Kd2rnHlGijyvc8FsRZP76iVGVY4XnWcB88McIOVzrGb3kmBLie8pNkUkZGI7Qj7bbsvy9
	 oLxpRvNQVgyYkLi1KLYEp3G2JTditgLM1pv0wrgpakqX8PXs7U5HCdNzdOzHHAKfJag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=m77It3AR;
	arc=none smtp.remote-ip=209.85.214.175
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E507C606A332
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:43:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E507C606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=m77It3AR
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2efd659464aso2667055ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175001; x=1795779801; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eVgtKYkwPgYU4uayGBjffLSsBvG0HKLAfvNm2HOLvA0=;
        b=m77It3ARMTjZqUq6OHHALOtQGx3sLhRKjVH+4T4LeA6GJU6KfxYHZoeezT3crTOGz3
         WMYcQp4HQ1n4/6NmOuMqJjgl6tMjZSq8OZt2p4Oz/RTSe5muzguVAEV3K9ZiZXvq4BYk
         4bXui60+BjxYpJzNXvkR8TniBOE1SX7+NkKZZYfwbAlG+EsJjBfmNrhIMSJvSU1lfLeO
         S0u6E3XfNqGdxLCyIHG3VNw5xPqy3/SAPcs1XHNezg5IuBEug1VOjDGUyDDyfMxqnoZK
         8dwMC6e3X6eLC5hVy9c9q4JkFcTUAhvQixkb29zsfgsiB9SEKNemejt8YeHuUHIrKD59
         CeCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175001; x=1795779801;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eVgtKYkwPgYU4uayGBjffLSsBvG0HKLAfvNm2HOLvA0=;
        b=2JmWSLmBmF3sT1Vza2jPXxiKzI30f+7sypd5kkrb7rC8yJq+euum9BddtoC0mvVUiN
         fL7FkimbXY8L4NFzTIYlWxxPIbTV2gufRU3YmJiNPRwfGMkkSQDUGZIslmeGOD0gh0/z
         Tp2ED9mgtz121KfKXzgNsi7w1sfa8cSe/Z4Zj7AbbpEvwHI/n79q2pM3Chlm5TyX1Kvx
         eWwMIZytjrygVRnjbGZO+tUNuUMhGMoPKmoDoMbndzKtOQM1WPFZNC/AwvRqVtYtHT/e
         gWnAEvVOdauHZi4D9Fpnj7SZk/ZvsXXp3mHF25FVAtdNv3NMIx6oDeVmqhknUEVGj7wv
         tzCw==
X-Forwarded-Encrypted: i=1; AL+hErFyVh5PCbUgGFzr5df5H4YcLr3WCY2GShJm6ArwUyFMy9fX/0O4PHhbxiRABUvlwFKyKGqn0VWkZEql@vger.kernel.org
X-Gm-Message-State: APuU4Z877k0frZhSAccQl0uRkTqxZNA2l8cNwLMh1qLNRvn0VXErHP1r
	YYsyzPAHmt2KpZvYEi/3W98dd3szRmplPaQGixdoVV9RRy+MsOlf8VnvG+13IDT/sZM=
X-Gm-Gg: AZFdTZckLUMBTTJ44VcUM6/MDKHGBqDRf0OPhLJQRLAhiY/D2L1vUd5yHqs4nKFnO0P
	tNMDzJs47JLkNDoknr9FGzZmzF/tDbxxFMW0C5etW7yx2TT8ucdH4GHbZLXsXVkYGQXZmlIwyzd
	nBmarE0RrxPR0MeKtxIeOpAaYTYIdwKLhUgkEQApOvgbiGdPZALFLJpNaFWUIxSsF+a+P3iESSl
	PyzwpH5k4yr6cH2kcT+scJM7LEAshy+4uKJfPzoPM++VQLIcsIKspzQ9Lr0jeKFyaC9i/aVd2Hv
	QM6ig4htkWamqqyYCqB33Ov6cGKYHoTQVLNo7E/+zKm8MGXQxyRtPi9E1dun6sQDJ1FNNlo8AdF
	QhNucLJSBiSIVchoS4bIZC5AChhPa3Xzm2fgdnv28iEFUosfOslZKIoZZQopsET5Aun/OF1ezAp
	Bbbh3OHFFgoDSajmXJjMgRTQvur5h5ycvj9y1N1KD8i+/3YLGINFuEAvMuHb+a8LW5eidBIGxtj
	NwZmM/a/Ld6Byz55l9HolpERb/8TQf5KoGIPjPpvthb686l0kkZ9+7YCs8DR5dDcE3DgA5YGnf/
	lRhO7FaDnGIvcY2+tlIKL+Rv1YDMDc4EtARXIceHx8QLNXLaWiKOL72FpXdOrYcY06XJMPrCE/K
	XhaISm6u6VsZvqu6iB1tzGAgctpmqsSwB8tm1
X-Received: by 2002:a17:903:1ce:b0:2ed:d1ff:fa8a with SMTP id d9443c01a7336-2f03f147f84mr27476485ad.36.1795175001342;
        Fri, 20 Nov 2026 03:43:21 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c2091sm13072045ad.20.2026.11.20.03.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:43:20 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hare@suse.de,
	bvanassche@acm.org
Subject: Re: [PATCH] scsi: target: tcm_fc: reject overlapping write-data frames
Date: Fri, 20 Nov 2026 20:43:16 +0900
Message-ID: <20261120114316.3072301-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <506886f3051941899c26b3dd4d2a32a3c0cf9846.1791812937.git.yhlee@isslab.korea.ac.kr>
References: <506886f3051941899c26b3dd4d2a32a3c0cf9846.1791812937.git.yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is superseded by v2:
  https://lore.kernel.org/all/20261012153502.2435483-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
