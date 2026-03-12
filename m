Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BC13F65FC
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 16:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773331744; cv=pass; b=FJQs5vhfAIJNInI1Z+eXVsBAkEyPEwyscT4aPR/Yzuy03YsmuVlUtbcBI6vfkeKX69Cp0iHqvrMyyyBTFPC9b/s4p8LnIHL8ILTv4tW076ZsGgo631rsvd3oTvFfVbK0FfyWEBKoFh8aN4sv5OBQEScSjtFEsQDqqTahqf/GIaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773331744; c=relaxed/simple;
	bh=/9ZhlXnE8IpHyY7rKGq8AMXoEoLmeVmAM+IAe1Oezhg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rwVM9tV12CvDAX3YFseBfOV5085cJJjZh7PkY7UydIqkCdhODDtA0Gh4guCKa4LBfl5o0NSzhzliMD4MhE9gx3+JgMHxNOR93NFc+BUfV+aAtYDb7F4HIa/WbqDmyFXpVANyF84+oskUy2qr4bD2LDp5bBV6aYcZ1Uh6nLBy9lc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=m1ki3q6s; arc=pass smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="m1ki3q6s"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-64ad79dfb7cso1479999d50.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 09:09:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773331741; cv=none;
        d=google.com; s=arc-20240605;
        b=Z3BrPS+oAk9SwNKa7JkhkNSowwFIaRJEGsaAN6QJTysjw7dRgosjXS9IvryW0yLCvi
         Bld3Ynx6UsfiToM5Pmcva12xFQvAXK8BWVE9T7LJQnXr6D5LYvjQ1rPjTMXZpnfnVlEJ
         PjcjKWSfz88N8hBq9pHQNYwJAjtaKSkbJji/H7ZJaaa3c7dbG3lOyINUxkw2OqX7b5S4
         /jYKgglvd2FMnIcgCLjAafVEGeD6rYi9uvs5dyzWDMZtKqO/pkXUUjtWsMS0wfLNp41o
         nJ1C3XZ63hTqUjun1aOQnJ4if1CWLnIKtU+Dv4LEzDyj2FswkqSmrMIeVmFazh+WI8iW
         cnyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kI5PTFr09piXXwe+dHgxbmefu5uh1N96l8rxcGpDT20=;
        fh=bWPBhuA1mOlSRIVCxfNq9l34ZLhoaB5mjtMtbN4s7jo=;
        b=ecmEQhf9+wfOZHdeNM7n9A2BA6dXRn1M/E2HXQrU8mKp5BsR8c2cMXaN3WiSJuO4E4
         r7Gbj8oF4xIre0MxKzRdPLSCc9EvsVRvR4JlzXZAdwOlOVJK6UZE+TKAYk8HKE/ODkjM
         jik8BtkJY0o+0DtcytDeSOvnnu5dL9X1YfLMqrg2UfD7OS/AcjFY7oB1zi9sUDrf6N4e
         4WbBUop1aQCE4XlQKa2r5ynrHAJx+VaIyPbeVUueIfk7+VgqrxsYTH4Y2t1WDGZPqo/f
         fV1jG3RqjO4MB85YMpRl33eZWPT8dBWpRf4AA07Ncvj6VY+9gomtLkPJedLTcau8batT
         K/jQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1773331741; x=1773936541; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kI5PTFr09piXXwe+dHgxbmefu5uh1N96l8rxcGpDT20=;
        b=m1ki3q6sM4E2UACesTTqdadtI+Q0abqlUwfIdHI+OjmsRX2whEFMpQZptypVWhQx7h
         QD04yZlyfzP3xSivF9scjOrX5/FKYwiLrKA2X7JGefZSd1ksKzyMr15sFt8BUlBtCA1S
         qJU7H/z8w1uO+F9Lf0dqC/P0kEVsXjabxHZfvBx9uTBgICn+qEBxH7rHMoE2jVFa285u
         ZgHMmgqvOB2dgKagDrzwCVgXrpWT6UXW/+5qlE/3A3PliRynwsbURLgRm9zWpjrvx8vj
         l50ZunSLyn6Bt2c18cyLVOhmld8Lw2f3Z/Tl83A9P3MTDzd0bDNTqIw9vU+Apak8seEn
         KC5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773331741; x=1773936541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kI5PTFr09piXXwe+dHgxbmefu5uh1N96l8rxcGpDT20=;
        b=iq1jW0J/GN4wN6cxAXn9qn//ET/Sz+azWKkJIkYOxaLOPdjC9Zs8PaDFIXH+wJmodT
         tZ3QpQaoxJb6trJTC021fFESZ3w4ZghWc7yNEzF+odx6ZsiUIisD73a75yjaNvBkLrD/
         q7asijVgCf2s0972X/NIe6ZqZ0qzcNw04/maZCYMYx9BaAwA/B1UdQi3aTreI+VoYWg8
         xLfj9ELzLuars5roGJs7aFwOGcYci74ABfZWu7HdivykEbE8ADVoSm0oHW88lxN1Te2G
         w7VbZAd89aLrwq0ujfoI3IJ8hN8OqnNg7TpCtRn7vzxy62TubaKsZXNb/LntmZAdjemJ
         gAaA==
X-Forwarded-Encrypted: i=1; AJvYcCULH7EDSAsHvmLoHWGQ3pek7UTiSitCnGgAIKHd9LcTk0BTqWzQoVU3CjT11LsXYjtBDoBEW99Y0+Vz@vger.kernel.org
X-Gm-Message-State: AOJu0YyZQ/9wujEcz8Eiz1V+Se4e7xAgvIsnvuEI3xeFmSA+qk9iOCqW
	tSA8lqQHOnPCSlWox1Vd4bAzCzKQ6aZQxLWnwHMecw2Mo2x7c5l1JGf1gklc8ylRYbrGYZktgAk
	l2Q+2qA4fOo3rurQJ67w8vkff9dGAdy8pZj4V5WffLQ==
X-Gm-Gg: ATEYQzxyYqDTiazyKrLuOoAK0fKouZ5JrNhieSf0zDwt8d/yqz3jcajtuPhHXCzqpQ3
	2oDZUQyBGFUTLQF4vGvHV1suJaZb+EcpM7gALTXpihd93kN7wONaqZWe5kP0WhkpcjSNHvw3gwU
	F0k/QfoGPqn5lTNbvI2bMaJ0LOZBKcknJe3E7d26OIA5N36mDpbO6ISH0b4p/74mz7igBUK/yB0
	DlJb1t7gQEZXeIfSpl86GzPFIXrf08azVZtdSbs/6yI7U8itzCpZei8dqDrxzILsl4sPZ0lEVf4
	h7nZP4k=
X-Received: by 2002:a05:690e:448d:b0:64a:e799:1d9c with SMTP id
 956f58d0204a3-64e63079bb0mr62693d50.60.1773331741406; Thu, 12 Mar 2026
 09:09:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
 <1e3c2830-765e-4271-89f7-0b6784b37597@efficios.com> <20260312112354.3dd99e36@gandalf.local.home>
 <219d015d-076b-4c80-8f63-88569115fdad@efficios.com> <20260312114041.5193c729@gandalf.local.home>
 <1becdbce-2c01-468a-bbab-42b5dea9fdf8@efficios.com>
In-Reply-To: <1becdbce-2c01-468a-bbab-42b5dea9fdf8@efficios.com>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Thu, 12 Mar 2026 12:08:49 -0400
X-Gm-Features: AaiRm50l09G2avZYKQas6kLTqrDst8ZjnHTnngudy3h6MyVa79lzABXaRh3Trz0
Message-ID: <CAO7JXPjnnruhM5oC6xMgnYaQ9efzYFqMCFiJLNM3HCQ+ZeCiJw@mail.gmail.com>
Subject: Re: [PATCH 00/15] tracepoint: Avoid double static_branch evaluation
 at guarded call sites
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, 
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

On Thu, Mar 12, 2026 at 11:49=E2=80=AFAM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> On 2026-03-12 11:40, Steven Rostedt wrote:
> > On Thu, 12 Mar 2026 11:28:07 -0400
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> >
> >>> Note, Vineeth came up with the naming. I would have done "do" but whe=
n I
> >>> saw "invoke" I thought it sounded better.
> >>
> >> It works as long as you don't have a tracing subsystem called
> >> "invoke", then you get into identifier clash territory.
> >
> > True. Perhaps we should do the double underscore trick.
> >
> > Instead of:  trace_invoke_foo()
> >
> > use:  trace_invoke__foo()
> >
> >
> > Which will make it more visible to what the trace event is.
> >
> > Hmm, we probably should have used: trace__foo() for all tracepoints, as
> > there's still functions that are called trace_foo() that are not
> > tracepoints :-p
>
> One certain way to eliminate identifier clash would be to go for a
> prefix to "trace_", e.g.
>
> do_trace_foo()
> call_trace_foo()

This was the initial idea, but it had conflict in the existing source:
call_trace_sched_update_nr_running. do_trace_##name also had
collisions when I checked. So, went with trace_invoke_##name. Did not
check rest of the suggestions here though.

Thanks,
Vineeth

> emit_trace_foo()
> __trace_foo()
> invoke_trace_foo()
> dispatch_trace_foo()
>
> Thanks,
>
> Mathieu
>
>
>
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> https://www.efficios.com
