From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Mainline kernel OLTP performance update
Date: Tue, 27 Jan 2009 09:28:14 +0100
Message-ID: <20090127082814.GN30821@kernel.dk>
References: <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com> <20090114163557.11e097f2.akpm@linux-foundation.org> <20090115012147.GW29283@parisc-linux.org> <20090114180431.f4a96543.akpm@linux-foundation.org> <874p01fg3a.fsf@basil.nowhere.org> <20090115024740.GX29283@parisc-linux.org> <20090120132703.GJ30821@kernel.dk> <588992150B702C48B3312184F1B810AD03A497632C@azsmsx501.amr.corp.intel.com> <20090122112955.GH30821@kernel.dk> <588992150B702C48B3312184F1B810AD03A4F59632@azsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:16105 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbZA0I36 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2009 03:29:58 -0500
Content-Disposition: inline
In-Reply-To: <588992150B702C48B3312184F1B810AD03A4F59632@azsmsx501.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chilukuri, Harita" <harita.chilukuri@intel.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>, Andrew Morton <akpm@linux-foundation.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "Ma, Chinang" <chinang.ma@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "arjan@linux.intel.com" <arjan@linux.intel.com>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>, "Styner, Douglas W" <douglas.w.styner@intel.com>, "Wang, Peter Xihong" <peter.xihong.wang@intel.com>, "Nueckel, Hubert" <hubert.nueckel@intel.com>, "chris.mason@oracle.com" <chris.mason@oracle.com>, "srostedt@redhat.com" <srostedt@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

On Mon, Jan 26 2009, Chilukuri, Harita wrote:
> Jens, we did test the patch that disables the whole stats. We get 0.5% gain with this patch on 2.6.29-rc2 comparing to 2.6.29-rc2-disbale_part_stats
> 
> Below is the description of the result:
> 
> Linux OLTP Performance summary
> Kernel#                               Speedup(x) Intr/s  CtxSw/s  us%    sys%    idle% iowait%
> 2.6.29-rc2-disbale_partition_stats     1.000    30413   42582    74      25      0       0
> 2.6.29-rc2-disable_all                 1.005    30401   42656    74      25      0       0
> 
> Server configurations:
> Intel Xeon Quad-core 2.0GHz  2 cpus/8 cores/8 threads
> 64GB memory, 3 qle2462 FC HBA, 450 spindles (30 logical units)

OK, so about the same, which means the lookup is likely the expensive
bit. I have merged this patch:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=e5b74b703da41fab060adc335a0b98fa5a5ea61d

which exposes an 'iostats' toggle that allows users to disable disk
statistics completely.

-- 
Jens Axboe

