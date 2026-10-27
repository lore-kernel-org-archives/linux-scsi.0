Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793068886;
	b=AR1X7V3IEfJ61kUyaPL+7NtqTDMRfUXR8ohxkSjII5GSqInKw9K0Vp7wZWLJrnLrtPc3
	 bLQ+U/y70JfcwdH1VrqT01JS7TRbJnQ7k85q6l4+j0FqHH1WOydeAPFI/XVpviDmrqDU9
	 EFpKnoPfz8eKMd8Ghm4Wx7gig5ExSnPJk8RZZP3Jv8Zl277vxUEfgkOioVIY/1AJ+U49M
	 Ji/wAYGOBHwwAbK59l2GfpRgtxZtjIr9RgaQXQiCqghWxi3W/38+HerK8xLD7704l5pxn
	 q61ZzVyOyykZRLpHigCFRekCyD0szcY4F57Ne5u7dVRT4vyENcvlupl0xbRCZGzpKag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793068886;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
	b=sW6Ws2wKcFn7e301YwcFxDjM5dvqPXA0f0FUHvqVqVPgsdf9+kmMeN5fXvLtK7Lk5mbX
	 2oQWfoxNjXhZcXKBdKR3Nu+1DHPp3ODHH1mLCgQtdgmfUbYcSQRlouCxiNy8XD2xlSNLV
	 ncr61F3uTsRhFUugOsMeB2HcHUEg5E4dHj5LEYiP/Ubse+0QKQ0GleiNW8yIk5I/AhUW7
	 lz99jBRGpnRoDNJBB9GN560zmjvsQJgTN3LCs1qUQAYTNi6KY+gjFWBA+a9bG2AwnaADq
	 CJxB2d54MstC833ryCj6FXYnvindPvjok9bnxxi4bvTTuLyhSg4SYuHcS8eCpa+My/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=pass smtp.mailfrom=kernel.dk;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=oc6cZqFa;
	arc=none smtp.remote-ip=74.125.82.42
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61928606A31F
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 02:41:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61928606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=oc6cZqFa
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-18cdcfc05ffso4488335c88.1
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 19:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1793068884; x=1793673684; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
        b=oc6cZqFau/HqROtNMBTq8ZP3TLLLzMKPOdbVxFYEww/DOpOMHzAfKhTORNvN4KTBkp
         LUp5Moi9eFCEYu5/4XDZT8WcjpiPsCN+0zUGPUekQp2yZJY0zBe8yl4kYAkKqjEdTrbQ
         qqNSykJeEwW7qBFZEoQS1rQ+7ZwY381+e8TxKyiv+Q5rLJiCFF4PtyVkTxWHTKQMc6vO
         +lb3qFo71UgGSSnv6IseZ7y8wLhEFz6jBXh4HUpywe8jgXN4FoqKQy7CyAzCO9Yfeytz
         HBIYtHcP3MQ7eijYy79F5eSeZqsN4/+XnIDB6Cna6QVY5R0NQaf50jlOwAuklcgL/mVV
         dVQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793068884; x=1793673684;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
        b=X2p+2eNE4gDuf7B0HOiOh4utQcOI5HvBlkvMv7UzYJaLPq2iRMwpf8RXJz7zjpLMyk
         Q48oh1Lfq4Mo84hbTpVYV592oo4j0NPP1hd8D65LQvN5auIU1LtPwTKdqnc2frhohxSI
         wz3pJWfIypC/q7IbNm7SMj7J/gytF0EXreVH8YJnlGrVxGI0ep6+Kj3sYfnG3apyqvxv
         6k6tl8YP5fPSZGrSFv04YGTkJ7lUtUsVnRvxXhO+4D/VhAALYMrRFZthtRI0u5csFfo/
         G29CT7y3/Jc2ReQc7bUgXwDyf5F9/AQFS72DLJFpT/9VSM7xf1arPzDF6NwecRLGvDbi
         uBdQ==
X-Forwarded-Encrypted: i=1; AKwUvBwUBbTLnz/GE6noiC60fQkzgyQSe36JyiEcY12GSQCaThBVsqM8r3XB6pOGa1VjHIeWqXuux7052cMe@vger.kernel.org
X-Gm-Message-State: AFq9FYLBbY5C4VkzdrO8W4yvhm6xRNMFyrqxsqVpqAObFxtgRQssKNsT
	NoT/YXt/CtkNBHgNHGsCiKEBPRhNVcV2Z9uiPLlLqTHSn3QzsLRIm6qk4Axs9LIu+zc=
X-Gm-Gg: AYBFou1D1+rFLY51q4bgB5Tn/oldD3zLdH853KlO2JLkrp7dnFI/57cEfbSmWwpQi3+
	oPrvitvPXtvUgqWyxtr/WEMLqP4aOt5y5rFK3Ih6V/TgHy9ik8LObKO/qEPdyw4xp4bcIhScE6z
	7LAm/tJ3lXxJzDKsoGHRjR4JcTE82fpTnT9PBK2eiDcT+xHgHXSyqyX5/dOcw6NvGAbmXKo4iHD
	hkt5787M+1EuKRv57mPPCi+WzdHW/nebEzE1ZQsDgZjFit+/9x9Mo6d4tycWgtH9u5ZT+4Zt/LQ
	u6/QYC50WyXxAhR8uZEHP80yF7+C+rE0SKcgIaUguqOIPIIs/joJeJ8Yz6C6syFTHfBq+5Aw+T6
	hpybvVPh6U/HYEKqsFxEraB6+KFNU3ckk7aocYSX0M5zGYLmr5DHRDas0qm1e2Zwl2Vb0O+dVoG
	KanK0eZkNjVbH9JqCiz0gonmMxUFNbzQQV6sKcJBbHcWfzJf5iFs+WOJpJEQAa0+g7WMwJVHYfk
	8m+HSXacCPwavoXURF6a/v3zWmeWiZ4q27v08gp0jcAQKJn1EJnGhgtgNWq9wTDZkWbpPacwFwx
	6dIaKRmqaoWtuqV+H+Ygz/AwNLtqeeoz29EmEzg=
X-Received: by 2002:a05:701b:4184:20b0:191:444:425 with SMTP id a92af1059eb24-199290fe40cmr12440066c88.2.1793068884148;
        Mon, 26 Oct 2026 19:41:24 -0700 (PDT)
Received: from [192.168.1.106] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a1bfaf25sm29293759c88.14.2026.10.26.19.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 19:41:23 -0700 (PDT)
Message-ID: <1ee97e9e-3658-41a7-a879-348f51ab547d@kernel.dk>
Date: Mon, 26 Oct 2026 20:41:21 -0600
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
Subject: Re: [RFC PATCH 01/10] scsi: bsg: Don't copy sense data to user memory
 when canceled
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
 <20261026215226.3713941-2-jthoughton@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20261026215226.3713941-2-jthoughton@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

