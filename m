Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1102AE76
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792023779; cv=none; b=iFT3MGkGX/i/5VMOHaoqriOMdEfG6f3NM4Q/kuOVZcXldPtg+Ll4UYB8ZuDOAbL9xdgLrtodRRsFeAwrKG4yjKHfKAu7w/Rt2w7h+FQOTrTbTdQoMZD4d3qm/5yhv3pQpnpxnNCqQ2I1fut64dKJDsp9CsUgtD1cE2lWiD4EEqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792023779; c=relaxed/simple;
	bh=h4wRsX25ceVN5wBSWT2Q/1GU750aNS0TrYEHFDgduhw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ttylI6FhHtO8L+gIi+YwKkp+/CjFtskoNqSmnCUbzh+SJ+ap1lV2n2bbRnBSsZszuFwGhiTKH3CeATV3BhF60fqHBGsE00oc1RPo/MAXvXtjtCcDRwUgAXXOFySbZqYVOZYxuSgUo6WdT627YMX+q2rMJPQNC+YwZaCuuyHYFAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EDvuDtYs; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EDvuDtYs"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-88c4da716f4so1221470b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792023777; x=1792628577; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h4wRsX25ceVN5wBSWT2Q/1GU750aNS0TrYEHFDgduhw=;
        b=EDvuDtYsQKAVFBrsvlfcNveaO7ZLeDvh0o90Kr9ns7dKBt2Y9a9xa1/t3zH0+nnwuX
         p/XPxLHfYmqRTC2kr5Z+9Ofb/ajv89ETGVc2wobY8Q4XvRRcg33Wcb+rjzRN78eJjTA8
         ubvioEime8ffSLeS47HBPULb6K4g+WSQd1qB+jxXHB2gE0irAIMScTFqBk9YIASPV+ip
         q/z1jZkFDkTDCoR/g6EpDyXlYeSF98Aa82tzvYpKMsrXo2Zj+WLgtINkTNOg/9i2LDzd
         E8Lg3EUofB9IDpvbs3Q604jA9iqkDsPDvS/FXuttjKUWUXAILEItoSh6pQk5KBHGFQ9R
         sC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792023777; x=1792628577;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h4wRsX25ceVN5wBSWT2Q/1GU750aNS0TrYEHFDgduhw=;
        b=K7YV8HEM6iDu+9JLKMWpNGXJcUarXtoMpO0PH0dflvxPXiTyZobTvGVND7oYaDPfMg
         uhxoIQi+s2tpE08M3OJekz2mitfcOEMsRFAywwm5UPOW7hJy2qMrVBLv73zz9DXoV8xt
         8T3DZLw9kTf6z45RIwRNiz2Oa1Gezbf3N0+BUUxF7MpyxULKvVveeobpgsaQ0mKlgrq9
         eKfhsseVr4P3Tn1uP6K8PSx3JCJ7TOEYAaLu3CckkYlQHk9hFH9jn1kcc+EQtjJNswDB
         bRfU7fOU3vTES9UZCxSa7PDSFRrPvADtHR1Lg5NXrOQ4cD6fDnZXesL9jGULzxDguDng
         1ZvQ==
X-Forwarded-Encrypted: i=1; AKwUvBwpWXHvKyu4xLnb1rsGteIr7XLTi5I00IcNBwG5ixM63YZlwtLsN0bigm4esFtdqd5bwhUlFG+Ha1NX@vger.kernel.org
X-Gm-Message-State: AFq9FYLM90BvcnHutKN3eihY0EW7umKqsMoZw5Ik51bnSySbjYM2f2qe
	kMpIFL6MIj5FoTTzs8k2ISPZCaGNKy1EWPSzqAzXJwaqBxLy9C6yiQwfunaJnn1NEufPfsA9966
	V7M6ocqeXM5kQYL3y7SfB6g==
X-Received: from pfbic14.prod.google.com ([2002:a05:6a00:8a0e:b0:899:1f5b:5265])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4652:b0:888:2b10:e26b with SMTP id d2e1a72fcca58-897c6e1cefcmr14526635b3a.18.1792023777107;
 Wed, 14 Oct 2026 17:22:57 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:22:55 +0800
In-Reply-To: <e3706904-3b53-41bf-b8c0-48ac4d2e2cf5@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <e3706904-3b53-41bf-b8c0-48ac4d2e2cf5@acm.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015002255.3458767-1-stanleyjhu@google.com>
Subject: Re: [PATCH 2/3] scsi: ufs: bsg: Clear the UIC result byte before
 sending UIC commands
From: Stanley Jhu <stanleyjhu@google.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Brian Kao <powenkao@google.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On 10/14/26 6:30 AM, Bart Van Assche wrote:
> Shouldn't invalid inputs be rejected rather than trying to correct these?

Agreed. v2 rejects a non-zero result byte with -EINVAL:
https://lore.kernel.org/all/20261015001855.3450573-5-stanleyjhu@google.com/
