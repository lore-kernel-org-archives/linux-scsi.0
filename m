Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851A429B8E1
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792024891; cv=none; b=tzZUPpiTHZBEfZHh2xyEVXSk9rKqP/ag8TdNTMVjjvk/ESyI15M3eL64gecESCLG4OVx9ssG4z0KTyOwxJCrDDxm9PxWsicdSRFOxtXsItEY/UVm1t2qo2CKiNPrtyG1D9OLa9ZI7JJuwW+VICvUmyBe6NGwktZarHlvTnMtvPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792024891; c=relaxed/simple;
	bh=x2bEOdgUloxAb1N3O3+8rBHIrKFC9lz/f3MKyYXYJwU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PoepeIhBJUWgDSfRhdKBvRf+AAHdm9DmSRbMDZWhw0IAO3yqJimnQYX5AGINIfanRnUUwDn3vrJGE+V/t4/Dv0BYqgRj4BbTIsxcjNozdtzojpCaY6wy+5UR07nW3NHsGSqo028LklO9/x2ENAa7IYs1VvKD79JRYLR/JUBGcGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j4R834sx; arc=none smtp.client-ip=209.85.215.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j4R834sx"
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc42a07d04aso1334051a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792024890; x=1792629690; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x2bEOdgUloxAb1N3O3+8rBHIrKFC9lz/f3MKyYXYJwU=;
        b=j4R834sxf7I/lMqQn2UO8Xd3R09h6TUtazePU+7N2sjaazrWcIWL0BekQHSXaKieyu
         FaHEazQj/il4vQtC6m3iL3zuiC5XEThFdCewwvTNzME8Gc8myV/CfYGmMCsHooNZTSTH
         4kJWw9Zj8FG0RaSqykjjuc0LwfMyWa0t2JnMh7n/LN6Qb+XNlWUdrLITjHHCCtKxh5p9
         HJaLf1f3XfJixSvzJAPIFOW6q6cD8XxFSr4dfvFvCoV55RLl5h7TOKP/kxulnR2qVAXp
         dJ9YT6B9aASFZty++OxS5p4gaehifaI4eTpTLaW5eCS/wnA/wB7e7fy1dZXlqnOhbswt
         ZbaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792024890; x=1792629690;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x2bEOdgUloxAb1N3O3+8rBHIrKFC9lz/f3MKyYXYJwU=;
        b=OuuOPFzmKxxyt9TvJdMCY6xWV3TVqiQ89cVvCVcN7DvrSC8cBI9Ig14pXcINQJQ8GK
         xcmMEyrrfeSCt87tEprVz0eizfyWMH/1r2SUPkLncGFw4DjERbRx0hYrtxzzhydyg+vM
         zMAZt2JGKbkk90eWSzmhfJYE5+0AYY87M2VczHNfRcKrYt8d2f2WpEBMSnWCQIaLRB2C
         F/ySRFVOUJuYTrPksUJb/t2469NXiiEcSSIEHDEtB2OLIZP2uVopPTcj6GnsZorKCoRE
         uv64GKQH9p6BDsfGMD+Q5bAr4Ti3aqxf+TyNTlJ9lpMLsjgOpff9DNCxlGuWUCmJhkOC
         BH9w==
X-Forwarded-Encrypted: i=1; AKwUvBzaNEtlNEtj7WgO5e1EA2q0V8x/cZce/7lY2mSFkD43zPEaqbVhqSkjnpbxp8bWgxzblZJgNSEVZ4SX@vger.kernel.org
X-Gm-Message-State: AFq9FYJ0+G+TuxD9Zgc7n/aagbAyz3BvqfcLqmzg7TDXyUQaxdz0kyjk
	LKkiALFHMbIimwuFb41WJN/yU8Cjtav7SQbocUkcvNytvyzdkj6iaebo79wDFKDxhunh/+ka7lc
	1EMsA0B/vuURAn5l1wH5+qA==
X-Received: from pfbfn25.prod.google.com ([2002:a05:6a00:2fd9:b0:89e:11cd:a9bc])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4185:b0:890:a3ed:8a49 with SMTP id d2e1a72fcca58-897c7cd481emr15442585b3a.51.1792024889687;
 Wed, 14 Oct 2026 17:41:29 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:41:28 +0800
In-Reply-To: <sashiko-outbox-172059@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <sashiko-outbox-172059@kernel.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015004128.3503693-1-stanleyjhu@google.com>
Subject: Re: [PATCH v2 2/5] scsi: ufs: bsg: Clear the reply buffer before use
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Brian Kao <powenkao@google.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 15, 2026 at 12:34:36AM +0000, sashiko-bot@kernel.org wrote:
> Will this copy write 64 bytes starting at offset 40, exceeding the 96-byte
> allocation by 8 bytes and corrupting out-of-bounds memory?

Pre-existing; fixed separately in bsg-lib, which sizes the reply buffer
to 104 bytes for UFS:
https://lore.kernel.org/all/20261013132708.1669415-1-stanleyjhu@google.com/
