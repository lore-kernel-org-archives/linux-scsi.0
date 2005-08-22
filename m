From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2.6.12.5 1/2] lib: allow idr to be used in irq context
Date: Mon, 22 Aug 2005 09:28:58 -0500
Message-ID: <1124720938.5211.13.camel@mulgrave>
References: <20050822003325.33507.qmail@web51613.mail.yahoo.com>
	 <1124680540.5068.37.camel@mulgrave> <20050821205214.2a75b3cf.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:5505 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1751242AbVHVVf5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 17:35:57 -0400
In-Reply-To: <20050821205214.2a75b3cf.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: luben_tuikov@adaptec.com, jim.houston@ccur.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Dave Jones <davej@redhat.com>, Jeff Garzik <jgarzik@pobox.com>

On Sun, 2005-08-21 at 20:52 -0700, Andrew Morton wrote:
> erp.  posix_timers has its own irq-safe lock, so we're doing extra,
> unneeded locking in that code path.

Possibly, the posix timer code is rather convoluted in this area so I'm
not entirely sure my analysis is correct.

> I think providing locking inside idr.c was always a mistake - generally we
> rely on caller-provided locking for such things.

Well, the reason is because they wanted lockless pre-alloc.  If you do
it locked, you can't use GFP_KERNEL for the memory allocation flag which
rather defeats its purpose.

Perhaps the bug is in the API.  We have pre-allocate, new, find and
remove.  Perhaps what we're missing is a reuse all of which could then
rely on caller provided locking, with pre-alloc and remove requiring
user context but new, find and reuse being happy in irq context.

James


