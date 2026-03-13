Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3E4336882
	for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2026 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773410569; cv=pass; b=kPUbL2x8I8RJOm0d2vywZcxstnv2tzpWuBlumjZby8v/+FNCcBxYFpfphjHVCnHJPhEIjbf/sEckpTzoCunnxbgnjT7bc23PRPoU7+9rjiEaY56iWihSMGJp5T2X5A7W6gpR0boggGE6R5TKBbQCOCUELdfhenX8acTWODGGWLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773410569; c=relaxed/simple;
	bh=a7/dI9iHAkAoxpT/Y/jlrZ1Uk/u+tnKK+1+hPiLUJTk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cvu0iloogBvGKQK5ukK33oetUATI0GOKtjABcLj1hEo1iQbWPIVW7AV8Si1x7kKgnilVOnee13wCPxjhr7VlUcdERgYDRta+wivVN71RLNxaFmn9oPv5HyjpFImGBV2GfDVtRTC2tfO6ajMXipnnK/IOjigYkc/yyBy+1TWPyfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=ObfNwz7s; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="ObfNwz7s"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-64d5a7926cfso2323774d50.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2026 07:02:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773410565; cv=none;
        d=google.com; s=arc-20240605;
        b=T/JsSs5NsdRq3aBXDGfU4RvhNs8+KCZAmN5PtjrmWqTDxxscYBntnUK/CJqk/uVzZe
         3KuHybuAMbGqntD4kHT41iBCDN3tjPeOrQovSK3VbRbnsB0m43YdMS0zXomRgUOcnpjx
         c6oRYXXkk+nwmbKg9aPWynOofvIwaNhNxLXyjMLDTzcb3GkJq/3sq53QViR6dmNuCEq3
         UE9UVcPNcxRrYok3fVFO5wFTTIt7s4+XdxMadw4vzW0TVhKPaIbE68DaHBApiFCeCElL
         L7DuqSJzy5eBZgNEHM5+19hU2UpD67zeXym5xtZSlgNDBavmk/u+7Pd3GXlKavSF8DN+
         a/rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a7/dI9iHAkAoxpT/Y/jlrZ1Uk/u+tnKK+1+hPiLUJTk=;
        fh=YEXOc2HmgMzf1wdFjWXC22ZY6MprIMRofhWjayw2RHE=;
        b=lpZgllh4hRXTlX9i4FDxs3S1yfRgnkqLD5nxJoUKtQf7t3G/A3YhF8D1tLi2bCBnV3
         AOTYGCjZIvyrF9sWuOc2kK9rdLYkwQ5Zw9HK+6qUDO2Wx5zOSTHW8MNWpd0fgF4WhWEJ
         +ycMHj1nEIjEfauvxiSiC9Hj9V5C3wFh8joK5kLv5q+dgiPnlDL/cmfp6u/lnvqHcL6G
         bnSolXsk1pxuAHBdUsRFjULF2CjvqbJWdOH55DUulhUYoCEWefRnkam4Pi9zefV9Q7xB
         Lxhl59TCqP6LeJSJ+mqr1YHruyCoansn0zVsxsqOjAyoPjhduIgZ4ilxvRjbeqS+/pZE
         4gtA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1773410565; x=1774015365; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a7/dI9iHAkAoxpT/Y/jlrZ1Uk/u+tnKK+1+hPiLUJTk=;
        b=ObfNwz7sVmzZBuIGYYUHNiLCrYOnrj8c6jSXCTXbQttafWQ6iigv2iFCUWBaoiYoUP
         65QJafHt+sCKkuHWwkmPoCcyygdqmYnJqwQvkPOoFp//2xTrPOAnMOEt6QHOb6B2JvqT
         uUidn8yG11+xxULj+cUGv2RAFi7xkRZfAAMzfTE8wLSqLl+bB0W1/CQna7kgFTcQ079U
         jdJDbGknVFFIGRjt+9Ia/rAPUbdCEaVBzQY/lQOSzveUUMV9JbrJZ9dM14sssdL0Veoz
         2HvOhbyl3fwXxpTdX3XOVWdJQawUfi41VBhM025fBbFm4jHJUnRUxEJqrBTBuYU1u6Rq
         p7og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773410565; x=1774015365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a7/dI9iHAkAoxpT/Y/jlrZ1Uk/u+tnKK+1+hPiLUJTk=;
        b=NX0rVifzBMSagsyiHZpZjolzP4uD6Ke4louLqcYux4TU6gmWVyCrI3ES+49pcrOwNW
         6/GZG3BMBEg35Uu6MrOzQMtYMdpiXsj0uahTYSGa7uDL9rZtFT7WNaKxD25/VVUezfS6
         2Jozi8hhBZliaosgU51simDxEHDNXQziTA9t4o/R3ddQGUkHLKJNgNKYQNJofgRdChWS
         HsbESt5GgnQZ2n9eDjEvBsa9im5JXLCyT7YgqgBFJMeBmNcbrsUFjX7NWwGacW/Jxb00
         lTLlLn0fC1tbO3SiL2GqK9+YvVUu6F8PpXwqp+FdoEq47J96CceVsiuJ+GWegF1Dmiby
         HluQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAp+HraJj5HTNiJjkhy0RflGSV7gDUbWUYW7xP9nSSmbXzHBoRk80ZEFgqZ8yIiUXv31HoxFkZP9uT@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh8ybSZqZZAqOJtbFL2mpcm/PtvCNuU+gLJ0zqwPpyLdZ4XDv1
	m21bZLyIrvsFPqcwUq3VLt5+QLMv5Cr+DqEXEcl9qanVOSsCFKF68TTPxlYJ5zavLmN2W5+bqms
	x8egH87TQ8uS24XTbfb1XdOssihD+3PFMz+igdeOaDQ==
X-Gm-Gg: ATEYQzzBkXM+5gWmhX/USn6PfIdxKlGFOPDZw9VuWMyr04EFmXKERP06koRMaZl0L7u
	Ebrl40tjkrR2ysUgvjfyPxJOcMk7ErlQ6WaMuR2Zkaasy3fld+cIlmTsjpIDpCAdo3Ogk/SKcjI
	/7AZvXLYLTX2i6DhSMhQKcL1CsjS+zvjG2QOM4hZX7Y1v4S38mylVIpFn/rtqJvMGMtU52L9U9w
	HIpyU2gDfONbmq7hCWfoArzLm4UHbDP9fP98d+xn+9jiv7GR6v3IB5kMBh+Mz/LDHfIGnky6HKn
	5C2AhdE=
X-Received: by 2002:a53:eccf:0:b0:64d:568b:bcb3 with SMTP id
 956f58d0204a3-64e62eeb40fmr2691449d50.9.1773410564388; Fri, 13 Mar 2026
 07:02:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
 <1e3c2830-765e-4271-89f7-0b6784b37597@efficios.com> <20260312112354.3dd99e36@gandalf.local.home>
 <219d015d-076b-4c80-8f63-88569115fdad@efficios.com> <20260312114041.5193c729@gandalf.local.home>
 <1becdbce-2c01-468a-bbab-42b5dea9fdf8@efficios.com> <CAO7JXPjnnruhM5oC6xMgnYaQ9efzYFqMCFiJLNM3HCQ+ZeCiJw@mail.gmail.com>
 <CAEf4BzbnfyhCqp0ne=2gRnVxp-mdGmuZwDeFRyhRYH+eDcz2-w@mail.gmail.com> <20260312130255.6476e560@gandalf.local.home>
In-Reply-To: <20260312130255.6476e560@gandalf.local.home>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Fri, 13 Mar 2026 10:02:32 -0400
X-Gm-Features: AaiRm51K5Hc3O7_rOVK2jMiMzft9bvuP5pyZ-VF_j7db91GKvyylhuGDp34sRoA
Message-ID: <CAO7JXPgHYZ9zF1HFahb2447X85YRZCQQBHB6ihOwKSDtiZi8kQ@mail.gmail.com>
Subject: Re: [PATCH 00/15] tracepoint: Avoid double static_branch evaluation
 at guarded call sites
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>, 
	Dmitry Ilvokhin <d@ilvokhin.com>, Masami Hiramatsu <mhiramat@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>, 
	Aaron Conole <aconole@redhat.com>, Eelco Chaudron <echaudro@redhat.com>, 
	Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org, bpf@vger.kernel.org, 
	linux-sctp@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	dev@openvswitch.org, Oded Gabbay <ogabbay@kernel.org>, Koby Elbaz <koby.elbaz@intel.com>, 
	dri-devel@lists.freedesktop.org, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Mario Limonciello <mario.limonciello@amd.com>, 
	Len Brown <lenb@kernel.org>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, 
	linux-pm@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>, 
	Kyungmin Park <kyungmin.park@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, linaro-mm-sig@lists.linaro.org, 
	Eddie James <eajames@linux.ibm.com>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
	Joel Stanley <joel@jms.id.au>, linux-fsi@lists.ozlabs.org, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Deucher <alexander.deucher@amd.com>, Danilo Krummrich <dakr@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Philipp Stanner <phasta@kernel.org>, 
	Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
	amd-gfx@lists.freedesktop.org, Jiri Kosina <jikos@kernel.org>, 
	Benjamin Tissoires <bentiss@kernel.org>, linux-input@vger.kernel.org, 
	Wolfram Sang <wsa+renesas@sang-engineering.com>, linux-i2c@vger.kernel.org, 
	Mark Brown <broonie@kernel.org>, Michael Hennerich <michael.hennerich@analog.com>, 
	=?UTF-8?B?TnVubyBTw6E=?= <nuno.sa@analog.com>, linux-spi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2026 at 1:03=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Thu, 12 Mar 2026 09:54:29 -0700
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > > > emit_trace_foo()
> > > > __trace_foo()
> >
> > this seems like the best approach, IMO. double-underscored variants
> > are usually used for some specialized/internal version of a function
> > when we know that some conditions are correct (e.g., lock is already
> > taken, or something like that). Which fits here: trace_xxx() will
> > check if tracepoint is enabled, while __trace_xxx() will not check and
> > just invoke the tracepoint? It's short, it's distinct, and it says "I
> > know what I am doing".
>
> Honestly, I consider double underscore as internal only and not something
> anyone but the subsystem maintainers use.
>
> This, is a normal function where it's just saying: If you have it already
> enabled, then you can use this. Thus, I don't think it qualifies as a "yo=
u
> know what you are doing".
>
> Perhaps: call_trace_foo() ?
>
call_trace_foo has one collision with the tracepoint
sched_update_nr_running and a function
call_trace_sched_update_nr_running. I had considered this and later
moved to trace_invoke_foo() because of the collision. But I can rename
call_trace_sched_update_nr_running to something else if call_trace_foo
is the general consensus.

Thanks,
Vineeth
