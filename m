From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: lockdep warning looks scsi related
Date: Fri, 6 Oct 2006 19:19:26 +0200
Message-ID: <20061006171926.GC8814@kernel.dk>
References: <20061005100853.4d65dc90@dxpl.pdx.osdl.net> <1160140963.3000.106.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:32772 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S1422763AbWJFRTm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2006 13:19:42 -0400
Content-Disposition: inline
In-Reply-To: <1160140963.3000.106.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@fenrus.demon.nl>
Cc: Stephen Hemminger <shemminger@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

On Fri, Oct 06 2006, Arjan van de Ven wrote:
> On Thu, 2006-10-05 at 10:08 -0700, Stephen Hemminger wrote:
> > This is current main linux-2.6 (git pulled yesterday).
> > Running on 2 CPU Opteron
> > Happened during overnight (beagle cronjob?)
> 
> hmm lots of changes in cfq, and to be honest the
> cfq_exit_single_io_context() change makes me nervous.
> The comment says it's called with interrupts disabled, what the comment
> does NOT say is that this function ENABLES interrupts!
> (the entire cfq change has many places where interrupts now get enabled
> where previously they remained as is... )

The comment is stale, it isn't called with interrupts disabled (or the
spin_lock_irq() and unlock would be buggy). The lockdep trace is
interesting though, added to the list of things to investigate ASAP.

-- 
Jens Axboe

