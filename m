Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1477339183E
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 16:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773334485; cv=pass; b=P4JqQdRCkCWE/iq/ttBNIKgCtYhd067GEf8gMBdkXwczerEEeskYEB0Az0MusZooP/AZ8GuLHTSFExCJBh/FfVxbfLs27RDerB0G2AQQxujV9qFRaSpNkQ/oNJAoo446QEv6flARBQCcGl3ac80/ZH8BOjX/CrgtzKGG4/CF2BA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773334485; c=relaxed/simple;
	bh=0ivvtg/7i339ZQR+9yPgWn9tEIiWD5JfW0IrpKNu4D4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b3YCi91R+5bAnc3pO4T1k1sqdm2NvLO7xWR2id8mjQfOVChpkFBZjo/iyIetrF3ldqR6pSvKuFUVO4njV3V4HC7pljs3R89lS8XGpV6/+piZ5MEZX9iFdQeT9lZ4rMBLQEHdH6PKoFAK/IVXgY711K9FeSEBJZpdua7B9HBljtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kFrQITnb; arc=pass smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kFrQITnb"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35a1dd9c842so316914a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 09:54:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773334483; cv=none;
        d=google.com; s=arc-20240605;
        b=Lw9Gy1L0+dh8CujW8V4v51JVV4xMnXLrhTiiOEwdF5nfXS6PY29S6m57zrMSYL7ScK
         MQ6Lg2Cb5f3CZhEZ7izuMJGpxp2YdZaMynWPURntpatlHXIgo0mDCknHmypf14fLBL6R
         HhuTGtA1LrwV7pMCiG9xI93rxkVvp9JYTws0ouEr+36RO9IQWr/ktOSO1Qvh9mA0ZjYA
         ILdhU2e4dF8B/Zsd57CYRD6ycuFWiu1A8eMBF7hWrX/KpGIqTriiDq0ISkir5HHJL2kl
         dDT1l5S8+rtGL6kUcZtLTwaS2B4NTcYhhOktJY9rcg0RNvr5eXFw5d0hXHXh62ksS+T9
         ORYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+kWy5KRAZzJ0k+gfnUe4+KiD3cukw8nZMNARL7dWDnQ=;
        fh=sqUjPtyiftrk2oxeEYIjWmDvc2IZ6tKfUqhxdQza9hI=;
        b=HN7JjaF4HLm/T6cCt3NifiR65nyKgVNPUrD4YEKAdJ89Fwywgq9By8lqRQlO4JI4Ie
         KhgpTklsXSPt9YrcEJc/gLDVvN3WBB63SN/cWHoT7ZcgLoVKqCSVOImxbnRVQGBsG/k2
         f+mmv1vIw+Lpd88fHxjRagt96RoLi7DvnK1t/mwlWQpJiDGeE9FleHYXeLltCkRdC4lf
         qmdc3YUQyCQ67TX0fdMIv76zjFD6M1NZbO6iVqmz+u7HbVE90oQDUW//r3xp9vhT+8ae
         MMIZs0LwnZNagX7Dto4qjRD/Fl8MombWs4MnbSW+1pbqeQUj0ZmA3uQV5UhCxgoLHqZT
         Y3QA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773334483; x=1773939283; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+kWy5KRAZzJ0k+gfnUe4+KiD3cukw8nZMNARL7dWDnQ=;
        b=kFrQITnbSdq6fGGAo1Qs91MmVTz356ySgdYWMhoXz+qDA2sI5h/kKKPobud1lef9Qq
         Vnjg2VUjWxY13G90CmzMMLIGG1mhAwthMdOZYeJon+O+0g87Kr6AJ417GKQwYBg4ntGg
         crbqh1wylitW5W3iDY0c9cFEY7XSz1kk+X6ijp5ETi+DfQfNFfcOE0+jm8SyHkpkeZCH
         z7cnWY15WdETUtxAXisuTIbTwonAFvkgAQR0r46HDiAaLCOdaFl6hAZomSDbAEI+l/d2
         UjnUvLY2rcGWyZPKGUWcqGXGW+Udo+G6jXAxvhMluPCc79Lf1wiRS3jOdfepdDepHnRM
         dA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773334483; x=1773939283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+kWy5KRAZzJ0k+gfnUe4+KiD3cukw8nZMNARL7dWDnQ=;
        b=CF6sCO7YKXetEzOn0aA2djU5NfFgsHY+HlxK6Ih17pJxs/vo36Zg7znJroaABdDfFP
         tQDo65ZDjI4FL5g4m96ea6STrbdRLoAIaTvWwzr07TTyzc0Igrj1SAnK3Tz3+9sFmLYt
         vWopvD75Vb5qkaR6DzXfM5OFQFUUqaXZmKMi7exoewDOxJrolZ8wc5Rbl4+w8lHb7ulP
         6OPESxKH77J1xQtQydO3ctxr03pmJQi3nmtlOqwwcmkUztRGAf+kJr6E5HNcqVOhMmQU
         hUfKGS+sjdb8vKVVar7rm3j3Vqt/+cXddLcIBQaPY7DcXUD7M+gkOMsX1bRI3x8/5dtr
         ehFw==
X-Forwarded-Encrypted: i=1; AJvYcCVVf7l/94mZ96BHZ1bAac+64LSKPqU7vO+L3KBhNCJonxkZQ7N8D7Ott4LA+dRcOooBP9b9e1zdaEp7@vger.kernel.org
X-Gm-Message-State: AOJu0YwVDIuGfl5XAw8tlEkgKglq4XBhO4OcElE2yQDF2p2fJ8xCbaDD
	XqUWGFcplhBmiWoqQmp/UD9veVE3lUMLavbLBpayJWxUFOfQAvbS6r9qo1j/rTYLLzS428MAGCZ
	2u+hyPR7fd7hey+Arj2iuKH+RdUOW2eo=
X-Gm-Gg: ATEYQzx7QQ3AQ2El22XCz0DIqS8gbJq+cVZo3qhC1mCpxysh7hKB4FeTW/p9DWVjidb
	5OfO2xCWcJvszRuOxgOUBmPs0R5a/yNh26mJSk6ON+RLDwNFTAX4I9pIpLgvx6FL4K1RGOn1+O0
	3Qa/Y5KSAgzaz6lYrHgcfEsbBzpgSnG1auSq/wZobgxpJUTqBON0KZ7nS3bvrY26PSMPscsdXJi
	lGy6qHDO3V1WuW5VwEEcFD3RfMrjetpkNlDR8Ssbnl+hN4pdVsGW5nBLJ8mdG3M0LwGzMloHi/6
	ks7YCfNgmBnnFU3Pv7npG1A=
X-Received: by 2002:a17:90b:288e:b0:359:8d0d:5905 with SMTP id
 98e67ed59e1d1-35a21eba194mr250522a91.9.1773334483388; Thu, 12 Mar 2026
 09:54:43 -0700 (PDT)
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
In-Reply-To: <CAO7JXPjnnruhM5oC6xMgnYaQ9efzYFqMCFiJLNM3HCQ+ZeCiJw@mail.gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 12 Mar 2026 09:54:29 -0700
X-Gm-Features: AaiRm51tg7oVvkVGab0X55k0oYxIuUltKNvtNsrbO-Cw57of2y67mwv1ziUvJS0
Message-ID: <CAEf4BzbnfyhCqp0ne=2gRnVxp-mdGmuZwDeFRyhRYH+eDcz2-w@mail.gmail.com>
Subject: Re: [PATCH 00/15] tracepoint: Avoid double static_branch evaluation
 at guarded call sites
To: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Peter Zijlstra <peterz@infradead.org>, Dmitry Ilvokhin <d@ilvokhin.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
	io-uring@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	Jon Maloy <jmaloy@redhat.com>, Aaron Conole <aconole@redhat.com>, 
	Eelco Chaudron <echaudro@redhat.com>, Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org, 
	bpf@vger.kernel.org, linux-sctp@vger.kernel.org, 
	tipc-discussion@lists.sourceforge.net, dev@openvswitch.org, 
	Oded Gabbay <ogabbay@kernel.org>, Koby Elbaz <koby.elbaz@intel.com>, 
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

On Thu, Mar 12, 2026 at 9:15=E2=80=AFAM Vineeth Remanan Pillai
<vineeth@bitbyteword.org> wrote:
>
> On Thu, Mar 12, 2026 at 11:49=E2=80=AFAM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > On 2026-03-12 11:40, Steven Rostedt wrote:
> > > On Thu, 12 Mar 2026 11:28:07 -0400
> > > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > >
> > >>> Note, Vineeth came up with the naming. I would have done "do" but w=
hen I
> > >>> saw "invoke" I thought it sounded better.
> > >>
> > >> It works as long as you don't have a tracing subsystem called
> > >> "invoke", then you get into identifier clash territory.
> > >
> > > True. Perhaps we should do the double underscore trick.
> > >
> > > Instead of:  trace_invoke_foo()
> > >
> > > use:  trace_invoke__foo()
> > >
> > >
> > > Which will make it more visible to what the trace event is.
> > >
> > > Hmm, we probably should have used: trace__foo() for all tracepoints, =
as
> > > there's still functions that are called trace_foo() that are not
> > > tracepoints :-p
> >
> > One certain way to eliminate identifier clash would be to go for a
> > prefix to "trace_", e.g.
> >
> > do_trace_foo()
> > call_trace_foo()
>
> This was the initial idea, but it had conflict in the existing source:
> call_trace_sched_update_nr_running. do_trace_##name also had
> collisions when I checked. So, went with trace_invoke_##name. Did not
> check rest of the suggestions here though.
>
> Thanks,
> Vineeth
>
> > emit_trace_foo()
> > __trace_foo()

this seems like the best approach, IMO. double-underscored variants
are usually used for some specialized/internal version of a function
when we know that some conditions are correct (e.g., lock is already
taken, or something like that). Which fits here: trace_xxx() will
check if tracepoint is enabled, while __trace_xxx() will not check and
just invoke the tracepoint? It's short, it's distinct, and it says "I
know what I am doing".

> > invoke_trace_foo()
> > dispatch_trace_foo()
> >
> > Thanks,
> >
> > Mathieu
> >
> >
> >
> > --
> > Mathieu Desnoyers
> > EfficiOS Inc.
> > https://www.efficios.com
>
