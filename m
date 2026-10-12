Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6FC47127D
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 09:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791795752; cv=none; b=SLIQVVXdfuLNSGCLTm1ouU4eRfdB4eI5awz6iZ66+QYul/sxJGqw1b5dg24tvCjA2F/QQkavV4rzYdcj2+Kg3afhGmsVmQQ/g3gBwbEqa7Zj0pWfK8ZhJSC2nkjbDuCmYB3Oj5OtGzT1SwEuxYlUZeYD5wwt84ozvzHnKj6MuHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791795752; c=relaxed/simple;
	bh=bjF/sClYqCGL939pnFf+kLQX8zKbUrhgCJZgeEGIDLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kArsK6/eoiBy7JO6oB946cp2Ex1tv327i6ra5M68k31ntn0BGapnTfAve9rF2usEuSKaUpNDIjN9ehFWJsMnGk60ynx1G6yaK7OaOQmFauBchf3Gas9hdU3e5y+iMWJ+Z7ZrI4ZgykMvWTVojrbf4mwQnkysGGLW7RJs9VHko/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=JVXiwoyd; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="JVXiwoyd"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ab868eb9cfso679279a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 02:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791795750; x=1792400550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=la0yUppRKkBOXKqJrbZxqUja+1YySJSF4z3IR3acabQ=;
        b=JVXiwoydZSsQpB3c3vCrIRVE8ygF4xYG2ODQ2mSRu8WRx/03l72lZjt2rBvZ9KrVyN
         xtAmwCcrQo+QtYmhnr1+2XqY/LQ8AwMwSEULFegklRefBTsv5aP0styWULBdP1ztHsi7
         DInJm/8TQdzMQZ9XMpTkeZo6EfsxMtQc5glr+Vkc01kVcJ08YonOqXVHznr9y37kgWx+
         0uNTvbF5lwUdOup7Hwv5IWliVkig6rnmlvBLgocHU/P+05glMkhrWfj5rlfBLMfi0+Ks
         6fqSfFy2GQZESO3AnL4EXr3jRAht1M/75dTqPF+uJKEaTGCe1DsdpzhV/P2UeA36a+4d
         5jhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791795750; x=1792400550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=la0yUppRKkBOXKqJrbZxqUja+1YySJSF4z3IR3acabQ=;
        b=MiWaxpVPB7akAB2G/84YnF6DJvaUsKobJNkkoI4fFNPetMvPnaa+TgSvbihxUhovag
         A5hJMUPzLz26b5rHf9xneVwX60Rl48rMV3NeVpuWhnKzMj4RzC5dQImFaBLW6B8/jEDl
         kj/gWZxbXXJTrec0Cotmy7wATRqaOfZ2bfpx1ulXhY0z1gcEjYInj+j2dCJmwbRDaBjH
         zcKbHaPDoiJI3WDYKuTkOyR3acONS12M/keY0EnDS7jFWs3ZB27Ng093cNo/8H3RtCy+
         6qlSMJcU9NbiVun5XpSTFQDFfGxjmtyBV+oZ5sxvHi0yBbfgBRcq0dEQ5m7t28jnRxvh
         /XBA==
X-Gm-Message-State: AFq9FYLH+BOlLUdFvz8zuQqp72iyXzIZPS2ci0pl03U2asqLv+9DihVs
	e5Agij3avzxh9kG7iTpO+8ZGlq7PCwba/AC9lNwdhXEruQd8ro3SEInIJITr3exO600=
X-Gm-Gg: AYBFou3vUqfoyu1iobTTjVBmWCQ9kz1DCHo3JP0fPT7J8qtIHE2v5ys0Lw/twJPC+W7
	0oU5Cf2+SOTDTZ2GFp0l6kxfBCmIg2XvjUh6l+XyxLla2bztR+OduyFE+hMvyQfUFu2ctSC3qz2
	1JlvhTOZgldtCIYien4hwtULVpAkl5kTLmUO7P1pvZFUMRc30FJoYfEpKutHpFkJuUKlXqi6zJ7
	GzcfSlifqM1eGFoJ/qwPWlx78QvLrnG5P/ShNWKkbcu49eDHfdJukvWBKiPA31h6K1HiwNXhpwk
	wkNeH6tdGHBfin6duvhRtVfGbf7MpGt3kOR3WjSCYIUnR8qu+uY++P5kVgq8asM555dbxG+qWlP
	slPoT0avka4xUt4aSRYl0Fods/L+ZpSCMl14oDJSpqau0Z2il3gb5/9b3hTG2q441s6/YqS+rUj
	GoEJIfII3zkN6VyrXOBCrkTPl29CRsFLAz67gZilbPYHoZJNGxiR5pOLyfK05OuU5eNxriEfr83
	jaHNA==
X-Received: by 2002:a17:90a:d2ce:b0:3a9:9f13:e960 with SMTP id 98e67ed59e1d1-3ab3a98f4e3mr7312162a91.60.1791795749920;
        Mon, 12 Oct 2026 02:02:29 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab3962f771sm7291898a91.2.2026.10.12.02.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 02:02:29 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org,
	ching2048@areca.com.tw,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH 2/3] scsi: arcmsr: check the completion index the adapter reports
Date: Mon, 12 Oct 2026 18:02:21 +0900
Message-ID: <20261012090222.2286418-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-167808@kernel.org>
References: <cover.1791789900.git.yhlee@isslab.korea.ac.kr> <f0e71746bcdaabb1e105297ed86ddcf2245b0c86.1791789900.git.yhlee@isslab.korea.ac.kr> <sashiko-outbox-167808@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the review.

On the interrupt storm: you are right.  Breaking out of the loop left
the completion consumer index unadvanced, so the adapter would keep the
postqueue interrupt asserted and the handler would re-enter on the same
entry.  v2 skips the bad entry and continues so the consumer index
advances past it, clearing it to 0xffff on type F as the normal path
does; the queue drains instead of stalling.

On maxFreeCCB: also correct.  arcmsr_get_firmware_spec() can raise
acb->maxFreeCCB above the 1024-entry pccb_pool, so v2 bounds the index
against ARCMSR_MAX_FREECCB_NUM instead.

On the uncleared cmdSMID in arcmsr_hbaE_polling_ccbdone(): this predates
the change -- the polling path never writes 0xffff back for type F even
on the normal consume path -- so it is independent of the index bound
and I will address it separately rather than fold it into this fix.

v2: https://lore.kernel.org/linux-scsi/cover.1791792888.git.yhlee@isslab.korea.ac.kr/
