Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCFB21773D
	for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 17:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769362947; cv=none; b=PKY7t10mI6zHUisIm8e2h63w5dYLkLgd9K4JyQx6m4AD9JGNvbQSWTc0WHrYJ0Vjrjtlq6lwVVKYUVF/2Ufp2aBqcjp8ucxGXhyhWA1JhI/WNCihzzocb6XsCWOh6QPCk9+jjVu/x8j3bZJPH8QTq/1Q8oXnwPoH0j9Stp9kuvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769362947; c=relaxed/simple;
	bh=tAnr2wEDJgbaWlnCQS5U3DCTk6zhmdLXdf8l1M4keUo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WFF7OVnpUswF3mttNEmydMsQNpkgpJUfn45hnoObPPWEpLkDeLdpuQ8G38ti94lYudl2WmxjYhQGacfa81SywoXfk1HYBAxqscK3teqVVBfKpvcy6NRUcQgjpFmAi9yvu7ozgpDo0t7TXFJLGSEHSVW64RLv/VoVLTpqlol16Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BsRe9Bi9; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BsRe9Bi9"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so637662466b.2
        for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 09:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1769362944; x=1769967744; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5DCteMoE4PHKDKHbyMWRU+nbB0TDuiBsnexXnbb7daM=;
        b=BsRe9Bi9H7Oim9IwDjDsz06wXWPTs8rRZ5D61SM6eSbn4o+cn6RCr6BOkJzBjhKFzM
         auCxSEtAu75lGRsJorIU9p5sVbMmv6WSTGhQB+UY+xGY5hRK/liSk+GHlSNxpSt8ktHj
         QKm3FEwDM3wXdRIHMuCj02V5DfUQM+qoJ+o1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769362944; x=1769967744;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5DCteMoE4PHKDKHbyMWRU+nbB0TDuiBsnexXnbb7daM=;
        b=XW0zblNtb1IrkBvpbrhhJKejRh3zfXkVTMX483w0vmZZ4D8y/On9WWtqIpeRunpsv7
         mS8i/Mb8zOXJxs7qaj3kDwXdkmfsZeT6KrqjR7pewF2Mvc+JkNCmRYmoCdTsIm/7YaQr
         w4M1GB0/diHPAdYJ7fnnWwx+ECKkgNBc7K3tEmewqy0wrTuaJGWiKbn79paQnHNyI//e
         x47e7+GnSqZ2/8CCj5B/tsiSHrX5hfoq/EEU4/agZkcbobCTzKlmEGbx07Wo/OR5ohmS
         9tOnR/m4nyGpqDP9xQSS3ssY02XfceBnD9C/b1rFKgcfr/NKKBL8cfYkF9M0KChMBhgX
         75Yg==
X-Forwarded-Encrypted: i=1; AJvYcCWj8V3LX9w7Ws4BhLSfUde7P7KHnIqu0HNobFgdOzfRsubRQq3tB824gshqkQoOz5vxUFose6vTy/Z8@vger.kernel.org
X-Gm-Message-State: AOJu0YxTK3SxNPK4l7O0RyGrGwxXx/FoWHCkSII05Nyqez6Rl32WKwoU
	OMaD0z1roPRxZC78+vS5T8N5XKrorbpdPtOUsaeGQSle0PnFIlLEEx9ji9qHdcv+mvak9iwYhMR
	O6Gr1XPIQcQ==
X-Gm-Gg: AZuq6aI0UxEgEgpzg6Jovk7tP3MQmEDet2Da5WjCPbwAT5Y7yJUkcVxYX20SNYl5AlB
	Yt2FnqOHZd37rTo+NrB1Y6nuLkTTHtqIssEiEjVcqvmgR7KK21oV3UW+5ZL00YfyfR895ZwwnBT
	vke9wFxspdIl+KTxuiP+L27X3IZ3EmZZelmq/vAYL24BNBi5SNjAY2h3WfomD3OyeWsKTLRSnE8
	PMjy+EHphR9IY7+QUSzCJMrApfEAPTsDbapgyKQBb8ogLzP/URwq80RYCm4ERTsI64czaVkHTJT
	yc6ZcqjbZEsJWJ14lxljUXPuedegXFxqpWAjqkYG4C/Rk7eAGKC0ATWABkjdLU9c4Y2FztoVaXV
	lUbroB9NEbwDs2gIBZfEonJ0FRoCADCyJGsOUHiZUqTxF3xqJVgpIvBc6AdJHCaalIxt7gW+8cl
	DjIMnm1C95bNOmlXlhaxtJMMOQb9/acdtnNbY0kyarCJ1napvdMH0NeKl89pFF
X-Received: by 2002:a17:907:3f8c:b0:b8a:f3c0:c09 with SMTP id a640c23a62f3a-b8d2e888832mr180546566b.59.1769362944230;
        Sun, 25 Jan 2026 09:42:24 -0800 (PST)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b885b419288sm494330466b.20.2026.01.25.09.42.23
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Jan 2026 09:42:24 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b8d7f22d405so15211466b.0
        for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 09:42:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWj0M69o9zSe1kYOdU7gl1B7xtVJxP+eYTPczzNnKiBZIak/AFaCgSivLT6sCTJLHpwrT19I9evVvkj@vger.kernel.org
X-Received: by 2002:a17:907:60d0:b0:b87:368a:2bf7 with SMTP id
 a640c23a62f3a-b8d20b4f2cdmr187467566b.13.1769362943380; Sun, 25 Jan 2026
 09:42:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1a20127d291b660d4f85bb85c1dacc67c228c368.camel@HansenPartnership.com>
In-Reply-To: <1a20127d291b660d4f85bb85c1dacc67c228c368.camel@HansenPartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 25 Jan 2026 09:42:07 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg+4HjC5+qo_dKoyCt=TmVuUQqpWGAHMcRv6KKnv64v=Q@mail.gmail.com>
X-Gm-Features: AZwV_QgA3FSudOgPV_xTFJwy4sJg_3DodD2t1qeIC8gW_8LM-LqkxTfOW77ENgo
Message-ID: <CAHk-=wg+4HjC5+qo_dKoyCt=TmVuUQqpWGAHMcRv6KKnv64v=Q@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 6.19-rc6
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 24 Jan 2026 at 20:14, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> The patch is available here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

Nothing there. Forgot to push?

              Linus
