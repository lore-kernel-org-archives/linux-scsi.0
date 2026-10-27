Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135924;
	b=ZRB7Gj882J2oVNd6JuDCR6ksUEdTvu13F36mzpTLgeEQGKAa6+P0aoPjXQoROLyNwXBl
	 g3Etn3xpZz38LP3GgbUf17qCsYMC5/QUL/DwMBBW0e+9uFW8ICFaCtlHAljwTWiIJymNC
	 0HsNt2KDENW4pn1wcKwJmFH58JUxss7tQg7RY5gGvBM5hEPyvQqHWTlAzQZMfYRKPyTOY
	 DJOCx9Viqo9ooOXNvJ+SkaBptsRV6N9GRFWzIZa+niXai35yJibSToF+5GAx+Ww98fQDa
	 jAWYGfisJvPEVW1dUgN3pp+s08+6iq+uf1PLyUZzMW/X4XBpVVjMU4yf9Spy/8yhxTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135924;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=qUMx95Z2/FLv64tnydT/x/C4fd+wJMNdslwBEILinGo=;
	b=1XWhvMQdrxwcobXq4U+ODUhPaYStSQr5rd6SW+rCmSIxyAqIu80K7ihaTEh0TaDF7Ihy
	 mv35H8fu9nNAJcluIiCV5pO1+TQ7ZxcA/V5eWK+SFEb0ZyhH1RKknKR6BS1VNucKDV7Vs
	 UBki48uXlvU3lRI9qmSO2z7rQ8gJsYB4Qb9rfZupAdyQqm4uDyesdtVsABwWhWxJyagfE
	 jg53bxVx4ORK3P4FznDE4LWq8TEfwu/69MKY8wHRnjEAlNjMwHoR6TRVUej3l7LK1tFxm
	 lV6HoLXu53fCZb/vGNUHavKLAK3LXuL30p6xkCzg2d7nL77R35hmNkXfUDI5/URB4KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=O9t1oNxh;
	arc=none smtp.remote-ip=209.85.216.72
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7895A606A320
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 21:18:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7895A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=O9t1oNxh
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ab7f1efe5dso432350a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 14:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793135924; x=1793740724; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qUMx95Z2/FLv64tnydT/x/C4fd+wJMNdslwBEILinGo=;
        b=O9t1oNxhj7Xw67fxZOhJmZ8vNAdxWgxOGEEZGK9oId6/aVHLsnFtQlbNQ6bzhC9B0E
         f9O/mJB1tznoMWpJP5vr6IAfWd7OYL3+vqog/K86lyrB9hPII1dxM6rPxBJ9Kby9+ucJ
         q3hnsiNT2ru8vSf8egpVYYGw35wKVG80Vu3ezvTOK/2hErKcg9OsAoYftXOMXvmgvOsE
         USSlpzb9cbn2+MUY6DGfb3+M18AMUDB5o3XD1HYrd07vSA1sr+KPFgLsCAHlt3yIU0CJ
         46wb1/8vXqcmincC/gKw4zIHqOkFMeY2f47UtXQrgsFIIglqeYn4Rz2uN2mV+APvhSlW
         0LBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135924; x=1793740724;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qUMx95Z2/FLv64tnydT/x/C4fd+wJMNdslwBEILinGo=;
        b=ebZQzi4SRM240qepPmt84IlQXrw9nyFRGT+K4BL7hIUwxWj1SyHSzELkPJDeeYK5uf
         lfwtKkaF3JJ+0PRjbITwfs5gZyXae9TBUPmwA1YE80XS7omNYxY7iXpyj2AKgoeU9NrQ
         A0onLtvnTKuAJDz+D2pvKn5WiJvtVz+A22WnPACJNQ+zw3oi+XOQfynNJtNKGv/awlHC
         TkIdtrRWUTu8lWQcLztvvZOsZU635C2YKOnLeGuLCNUiH/iUl+eIgWe1bSrqocYuXsKV
         YudHZFWi/2ykQyecyBdbzPGejhqDa/Mr+9aajEvp1hrxC0OFBnFu4qDfrmPMpTC8ocET
         NXAQ==
X-Forwarded-Encrypted: i=1; AKwUvBzqI2Dnk5hfNPhlOMo9qWpJFfrJF/XLE9lACgZvqxPW9lRA6OSq1ZUsnmEedhUGvXbRRphbIp0F8p0p@vger.kernel.org
X-Gm-Message-State: AFq9FYI3qGtQTpfTcLyDvPzMuyvJJluS/l9W2hq1iOaFCLgCn6g1+Uv5
	3T7hUTEfQXpp24GvNaN0WA/arkRNjl1H5HmJUwHxjoaUQ8hNuQw9QUqzgemiLuzOqBWDtjnzo3Y
	0moxEfg==
X-Received: from pjvv8.prod.google.com ([2002:a17:90b:5888:b0:3ad:850b:6f1c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:288a:b0:3ac:9706:7739
 with SMTP id 98e67ed59e1d1-3ae5819e5afmr211698a91.17.1793135923585; Tue, 27
 Oct 2026 14:18:43 -0700 (PDT)
Date: Tue, 27 Oct 2026 14:18:42 -0700
In-Reply-To: <ac22215d-3e58-4aab-851e-47c30836e058@app.fastmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
 <14f5f919-55bd-47c6-a1c8-6f1445cce733@app.fastmail.com> <CADrL8HXQdzcroeGN-ACjyy-jSAdBNHiT1_BCVVe0P+Y8ZueiyA@mail.gmail.com>
 <ac22215d-3e58-4aab-851e-47c30836e058@app.fastmail.com>
Message-ID: <auEVMrMDqVuKtDqh@google.com>
Subject: Re: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
From: Sean Christopherson <seanjc@google.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Houghton <jthoughton@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 27, 2026, Arnd Bergmann wrote:
> On Tue, Oct 27, 2026, at 18:29, James Houghton wrote:
> >> I would think that user_access_begin() is a more natural place
> >> for the added checks, as this should be called exactly once for
> >> any function that accesses user space and also stays out of the
> >> way of the copy_from_kernel_nofault() etc.
> >
> > user_access_begin() isn't used in a lot of places that I want to
> > catch, including the KVM case. Roughly:
> >
> >   kvm_write_guest_cached() --> __copy_to_user() --> raw_copy_to_user()
> >
> > There's no user_access_begin() in there. :/
> 
> Good point, yes. After the changes described in
> https://lwn.net/Articles/1102061/, I had assumed that all
> __copy_{from,to}_user() are going from common code, but it looks
> like the series so far only touches __{get,put}_user().
> 
> There are of course few enough of these left that I think
> we can consider doing the same thing here and turn them all
> into the checking version:
> 
> $ git grep -wl __copy_'\(from\|to\)'_user  drivers mm virt
> drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> drivers/gpu/drm/i915/i915_gem.c
> drivers/gpu/drm/i915/i915_query.c
> drivers/usb/gadget/udc/atmel_usba_udc.c
> drivers/vhost/scsi.c
> drivers/vhost/vhost.c
> mm/kasan/kasan_test_c.c
> virt/kvm/kvm_main.c
> 
> > I do think user_access_begin() should have the new check though, so
> > I've added it in the v2.
> 
> I had the details confused here. Seing that user_access_begin()
> and the other accessors always call access_ok() at some
> point, maybe that would be enough?:

It would help, but it wouldn't cover everything, e.g. KVM "caches" the access_ok()
checks well in advance of actually performing a user access.  I don't know that I
would fixate on KVM too much though, as KVM's memslots infrastructure that begets
that behavior is quite unique, i.e. it's unlikely other subsystems will have these
types of bugs *and* elide access_ok() checks at the time of access.  And KVM has
natural chokepoints for these accesses, so it's easy enough to harden KVM itself.

The counter-argument is that _if_ there are other subsystems that are caching
access_ok() checks, then those are probably the subsystems that are most likely
to mess this up and thus would benefit the most from common hardening.

> --- a/include/asm-generic/access_ok.h
> +++ b/include/asm-generic/access_ok.h
> @@ -33,6 +33,9 @@ static inline int __access_ok(const void __user *ptr, unsigned long size)
>         unsigned long limit = TASK_SIZE_MAX;
>         unsigned long addr = (unsigned long)ptr;
>  
> +       if (WARN_ONCE(!current->mm))
> +               return false;
> +
>         if (IS_ENABLED(CONFIG_ALTERNATE_USER_ADDRESS_SPACE) ||
>             !IS_ENABLED(CONFIG_MMU))
>                 return true;
> 
> (plus the few extra copies of access_ok()/__access_ok())
> 
> As a quick fix I would probably start with just the 'if (!mm) return false'
> bit here to get something merged while we still discuss the other
> details.
