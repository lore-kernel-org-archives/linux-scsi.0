Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8277080600;
	Fri, 31 May 2024 06:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717138106; cv=none; b=olkm1pefxmzKPPygopKvEbnSThbgnX+/s+L1FFWgIuDZ3VBvIdmbfTArX8BTiLr78c8mWivlm5dtn9w9vAEVO8jNrnPlwDxOqBOweoRyuRdXrwSbhzkNrJfiGD3nOpT086WnNrtOtFn/qZji6q1usoRJcVfSqbhTrsKw84Vm9m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717138106; c=relaxed/simple;
	bh=B4sCqlGaqOguyZ7JxZXcbNgsvJq1unOM9UwjV0Rv4M4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QSx3RxkgprMUZq2kL2cq6aRUPmJ84+B1ojmQmvFTpCRX4YD0gwZt13vg3jUZr5siBl7WW8i7CFxuaniflnWkqi97OYU7V2DOT649pevWsIJDxtnvFNQ2yDxDrcQ9WofbGxI8V7prssu20S9qa/ty9R/m4CHIf5oso1jaYuLtdgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GKw2JnUR; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GKw2JnUR"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-5b970e90ab8so1030274eaf.3;
        Thu, 30 May 2024 23:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717138104; x=1717742904; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UHfXsuY+pdYsu6JkPOmIMiIuAZ41w4yugEvYSYmSsZg=;
        b=GKw2JnUR4Rc87vtTebwXnwZScGA/k7nUM8d6wP/5PHNjakC508NwrVcsvUuavGMvNY
         d8mowvHO2wm+UrripD/I8v/vQwfLJBF29kaj/iCnL/yP8P9M0G4yP4u6d+fCiHT0UgRP
         YQmMhStV8YZF3nQ6rbFG8Qol7SfLwm5hMRVGKiWVKNfLfQBTQT9321fwpz7xiZANCwjz
         5u8WAIDDHr30Cc6TlsoQHAOBrjWvmzlJtOrQg6JWPTZaZMIcgvo+T04Rxmw1FA91rs7f
         rEGecgjTNEo9X1tAcwGntHIaNALcqSFLyxqRI4bLJrQYx5yinwbtB80EzhXh4GP5f2lm
         8AtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717138104; x=1717742904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UHfXsuY+pdYsu6JkPOmIMiIuAZ41w4yugEvYSYmSsZg=;
        b=pdBqE0wlzH0BhGukRkQWcd9miAgJE6qAxPou58cf8yZXn6AHPns1uI7wtskV7ZhMhL
         86Jcwv2MTtm7Rphn8DP/cezvasasLmdjAEiceQF0dw+HsKtyCDQFBp1j1tb4g34crwLX
         wJM8yTBfq89RNaa+yNpDF53LnY9gkF9AMIkrAc0E0MK9Nsqd+l2xXtNFv51xTB2NbUZJ
         Jdye4f40Duw0tcU1kSrmRvr7dqAuYOX6l1CWNZXlvqRSk46eLRLeMcwSTms2G9hgV/7i
         v55LUlk7ANTbri6RbtJwnsy5WqQKe4AKY+4qXQn/Jvr0K4bchM1UhobADSOlg85ioY5A
         cb+g==
X-Forwarded-Encrypted: i=1; AJvYcCXjz038/Y9EAqt4NHEu2NoDwetXhoyS/zwwiOXaZBcTpTIc5fV1gfHrMxyPsCuCcJ3iUhoo2u39OhM6oXHC6q/iQp/WSLVytTeZ+kmNUA3veYDc+eTawhbqunAiOl8xWqE3MOB8adGQsltbwp6bpKqhb1XZPCN+1JUr/xSC6Zf+mGscVA==
X-Gm-Message-State: AOJu0Yy6RbHmDd70C1bopknmreYrXIZSy8eHAfLF2JLTrLFzcOOZRE4F
	dhTZOLUlr+xi44p3ISAIyHlJyyo3y3BPICPVmUC9UOatUkHOgnoj2AXxQEQZr/4faDPJ6SyH2TZ
	6FaQ3K2xzaRuM80dGOKUAlsCiGjY=
X-Google-Smtp-Source: AGHT+IEkgVU5yVpc+xeOYwUOJd29bp6vThPd4yP1XUDfgboWzFw/FVhH/FxeC96crk9g7iXBffgH6P0YPBoJ35FyjnE=
X-Received: by 2002:a05:6820:151a:b0:5b9:70f8:4b82 with SMTP id
 006d021491bc7-5ba05e1f5a1mr1238669eaf.9.1717138104409; Thu, 30 May 2024
 23:48:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240529050507.1392041-1-hch@lst.de> <20240529050507.1392041-3-hch@lst.de>
 <CAOi1vP-F0FO4WTnrEt7FC-uu2C8NTbejvJQQGdZqT475c2G1jA@mail.gmail.com> <20240531055456.GC17396@lst.de>
In-Reply-To: <20240531055456.GC17396@lst.de>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 31 May 2024 08:48:12 +0200
Message-ID: <CAOi1vP-VXeOH-kShRKv-b=id1zN9tLiqOo8EKpOWoJuQp_Pm1g@mail.gmail.com>
Subject: Re: [PATCH 02/12] block: take io_opt and io_min into account for max_sectors
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Josef Bacik <josef@toxicpanda.com>, 
	Dongsheng Yang <dongsheng.yang@easystack.cn>, "Roger Pau Monn??" <roger.pau@citrix.com>, 
	linux-um@lists.infradead.org, linux-block@vger.kernel.org, 
	nbd@other.debian.org, ceph-devel@vger.kernel.org, 
	xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 7:54=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> On Thu, May 30, 2024 at 09:48:06PM +0200, Ilya Dryomov wrote:
> > For rbd, this change effectively lowers max_sectors from 4M to 64K or
> > less and that is definitely not desirable.  From previous interactions
> > with users we want max_sectors to match max_hw_sectors -- this has come
> > up a quite a few times over the years.  Some people just aren't aware
> > of the soft cap and the fact that it's adjustable and get frustrated
> > over the time poured into debugging their iostat numbers for workloads
> > that can send object (set) size I/Os.
> >
> > Looking at the git history, we lowered io_opt from objset_bytes to
> > opts->alloc_size in commit [1], but I guess io_opt was lowered just
> > along for the ride.  What that commit was concerned with is really
> > discard_granularity and to a smaller extent io_min.
> >
> > How much difference does io_opt make in the real world?  If what rbd
> > does stands in the way of a tree-wide cleanup, I would much rather bump
> > io_opt back to objset_bytes (i.e. what max_user_sectors is currently
> > set to).
>
> The only existing in-kernel usage is to set the readahead size.
> Based on your comments I seems like we should revert io_opt to
> objset to ->alloc_size in a prep patch?

We should revert io_opt from opts->alloc_size to objset_bytes (I think
it's what you meant to say but typoed).

How do you want to handle it?  I can put together a patch, send it to
ceph-devel and it will be picked by linux-next sometime next week.  Then
this patch would grow a contextual conflict and the description would
need to be updated to not mention a behavior change for rbd anymore.

Thanks,

                Ilya
