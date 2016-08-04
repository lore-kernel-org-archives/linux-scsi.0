From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dirty/Writeback fields in /proc/meminfo affected by 20d74bf29c
Date: Thu, 4 Aug 2016 13:55:33 -0700
Message-ID: <20160804135533.153ecbdc199e03f359c98e75@linux-foundation.org>
References: <80b21fe4-ee8b-314c-ee3e-c09386bf368d@pgaddict.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <80b21fe4-ee8b-314c-ee3e-c09386bf368d@pgaddict.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Vondra <tomas@pgaddict.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 1 Aug 2016 04:36:28 +0200 Tomas Vondra <tomas@pgaddict.com> wrote:

> Hi,
> 
> While investigating a strange OOM issue on the 3.18.x branch (which 
> turned out to be already fixed by 52c84a95), I've noticed a strange 
> difference in Dirty/Writeback fields in /proc/meminfo depending on 
> kernel version. I'm wondering whether this is expected ...
> 
> I've bisected the change to 20d74bf29c, added in 3.18.22 (upstream 
> commit 4f258a46):
> 
>      sd: Fix maximum I/O size for BLOCK_PC requests
> 
> With /etc/sysctl.conf containing
> 
>      vm.dirty_background_bytes = 67108864
>      vm.dirty_bytes = 1073741824
> 
> a simple "dd" example writing 10GB file
> 
>      dd if=/dev/zero of=ssd.test.file bs=1M count=10240
> 
> results in about this on 3.18.21:
> 
>      Dirty:            740856 kB
>      Writeback:         12400 kB
> 
> but on 3.18.22:
> 
>      Dirty:             49244 kB
>      Writeback:        656396 kB
> 
> I.e. it seems to revert the relationship. I haven't identified any 
> performance impact, and apparently for random writes the behavior did 
> not change at all (or at least I haven't managed to reproduce it).
> 
> But it's unclear to me why setting a maximum I/O size should affect 
> this, and perhaps it has impact that I don't see.

So what appears to be happening here is that background writeback is
cutting in earlier - the amount of pending writeback ("Dirty") is
reduced while the amount of active writeback ("Writeback") is
correspondingly increased.

4f258a46 had the effect of permitting larger requests into the request
queue.  It's unclear to me why larger requests would cause background
writeback to cut in earlier - the writeback code doesn't even care
about individual request sizes, it only cares about aggregate pagecache
state.

Less Dirty and more Writeback isn't necessarily a bad thing at all, but
I don't like mysteries.  cc linux-mm to see if anyone else can
spot-the-difference.
