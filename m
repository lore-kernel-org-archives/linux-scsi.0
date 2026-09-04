Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7804035B62C
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 01:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485430; cv=pass; b=BAP2TAUPHvLmu9ECtv/MdnulI1n+OGsFZ8nVPAMpKcTM24CmUH8n9BGo7bH/3MMbTJgYcczi6A9L4oJZgStXThN9ql+ZLEja6iCy5uXJYvTVjXjG1fSywAP8AWyc//o4LqbCZcVx6VAkhamZjNu1DKMIQU617cVM7qo0LZkynhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485430; c=relaxed/simple;
	bh=SYDvkh8Gqu4VGwUGF72ItVZ97u41+W0b2kbxS8TvHkA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IgHsSh4uLA9QU1yCmdEJT9TJchghDAegF+MA3aJRoUAHxU7jxVyezEDAyc9NyhIjwimjGzGlFUaHOq0gdQSx1SX+nPIZUDs4vu7aJIaDX6qT7GVZJyRQmuKYER/orH+HlxbURxRagJTGF8AIswFyZQ8GO/REo3BArIseKZnPaPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MtfhBwNw; arc=pass smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MtfhBwNw"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a6141a61c0so2746a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2026 18:30:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788485427; cv=none;
        d=google.com; s=arc-20260327;
        b=EaHy05A7IIKsDYUWwScklfdN7jpuoQeMbc8bG13OC3RCWs0SK4ZxWEoZnB+Xb0+NSP
         O3Ih8oaxOmCjSdgGQgHW/ygdPY1PmHDn6nTipIhWfsB/kIrsn5lDu3pArliumNR1ZHq1
         +ggEa1aDkxhcpWY7cyiIHVtE0PKdtN5WjU6DlqWMTx/nc1xlJSMembGE7wkBQz3OUC8q
         4RiRXtIerUsOAQB4cYx16qCEt8tKN+vbCKNGm0zOWzaKxOs50bVm79PFBnLVufW1yysK
         xCN16d7STx1LsH9iLqcKrs697EJFV06jPnXYeWCxEaU3yqo+t1b2JsuM3xUROXoQq11x
         P13g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SYDvkh8Gqu4VGwUGF72ItVZ97u41+W0b2kbxS8TvHkA=;
        fh=4dLkm9M0Dvm05KxKmF/ZJxLtnZzRW2jDVNaeiblfIMs=;
        b=ndq4Ijw/0iRgSl3B1Co2e5La7FlX1VL2ph+4OSF6yQfXxIRmo2GRzCndInTHWlLvZS
         q8zYR4IvI/54s+55MS8v6hpIySodUXsFrAzGoqF8qnVMg7bT4n/0DuISqIC21OvzqQN2
         kuo7OUhcwzRBEW6T7Vegn/7r8gs+SpS+jwrFT/RONvWE58MCgF9YUEKsa/0JXbs5x6QC
         UIhThS6SvG+Ubg0wvHtuOoaSjKAMAOLlCKd/iA7M0g65M5x48/+I7OLZUYQVRGvWKMgE
         zSsU9kJGwgFWxPLruA7IAlvIQBaWuh0BkLj5tEqQQzN1H9kMuQX3JyalzHQMb8rwAv3s
         +2dg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788485427; x=1789090227; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SYDvkh8Gqu4VGwUGF72ItVZ97u41+W0b2kbxS8TvHkA=;
        b=MtfhBwNwaCmP8XDB4GsmJPDTGt9G4tUlQYhGcCZ1xj8Htm7Y2ex6sp+ShcjBHwfaIi
         16Mrrxej+thURnxSf6CeOXVqSeWXGJo4TAjsC1SKZLZVMFfipRIpk+mXWdy0Ro3530bS
         JoNHGrirrSwrGReEJIlcjOz20N3o7V+BNPoVDlv8SSq88DoAM7lytMYwJ4PQ7aC1z3I/
         AvKMJ1426IXCK+o3+PV0GZYB5E0+lxiYRicRzt5VgzNAXpwGsgWQQ1EdScUu94LD7vbp
         boUbC0tRfKtiN+Nj1qahH90k3t1pr9VcPNqKzOMKigGjjiqObbN0qQD7cVIa113N3AcC
         SYiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788485427; x=1789090227;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SYDvkh8Gqu4VGwUGF72ItVZ97u41+W0b2kbxS8TvHkA=;
        b=hD/XeqAWaeT3lFYKstuuEL1zWqsguFUlzuc/jFqeYgyrJguXjk1KBbqpyKQMnOmijd
         +VtsrtulPFVtV8uker5bNNpsUkGdr82A02LrgVyWITO5UGEx8guERR/dMX7nHLjB1vxS
         NwL46KLO7r6ZImEdZESUSST31x9sVSBPU1IbHknXyJ410MMSF2Kb6fWk1d62i68C7bru
         EK9MiK8adlkj3W7WG6wIbqr4uFm+le4eO3Eip9NkJGwhqHLZKQi9nvYbvZgo/GBSE8H1
         Gd8rrYGgYFxa3b8gLA6JAQZphrejbawJTg7aOnAZdwuiHu8W62QrNT+xwpMqX8cMTK5U
         tqzg==
X-Forwarded-Encrypted: i=1; AKwUvBwL+Q/qTirMMf1nrUJPfjGkoM3EaxCEbYZ6PpmBCBHJKL9dC/8okSlEAKGdtE85LVLMg4XHBJMYLG2m@vger.kernel.org
X-Gm-Message-State: AFuF++mCGkLi/MjF7VhAFETVX+t2iM2KjkAOCVWlEEZjYgeAyCIJwmo8
	/2OeMW/kQJa4D231/FAbCrrdi4x11wygGrdhV3C74jg0k2YB+7rpqMGztUqaFhelL9da9l87GUZ
	wA2Rj6QzlvRz8eCj6yiTdJQy4cfCPwntiaorKR1Bc
X-Gm-Gg: AYBFou15sMDs+F+LeD00YThhxLnwxorkln7J3L51bKm9GzA02xRa/9x9DouRX407uTc
	68Q47BDCwfXfMTs9s7lS6vQf9FnVjzkgUgWkK+bF9opjamqvB6BKvLf83wCNaCMZGCB+JOAgBed
	5/1al5a90cdJQ6z67/o6EISNbFhE6PabfPXSgsliW1V5sRL1ymSabQcYdCpdUyFWfkRQUZOzEDL
	HTuN34QzHp1dhCdosP+hKXtroOsBaju9Moa5rOIvRoYQ3PH0i85f9isSCcBvuqtCu8WeNFU5u38
	xLt4UVevXFJnupoc3bfV2jWgyTjxhKUdBKt3aGmTIug=
X-Received: by 2002:a05:6402:1154:b0:6a6:76c7:65d0 with SMTP id
 4fb4d7f45d1cf-6a7e9dc0cedmr7971a12.5.1788485426203; Thu, 03 Sep 2026 18:30:26
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831130129.3979454-1-beanhuo@iokpp.de> <20260831130129.3979454-4-beanhuo@iokpp.de>
 <CAE14pddCf1VhLVC_H-Nv30C4BzK_UO4Eknd27g72d1nAjdBdpA@mail.gmail.com> <f1e59607ab2f5554993dacf21947024e41278058.camel@iokpp.de>
In-Reply-To: <f1e59607ab2f5554993dacf21947024e41278058.camel@iokpp.de>
From: Stanley Jhu <stanleyjhu@google.com>
Date: Fri, 4 Sep 2026 09:29:46 +0800
X-Gm-Features: AcwNN1WqpKQ9dvQE183nH8HsNdiEUkNRgZ_8L4LRNHHVTD2yt5OLSz9J4XIN8jY
Message-ID: <CAE14pdffhBju7fdez5Aewzz-rBCoRWDuCZJrOej9iJrFCR5+HA@mail.gmail.com>
Subject: Re: [PATCH 3/3] scsi: ufs: core: Report the current clock frequency
 to devfreq
To: Bean Huo <beanhuo@iokpp.de>, Stanley Jhu <stanleyjhu@google.com>, 
	MyungJoo Ham <myungjoo.ham@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, 
	Chanwoo Choi <cw00.choi@samsung.com>, "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bart Van Assche <bvanassche@acm.org>, Jie Zhan <zhanjie9@hisilicon.com>, 
	Krzysztof Kozlowski <krzk@kernel.org>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Bean Huo <beanhuo@micron.com>
Content-Type: text/plain; charset="UTF-8"

Thanks for digging into this, Bean.

> That holds up the queue for up to a second only to set the same OPP and the same
> gear again. This happens today, without my patch.

In Non-OPP mode (!use_pm_opp), devfreq_profile.initial_freq also needs to be
initialized to clki->max_freq. Otherwise, devfreq->previous_freq remains 0 and
devfreq_update_status() drops the initial time_in_state accounting.

Thanks,
Stanley Jhu
