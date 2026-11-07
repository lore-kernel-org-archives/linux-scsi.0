Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794069308;
	b=eNUgF6TR99e54PaMjfopsEH/bwnlaKdksVQMg6/EYw+HDzFlv+76HzgBng8qc4hrl2WD
	 lxpP4Ms0WAo9ys5uD4YMxtuHJ9CcvX7Cg9iZPTEeY7xZHmJC3mWS8/wW8/DWEwishBHbd
	 3pjWfiZjHbMEZTR4B0sDbkL/BZzbBMhKw4S4p8fg3mrwrSxP5pKSoK0E1cPS8wLU+4izP
	 JwdO8pMHje80yFoA2IF+aIQW+Erc3YZSVGeK7gmztfEBEi+SEK1PAqm06nYSYRPNJ21W+
	 2JrhdhEnwSRnTHAYst8PWJYDpNlombuZ74D7N56+2DlRr93e7LaBG8kCqAO7tDNG5pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794069308;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:User-Agent;
	bh=t9lxvGsvnVKAYbZJhO8MAWe0ocVncbdFnsrj+9efmqA=;
	b=uFC0SQxoK1Rdowa4Rlb3PscMIrI9JcBGmL6YkOzNDyoFTGic8nNm7X53F5gYk/D2KtUc
	 FHkjoZfsQfOrQeRfvMjympkeWJbrzEXKfvLM0jgIcxQwIEg8fpjnRniwQ6Ps2VkWIVIU/
	 PS9BF9sRp+Lu/WaX5yAXPvMEG6Rm9ULR3cWk/v47qBWZfecTkgO7lLUnYcZ6pgNB1tcFD
	 NAcPQRTLRfnSs+nNOp9IoB2Q7p0SmLwyqhDTgVd9WgN5TUh3GuQ5nCgU9ln+pF8v9eho0
	 7eQ0SZmTRrij4N3gEQwik6NC3bP2BA6mwSxw0TWtrKqiv32lnCnody4S+ferokG9Yww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=TNBOtk8t;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1897606A326
	for <linux-scsi@vger.kernel.org>; Sat,  7 Nov 2026 16:35:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1897606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=TNBOtk8t
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3b0ae87069dso749791a91.2
        for <linux-scsi@vger.kernel.org>; Sat, 07 Nov 2026 08:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794069307; x=1794674107; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t9lxvGsvnVKAYbZJhO8MAWe0ocVncbdFnsrj+9efmqA=;
        b=TNBOtk8tJLyhYRYcUZ6jwm7nfKmCagIm7N9TXcmUQ4pXY2fzS+SzU3GmVAphRD0tsk
         Dj3u99LGuC/LtlzRqD9RcW80Hof0n3tV5DEkhPOUd167Ts0jC0urKJHx+1EL05HrKv3x
         34CgyoRjK0WnQ+PkZuLCnhmWTLd0pbIXEN9hY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794069307; x=1794674107;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=t9lxvGsvnVKAYbZJhO8MAWe0ocVncbdFnsrj+9efmqA=;
        b=OvjruJI7RriXRmnWsCnFv7SMJudFMNfUnHmI2UzAQusMn9RivjVE/V96+tRVTyht6J
         TDwb1KjsxkrFRN37QDhPzdPO91m0q7uoSeSG3H9n9Ja6t4Ub8IEJrjLfWVwvFpobWmn6
         93IfHcPwMFuqyJKIjQZ4D8wbftemEU+GOVK7Ry+mKq9TcSKRY4A34v6peX/T4WFyL4m4
         U+nfpNib+aIywcapX895iUYnZtfhyKrDNJEXuOeO2/wAZd3iwV01XHgOr6kKuP7nen9G
         Pj7Pzif7uJFBz7BO9OIm8rlo2I3K96to56wiK1Ajkv3SnCTIYxosJV4oz77fy8Sg5QEz
         73Kw==
X-Forwarded-Encrypted: i=1; AL+hErGHRXtIeiBwDr7+zXCmNDQjIRMHtbJNfrXx2efWPX5j/vkq7JGjqB9eLC3iMOLb6AaoT/Sf6Zh+M0Us@vger.kernel.org
X-Gm-Message-State: APuU4Z+w1ZNVkQ3JInN2EwUfUAilz5mCZGmZqbIXB2cDR8092NeJvAyi
	3NAizgglhiJ3msR5T7H+x5FmqfCG6GZ7/hdbR2Hr6H05pjoPi1Ew1/AjQsJe3kQv7VQ=
X-Gm-Gg: AYBFou37y5X+n4rVf1NTxVHlAVEtjaM9oiZoTtQ6EPP1/4YbZeQ+Gc4gU8whFdMS3Hl
	gfpsSyaPUqUubO1oTDyClmz4FU+r8gTp/0Tb1VPDNligJNXtb+hbedxoFi8GK12ch/cqQYTUxuX
	l2+vjBox2fm9I62N9uZLs7wYzFCXmYGcyGunmhXfjfuBfMYES5Rrqd5qPpmw7vRjPCAFkJyr5Vt
	ZNtp2jdkOqHNsr1tCwBPHkOvgC4HozhRQLDtG0uU9+tO5DeYK9KTfjtUgymwjUZOi+MyvkfCT1o
	zOZVBum9MX6j6H//6dgItWJNcUkGzT24VHKx6ogFGKzjgq/7LBrRGww3I4Jq3O4YQV5or6XuBjk
	o6ibM0DfCwloJiSGj+RMPIpQJg+yut6p9BQw1++kK0y1/kpRzOZ3nhnMnC1F72Boj/3fDbR7EOw
	fmYcVpz1buG/h1F5ZvC4R2lYw8QeWcvUlaviSFk/KR6wygU260p9oMtF+ntbMzM2FXtQa4qIPN3
	6t8MytBZo9lwh1E/dNHKaS4jNUr4OqNbx2pbofe3vAzf0lg6JLZEZHvDZ6HccvmTtP5DACgsxGY
	zetV1mHyEPkNkClPr/ip5tHpvLp1e3ZawOQFKM8WS3L2G6F9mgIpI41brOCsnLSQ7RXVJPYih1R
	kn13WlTdp/6EC7LwDYGcIEwSCmMsyoGMrKYxYWz5YhaVBgaIEZ6LB3okLcbGvKB8cDVvFomtwfE
	CW5bZxmbbmqnejRI4v4DszSP92Z/2TaipLH515q0ZvUGv9kETT0PAijg==
X-Received: by 2002:a17:90b:5107:b0:3ad:8a14:bc73 with SMTP id 98e67ed59e1d1-3b0db6e8f4fmr5544638a91.50.1794069306903;
        Sat, 07 Nov 2026 08:35:06 -0800 (PST)
Received: from localhost ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1058a80a1sm3974994a91.12.2026.11.07.08.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 08:35:06 -0800 (PST)
Date: Sat, 7 Nov 2026 08:35:05 -0800
From: Chris Down <chris@chrisdown.name>
To: "Martin K. Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH 0/2] scsi: sd: Fix WRITE SAME(10) data corruption
Message-ID: <cover.1794069087.git.chris@chrisdown.name>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)

With scsi_debug and 512-byte logical blocks, a 1 MiB discard at 2 TiB
succeeds, but it's the first MiB of the disk that gets discarded. This
happens because the starting LBA wraps to zero, because it doesn't fit
in WRITE SAME(10).

Write zeroes can also run out of bits for the block count. With a
0x20000-block WRITE SAME limit, a 64 MiB hole punch sends a count of
zero and leaves the whole range as it was.

Let's use plain WRITE SAME(16) for write zeroes when the LBA or count
won't fit in WRITE SAME(10). For discard, we can just refuse the request
and leave the data alone.

Chris Down (2):
  scsi: sd: Fix data corruption in WRITE SAME(10) write zeroes
  scsi: sd: Fix data corruption in WRITE SAME(10) discards

 drivers/scsi/sd.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)


base-commit: 04feb5fd2c23894ebc2cdaf4a4cc38b8667b17ac
-- 
2.54.0

