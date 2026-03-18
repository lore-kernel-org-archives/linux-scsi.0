Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34133090E2
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 16:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773849745; cv=pass; b=Kqe8YwhlNcO2SHkzCD5oVwIJX4o+348QseWiI1tpc5lgF4L+GhOutlpkpGpQ5A7Y/IY9XbLpmNpatYCQPJcoA98xTCBkfC9xyG9Jfpxm5V31eo7j8jgQXzIsajMRpI8iJ8LkqiyD5TlB8NmAqtNv87/YeJ8SuP8ZKMgZ/z3TjzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773849745; c=relaxed/simple;
	bh=Sn9jbrHlytwm6vm7UMn5Ci63+904PwFRZxmCisoVDck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RlBj8EANnsnIhIEu5nCzv7Rl71vrWamnkJzgyUHKyj5ZbyjXzp8cADh0V0712xpRaGmzvuvcPeSRLSjgZLC7qenRS4kcfzUu5zabPFhkRxZOUpdySYn4k7XzivvcLznGGqMWLGr8dayDTb+k5AV0A44ukkb7HkYvCodK2uFOmnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wm0jPzpe; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wm0jPzpe"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-509062d829dso620691cf.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 09:02:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773849738; cv=none;
        d=google.com; s=arc-20240605;
        b=aoScfd4v2rKLJ2B3v3i8WVHLCKaK+FMS93oX2I9jgbH/kUv4rBQUhtEgijjXynE2XZ
         bC2On6nb2jDw+x2ffQbBT/s4CWQQIFXgO5b+MM+jMKDoY/f1G4XUB9YxlyYpRoqi1xQc
         ruhAgo6I4SM6oNjcLRz1J1BZ39uN2fIZxkYGaqwxS6Aq+1NoAMrU2sGTofVnGg14Fu3K
         GRFMw8rCvK9z2uTQYxUl0k0cQRH0GmWSdbDLaZLLrWfJjmNjZ4E8vIv7Orw9x6C5NGoq
         l2640m7KH0lSgdw/dzq9Tto8W9VXy8wznTM1Qk/3bbnt7iBH8Q32vkKZezAdgjjDg0ne
         irVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bBf0X4ZI8hrueKElVjOm/fdCiPNUuzJRpv2jzIUCVLI=;
        fh=gHmSkR8o8w7fhs9Smp8ZpIKFwUFrwqajF64UpzRiJBc=;
        b=lSPIdX+pk2c+oAfc60l/ySiIG4V8cWPmsb8hzBv9OfOcItrpBuCVAeE1S1RQrIk5Q+
         5Y9Z9Ax0GryuB1ZIT6y+CRZ9qWOPuQPOPjRDLgDpM+79oD65t/uFBvLWSlk68405uYjS
         SSaM+pSeU5/7SRNqFhpc3SdRwDNayOjheTpeq5ZZ+CC1YtNX5+eLxGMDXpfJ0eYqjj9i
         +9fiOB4RIZA3IWI60BRT2nVAYhJUXdY60L5m3eyXZVSfBQnlbFb6nU/1lv5aJ7xjbncr
         c8ZZgvUXNsbWMrlOVuN/yvJT+6nmA6oJM+INOUkc9AO3QnoXMuasPLOdAY7UiS+jhWrb
         aDMA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773849738; x=1774454538; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBf0X4ZI8hrueKElVjOm/fdCiPNUuzJRpv2jzIUCVLI=;
        b=Wm0jPzpeHp5dNdtnLhc5H1xUtQtEyN6dAuXQxuM0/SN+dHfWxkgkDLEv16Sd+NSk4R
         W3zwVULhxvCobeOJ60+FPx2K3eBstNvsz1o15jYru4GL4ux6NqrdChHlBZ9x8AUqIq29
         mSh4V0HHJ1KEDYe3hbSIWJt/zucGLqTxfR/1Gy6C4SU1SnJYyWvn9m69CcuCepH7L6C6
         n0wL88/pgPhUZ1Xwjk6REDhoOePUSYUBm/1TlDa4divFXSqbTArdZq/crK4tSKTSMu00
         OMs4vzIJDqWDaaZZ7G+XPePGtrej7nUQn43nj8Vez1JteO0v0mZPWyOk90/G2Tpzi1+W
         Y63A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773849738; x=1774454538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bBf0X4ZI8hrueKElVjOm/fdCiPNUuzJRpv2jzIUCVLI=;
        b=OpZThnTrJjmsIpaXVquhvM56i6OIE2o1v0yDYwrfGupqBBwTYDDRiKYEHQFcLDWcnZ
         AE+3dgyMEdLjwuiXNqbhmjxQO4yqa/Ass7rcEkR+ozcfFLcLPBPGncSIdDAF4JRva3C7
         B+C6o//+B0ebzMlrk3LGQftN2fCPT22cE6gjy2mO8m47BSUOpCr0hgUyHYW90DA8xuYl
         FSb6jY5+q9jZc+0A2lQ3Gw44xZEj1GpQCUH/4TEVut0dtC6dADNpOuFl4NzTctcm+D4M
         b3g+8dNpkQzKnTcrbdCV85kNXSBU5ATogCKSt+R5cMmY5it1IVy0/rWe1Wj3ajgEhnNA
         xL9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXRcI9VM2RkS0HWXZHF7+8EP+Hrufke9kuvK+igcdoFOoohPj2OebLeSMNbCxvJCRU0fIU525MrZ0iE@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/+AY9IDqbBDNDnvWY86uHemZxZju8SFehXaCmh0ymKkkWAAbN
	M6SQUU4J220iVZd81JU24fm9ULOGaJ2GVdnfKMFOejYz19w0WgteDGZH7MtXWSnbl6tImxrzLJ7
	N3NS2aGDf4a81vZPsrkxjQaunwESSbeat7ZpyMe40
X-Gm-Gg: ATEYQzwK20cfP15C182oe64wQVtiu5iWPvFugQ6KUH2MbgRHEQQKtktddFU+FNbzVLw
	l5wnovakNb/65q25VB6MyvpELn35/RPqHYkrWpCwTIjyRlTOZ0C36a7ehRdNp86uAEfptPfAcWK
	OlQ6MKVWdZX1PhHjWuoWoaYIunyLtft2Q6L26m5ekcT91Bs2T8lR0mcJ2CR5uEAegt5O5HWYe//
	OorO4U3fINqgJbGy5qagz7rK67548r4/m9As0ddHvURw3h1CMImKeGPMqFL6/hcHDFT/CkT+sAs
	O2yRBf2uR6uMwJlRI7dCYZu49LL3at+rBRT/TUI28wiSJX8S
X-Received: by 2002:ac8:5d4e:0:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-50b1462cacfmr16816931cf.0.1773849737454; Wed, 18 Mar 2026
 09:02:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <4e152e7b8e1a93baf0777628eef9409d031cf8f6.1773695307.git.ljs@kernel.org>
In-Reply-To: <4e152e7b8e1a93baf0777628eef9409d031cf8f6.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 18 Mar 2026 09:02:04 -0700
X-Gm-Features: AaiRm52kf0p9Fxu6EolM9nhc_2BIDOLEzyHhrKwtGPKlzkXo42y6XvhNDeOCJ6g
Message-ID: <CAJuCfpFd-d-E24d5-G6=dSYDpyHkwS=aXzGd6+SzyMkgssyPAw@mail.gmail.com>
Subject: Re: [PATCH v2 16/16] mm: on remap assert that input range within the
 proposed VMA
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, 
	linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 16, 2026 at 2:14=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> Now we have range_in_vma_desc(), update remap_pfn_range_prepare() to chec=
k
> whether the input range in contained within the specified VMA, so we can

s/in contained/is contained

> fail at prepare time if an invalid range is specified.
>
> This covers the I/O remap mmap actions also which ultimately call into th=
is
> function, and other mmap action types either already span the full VMA or
> check this already.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/memory.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 849d5d9eeb83..de0dd17759e2 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3142,6 +3142,9 @@ int remap_pfn_range_prepare(struct vm_area_desc *de=
sc)
>         const bool is_cow =3D vma_desc_is_cow_mapping(desc);
>         int err;
>
> +       if (!range_in_vma_desc(desc, start, end))
> +               return -EFAULT;
> +
>         err =3D get_remap_pgoff(is_cow, start, end, desc->start, desc->en=
d, pfn,
>                               &desc->pgoff);
>         if (err)
> --
> 2.53.0
>
