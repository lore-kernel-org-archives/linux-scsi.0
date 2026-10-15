Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D452547053
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792024889; cv=none; b=D/QGDJLG1keubakkl41ruNLufDzJG5HXz3crdLMnzUJAyWdlRkGhBp1H/RP7H4AmcBEUK4WYxXaAaDreolyk/MJvOZb3RAehDpd1/w6YPqrH6dqFL6PYl6RiS+23KYX2LODQNjnh9Z0K1kFEYpX5eh6HAR/wY1ATVXBczY876L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792024889; c=relaxed/simple;
	bh=Pf5+YeQcPloVKTlYpAhhmE0RtcJ7wod9H7wGMxmpep0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y/g9+rF20cPGGNzScwDKCDyo/5MZUv+v1+Qwq58depVMNjXecUHdgORhND+8Q9KpkAjljSft0ZtLDlDUHZuxL0yZ7j9bqHcH5nkUfP3qLvpL9/KYO3tsDNM6slo9MufyZ7z7i54PcFnCMKlBCx2h3FlJHnN0EqjHpiVgOjet0tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HY+2cuKg; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HY+2cuKg"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ac450b74b0so3083479a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792024888; x=1792629688; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pf5+YeQcPloVKTlYpAhhmE0RtcJ7wod9H7wGMxmpep0=;
        b=HY+2cuKgGSi3UXoU0G6gIhvWmAJV53R46Y5PT7g7cdXD8Am486fQLdehc9D3Cmcql0
         OEeh4jb0qOzOdTUam5rmDsvOhbAr/C4YQaptipiBChlZvW9CvPzfBEvNdkpIn1DpeRBl
         B69xBwFdZN5rOAGf4b+tk1qrD6KLs8EUw6t3jxHIa82p6f2JfCCkso9ZbeHWF2iBmz6B
         7cCIhtBB7DQGntyb0pZPs+/xV4REAM4ChvJ9obd47VW6rF2A8LpcP9hpOwrAeJ54Uh2i
         cruWclWGttpzC9TdMJWpTohJc6OlZhT7+CMXFw7WvRUov7AOdDuXn2NEIh2xfLEhkfCg
         epXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792024888; x=1792629688;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pf5+YeQcPloVKTlYpAhhmE0RtcJ7wod9H7wGMxmpep0=;
        b=ELMcMKb2TWAQUkSlgX8SlUgc9wDdQfpy6TqtcV2vXIM/LjukXqSLwse4tjmC5w9Eea
         0L3mDj2vVjXuvPakPNCwfIrroxIGwMDTJPwF9tuCtptpfP3qkZoW3zyXWtsAN/0d1xR3
         zvDzGegJgVGgdzbj1wEFPN457Mg9wEc9a3GVDnTBQeKezS10eW3XBW0XmmRqGugeNz/L
         XUwBYUcxpN3PnnRFmGNPnig2drfkFt7ASY8zzFJEW7aEgdiBD88YPNwuf+p0ugP3c5UO
         1c/C2i2drNUzQFCPJORjyqrVGqdfelAsWvEdxQYiD+nEp80/s2Vo8neCOzXp+Tsuh0lt
         eR5A==
X-Forwarded-Encrypted: i=1; AKwUvByEZvXfazIijrvS6G+Rnh+tvKNIcJZdzSKpc/VgYuWDKrJsLPJIOPsZAFUizAQASOASTdzjQtzENPmk@vger.kernel.org
X-Gm-Message-State: AFq9FYJRYrh326otFPHVqWWydaQyA0fpta+qRDL6X6CAiYDHIfx6ZxEA
	Jf1W53vMGNackrJuvnR8TsCctNeuZVJBZMz7gdWz3Ww4wCSdAx+a84r3NXxsM3VHhlU60qwy8yL
	/YaWgEVNqf7Gy7I/dsQ/veA==
X-Received: from pgac2.prod.google.com ([2002:a05:6a02:2942:b0:cc7:e840:a614])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:28c4:b0:3ac:8af9:4a73 with SMTP id 98e67ed59e1d1-3ac8af94eeemr1509712a91.28.1792024887625;
 Wed, 14 Oct 2026 17:41:27 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:41:25 +0800
In-Reply-To: <sashiko-outbox-172057@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <sashiko-outbox-172057@kernel.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015004125.3503453-1-stanleyjhu@google.com>
Subject: Re: [PATCH v2 1/5] scsi: ufs: bsg: Complete the job on error
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Brian Kao <powenkao@google.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 15, 2026 at 12:32:09AM +0000, sashiko-bot@kernel.org wrote:
> Because job->reply_len is set to 104, this copies 8 bytes of adjacent
> slab memory to userspace, which could lead to heap corruption and
> memory disclosure.

Pre-existing and not changed by this patch; fixed separately in bsg-lib:
https://lore.kernel.org/all/20261013132708.1669415-1-stanleyjhu@google.com/
