From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2.6.12.5 1/2] lib: allow idr to be used in irq context
Date: Mon, 22 Aug 2005 16:53:35 -0500
Message-ID: <1124747615.5211.34.camel@mulgrave>
References: <20050822003325.33507.qmail@web51613.mail.yahoo.com>
	 <1124680540.5068.37.camel@mulgrave> <20050821205214.2a75b3cf.akpm@osdl.org>
	 <1124720938.5211.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751296AbVHVVyJ@vger.kernel.org>
In-Reply-To: <1124720938.5211.13.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: luben_tuikov@adaptec.com, jim.houston@ccur.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Dave Jones <davej@redhat.com>, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2005-08-22 at 09:28 -0500, James Bottomley wrote:
> > I think providing locking inside idr.c was always a mistake - generally we
> > rely on caller-provided locking for such things.
> 
> Well, the reason is because they wanted lockless pre-alloc.  If you do
> it locked, you can't use GFP_KERNEL for the memory allocation flag which
> rather defeats its purpose.

It looks to be feasible to implement this locklessly the same way as the
radix-tree does (with a per_cpu list), except that you still need a
start/end API for the pre allocation to do the initial disable of pre-
emption.

Then the remove should simply then free the entry (again like radix-
tree) and let the slab take care of necessary locking.

Of course, if we're going to go to all this trouble, the next question
that arises naturally is why not just reuse the radix-tree code to
implement idr anyway ... ?

James
