From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: blk-mq vs kmemleak
Date: Tue, 7 Jul 2015 06:59:37 -0700
Message-ID: <559BDB49.70209@sandisk.com>
References: <20150703161137.GA10438@codemonkey.org.uk>
 <5596C080.4050009@sandisk.com>
 <20150707103323.GA13228@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0061.outbound.protection.outlook.com ([207.46.100.61]:10880
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757610AbbGGN7m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jul 2015 09:59:42 -0400
In-Reply-To: <20150707103323.GA13228@e104818-lin.cambridge.arm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Jones <davej@codemonkey.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 07/07/15 03:33, Catalin Marinas wrote:
> On Fri, Jul 03, 2015 at 06:04:00PM +0100, Bart Van Assche wrote:
>> A few weeks ago I had noticed similar kmemleak reports.
>> However, when I reran my test with kmemleak disabled memory usage was
>> stable. See also
>> https://www.redhat.com/archives/dm-devel/2015-May/msg00198.html.
>
> Further down in this thread it gets interesting with kmalloc-96 objects
> disappearing in /proc/slabinfo with kmemleak disabled. Kmemleak does not
> allocate such objects, the two types it allocates are in separate
> kmem_cache as kmemleak_object and kmemleak_scan_area. However, the 96
> size is reported by kmemleak as well, so maybe it was fixed by some
> other patch in the meantime?
>
> If you manage to reproduce it again please let me know. Thanks.

Hello Catalin,

Please note that my test was run with CONFIG_SLUB_DEBUG=y which causes a 
red zone to be allocated before and after each block of allocated 
memory. Could that explain the kmalloc-96 objects ?

Thanks,

Bart.
