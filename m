From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Illustration of warning explosion silliness
Date: Wed, 27 Sep 2006 18:35:07 -0700
Message-ID: <20060927183507.5ef244f3.akpm@osdl.org>
References: <20060928005830.GA25694@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:39302 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965176AbWI1BiV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Sep 2006 21:38:21 -0400
In-Reply-To: <20060928005830.GA25694@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>

On Wed, 27 Sep 2006 20:58:30 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> The following patch (DO NOT APPLY) illustrates why
> device_for_each_child() should not be marked with __must_check.
> 
> The function returns the return value of the actor function, and ceases
> iteration upon error.
> 
> However, _every_ case in drivers/scsi has a hardcoded return value,
> illustrating how it is quite valid to not check the return value of this
> function.
> 

What does "has a hardcoded return value" mean?

AFICT the problem here is that (for example) (going up the call stack in
the callee->caller direction):

scsi_internal_device_block() returns an error code

but device_block() drops that on the floor

so target_block() drops it on the floor too

so scsi_target_block() drops it on the floor too


It's a small matter of (correct kernel) programming to correctly propagate
the scsi_internal_device_block() error code all the way back out of
scsi_target_block().

It all looks rather sloppy?
