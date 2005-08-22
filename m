From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.12.5 1/2] lib: allow idr to be used in irq context
Date: Mon, 22 Aug 2005 12:51:45 -0400
Message-ID: <430A02A1.9090404@adaptec.com>
References: <20050822003325.33507.qmail@web51613.mail.yahoo.com>	 <1124680540.5068.37.camel@mulgrave> <20050821205214.2a75b3cf.akpm@osdl.org> <1124720938.5211.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751100AbVHVU4e@vger.kernel.org>
In-Reply-To: <1124720938.5211.13.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, jim.houston@ccur.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Dave Jones <davej@redhat.com>, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

On 08/22/05 10:28, James Bottomley wrote:
> On Sun, 2005-08-21 at 20:52 -0700, Andrew Morton wrote:
> 
>>erp.  posix_timers has its own irq-safe lock, so we're doing extra,
>>unneeded locking in that code path.
> 
> 
> Possibly, the posix timer code is rather convoluted in this area so I'm
> not entirely sure my analysis is correct.

Then _please_ drop this thread.

>>I think providing locking inside idr.c was always a mistake - generally we
>>rely on caller-provided locking for such things.
> 
> 
> Well, the reason is because they wanted lockless pre-alloc.  If you do
> it locked, you can't use GFP_KERNEL for the memory allocation flag which
> rather defeats its purpose.

James, please drop this thread and let's concentrate on SCSI.
 
> Perhaps the bug is in the API.  We have pre-allocate, new, find and
> remove.  Perhaps what we're missing is a reuse all of which could then
> rely on caller provided locking, with pre-alloc and remove requiring
> user context but new, find and reuse being happy in irq context.

No, the bug is _not_ in the API.  

*IDR is perfect as it is.*  It gives the caller a lot of freedom, without
internal restrictions (other than the provided by this patch).

Now please let's go back to SCSI and leave other people's code and API
alone.  Shall we James?

SCSI Core needs enough work to have SCSI people worry about other
people's code and design... or is this the modus operandi of the
SCSI Core maintainer...? "Documentation/ManagementStyle", please?

Thank you,
	Luben
