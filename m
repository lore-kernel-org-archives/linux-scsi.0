Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9CB361DB5
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 08:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792138770; cv=none; b=ocVwkk8xAiD85BSOrUC9SWUJmyQM9nUZc6L7c2SQ/MK1+aZQQByBR/ihRbKrvc931aJwGuuyp4xtox/4TCcJJuF6FQlzDdGpX2CbnPCZM90AWRjRu5WLf46UlA0lO41qy0bmX0kDY+ycyXYLrU4Cqp2jJPeHYhTpHPN/xQjAoI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792138770; c=relaxed/simple;
	bh=jIEy5cT5mmkkVcGKdpbeH8K331ZFV/0IWVEdNWVBdcc=;
	h=MIME-Version:In-Reply-To:References:Message-ID:Date:Subject:From:
	 To:Cc:Content-Type; b=H/4lFx0yduDstor1ElGnoZDgWg2jITq4v9culeYdgocsAzWDrH+uG+DOWoC1hgz370keXfnEIifwidJ1F2Ws3YZlYvdfUhUk3su//zqOznpdCESnBsj2DpIitzjx/JQcdzLCddDjUYMhAS9rCStTJu8vzlyyiV9g2CutVproxVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H9psIowU; arc=none smtp.client-ip=209.85.215.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H9psIowU"
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd1e45a268cso2408631a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 01:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792138768; x=1792743568; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jIEy5cT5mmkkVcGKdpbeH8K331ZFV/0IWVEdNWVBdcc=;
        b=H9psIowUu4TXcoj5LDcRHyhCK/XHrx5XlWUDfbx1BDTWGcJj+/huC+N6LepKzo2gGG
         NM9Vy6xbXhR6LTdSEA/WXSg8MXnjCLMfOZes5fEOpP46P/I1HvYiA4TKltTSD+S/hioP
         0/Ns5a6ky0V+F1BjSVxzDtI5flD5mdi6MktZVEbqXq0kgFdQ0wWjLfQe7DDG6kBJl+jV
         5bEuMP2zmlzFZQ8iAilHY82A7akyEVLwbUdS9mRsoSin0VvbyNYOhrI4Bo4HlaCnu/3C
         TjqivscDY9pDnps7jWOcUlruajLAtOZFqxDAGpN30LwEkCLd6SqRDhhmHcX+dO76P7Dr
         pFoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792138768; x=1792743568;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jIEy5cT5mmkkVcGKdpbeH8K331ZFV/0IWVEdNWVBdcc=;
        b=Qhi5L4AtLhk9KVYIY3TkWUBMwlcmrCNr9bPGdhwBSdRwa0q2K6BLWiiOe1prwpxyST
         disc1ydKiItIdIw0YO89V3Lm7OyC3cY9rKEnqhBRyBGiySUDs1aFNEj1DBPoiDrAPQry
         uuo8meLv+6MezUxXxUEsIb1IbkwJy/2gLL+EUTVqJt0ehrDeuQtBjg/WDLtZD/jN8ICp
         iY56XOWve/m2nL94HfDji6WSUSpvjbJ7wfn4HYGOD7Lx/r5k/yYfLdcftGJE6nprDuHa
         BT4QOGL7z3ykVhA2bxNx1KxLm3azeX+oOOh5J3nCni0naLryVEdsoB+otW4C6mqMyEE7
         Aozw==
X-Forwarded-Encrypted: i=1; AKwUvBxqENFuqnmV0QozCx4N1tiQaNuoadpSlc9gUGRV5pNOf5VNDTPcjTFV4JZgVusxw1GOvr9Kba3YadC/@vger.kernel.org
X-Gm-Message-State: AFq9FYIdJBmhRGApAfh8rLdgZ0RrYSvutK3fawRRGcZA02Md3XsWaz0N
	dAKAMiPMN/fmzBO1cj99BgaPjHDwb3ChnZJHcYWwC7fzyFchSe7hDoYDswY0KiMZQSwRhqBwmZt
	kP9UmGqVRJkkQL/4Ub2NmXg==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: from pjq16.prod.google.com ([2002:a17:90b:5610:b0:3a8:6a28:2f71])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3888:b0:3ac:7449:40b4 with SMTP id 98e67ed59e1d1-3ac7449442amr7697078a91.45.1792138768041;
 Fri, 16 Oct 2026 01:19:28 -0700 (PDT)
In-Reply-To: <1792133053-143069-1-git-send-email-shawn.lin@rock-chips.com>
References: <1792133053-143069-1-git-send-email-shawn.lin@rock-chips.com>
Message-ID: <18def4b6dd87d761.3137322e31362e3131332e313435.158157.0000sendgmr@google.com>
Date: Fri, 16 Oct 2026 08:19:28 +0000
Subject: Re: [PATCH] scsi: ufs: core: Fix stale comment in ufshcd_mcq_config_nr_queues()
From: Stanley Jhu <stanleyjhu@google.com>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Reviewed-by: Stanley Jhu <stanleyjhu@google.com>
