Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA763EF0D6
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 16:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773331550; cv=pass; b=q4rWRub2764s+biHiU2JLjg/DZttv3z+MSwHbec+EhHISDw0fhLwoSmYY+I577gloIAIGQVxMve/dEHHqFAwpz55Cv7gQjh8jEhmu22zISLxI0GmOcBWFGA5GSGn6B2JH01uX0npK1plrcYkONhvRZFAaCZYTovlOctznJo1+CM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773331550; c=relaxed/simple;
	bh=uXwIo7R/AWmUX8v9NfNe8o8eyYKkzsQlLFxRYRKmo54=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RM/bVwwtBicSPeYUXyy1BVl7kBm0K8phGDB00u6Q+UTC7et3jxkaveKGZPT+2pq1GgcMjOJGhmS4XlFYBSrps5t9IWp41f+cpTKlGd2iOKmnNdrhH7awiDtBoA218pLmLbkYctgKpZXuYz2I4AgLARTa2GvNbdBxypFYfxuKqYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=ZV71t7Yr; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="ZV71t7Yr"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-64c9c8f8783so1433665d50.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 09:05:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773331548; cv=none;
        d=google.com; s=arc-20240605;
        b=j9hriz5AK9LuWHpizk6HxqrFezcR+AwwWj55l+6gITCbhw/LXhxMwPyvV0Srh7Paj9
         3kE7meTeNjlW8l4sYOY+QtPJRqlWHos6OZJK2QCDu4YkeM3baJXxXwAbKXOk4sppIO9n
         A/1hNl+ZaXF+rmKovE+eshaPUSmouIc+E8ypvDnlOwPGOztKFBBVqYMZfkXqqrqEoNZl
         ayTNfYYQDh2pYovIXRgg/D5LxDfWV9dH7VixdM7KfZtfPLoAgz73QHKdyJ/ccdQc94xu
         ErfbA+kzpiRtKt60AK0iCiLPupRuDd+vkq2o9st8MYC/Fj3nSj7zySwuq/t231Cg+MlV
         sy0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JmKlkavBf/yAOF4s82cTsdoYBcDg+c1w7g0d5bSER7o=;
        fh=optKwakWubdrJjGvzIvx++679srmai+7iuZ+AFZ1gQ4=;
        b=RUyAc+EoqkziTDLmcZoKkwmCru3hpHGuQe7AbfD5Xi68nR+zKxoxnm89QNx+sLJQ4p
         koj43tK+JD5+YdZ1xQv7bfFFE8CEO8daQKB0AVbUUkdv4WRhJXpE5y9f9L0+esXf8Mhq
         QgIPx+/ydXeWxY8IAQej98QHo5XIlVgRV9z5DyEFJjEqt83GUyLwUEVDbFq2cLIs0dzz
         rUQLDNFQSW1bNbF95p/eNRw6xi0IFFpBXw47jBlVphLDid/Hm1e9RoVrXM1JTCr7up6Q
         Og9AMC0gsTqw1bxxVDJgw9cAtMdVNJX6ah1unTmP5tW0gg3BMRWdDFHyFghoFdLO0TzA
         94rg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1773331548; x=1773936348; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JmKlkavBf/yAOF4s82cTsdoYBcDg+c1w7g0d5bSER7o=;
        b=ZV71t7Yr1bKEaCrw5G92Jfwsdtqtd7yVBewYsWTdMu4hlPrngoMiOi9Tg98BUXGj7V
         J8zfT8WZvuSQVQoHqLeSQshOj58obuQHxEJH3i8/pbu12eU6C7Ce24M/UJLLYQE6Gyj4
         MBJKDgq3YAhHELLZd+5LiW+wYl057MgHnzcIvUsegkYPkvlEfdww7dLPjrHlDmsadUdM
         wSRYkiv5Ntk9U+9jkH4To9xPIEAmJ9iWvbmxM8yMdXibURUG9CU4usIPwIAMNK/zJ+LU
         w3EzMZjLrprjIUB0o8QsaOC68H8pgsKxw2R93SbRJDixW4oABx/etf2ISufqJ1uZrO5X
         OKgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773331548; x=1773936348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JmKlkavBf/yAOF4s82cTsdoYBcDg+c1w7g0d5bSER7o=;
        b=W/cFYk9OSWDQ9vnJiOvanvvr6H8Esc+iPfhXz30P1leaCuT+I7OeP0ZE73z+AJmySH
         F8TC0TcKtecpfQcAQ3QhCgSXA7WofKAg2+MfhOht//TesDPjXCOuqmBv4OXcpN5G5o+w
         c1Nfdj0+DfiB259Dm53VFxeAnGfVq7+nSKOgl7QNRm20Iy7Dk8JNWtAN9JOPgZeyzp8v
         WkNyar18VgHg4UQv+3RZ1vlmIm+1hX+WZrAj0IAwegD7itxdhnx3uF7B0GmdZg0cc1lo
         jA/JwWW4wXDAxA+/TbAw8auRyOGwC8Kq/jMkOUPCTvW/B0WNKhQWK7b3neFN1QhZ57nV
         gW+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXxwqaGTHsz1jeARK2BuiFBfHvLkVlvIOFdIUd0boCcuL3y83pnAqHvxx8jplVnNB5mPxPF+kWzKVeM@vger.kernel.org
X-Gm-Message-State: AOJu0YyRlYvi4M9e4ZMCTcpmKXFjCUUr9hcmue4+u3Kbnaf4L68N0e7P
	O0mbTA35RN7RiAbRGkC4E1s+hAYeP6Mg0BcMoP9RD11s/SrLPao597NMtgZHB/ZoTMjrwmk7ii2
	PjU0p3mfEf5WBD9fhpKuFJVyLyfC/qoDRZtX3BYoZwQ==
X-Gm-Gg: ATEYQzyzRH/BRtso1ub3IL9mx43GWKVvBZrTtne8VMGpv5jIWXes5l/mxunY59kSPXs
	ZQ0VdDsLp38K6nhZYewUnkhuBrpJs0+/2jt7j4yRcsjejYmDsXH+fyeJjxaoQE/HNSmvP6b5XL4
	CHnONUzvERmKvhYcU2GiRISjIytjrwEyMhr0ZePpeknR4C1UMFhqVSinOe9fGCBwu0iCUVyEB5O
	LgGrTLLtXdSk25LVsquiESMkaXYGNfFWNrWtU8TDdqAIK6ogTVJZwTqApz7IEdqKw+u5PY43tES
	vJSLbpA=
X-Received: by 2002:a53:df06:0:b0:646:9ddf:5f2 with SMTP id
 956f58d0204a3-64e62869514mr137952d50.31.1773331547890; Thu, 12 Mar 2026
 09:05:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
 <20260312150523.2054552-2-vineeth@bitbyteword.org> <20260312111255.7925b4e2@gandalf.local.home>
 <CAO7JXPhg-Etspj9YahZrq8cmZ2K6AGWDrMnHO+oD96P_SmOLBw@mail.gmail.com> <20260312155326.GB1282955@noisy.programming.kicks-ass.net>
In-Reply-To: <20260312155326.GB1282955@noisy.programming.kicks-ass.net>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Thu, 12 Mar 2026 12:05:37 -0400
X-Gm-Features: AaiRm52SVVT4jiV0FzOGXISct6FMh2E9oWpuKL1FA2qkv7l8yLE2a6rVIE8wyUY
Message-ID: <CAO7JXPiu8-LE_gG001_GQLoGVYakPdzmH2SXLqfzJjEUxbn1Rw@mail.gmail.com>
Subject: Re: [PATCH 01/15] tracepoint: Add trace_invoke_##name() API
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Dmitry Ilvokhin <d@ilvokhin.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
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

On Thu, Mar 12, 2026 at 11:53=E2=80=AFAM Peter Zijlstra <peterz@infradead.o=
rg> wrote:
>
> On Thu, Mar 12, 2026 at 11:39:06AM -0400, Vineeth Remanan Pillai wrote:
> > On Thu, Mar 12, 2026 at 11:13=E2=80=AFAM Steven Rostedt <rostedt@goodmi=
s.org> wrote:
> > >
> > > On Thu, 12 Mar 2026 11:04:56 -0400
> > > "Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:
> > >
> > > > Add trace_invoke_##name() as a companion to trace_##name().  When a
> > > > caller already guards a tracepoint with an explicit enabled check:
> > > >
> > > >   if (trace_foo_enabled() && cond)
> > > >       trace_foo(args);
> > > >
> > > > trace_foo() internally repeats the static_branch_unlikely() test, w=
hich
> > > > the compiler cannot fold since static branches are patched binary
> > > > instructions.  This results in two static-branch evaluations for ev=
ery
> > > > guarded call site.
> > > >
> > > > trace_invoke_##name() calls __do_trace_##name() directly, skipping =
the
> > > > redundant static-branch re-check.  This avoids leaking the internal
> > > > __do_trace_##name() symbol into call sites while still eliminating =
the
> > > > double evaluation:
> > > >
> > > >   if (trace_foo_enabled() && cond)
> > > >       trace_invoke_foo(args);   /* calls __do_trace_foo() directly =
*/
> > > >
> > > > Three locations are updated:
> > > > - __DECLARE_TRACE: invoke form omits static_branch_unlikely, retain=
s
> > > >   the LOCKDEP RCU-watching assertion.
> > > > - __DECLARE_TRACE_SYSCALL: same, plus retains might_fault().
> > > > - !TRACEPOINTS_ENABLED stub: empty no-op so callers compile cleanly
> > > >   when tracepoints are compiled out.
> > > >
> > > > Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> > > > Suggested-by: Peter Zijlstra <peterz@infradead.org>
> > > > Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> > > > Assisted-by: Claude:claude-sonnet-4-6
> > >
> > > I'm guessing Claude helped with the other patches. Did it really help=
 with this one?
> > >
> >
> > Claude wrote and build tested the whole series based on my guidance
> > and prompt :-). I verified the series before sending it out, but
> > claude did the initial work.
>
> That seems like an unreasonable waste of energy. You could've had claude
> write a Coccinelle script for you and saved a ton of tokens.

Yeah true, Steve also mentioned this to me offline. Haven't used
Coccinelle before, but now I know :-)

Thanks,
Vineeth
