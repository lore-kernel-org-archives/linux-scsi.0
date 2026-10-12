Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFB647887B
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 12:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791807380; cv=none; b=SS9csy/MYoX7whf2qCMxOE85eGmXWfxvwgt7NmsEVDbqEveTzgeTve3d5PoN0slTYfpow0k9WVpeFi7sUnqxMvISvhU6Sq5i8ZqoLl8tSFv8bGBYqe5hwhczEz+Wg5dFXtZxoIPcxp4y2WRT+yzPfy+tdHTe0qyJnrYFQzgEbVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791807380; c=relaxed/simple;
	bh=jR668KmHveWhKfzwm/VRHu50O+jFQBt154c4fksmz2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsyrD7gJmft66PLE5OmTCG5ZBhksp1AzDNpbfarcPEM3o4bUMpBVt4Pv96u0Uibp2URMo4M0XFmfO4zhT0y8pG/jKt6KjZ5Ea5XfIMN0OQxciB6mxWGoNtafBCtAC4UTLxsPSKhRWvi4Jf48MVVY/xlo1HfpMYkJbQF+VxTD/Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=rWy1GuCJ; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="rWy1GuCJ"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so931436a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 05:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791807378; x=1792412178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jR668KmHveWhKfzwm/VRHu50O+jFQBt154c4fksmz2Y=;
        b=rWy1GuCJQvH3ZGLkXj1Th3rfsuN8x1m4sNnZLKBasWjsepZlPpcR7TFHVYQD71xNtr
         UfzQ8dru2hNhsslG6ZzFpxdFLRhDq/e+OjxjMjhnP6arOm33QPZ3a0Y7eq4hw9gZj3dC
         JaEYUsp+UeCE52oKdYn89JerL54R/ODgWaW48CsRumJjaEyVn5Bx0enkLOTeMd2tXE2C
         yNnqvcrlADqHe5Q4XHlojJc4yWlof+EGM+nNiG4tIkKnw1YnAzzYcZLnQutACgrE3rz9
         U7zsilqmlUv5mkwM21+AgNQLKA8EMyXHGWngq6batSYXyH0eYmbDs7syKbrC9UlugTru
         gN2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791807378; x=1792412178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jR668KmHveWhKfzwm/VRHu50O+jFQBt154c4fksmz2Y=;
        b=Ib+KEL4IjFGMbEgwPqpy7D0wMg66Cwo2+W8YQRttdVmbsYOuXfglU2zNsVuPed+c60
         6AZVX/EZ0yPKNvlmFAIAQsOXQxTQqNmuwf1Ifrtp+WHfqNQusZh7AffOQ+iHBPTFVA3W
         057+VhdLCwco9M5sKaycjrD895/cLRYYpROc4NZQK8VpBvBvBjDM5I84f8j6m3lDilZd
         iOWk+E7brsicrHyEkizdIIYpuGmAS+kE18hRksl8x2JUWZ4gyZCCeEmXq79RkxNYbR8B
         BgO6t7dBxNW5652+r/JsUfestRhsY737QfyQCC+Q7GdZAceTZbqkrbkJhWZpUoRCTqFV
         ZTAQ==
X-Gm-Message-State: AFq9FYI05C9+TOCmD7Ic/sdzV4Mui0YnF2+xZaDnZqvDCQD7zfepyMz9
	u2aQP/oyNMt3au7wTyRgfLo5xpD3OVXkCYLR3fgTXSqqwx3eBDj0CHpANXZwWQZHMTzamIgj0m6
	N5QuC7eo=
X-Gm-Gg: AYBFou2x4TUifh1oTQdIF4eCecbmnQsHJK+shMR4S5FHSzypLITmg2puM7sFIInaNmD
	nY3Z9VS8gb4vSUN/yFFb+mnx1q4RTFNPK0MYUMIHKgO49bj4o4QvcJ/mIyiCvaqV6wifcBkVLkM
	T5Ov5iRFjh0JOEjs8z42D17Cm3J4GcNBamjw/Guh9yZGBCVF/Cgc3lnjb3a/3+TISBXeChsIBe2
	6RKEVseE78UbSzNaY1p2oPYKWzQRJXMoRFkKsTM3M1ySFfKSARYS8mE8aqIxwWugXNXWp1n5wgm
	evKVaW5xICdpdvaTKSA2a6cnFXp9qd8a9roob3wTu1gchXY1yRO/+i5Vub5h6iji/aOd4KxaYbN
	1belq0Hy1B33gbcWUMWiDkHRvrccHOE7TY3HkLvJ9dyH5vQIVjmkfMlEVBSDmEE7gqA5o7N5eKI
	7GLkgwwzJgPt8PKBO3yfmIWng/qZyd5qiQobQuR7DrWq8u+fyTDyzOuWZJIdANJCvynUh8qYlQh
	Xemh3Mz3YQvcVj/wC6u9Q==
X-Received: by 2002:a17:90b:2d0b:b0:3a7:e11c:4e6e with SMTP id 98e67ed59e1d1-3ab3a97a71dmr7873463a91.59.1791807378165;
        Mon, 12 Oct 2026 05:16:18 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:7bd2:1202:246d:44ce])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38ff0ce7sm17212536a91.15.2026.10.12.05.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 05:16:17 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: linux-scsi@vger.kernel.org
Cc: ching2048@areca.com.tw,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	thenzl@redhat.com,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH v3 3/3] scsi: arcmsr: wrap the type B completion index before using it
Date: Mon, 12 Oct 2026 21:16:03 +0900
Message-ID: <20261012121603.2335651-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-168041@kernel.org>
References: <cover.1791803953.git.yhlee@isslab.korea.ac.kr> <459990a0367f7268c0056098f6e2631700e20327.1791803953.git.yhlee@isslab.korea.ac.kr> <sashiko-outbox-168041@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is pre-existing: the patch only wraps the index so the first access
stays in bounds, and leaves the loop and its termination unchanged.

Both type B loops clear each slot they process (done_qbuffer[index] = 0) and
advance, so the loop only keeps going if the adapter keeps writing fresh
non-zero entries into the ring - a faulty or malicious device forging an
endless stream of completions, which is a weaker and different threat than
the out-of-bounds read this patch closes. The same drain-until-empty
structure is used by every adapter type, and only the type C isr carries an
iteration budget today, so adding one is better done as its own change across
the board rather than folded into this one-line fix.

Thanks,
Yehyeong
