Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A783B19AF
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 23:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790724932; cv=none; b=PH1oh+ITnBksCUp1JEGAgXQHhdQiFQccQXwEVtZCZ8gvyMA/gfTh07snt4eogbVFLYh8FPrTHVAwn1U8CFAVwyDoeWYjk9S2zc4Z96xtf79TXxozX0beIB2mYzdTa3iXBAB3eX/leO1AyUBbFNWZHjg0SSE5luAL60PT48DCIkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790724932; c=relaxed/simple;
	bh=z/XfLnxSAIgKcJ6tsiWUwvmRl31g0g13SA0bYLysuBU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=punukxzgJcklfffNdGE0tok3NCMS+e6yKVtyaxF8WPGmwK1tts2ReuVRC0eKyQjm3B8Z2e91Chety55gms7hSb051fMmFW7M5FEJZkjcIb96aDvEGYT2Ww+B+VzHqyFkcznCOkMuIadMxVhDF1Ni46vP4N1oohOzYp9VJ8pp1uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=htiGCpa7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="htiGCpa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD061F000FF;
	Tue, 29 Sep 2026 23:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790724930;
	bh=IhENTVjlNjCKlkpBUKaoMsp6SPDCxWUp8dgSwNSW67s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=htiGCpa7tzHDOFwKbXSozyk2Y0cIyfxl5+C8t0p4rCJl66odhJxSSjlmul+qk0okC
	 UBaKq9KAz9zqUU1il5JVAyYIvV6l9tPGgC7FhGC+HusMqvGyr2s/3CTUm8QJbEYiEJ
	 0nKoMlObcUiJwLvdiMzieKImoZAE0wbSXY0Tc2KwHYXz7+VrMrwIjcJ0o6XxBH+UST
	 x8sKRhQ15+cU0Em/E8wo18FMpUWmkSSkSOffKaJHvhAyw0rrqRKMVJ95/XxGRQuQGP
	 ia3zaxwt+3hv53yXCnsQQ3yhlvL3ej/ECh04BJmcY7C6iQ+gXjHyHUJlnv4B5DRWch
	 O+Y+1fbkRe+QA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 6/7] scsi: scsi_debug: Improve lock context
 annotations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <c0546935640ceffd1b0513753dd469833e767c5e.1790723966.git.bvanassche@acm.org>
References: <cover.1790723966.git.bvanassche@acm.org>
 <c0546935640ceffd1b0513753dd469833e767c5e.1790723966.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 23:35:30 +0000
Message-Id: <20260929233530.7CD061F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] scsi_debug: unconditional exclusive lock annotation for conditional=
 lock
- [Low] scsi_debug: omitted fallback lock tracking in lock annotations
--

commit 2f1a5cf89b239b8a5043e8baea7eb6d404bcc911
Author: Bart Van Assche <bvanassche@acm.org>

scsi: scsi_debug: Improve lock context annotations

This commit prepares the scsi_debug driver for enabling compiler-based lock
context analysis. It annotates lock and unlock helper functions with
acquires and releases macros while removing sparse acquire/release calls
that mislead the analyzer.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 44840ba0c5b58..a6cd958855411 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c

[ ... ]

> @@ -4155,6 +4163,8 @@ sdeb_data_sector_write_unlock(struct sdeb_store_inf=
o *sip)
> =20
>  static inline void
>  sdeb_data_lock(struct sdeb_store_info *sip, bool atomic)
> +	__acquires(&sip->macc_data_lck)
> +	__context_unsafe(/*conditional locking*/)
>  {
>  	if (atomic)
>  		sdeb_data_write_lock(sip);
>  	else
>  		sdeb_data_read_lock(sip);
>  }

[Severity: Low]
Does unconditionally declaring an exclusive lock capability here cause=20
incorrect compile-time static analysis tracking?=20

When atomic is false, sdeb_data_read_lock() is called which acquires a=20
shared lock, but the __acquires() annotation marks it as exclusively=20
locked. Could this suppress valid compile-time warnings for data races=20
by tracking shared locks as exclusive?

[ ... ]

>  /* Allow many reads but only 1x write per sector */
>  static inline void
>  sdeb_data_sector_lock(struct sdeb_store_info *sip, bool do_write)
> +	__acquires(&sip->macc_sector_lck)
> +	__context_unsafe(/*conditional locking*/)
>  {
>  	if (do_write)
>  		sdeb_data_sector_write_lock(sip);
>  	else
>  		sdeb_data_sector_read_lock(sip);
>  }

[Severity: Low]
Similar to sdeb_data_lock() above, does this annotation incorrectly track
a shared lock as an exclusive lock when do_write is false?

[ ... ]

>  static inline void
>  sdeb_meta_read_lock(struct sdeb_store_info *sip)
> +	__acquires_shared(&sip->macc_meta_lck)
> +	__context_unsafe(/*conditional locking*/)
>  {
> -	if (sdebug_no_rwlock) {
> -		if (sip)
> -			__acquire(&sip->macc_meta_lck);
> -		else
> -			__acquire(&sdeb_fake_rw_lck);
> -	} else {
> +	if (!sdebug_no_rwlock) {
>  		if (sip)
>  			read_lock(&sip->macc_meta_lck);
>  		else
>  			read_lock(&sdeb_fake_rw_lck);

[Severity: Low]
Does the annotation completely omit tracking for the fallback=20
sdeb_fake_rw_lck?

If sip is NULL, the lock tracking seems to fall back to a dummy=20
capability rather than the actual sdeb_fake_rw_lck. Could this=20
prevent the analyzer from properly tracking accesses to data=20
protected by the fallback lock?

[ ... ]

>  static inline void
>  sdeb_meta_write_lock(struct sdeb_store_info *sip)
> +	__acquires(&sip->macc_meta_lck)
> +	__context_unsafe(/*conditional locking*/)
>  {
> -	if (sdebug_no_rwlock) {
> -		if (sip)
> -			__acquire(&sip->macc_meta_lck);
> -		else
> -			__acquire(&sdeb_fake_rw_lck);
> -	} else {
> +	if (!sdebug_no_rwlock) {
>  		if (sip)
>  			write_lock(&sip->macc_meta_lck);
>  		else
>  			write_lock(&sdeb_fake_rw_lck);

[Severity: Low]
Does this also omit tracking for the sdeb_fake_rw_lck when sip is NULL?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790723966.gi=
t.bvanassche@acm.org?part=3D6
