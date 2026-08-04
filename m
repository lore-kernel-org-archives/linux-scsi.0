Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C496030C606
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 09:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785835050; cv=pass; b=ZMVOmnR7zJedBUV2/ma2h6FTWLx6F9ZIwqem/A0UtHH+N1BXT8QtHVkRnTOexlsUyoA/8KaTi4frsPV8ZmcWwh+N8Ah5AP/BBUcQ37ZrO5yy07YrMOzjiuWwv6/D/5GcXAgtcckgxUwlvjnZSXHrT4tipRRy2Jm3a2Z24f0lfpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785835050; c=relaxed/simple;
	bh=ccCJjqxba/8aXTpy73PIvAut0TSt/5cZ3HOgSBePs0M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X0ShJv4MEUAyeisK17QkEI8W6+MBPho+GxLR2DD+vlo9tSrPuL8OIpx5qJ1diaj9zvJl8iHa1prueQYHdZXM/ACF/tbEoS+1BuH7lZt6ttZeA2dRK0cEAAvNT4nwgzn2NLPZ8SIJc6WiMG3naFo+otRKyKBX5ERU2ZoUCtgL3r4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I8144Lr9; arc=pass smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I8144Lr9"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-382ef647e20so4557205a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2026 02:17:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785835048; cv=none;
        d=google.com; s=arc-20260327;
        b=VTHr/4iyd32Q0irFOhpEqiXdPNQSWX8AoFx9RmHG93iyH/02XAAIyyRImcAIPg4m8B
         dPluHi3/brGCALceNI7InCzCDE0QIlA8QEqEnXcEg8A41r82Itda3PbwGdl9X/3EVFde
         f1VRpgl60FQXBjNln0NSxef79vgO28bp+hdGwgZgisZJoh4thsT1oeaEYiu+JL08V4p3
         18WV0LVAQdo17tKBxRPDw7ibpmCwl8Wy3G+N32gFyxKXxcrsIpdGXdk+6AOlYL1jxjzK
         pmAOW9JmXO3n9A7XjBg+ydGpfgJHf8nJKsz1vBGFE6WlxgpAMUtr2/3Lt5/qIqcfI4LG
         1rIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=k96tFsX14s94s5wbaT8Qlmqy1u4ahiJdjTDejBpDbbU=;
        fh=UcI9fjq63RKnKRG2Wez2wNJ3TpPq21uVqXs40D5SzAY=;
        b=boIz9VU6nmhvWvb0++8BfpPJBNM12IeJA0hX+c1CjHS8a48UFMTz+b8phPNFvxQCn4
         9afx/izP/bM0Tead1aE0/WLe+qbXUEOB/hHmFjTIcqb1TUqsrrZvjaPMXFhX3sOdRfIh
         SKK05qUCVzdh3IcMntVFOnAV3kcaNp7x+SbGYdSVGHCbvAsuffTpSndGRwOQajnKHllN
         CcT6b31jIFRq/Tl2LBj4FnQ0pIEaD294kMRTfP8qzmxLfbqPUiLFLuUgOMKBSf3CB0P2
         2e4YXyPmejx/8unWgcXapxGPyigYS3Sjy7rx8tZBAFQxRbW+zB6oOQRmBWiW1RZTBTBY
         +dzw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785835048; x=1786439848; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k96tFsX14s94s5wbaT8Qlmqy1u4ahiJdjTDejBpDbbU=;
        b=I8144Lr9yq4YLktZwVTx1R6mCx8o+w1vOjtA6lyMc+SAZ2er30r83c0RZLhqQmmCyA
         otqt9J0VrwJcfRBneKmF7vkdAq9hvgivKkKb+PCWs4TcVsRn1GCUVWOMr4Q8cg9Q9eAL
         nU67zlXYJHMuP0tuhB6NWg4GiyZKrxstyMibzIL6EJZe1QFkmHVMkyKzyFt58H1YxQSc
         m28uu4h+GqwvKqHL4sPq9bPNKAmSfytLYNobp9H8IGFRj3LH+uNmT2g4PsJ5u291IPzo
         eY/zXHJTrNp9nz9461JDl9k+pQ8KzE2gHs1Yvg6D6ME2ZwI7L1CTryad94acXubHSSYj
         hs8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785835048; x=1786439848;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=k96tFsX14s94s5wbaT8Qlmqy1u4ahiJdjTDejBpDbbU=;
        b=IgDnGaoVqsxwON/yp+ZpuJWyT2wQUpf0hVjVg5JyoiAs7Ur0zipsTlWQkZMYEn/knl
         NlkaroZ62oNBgiq+Q7UIS8MC6X9fjRJPwTiZn7+UB5joayNc4cmlegU94sTIUVvgkGzV
         jUBKwvE3IZcPormYWWIfQxA2AwQ48865dFOx0y7EdIO6IPpSNt+sZGD/IgDgQEtgX8ts
         oHw4JeCDjAkEweb8uqACONfTwIkr6/yn6ws5KFiIyvYsJwxau1XBM5n3JKSlOgDWfr4K
         7PoRT7ZdjuDw+Bz8P/mQxhQ+UfEl8ccvZMgTmLqBACbt4i7f8my//2yXwdFty7ppCARL
         fTGQ==
X-Forwarded-Encrypted: i=1; AHgh+RqAdROogMQOpn5PdRtc76JmDg+1feT0ofzCQK2vuRXs1wv/l17KM5P2nvJjjh0ML2fa/EaL88pY3Mix@vger.kernel.org
X-Gm-Message-State: AOJu0YwNvAL1WcxfnwnKx+PQF+YAUjC+x0ODKQlDsXP2WqF9X2K1xAS7
	n+5kOkO0LdIH7UMoFlRFERPtx3wjnk62kyyndfamlhbhUMffheG+zvgmQhO4ctolFcKVTdd5918
	MgemZfe6mOhRHOJiRAeLOoIEH0EQVlnf1+jmpPTzjarAkPlr5BbNSFxpFGT8=
X-Gm-Gg: AR+sD13HfTL3jL1VBPQVAYaNg+qChshgjj0TGc2ifrl5eonIxphZ+dYuwtVFDTFAtsO
	arSmF7VWz4Wmd0IDHCafpTUuaq8JnOo2KdcWU2lYOSuiArbMGxdsuKhMg85jyTm1V92NWP2n6WE
	0KcXJtyGk+ZJ03H1Ep/kFzfWEoGzr0MeGI5GIeMeHf76lseAK/qgsszZ1BKHbCnndLhlFHk3+O+
	54tkZTACKeqshRLMy/IkkLWgWZ9kfFl8DOwdznMgGaefgFgqrPWrMy7+bpmkbs80UAoOKLmj/VY
	PI6L7kF4FFbQWWYTQ5Viq70FaSd+iqtp5nqrf5J7COVhYs2Wm6UDZO6xgq9oqiOsPloCNNCvi3J
	EkHyxBSFuyYQ4
X-Received: by 2002:a17:90b:53c7:b0:38d:a150:ee04 with SMTP id
 98e67ed59e1d1-38fbc4ef153mr11476045a91.30.1785835047149; Tue, 04 Aug 2026
 02:17:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
 <970cc36fb627fae64b4957954483c74cf8e59c87.1785534721.git.bvanassche@acm.org>
 <7ea61c74-ed48-44cf-bfab-3f3a49b3d455@oracle.com> <a1de6868-f0b0-460c-ab0d-ee759e7886e8@acm.org>
In-Reply-To: <a1de6868-f0b0-460c-ab0d-ee759e7886e8@acm.org>
From: Marco Elver <elver@google.com>
Date: Tue, 4 Aug 2026 11:16:49 +0200
X-Gm-Features: AUfX_mzNH0EmorRENugBc69MLR1-gqKf67g8bUpk05Qi_JmkW4wav6Tr8tobJy8
Message-ID: <CANpmjNPuWgdoGzGvbJGy-rt+J3sNTffocp4sKR+auQhoHh=e_w@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] scsi: core: Protect host state changes with the
 host lock
To: Bart Van Assche <bvanassche@acm.org>
Cc: John Garry <john.g.garry@oracle.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	Jianzhou Zhao <luckd0g@163.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, 
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
	Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, 
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
	Ranjan Kumar <ranjan.kumar@broadcom.com>, Nilesh Javali <njavali@marvell.com>, 
	Manish Rangankar <mrangankar@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 3 Aug 2026 at 19:11, Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 8/3/26 10:01 AM, John Garry wrote:
> > On 31/07/2026 22:52, Bart Van Assche wrote:
> >> @@ -411,8 +413,8 @@ struct Scsi_Host *scsi_host_alloc(const struct
> >> scsi_host_template *sht, int priv
> >>           return NULL;
> >>       shost->host_lock = &shost->default_lock;
> >> -    spin_lock_init(shost->host_lock);
> >> -    shost->shost_state = SHOST_CREATED;
> >> +    scoped_guard(spinlock_init, shost->host_lock)
> >
> > Please forgive my ignorance, but what does spinlock_init do here in
> > relation to setting shost->shost_state?
> >
> > Elsewhere we have scoped_guard(spinlock_irq, shost->host_lock) for
> > protecting setting shost->shost_state and this makes sense to me.
> > However I am curious what scoped_guard(spinlock_init, ...) does.
>
> Support for scoped_guard(*_init, ...) and guard(*_init)(...) was
> introduced in January of this year. My understanding of commit
> d084a73714f8 ("compiler-context-analysis: Introduce scoped init guards")
> is as follows:
> * The referenced synchronization object is initialized. In this case
>    that means calling spinlock_init(shost->host_lock).
> * Compiler warnings triggered by __guarded_by() are suppressed for the
>    referenced synchronization object. In this case, the compiler is told
>    not to assume that shost->host_lock is acquired at the start of the
>    guarded code block and released at the end of the guarded code block.
>
> Marco, please correct me if I got this wrong.

Right - documentation also summarizes this:
https://docs.kernel.org/next/dev-tools/context-analysis.html#supported-kernel-primitives
