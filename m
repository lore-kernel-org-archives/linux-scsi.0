Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629373C2BB9
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 20:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780606720; cv=none; b=NaShiNzhBXsPaqKcVZNu9ZV8/bLSOM0Vxz6S9vU7TO14DuBORDj3X2toHGCEPHyaM9f13AW3ybgkfR3ob1XcTuYrm3HtMzKD/sV2/M1Nu+xi5qGJN2uxsZnyJE+QTZ4iRPpI6JOohirCd+jWRBAsI4m3qA/DuUMSSFICVZCYZZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780606720; c=relaxed/simple;
	bh=DQTkf1lHMIqbwK47/czYzHj+glOCSShwPoAIlDnSnRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oh1KDElVQs4G9MMeRsR84G7A773wD8HDOKCp8OdhDXkKe/Z4gCia7lwHbrwXAbW3tYT8FYy4wp7DBG32dcs8Fu0r7tqTkhVsycB/Jq1wNqvAdG1+03jHX8mxlCA8Qe+fDNOnHUOqvsHIxFGeCoR5EBZlP5Y6L6a6aOb9D2I2Nuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iknnO2pz; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iknnO2pz"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490ac357c55so13938005e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 13:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780606718; x=1781211518; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DQTkf1lHMIqbwK47/czYzHj+glOCSShwPoAIlDnSnRw=;
        b=iknnO2pzYAxVBr5i32I5mNFlyUF4hG16k08qD4F71/MXpgO41aPReHIyqAUUCJV6RS
         ViihSrIEddeu0NhEUPgs9lB8hDS+Ep36XfsjybRB+5GMugVp4FyZhL9U0kHhkOduxGbT
         maWotG0ZImKwZF7omJlhECYYrhgdvXilFsiefRidN5gYZPFckPzFPAR/C47NAPfVGjps
         7RHYlODTmTQhgbviG7ZVGmzhgRzv7pF5ksNClaagSXvoSSJmfCcX2whiiZxpwoscAXQB
         snl2pwk1CGqeCMF2Foq66rJF/MxGmx74R8cuKe5FYm1qsjt5qmQ8p4H7Ao3iwKimMlol
         8Jkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780606718; x=1781211518;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DQTkf1lHMIqbwK47/czYzHj+glOCSShwPoAIlDnSnRw=;
        b=iZr/A49Glg45mrWSsopTAWBE37fA84tXadRXMBMI3QPwQDl3UArex1bXSLrHiWBRgW
         GPYe/WFjlWmMAT36D1QmfCYEDjUkAEjZVaCFr4xuG1ytyhUigX7ap+D7/g4SMTutM+pb
         H7K6srgtE/kCz6cJlBNMGXTU79lmKNGAAJdWgteh8qFdzCfRAX87K11012R58UEIAawP
         QvwTK5TamSVzuJKCSggrhXyOgKhl05L6bjSosfXJIYhiKcpNCRYb5n+aDgs6go8OzvNs
         w1tU23BJpksS5PhFMUvnhzRvhYsySDvBr52YQrd/L9KfNnVb1Fde3CqH/wXQJ/QOf8W+
         flrQ==
X-Forwarded-Encrypted: i=1; AFNElJ/FQkh0DhxSulCsKPtxEpwG68uX+pNwrwKCwLImWaTmgBsLx6xaJWFRdPnzPA9nl6aonIJmNi8Baeby@vger.kernel.org
X-Gm-Message-State: AOJu0YxoWL0tNikOT8q5APAaUCcmSBQSTexJPLJD06POs0kHGb+f8YZi
	5EP8RfqxDhpoZ7h9Nc2BYEB9So0R16f536DCr9hl1HkUUaC1rbIeObaW
X-Gm-Gg: Acq92OHOMOCALvigNxU0dJiz4VpxIJXdNoFKygO/CheIbdGnusytnW218EonliG01CL
	hz2y7baMt408rRjfMmHKG+zI8JZfHb1SYZWwgq0egcoYhtyVj8TTT3mcfxcbft2DqKSEPVfvOXY
	wYawmTiC7YsTZ+X5BkjEF21KXeGpDnu5ZZ3tvFS6EZBI8mrAvT2UjiYcguj20o+0PaPw63N2IsW
	Czs29MqxAYgzR8wEn3hPXwDlfeFtHTf3yV71WPbEyPUFgGwED2OqwCeHoHJsZhv6dBlfSp/5Yoe
	Xx959OWMXhjtdCvAF4ICxyPwZBFw/IwXXQxBsZZSIB9Ewh4BxhcpbDNSMW2q/qnX3crTNq2qtg5
	BtzRISsCtviz1WHcUN6i7PTIBFqxxIVRngEE709LnbiukvdtCtZCY740j+7cUdlod/gKo1cIKrC
	3ukSvIzg8MXDzZtNdbeY2FIoNoWKL5SJ1O
X-Received: by 2002:a05:600c:83c3:b0:48f:d612:3c59 with SMTP id 5b1f17b1804b1-490c25a21a9mr4351475e9.9.1780606717742;
        Thu, 04 Jun 2026 13:58:37 -0700 (PDT)
Received: from localhost ([94.53.77.213])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc413adbsm100278155e9.15.2026.06.04.13.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 13:58:36 -0700 (PDT)
Date: Thu, 4 Jun 2026 23:59:21 +0300
From: Catalin Iacob <iacobcatalin@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	"David S. Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Jens Axboe <axboe@kernel.dk>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/6] Remove remaining references to the pktcdvd driver
Message-ID: <aiHbj0zn4y9X6qV2@toolbx>
References: <20260530-remove-pktcdvd-references-v1-1-aa56941d4315@gmail.com>
 <20260604-remove-pktcdvd-references-v3-0-e2f06fb4eef4@gmail.com>
 <96a48e65-6ee2-4b81-91f8-821a2de707db@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96a48e65-6ee2-4b81-91f8-821a2de707db@acm.org>

On Thu, Jun 04, 2026 at 08:50:22AM -0700, Bart Van Assche wrote:
> If this series is reposted, please combine patches 1/6 and 2/6. Anyway,
> this series looks good to me.

Thanks for taking a look.

I will repost in a few days when back to a computer to fix the subject
of patch 2 since you are right, it does wrongly suggest that the
implementation is moved.

For learning purposes, do you mind quickly sharing your rationale for
combining 1 and 2? To me they are in the same area but still separate
things: one removes dead code, the other increases encapsulation. Each
is a small but worthwhile cleanup, they can be applied in any order and
each can be applied without the other. It's true that, while patch 2
without patch 1 works, it would increase confusion but I find that an
argument to order 2 after 1, not to say they are one thing.

I'd also find it hard to describe what that combined patch does except
by calling out two things: "remove dead code and move the declaration".
Your suggested "unexport" seems more confusing than clarifying, I'd
argue that today the symbol is not exported since that ifdef always
compiles the export out.
