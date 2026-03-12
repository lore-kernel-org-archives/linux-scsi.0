Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E4337EFF7;
	Thu, 12 Mar 2026 15:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773328397; cv=none; b=SZNUPr0edZ8GVddEQD74HKkdnuQCWeOUmcOGTC2j0Hk9D9EIRd6y+ETpMWoxHQsWH6Jq/C5/wXq3N0ZFdZ8qigXt21o16kdTsL9BezeEXSNOkInOoMhg7qJvlC+EKi0OrJUzgcL0Amr57M9lYldAf/mBEgHi0frYH0dIIjw/iNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773328397; c=relaxed/simple;
	bh=6LNvill1oGCkrCI5IjXFokv4VeOiR/NDrtJjTtOGtYc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R/RK37M8OdfYAhG+v6FfIwWubp05OZfV3k0zt1xUsapSR5mIR/lCp7vGacwc+EBDb+AEZM45mx16BCJgpoEq5Yl0+z5hQTWdmzmMBvX0izH8jmqRPIwJBK0juXtUEiOEqZRnpwag8Gb+6qp06aLrqqI4MzthbvjowsE579lxsZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF4071B72E8;
	Thu, 12 Mar 2026 15:13:07 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id 78D742002C;
	Thu, 12 Mar 2026 15:12:41 +0000 (UTC)
Date: Thu, 12 Mar 2026 11:12:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Dmitry Ilvokhin <d@ilvokhin.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, Jens
 Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Marcelo Ricardo
 Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, Jon
 Maloy <jmaloy@redhat.com>, Aaron Conole <aconole@redhat.com>, Eelco
 Chaudron <echaudro@redhat.com>, Ilya Maximets <i.maximets@ovn.org>,
 netdev@vger.kernel.org, bpf@vger.kernel.org, linux-sctp@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, dev@openvswitch.org, Oded Gabbay
 <ogabbay@kernel.org>, Koby Elbaz <koby.elbaz@intel.com>,
 dri-devel@lists.freedesktop.org, "Rafael J. Wysocki" <rafael@kernel.org>,
 Viresh Kumar <viresh.kumar@linaro.org>, "Gautham R. Shenoy"
 <gautham.shenoy@amd.com>, Huang Rui <ray.huang@amd.com>, Mario Limonciello
 <mario.limonciello@amd.com>, Len Brown <lenb@kernel.org>, Srinivas
 Pandruvada <srinivas.pandruvada@linux.intel.com>, linux-pm@vger.kernel.org,
 MyungJoo Ham <myungjoo.ham@samsung.com>, Kyungmin Park
 <kyungmin.park@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, Sumit Semwal
 <sumit.semwal@linaro.org>, linaro-mm-sig@lists.linaro.org, Eddie James
 <eajames@linux.ibm.com>, Andrew Jeffery <andrew@codeconstruct.com.au>, Joel
 Stanley <joel@jms.id.au>, linux-fsi@lists.ozlabs.org, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alex Deucher
 <alexander.deucher@amd.com>, Danilo Krummrich <dakr@kernel.org>, Matthew
 Brost <matthew.brost@intel.com>, Philipp Stanner <phasta@kernel.org>, Harry
 Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>,
 amd-gfx@lists.freedesktop.org, Jiri Kosina <jikos@kernel.org>, Benjamin
 Tissoires <bentiss@kernel.org>, linux-input@vger.kernel.org, Wolfram Sang
 <wsa+renesas@sang-engineering.com>, linux-i2c@vger.kernel.org, Mark Brown
 <broonie@kernel.org>, Michael Hennerich <michael.hennerich@analog.com>,
 Nuno =?UTF-8?B?U8Oh?= <nuno.sa@analog.com>, linux-spi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Chris
 Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] tracepoint: Add trace_invoke_##name() API
Message-ID: <20260312111255.7925b4e2@gandalf.local.home>
In-Reply-To: <20260312150523.2054552-2-vineeth@bitbyteword.org>
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
	<20260312150523.2054552-2-vineeth@bitbyteword.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ywcbaqn9zwge3gfga96u97w7nijzfb5x
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 78D742002C
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18ieAMVXlCsjfIHQB5VYSMKQawnv3xLXWM=
X-HE-Tag: 1773328361-302890
X-HE-Meta: U2FsdGVkX19212n5hf5VfWxxI3698ig+MYJ7h5PCrgzm7w3SBjXRVmntUgy1KAiA1j7ASoLiubrJUkhEQG+sVPUaqYvKVHrwHJfLEWqAblPMb1GCyB1vNtgXBTh0V0ySDjWK4c33hpSt6/UqWv2L0DWGvadPudlZSBYs0RHFEdqFbOLNYrAcOZsPRKT15ByTEqCfDyAmN0Qx4BlSkuaDuqx2DqlJVWxM1GIGcenYfKc4Oug4F+oj89fFXccHcftI8mvLFhHknaGUAcf5v6epx6ogBFZcEEfmCJxjXwE/1rjNLuPMol8FZX9cbSBPAiHoHDFNAmrC3azhj+xd+IQ9/nDUnOF7z/s7bbkZPpL2MZx7bw+9cK59bCAAmgXFQUGvGdwUDjf+aJ99jx8W6XuzQvGWj1cuLtlykLy1hAkh57CyBpLZSVzGcIlLV0+qfGz9ZsIFZ0fPg4pdG4v8JMXapSh4ZRe71DXAUeEQ5q5ubssZsWB5mqjTVA==

On Thu, 12 Mar 2026 11:04:56 -0400
"Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:

> Add trace_invoke_##name() as a companion to trace_##name().  When a
> caller already guards a tracepoint with an explicit enabled check:
> 
>   if (trace_foo_enabled() && cond)
>       trace_foo(args);
> 
> trace_foo() internally repeats the static_branch_unlikely() test, which
> the compiler cannot fold since static branches are patched binary
> instructions.  This results in two static-branch evaluations for every
> guarded call site.
> 
> trace_invoke_##name() calls __do_trace_##name() directly, skipping the
> redundant static-branch re-check.  This avoids leaking the internal
> __do_trace_##name() symbol into call sites while still eliminating the
> double evaluation:
> 
>   if (trace_foo_enabled() && cond)
>       trace_invoke_foo(args);   /* calls __do_trace_foo() directly */
> 
> Three locations are updated:
> - __DECLARE_TRACE: invoke form omits static_branch_unlikely, retains
>   the LOCKDEP RCU-watching assertion.
> - __DECLARE_TRACE_SYSCALL: same, plus retains might_fault().
> - !TRACEPOINTS_ENABLED stub: empty no-op so callers compile cleanly
>   when tracepoints are compiled out.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> Assisted-by: Claude:claude-sonnet-4-6

I'm guessing Claude helped with the other patches. Did it really help with this one?

-- Steve


> ---
>  include/linux/tracepoint.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 22ca1c8b54f32..07219316a8e14 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -294,6 +294,10 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>  			WARN_ONCE(!rcu_is_watching(),			\
>  				  "RCU not watching for tracepoint");	\
>  		}							\
> +	}								\
> +	static inline void trace_invoke_##name(proto)			\
> +	{								\
> +		__do_trace_##name(args);				\
>  	}
>  
>  #define __DECLARE_TRACE_SYSCALL(name, proto, args, data_proto)		\
> @@ -313,6 +317,11 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>  			WARN_ONCE(!rcu_is_watching(),			\
>  				  "RCU not watching for tracepoint");	\
>  		}							\
> +	}								\
> +	static inline void trace_invoke_##name(proto)			\
> +	{								\
> +		might_fault();						\
> +		__do_trace_##name(args);				\
>  	}
>  
>  /*
> @@ -398,6 +407,8 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>  #define __DECLARE_TRACE_COMMON(name, proto, args, data_proto)		\
>  	static inline void trace_##name(proto)				\
>  	{ }								\
> +	static inline void trace_invoke_##name(proto)			\
> +	{ }								\
>  	static inline int						\
>  	register_trace_##name(void (*probe)(data_proto),		\
>  			      void *data)				\

