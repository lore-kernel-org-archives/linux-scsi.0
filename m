Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCA71B78F3
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792023603; cv=none; b=iwLpcza300PIdBPLlsbpJzFS/isczke9AOgzU0o9BnNUJPBb2PIx7D/gv9NEEInFbDxk+yOP5bQ6gHFPR7TKh8xR+MHYNTFfcpaqJdsbNNqcHgvqOREEEAvXxhx2nKo7TikvjY3HizYvZ/fcQr6GfF+KjjvXscK5DwmNCDyJ9Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792023603; c=relaxed/simple;
	bh=hT9C8KpbWvhuKNsWMFmwkxNYGUnSTIDYXUV4/uXNbho=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lWWUwXW5AN5y46HIG86xgf65W2WrAghny/BHVhMC8PullN534oAIcd4e8X22WaNb4lWREP3kGjRtCLTI0RxPfTwA3EYLIrEaJ1Co/wFLMNFBgd3GlF2jwIjSwC33KGOvF8oEVvmXX6xJRz3sIrBgiIMtq2QgZ5SGmymeesDReBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eF64rZKq; arc=none smtp.client-ip=209.85.216.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eF64rZKq"
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3a470ead068so5378015a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792023601; x=1792628401; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c63/iXJr8hVZch+xmWANZyQNFENMpYcROr3AAHKmacE=;
        b=eF64rZKqiBB1tAQasG7iSWR5w7CFmUFF76Y2xi/uiyrmcvazPjvVoqO2JH6dPsTFAv
         9Fp09Ev/1pgWxUjG3fqW4KybzZp7tckWpGfp3kIHhOS6wmELUfKN+RjvhLxzzLoXGion
         B4Ay6VuOmuOryQaz4qM9FLpDwpvQLGBWW2tTNuwMJOdGBOkWW676Fl777MsE4oNpzBjI
         LZZzoWZ092iYtym07V3I7zjxH20rYJrYi1vJFd9VsRCaKNsPC8vgVtObyi1Epi1a1qPN
         HJExF5rf+y6dmPy9pNx1BotHhSRFptQrjH6QGp5egyZZQmFFR30P10f7F5Pgcm9hADzy
         vGxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792023601; x=1792628401;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c63/iXJr8hVZch+xmWANZyQNFENMpYcROr3AAHKmacE=;
        b=CdqxnJ+ajbwyKFRvonB1vDMb5K88I4XobUZ3SIiC8d3NimlDwj4bp+PW8fei0ykHQ2
         0IPA1OSl5YPUs0tn8LeOuS2wjg9B7iV2Z/BP7f4Tv6H5TJWB2jncxXDrYgjM4Wrfyf5B
         TlX/inKjlojpxAgar3pEHxPhDeu2H7GvY9cmCU8Tf7Ww2QEt8dZVlDhggE/+BDNrJ6v3
         eOxCvTgVJdJL+HuAIQjmcmi3Qg6Bvueb7Lpu+O55Vx/rULMnKovzM/Cy4pTRuEpB88mT
         ZP2Fim/xC5esuK3VDHiYsbtnvju2VFfxxssOIECbST5thMeSr0wgb7eafEan7+L/mF0p
         jEIQ==
X-Forwarded-Encrypted: i=1; AKwUvBxobiBDKKDEll/buVblwmgmxyRwS17Be6eAdPYKA4oGwM1zarD4BrIHoFX3OaTL3rXeAM0kRv/6ik3I@vger.kernel.org
X-Gm-Message-State: AFq9FYIOPLFMMOJDi/2MXvOtL5YAvxHFuY+q7CWKXXcoOWkukihdoe4n
	w69Uvq3rrj+UWdfhesKI2snvkIDu7mmGGhv5qJPGts/FE1r/jQeOrj1MFgqIPF3U/LsU9G6oMPm
	7QGz84ZvL4Qc8GDfkpgjgow==
X-Received: from pgdo18-n2.prod.google.com ([2002:a05:6a02:6212:20b0:cc7:b455:d1fe])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2ec3:b0:3a8:240e:b493 with SMTP id 98e67ed59e1d1-3ab3acf5c6amr14581156a91.45.1792023601145;
 Wed, 14 Oct 2026 17:20:01 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:19:59 +0800
In-Reply-To: <sashiko-outbox-169843@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <sashiko-outbox-169843@kernel.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015001959.3452983-1-stanleyjhu@google.com>
Subject: Re: [PATCH] scsi: bsg: Pass reply_len to bsg_setup_queue() to fit UFS
 ARPMB replies
From: Stanley Jhu <stanleyjhu@google.com>
To: Jens Axboe <axboe@kernel.dk>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>, Bart Van Assche <bvanassche@acm.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, 
	Mike Christie <michael.christie@oracle.com>, Bean Huo <beanhuo@micron.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, 
	mpi3mr-linuxdrv.pdl@broadcom.com, open-iscsi@googlegroups.com, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 13, 2026 at 01:39:40PM +0000, sashiko-bot@kernel.org wrote:
> Since job->result is 0, this check is bypassed and the full bset->reply_len
> bytes of the uninitialized or recycled job->reply buffer will be copied to
> user space. For UFS Advanced RPMB, this could leak up to 104 bytes of the
> previous request's data.
>
> Should the reply buffer be cleared when initializing the job, or should
> job->result be explicitly set on all error paths?

This is pre-existing in ufs_bsg_request() and not tied to the new reply
length; the same happens today with the 96-byte buffer. The other BSG
transports complete the job via bsg_job_done() on error.

Both points are fixed in the UFS BSG series v2:
- 1/5 completes failed jobs via bsg_job_done(), so job->result carries
  the error.
- 2/5 clears the reply buffer on entry to ufs_bsg_request().

https://lore.kernel.org/all/20261015001855.3450573-1-stanleyjhu@google.com/
