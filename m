Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794231874;
	b=OXXUjtz+vkjGKlQsyTDfCFm5F0CD5h5o4Wwkr6YX4Kcx1HYBw1j9VN6B4qx2H88HN0ev
	 4M1LbI8dtarmZPkv+7BQjWwpm7Ba3Phpavl/FcFUO787vVMTdXk3xH7sBwiviN9Fta2T8
	 pi/4RKhp91A//ku0tVwNWM/MDzxXQzBP/M7ZfbTVK4B2tNL56yBIQxPa+hl5HV3RxaHim
	 2Xoo1bARnA0N/OfRP5q4IgMRjeUA7M6GLMa2RenO3Zv8i1f5kFfIRnUzahFuSRpXUoYwN
	 FbwYr6QMeWql1lXgTtHIyqJHlX7oyyQSb+bmleVDPmTJ34SP6EoTn4tYW2RKa5N/2rw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794231874;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=bghOY7pp4PqTwolmTpdD1zvT8+4Tek4EN2nSOV+gjQQ=;
	b=moy97/HU79b+oQ1/wEZ2vHlBFpmHagMElxziG5Ra+yoUoQEyLeDpLdztFEAEG/PmOx3x
	 s1L7aBvFSZsNWkDzZXG6Ydr2iBWaUmIa3mXYekHnOIooYxFrbwK9N52yOeFrnNylhEZVv
	 JnXjedC3jiC5uiF6JlMhGACvChGG5GQrMMDnPWY45mqYtj2rXWGGhQIXEM5XWETBxSiPQ
	 n3zvZrfbcjLRFq+5qtHiS7l8CpGM//5Wzgr/ksjV3H7h+oCFt4VyXhnYeMNuQlXeZi3DV
	 wAmNg4EMmEhEMEQ4uMwUPUs6xT/QfEMOYuL2JZ8TEjwMVvB3wQZMY1Bd9/7oYcLnhxg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TImMvHFX;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=YvJeU9XV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DEB606D832
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 13:44:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3DEB606D832
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TImMvHFX;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=YvJeU9XV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794231872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bghOY7pp4PqTwolmTpdD1zvT8+4Tek4EN2nSOV+gjQQ=;
	b=TImMvHFXpxlE3RZ/IESRjzXY1Bz3uz7xYgDzlWTn5NUo4sYbsDhB250NNUtPlMXxdG6DBc
	WGLwO6SrQB9OF8tN3uQs4q77tBIalQZPSuzMxkuyVzd/PCVOY7m+CBdrO/4kVUtIPdziQv
	zULBqgLEhzg8pLONbEyJmnj8v9psdCA=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-q04kBqwMMhqbrudzl3_UeQ-1; Mon, 09 Nov 2026 08:44:31 -0500
X-MC-Unique: q04kBqwMMhqbrudzl3_UeQ-1
X-Mimecast-MFC-AGG-ID: q04kBqwMMhqbrudzl3_UeQ_1794231871
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-4ad9bc6aa91so1150776fac.3
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 05:44:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794231871; cv=none;
        d=google.com; s=arc-20260327;
        b=pxwh8SlydNq5lUqEQ0/sdHnlcwmSLadumyWTZoje6X+xvydSktTm2uESdLZ60ccx4z
         dUTlZq0Ii4EvxhjkAg7zVF5YNSPiALqbcEwcBniodIdtx9Nzz85LaAwVRvIKY1w2B+Dy
         5LZ6+87dTtIM0aT+hV6vU0wCk/BmMdsunFx99XtCEdQhHI8dRCAUqRwpKC9woOICmUxj
         3/sARRHDzuPeZYAlnPfcJC2QJ6ZxUEcvQ4HHM1Oc1JAoHF9c7qVyaH+vF/DUVRU1IVj3
         mikSWbEABgsd992AyOL5rcrkrfIbB4uAgrOsCmRtxPZcap/sh3KTNQu5a8s4DGfJJFY8
         I4Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bghOY7pp4PqTwolmTpdD1zvT8+4Tek4EN2nSOV+gjQQ=;
        fh=DXa3jz1VeJPrsU7kwbfKVCgAp6Jw5Vgr8qXjJwh/AhE=;
        b=LlPQfUnXVsVLciCCz6JMw2XXpNzC4yBsMh8imT/K4cU0DUpb1XHkITqKFK85eNUcjF
         v2D3IemtmzA12zhqD9aoTr40ApzI0uSVq+Oe243Kb6U+z9mPe8xk+sQYkiFOORA0rpVf
         dOrVowLYCHeKoTXaAnwJ06hhfr3Ip5y+PP4ORsj7ppJcJM9P/REy0WaBJh/5S1IHmDt2
         UBU7Ct7XGIV7ruo3IRijDOwx08ZfkTqxNIRNnLPSsWoeSnEnkipsBHfOxS1wLc3wGb1m
         PpLTI1tNMqbOgoe1kKaCTJZ/7kzzl2qOhlzxnuJtqBlILhfGn0evaGfz3S4DKUFQNPfW
         pNJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794231871; x=1794836671; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bghOY7pp4PqTwolmTpdD1zvT8+4Tek4EN2nSOV+gjQQ=;
        b=YvJeU9XVwfRisHtjyrCD+g+YGGD92Y4vF2X6jtfhy6ghLt1eFKkMwEPTldRNTAcYwI
         GItFYO/P+dcWYTGtr8Jy81fAkwVcwgfbfg96bG+xjrb/OnsMZLb+hZW5MN3U/ZKjDpC0
         BOcktFnfPUXucHdwF1+UR4tDqvpRyDMezw8t4YfkxvDhMjaakRyGd2bAZ87J4j/v9ugf
         hJ2UzlhDvtuOcRc/LSpuVIkVHAqmBkkuIvITMWlo8AhVzCCkUw0C8YPHftpTxw4nf6N3
         L7byH35l6GMhiO9yNgS5JmHr9mlH1MPlA50sUGYgHyc+7k5qS/eYAJOO66qnWTunj81x
         ywUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794231871; x=1794836671;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bghOY7pp4PqTwolmTpdD1zvT8+4Tek4EN2nSOV+gjQQ=;
        b=WyJtHiBLbgbg/c9OQianjqu/D938ZzVdfxqvlkB3C49nfPcXB+ZF715xR+UqBGUCho
         GkLGmEE8Z1zjEjzCDr5oE7c7CZobvz/zPc3yOCTp592uAXMmPAnWcDYdvekrpkS7f+BD
         yWlAJpElmJmREUBrFoZ7jRDvIgGS7JdJbof6f5H6dxdonUEwOPgeQmIsOvGN6QeY2FZp
         FzITrTfByTzaJqBUBgx+nvD4yQglFba2rvhw40j3sdyoEq4QnjLuHTGwOrMYtJ9nwgue
         I8PdISizt/FIcHZBr990y/qorA6B1geJHJwrqh16IFH9AQc6UHbC7GU8k1IOi7ypgA1S
         bu3A==
X-Forwarded-Encrypted: i=1; AL+hErE9ZB3RT7nw+QFYuL3AYhc354ll3GpwvGYVnxdc5AUiE58L6NhQIxTRUOgQkc7am48EQIstq+LEqCrF@vger.kernel.org
X-Gm-Message-State: APuU4Z/hTs27qpx2KaSgfg2i/mNTYp9jwmJknyaok0kOlM0ngnsluqdT
	gZWnd5kxt61+XvmGYi/VYyHgkiZuUgqWKAnl4MrE5oXJZ+ZLDPgUsJNakiOqeyVyLCxUtzMpp4O
	INbhqzYypccvTjkA36eWzXqdpOUdAiav8j+W3MOczOqKfUHt4TImTw4RCFzwAVV3e2aWo7z+o6m
	77YIK1rlbYBDFV7Jil6p4AYDpdBadKYsJ6UhbDbg==
X-Gm-Gg: AYBFou0DOoQrr8XWuGvhXB1TYxhaDW8t37611sjrOHpQmtgLIb7UfjJp0PdXodOmUOR
	azs07ReCxRDBESYqWfkWRG1E7IszHZgO+UigOhBb9Hinx4febq9o3lZgTN9cZPerPgGy5JK832n
	tI8NzizNSALtD0HrEO1spfgFaAf1cJ2Z7Nd8Mqlikq0vZLST+kYm9vVFNc
X-Received: by 2002:a05:6808:4fe9:b0:4d7:17d5:6c9b with SMTP id 5614622812f47-56814022659mr2709804b6e.9.1794231870764;
        Mon, 09 Nov 2026 05:44:30 -0800 (PST)
X-Received: by 2002:a05:6808:4fe9:b0:4d7:17d5:6c9b with SMTP id
 5614622812f47-56814022659mr2709756b6e.9.1794231870169; Mon, 09 Nov 2026
 05:44:30 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106131829.3228926-1-cui.tao@linux.dev> <20261106131829.3228926-3-cui.tao@linux.dev>
 <1e18fcfd-785d-43cc-afd6-d181bf8305eb@amd.com> <CABdmKX0nCB2hT+iMh=BB-nC=fUBPof8YvjvO-gtEw+zcHZgvZA@mail.gmail.com>
 <b0f530ef-bbfd-4112-aa51-82fdad6c4ba2@amd.com>
In-Reply-To: <b0f530ef-bbfd-4112-aa51-82fdad6c4ba2@amd.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Mon, 9 Nov 2026 14:44:17 +0100
X-Gm-Features: AclHuK-kxgj3T37bjFOZ7HtSClpdxsaDMPyjW53dccz7zE1_ZSRFcURRmSZwzSI
Message-ID: <CADSE00L3AfcnfcboK1TdPQiW7ZW1KpxG70b1oyWFqpLciOG6ng@mail.gmail.com>
Subject: Re: [PATCH 2/7] dma-buf/udmabuf: account the page array metadata to memcg
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: "T.J. Mercier" <tjmercier@google.com>, Tao Cui <cui.tao@linux.dev>, akpm@linux-foundation.org, 
	dgilbert@interlog.com, mkp@kernel.org, loberman@redhat.com, 
	jmeneghi@redhat.com, kraxel@redhat.com, vivek.kasireddy@intel.com, 
	mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com, 
	stefanha@redhat.com, sgarzare@redhat.com, rostedt@goodmis.org, 
	vdonnefort@google.com, mhiramat@kernel.org, jgg@ziepe.ca, 
	kevin.tian@intel.com, axboe@kernel.dk, linux-mm@kvack.org, 
	James.Bottomley@hansenpartnership.com, sumit.semwal@linaro.org, 
	phasta@kernel.org, joro@8bytes.org, will@kernel.org, 
	linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-trace-kernel@vger.kernel.org, iommu@lists.linux.dev, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bobbyeshleman@meta.com, mathieu.desnoyers@efficios.com, robin.murphy@arm.com, 
	mason@kernel.org, harry@kernel.org, vbabka@suse.cz, cuitao@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 9, 2026 at 11:56=E2=80=AFAM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
> On 11/6/26 18:25, T.J. Mercier wrote:
> > On Fri, Nov 6, 2026 at 5:23=E2=80=AFAM Christian K=C3=B6nig <christian.=
koenig@amd.com> wrote:
> >>
> >> On 11/6/26 14:18, Tao Cui wrote:
> >>> From: Tao Cui <cuitao@kylinos.cn>
> >>>
> >>> udmabuf pins the pages of a memfd and hands them out as a dma-buf.  T=
he
> >>> data pages keep the accounting of the memfd they were instantiated in=
,
> >>> but the bookkeeping around them does not: the page pointer array and
> >>> the pinned_folios array, both sized by the buffer page count, plus th=
e
> >>> transient folios array sized by the memfd folio count, are plain
> >>> GFP_KERNEL.  A 1GB buffer costs about 4MB of uncharged SUnreclaim
> >>> memory, and size_limit_mb defaults to INT_MAX.
> >>>
> >>> Charge the three kvmalloc allocations so the creator pays for the
> >>> metadata it induces.  The system heap in the same subsystem already
> >>> accounts its buffer allocation;
> >
> > Only if the mem_accounting param is set to true. We (Android)
> > currently depend on it being disabled because system heap buffers
> > don't have a single owner for their entire lifetime (ownership often
> > changes immediately after they are allocated), and the kernel doesn't
> > have the ability to switch who is charged for the buffer memory quite
> > yet. Albert is working hard on it at the moment.
>
> Good point, making sure that Albert is on CC as well.
>
> So basically we not only need to charge the backing store of a DMA-buf to=
 somebody else, but also the housekeeping overhead.

For system heaps the housekeeping size is fixed at creation so it
kindof fits the reservation model nicely. We'd only need it to account
for the overhead (as part of the MEMCG_DMABUF stat probably).

>
> Mhm, this here also complicates the charge transfer Albert is working on.

The transfer would just move the charge as a single unit. But yeah,
the complexity will come from lazy exporters or any other exporter
where the bookkeeping grows or changes.

>
> @Albert not something we need to take care about now, but please keep tha=
t in mind while working on that stuff.

Noted. The issue already exists so my series does not make it worse. I
will note this for a follow up series.

Thanks for tagging me!

BR,
Albert

>
> Regards,
> Christian.
>
> >
> > Could you update the message to note the mem_accounting param pls?
> >
> >>> the data pages here stay with the
> >>> memfd.
> >
> > memfd / udmabuf is a little special because it uses shmem for the
> > backing store, which is already tracked by memcg under all conditions
> > (except hugetlb). We don't currently use udmabuf, so the lack of memcg
> > charge transfer for udmabuf is not an issue. But once we get charge
> > transfer working for the system heap it'd be good to follow up with
> > udmabuf.
> >
> >> T.J. needs to take a look here, but I fear that this might break uAPI.
> >
> > Thanks for looping me in Christian. The buffer allocations cost
> > gigabytes, but these metadata arrays are only 4MB per 1GB of buffer,
> > so I don't expect charging them to break anyone. Leaving them
> > uncharged is an accounting gap though, since someone could spam many
> > udmabufs from the same memfd and only pay for the memfd pages once. So
> > this change is ok with me.
> >
> >> A lot of the DMA-buf resources are intentionally not charged against m=
emcg.
> >>
> >> Regards,
> >> Christian.
> >>
> >>>
> >>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> >
> > With the commit message updated to mention the mem_accounting param:
> > Reviewed-by: T.J. Mercier <tjmercier@google.com>
>

