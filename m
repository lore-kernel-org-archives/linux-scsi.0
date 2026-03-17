Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29C1284880;
	Tue, 17 Mar 2026 16:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773763262; cv=none; b=IvBJD1tUpstreucyZicV1V+yIi7ZSHFUhEHLLmp7BC4+Ajh7ZKy22pgH9jTTmT3IT+h6qqq5YBBJTAI8mRaDYsXhsUS3wFpgGE/ZJk1ht4XfsgDJbNlMPyI0DZBilK9l8aaa3CTEqGYSbIhcrm7vw7wAOHFJU3GNaagUdksT6H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773763262; c=relaxed/simple;
	bh=GV6iBi3pSdNVXd8yD+APD3iD5U8pEoZAWjKTtickfCc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ik9TulYnmUjn2BZMknzC8cQDR41wnDwSPfmVbpX2aieuHCcBbgZupRxw/wJ1Rd9H2krUjS5LOHmp0PWfBtuTZq+3eFNkoyTgkNVHnoZu8zOOqoiaXM4jAruzVW/SuENdTbCM8GVpudZfEXb767Klx7Wow6UqJ/Rbkmo4HFn8u70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 86DB61A02AC;
	Tue, 17 Mar 2026 16:00:51 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id D0DF733;
	Tue, 17 Mar 2026 16:00:23 +0000 (UTC)
Date: Tue, 17 Mar 2026 12:00:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>,
 Dmitry Ilvokhin <d@ilvokhin.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, Jon Maloy
 <jmaloy@redhat.com>, Aaron Conole <aconole@redhat.com>, Eelco Chaudron
 <echaudro@redhat.com>, Ilya Maximets <i.maximets@ovn.org>,
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
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Chris
 Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] tracepoint: Avoid double static_branch evaluation
 at guarded call sites
Message-ID: <20260317120049.6a60fa88@gandalf.local.home>
In-Reply-To: <CAO7JXPgHYZ9zF1HFahb2447X85YRZCQQBHB6ihOwKSDtiZi8kQ@mail.gmail.com>
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
	<1e3c2830-765e-4271-89f7-0b6784b37597@efficios.com>
	<20260312112354.3dd99e36@gandalf.local.home>
	<219d015d-076b-4c80-8f63-88569115fdad@efficios.com>
	<20260312114041.5193c729@gandalf.local.home>
	<1becdbce-2c01-468a-bbab-42b5dea9fdf8@efficios.com>
	<CAO7JXPjnnruhM5oC6xMgnYaQ9efzYFqMCFiJLNM3HCQ+ZeCiJw@mail.gmail.com>
	<CAEf4BzbnfyhCqp0ne=2gRnVxp-mdGmuZwDeFRyhRYH+eDcz2-w@mail.gmail.com>
	<20260312130255.6476e560@gandalf.local.home>
	<CAO7JXPgHYZ9zF1HFahb2447X85YRZCQQBHB6ihOwKSDtiZi8kQ@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: eiowgk7zro9iwz8nfcjutbggq8cc8mcu
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: D0DF733
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/EZ/m41FERFj32TQCYYTyPgc7E7WqasUA=
X-HE-Tag: 1773763223-363035
X-HE-Meta: U2FsdGVkX1+o+fNh+z7n3E+PiUwqBZ68nGRwauLM+oVgtgpFs5MonLd3fqHB3rXD6BFYZexukj4pxl1VM45GwWde/4JCtp52s0VQK6pZ4Xqa4tvZvLsT4iKLFRi+KAPOR9ciwGsqu0KypbHl9hRVpw7ii/Socjjk14+RdTNwtL/9W3CF6CygSSKoXB/8hsfV+wEeLIu0+Vu7k1X1TT489JEuNfPyBVCGV+jWtTwa1GJMzmbQZEKNLjPpFlUNh0lxNaKm6XtoF736vhCLAK8SYy2ZwNIf/KDqLxnTevPHb/LrRG7US/kzn6HxPRPvbJNoIgt7v+iuU8ZuIBjndA9wdY4FVl8DtE3i2S6cBnN1WxdJr/SxTYBW2cUmiC+3UkuX

On Fri, 13 Mar 2026 10:02:32 -0400
Vineeth Remanan Pillai <vineeth@bitbyteword.org> wrote:

> >
> > Perhaps: call_trace_foo() ?
> >  
> call_trace_foo has one collision with the tracepoint
> sched_update_nr_running and a function
> call_trace_sched_update_nr_running. I had considered this and later
> moved to trace_invoke_foo() because of the collision. But I can rename
> call_trace_sched_update_nr_running to something else if call_trace_foo
> is the general consensus.

OK, then lets go with: trace_call__foo()

The double underscore should prevent any name collisions.

Does anyone have an objections?

-- Steve
