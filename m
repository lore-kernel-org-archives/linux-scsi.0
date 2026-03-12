Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600A73218DD;
	Thu, 12 Mar 2026 15:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773329053; cv=none; b=cb8qOq67rqiZQxV578I8pkQv7tZBnWuklLo5tEDEOcRnEUwJgf6/uQerlEFg2dKwsA23nxP2jhH0o/JWRMP1P+WsZawOjdXG2dt0lT2Bc04gTEAmj47LuOkpJLxWL1+Zy7XvD3k+BhtRqFmjrF75v+IXHpwBt6PUx4iirNwNov8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773329053; c=relaxed/simple;
	bh=sytxWOkyDIIeHX5CMaw9a1LerCjjFeV5ZrZULOHHkHE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eM1BHZwlq502mCNheCYMt1io97d/3/dKuHq3cMGA2MrcfkyQFTBCbreDEdyzXifHxLU4NJIYVQPFZN9x0AKM5PbSUJSomDrtQjEPU+8mU5G7nKVrtAq8gNBp9DitkYe3TNI5ikysoJmdpuj68NzV0sbY2wmFdGmsA/y6/eBRYBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 37E651A01EF;
	Thu, 12 Mar 2026 15:24:06 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id 087CE60010;
	Thu, 12 Mar 2026 15:23:39 +0000 (UTC)
Date: Thu, 12 Mar 2026 11:23:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>, Peter Zijlstra
 <peterz@infradead.org>, Dmitry Ilvokhin <d@ilvokhin.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Ingo Molnar <mingo@redhat.com>, Jens Axboe
 <axboe@kernel.dk>, io-uring@vger.kernel.org, "David S. Miller"
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
Subject: Re: [PATCH 00/15] tracepoint: Avoid double static_branch evaluation
 at guarded call sites
Message-ID: <20260312112354.3dd99e36@gandalf.local.home>
In-Reply-To: <1e3c2830-765e-4271-89f7-0b6784b37597@efficios.com>
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
	<1e3c2830-765e-4271-89f7-0b6784b37597@efficios.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h3739pmr1eu9bg7iohjao1rrs3tokc6z
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 087CE60010
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18y4imWQ5s/jJLRD+ifAQxkW+/MJIrfF8g=
X-HE-Tag: 1773329019-951038
X-HE-Meta: U2FsdGVkX19VCvtnyeXLm8RYcE/0528Of+u4uh+xWXIoIUAMDgzoBtHgAKGT8nAF/MB27RV3F/HBU7N8Yq3nctz4CjyozsdN+JtQpjXgcPgQ91Udi/zn6KJIrxNJApkTGgQNfwjA1AIJPhvzXyH3aMyWbdyoGtBKFOnq4RRJYVOvsob0d/ffWToVP4J5RUsRMz0qpdmi3Iljf9FrVu7POde112UEVgFi8OQXvPdVYuTecw25DZQQ5ipeWXW6Kr0xXH7b2TXafPsVNaEyw+eNEKMINQbygT33slpoLqfF/VxxC3FTWBQ/CxruNZ4auDV5bvilUFV4TL+gv3A/9X1r2mUEs0jEp6JnA2gRI3WDauIvML8TIfmFKXYkIboJC7/W

On Thu, 12 Mar 2026 11:12:41 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> >    if (trace_foo_enabled() && cond)
> >        trace_invoke_foo(args);   /* calls __do_trace_foo() directly */  
> 
> FYI, we have a similar concept in LTTng-UST for userspace
> instrumentation already:
> 
> if (lttng_ust_tracepoint_enabled(provider, name))
>          lttng_ust_do_tracepoint(provider, name, ...);
> 
> Perhaps it can provide some ideas about API naming.

I find the word "invoke" sounding more official than "do" ;-)

Note, Vineeth came up with the naming. I would have done "do" but when I
saw "invoke" I thought it sounded better.

-- Steve
