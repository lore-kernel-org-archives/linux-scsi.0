Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793068958;
	b=sW40tKPn1qG7jMyzUClhTmzWNQbzXp4WpDEPA1CtEFHFxdZO/s+yCUcGOofCyBYKFcdN
	 VDoC1m9wz1vhxWtCyj2WCcfcOfsbhbszvZN+5qlhWajSY7PLsxuq0euv8JjaasdGlgPWR
	 cRJv1UeN8GsFs0orAwd95aS7DB+0qWpeMo0xdVASHcifIVmK2lxrXwb9m0Jg91T/Vng0Z
	 /5LydEGaFqwH7qW0icDia004Q5PyDPoxXZ4W0itANIb9AbM7+qVNxk6V7B74h/UZ4C7Nc
	 XYcDY7Rjo0U49IDI8H6F8po6GcbXffMLHMGji6Wl9kiPvfCVc/w6Erk8U/diSlvtzIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793068958;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
	b=QzVouGsX641Zx44nev8WqLCI2B3c7N07X+r8cfhSY8x5/mfwyKELD1uTF+cHA+Xi6CYj
	 drZRlKmnUQ+jUtwdcmxGJKVqKppMA7DYi6QyEiCm1h01prPbHxjBLEqOjGnoX4Vkw5hj+
	 NW7MX7bEAteH4u9bPjqSbJ6d7FLoqmVRvWarLQWeGqu/whXn2foFixLIriBugPvkUklmk
	 Da2xOIX+pUHNFgtx4qDlGVX7ut2Jxmj2uOaU7IwS7WRxIn+w8CAGqkFm5ogZpt5u/UkK9
	 TPG7Nrq4m45R/zDaFV1kTivdkOW7bydZ/by+/uheusn/3EW9kU85+OHiCpWe8ZcnHrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=pass smtp.mailfrom=kernel.dk;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=nAMLJ4po;
	arc=none smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C36F606A31D
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 02:42:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C36F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=nAMLJ4po
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1846bc43c28so4071755c88.0
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 19:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1793068957; x=1793673757; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
        b=nAMLJ4pov/UKnTCLgH305UyFiee1Kbb1n3tCzOl712VaepOkFQaBHOfe8TqG3p1lZU
         FcmqVqrrqUreTloBdzXh9C3S8RzvKdqK0Wdm3ymTtA2e7F8hg+g3tAXi0qMz5tjjKhfg
         XZsmI+gaR0xwl7nmIQiVOSWVXQuFdQ0nDSV/JTrdP8vh+zCmGEp4ByKhGzO7Q9EFAqG7
         Z9UxSRbzl1SyjYddPBfqeotnjUxiWUf5QMQHMI+2cHXwFS8e7Vcd6faApvoLAEI8hyVq
         H9p+0vB8HKXlTDO8gBcIdyEeUOqojMCpKudjjewsxrlbiMp0bSMq+X14CJGfZa/XuOHM
         djkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793068957; x=1793673757;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
        b=WJaIqqaNzXvnzqUL0xbB0cpVyzw0PhO9xJRZboyJYVw9RZ4bHAO1ruuuS94Aax0NME
         G+hdsb+1lYwdThWER94eRxy7ocV5NjUuwVyh9T7Uve7uBiA9QkL9Yxna/4WUc+03Qm6e
         frd9+mDMEJb53NBaZYlcUclxJhQgEN9Bp3L9bca2Q/ggq51cJHz6sliSC6c+cn5MMHIx
         lERGfPyMmgN8Q0lrlGesCymbjbvQAqtFuuuM7YtERp1DHZ89GaBF3ifZw23DD3ghYVMV
         hzvF8x7uGzis0lxjI7GuaFjrqrtNvtlb1745tDK+Tofz1LW8Mvwawxycvh6bhHYveyZq
         yiKQ==
X-Forwarded-Encrypted: i=1; AKwUvBz5xCsM3HmHGASgDt/B1DLb4ZUtbMC3mV/i1lwbtuW/mUTzxJwNDYFvEOR3ELNKRqRQGURqruGaW336@vger.kernel.org
X-Gm-Message-State: AFq9FYKfBQwq7vqnNm+jd9lWNeoaJPLzEk/Dc2cx5xRkv4w5ZwvcmZPq
	RjOFLPZqa8MenLoq+7j182n+/kDV908WSlPL7lXM/kHOtI3cuQkLmo2mw7RsIneJCOI=
X-Gm-Gg: AYBFou1E4EAutT0UKDmbWjP1junMB/vE8/5ZcS+wLmi4sue6KpGOynXw1qLByZaX817
	FKjd2HDEDjLXNotmzopK9VFGD0/QBD6/nCKht2BQ8HMkF4sOcG+CKxuN+jiWbGdWuMs2YKNaU8P
	JgoHF92C53xuMhCQo5BBo3IpkIRp3sHpzvcwPIAfIKnzaPOqY6ogssG21q66KajIPrVCTWiIEMQ
	WPDwVXUDRHObRNZG10FwAgXyMe7ZSDcTFhpmgvxeaHY07/a0XQDcAoMjYIlex59C48W9B7zAZBd
	TIutA8apFbWieI9Y/1aOvT/pJG9BaEH2JQ1fv2iNkyYDZTyhTlvB7IGxRGPZdBD28wow50ASWA3
	TiFEUARwdxOcmbhs6ceSKBYxX2NdXr0zMZ7GuzUSsI6PSy7iOghVwzq+XwgrXC38bTzyTQZNI/l
	DIgkQG6mxAPqEYhN6ZnX8j7DFN9hotlqXbnyD/sS2JQxbZMJSgz9cWJUblB/bzKZiaLscyGof2T
	wkHt+P7qgVlLLNXsHg0rFmtV7TOA/vZKPIJ4TkaCQch3C7kIw1KKCLdWz0CThv3oATDNI31zS2R
	AHf1t8N5gkipEh3MK5VSNhGm3Uj/EsHi+XHtAVs=
X-Received: by 2002:a05:701a:ca07:b0:144:fd7c:84fe with SMTP id a92af1059eb24-19937307669mr13761314c88.35.1793068957501;
        Mon, 26 Oct 2026 19:42:37 -0700 (PDT)
Received: from [192.168.1.106] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a249c331sm59514670c88.17.2026.10.26.19.42.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 19:42:36 -0700 (PDT)
Message-ID: <30b1cf28-61e6-4f28-8e28-79815bd87617@kernel.dk>
Date: Mon, 26 Oct 2026 20:42:35 -0600
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/10] btrfs: Don't copy encoded read data to user
 memory when canceled
To: James Houghton <jthoughton@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
 Pavel Begunkov <asml.silence@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
 io-uring@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-btrfs@vger.kernel.org, bpf@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261026215226.3713941-1-jthoughton@google.com>
 <20261026215226.3713941-3-jthoughton@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20261026215226.3713941-3-jthoughton@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

