Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A977257824;
	Thu, 12 Mar 2026 15:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773330056; cv=none; b=Y6UZxc2Usnurr3H2kvIxEeqMakntKygUasQqwmHy3I3/DLMX0f9mvm6vhmtqcDUKjzo1YnIJa7ZIqCMwVNBnFeHwhESvAgY849aeh9+AklFfPIWi4Kt8N10WK+HpqLdA8wTN1j7GQUTGw8QtQotrIXa+6nEbY7nfoBYmCoc/Flo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773330056; c=relaxed/simple;
	bh=OxRg7tA8kXUHRx+mx/a3uzYLf94/OiyMz274Pyh6DSY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qQ+Dq/qZw9ICMtISiU3Fr6+xOz1M9Ihosfe9Cxr+JMjFTOEN5/gedINxmEvCfOzcb2elG1BNGk4pNR18oNwGtN1fS8qgMBnEicS0FjP4zRF6ZOA6zF31zGFsOGmkOPGvxgdwm6Xvz9aKuuXGA668mHjwRQLtThMauNdUgiFFS6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EEB99C17C4;
	Thu, 12 Mar 2026 15:40:52 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id 3AE588000E;
	Thu, 12 Mar 2026 15:40:27 +0000 (UTC)
Date: Thu, 12 Mar 2026 11:40:41 -0400
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
Message-ID: <20260312114041.5193c729@gandalf.local.home>
In-Reply-To: <219d015d-076b-4c80-8f63-88569115fdad@efficios.com>
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
	<1e3c2830-765e-4271-89f7-0b6784b37597@efficios.com>
	<20260312112354.3dd99e36@gandalf.local.home>
	<219d015d-076b-4c80-8f63-88569115fdad@efficios.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dizt9eoph1r46hcc7akmrtw69qmbfetk
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 3AE588000E
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/ZXXm4w5C9U5+099b/PvZQ7eUGtYiH+vY=
X-HE-Tag: 1773330027-687590
X-HE-Meta: U2FsdGVkX19Y0BxKc9hfd6/oWlCbD7knRVU4HNig4rSlbKfyoeUNxe0xLyOxKy2jHEKNmwC/SBnntITQ/gcP4GV84MGrzwGO/jSnmxSVU90QW1UewwurfqZf/IccLcQyMpO0NVm7ICOGECdjfFMFxxfbyCK2b8HRZTmFiNSnZRhQ3v2UxaLgnk4IGz6tQzClK6n9/8XrtKTpdPEXN08WeqXofu0CM6mgHZtypBJf2bNTx3bZ6VgbT/vGoPrjz+ku8bbQ/05BjCRjqyBZ8chjnNTTV2DkdRZQ/aDGM8chdSripiOGF3zSwSXCsldB5u/XfRMFDIioWgHfx7JpJLp63e8jmL0gMnugNLpYx40Y3FDqgXh+0wGRwMvubNhu5lNM

On Thu, 12 Mar 2026 11:28:07 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> > Note, Vineeth came up with the naming. I would have done "do" but when I
> > saw "invoke" I thought it sounded better.  
> 
> It works as long as you don't have a tracing subsystem called
> "invoke", then you get into identifier clash territory.

True. Perhaps we should do the double underscore trick.

Instead of:  trace_invoke_foo()

use:  trace_invoke__foo()


Which will make it more visible to what the trace event is.

Hmm, we probably should have used: trace__foo() for all tracepoints, as
there's still functions that are called trace_foo() that are not
tracepoints :-p

-- Steve
