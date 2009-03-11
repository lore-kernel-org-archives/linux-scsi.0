From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: possible scsi driver bugs with atomic_set/atomic_read and missing barrier
Date: Tue, 10 Mar 2009 21:39:27 -0600
Message-ID: <20090311033927.GB25995@parisc-linux.org>
References: <49B72F38.8090703@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44800 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522AbZCKDjp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2009 23:39:45 -0400
Content-Disposition: inline
In-Reply-To: <49B72F38.8090703@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Mar 10, 2009 at 10:25:44PM -0500, Mike Christie wrote:
> atomic_set(&hba->state, SOME_STATE_VALUE);
> 
> in a interrupt or thread or tasklet then in another thread they will do
> 
> if (atomic_read(&hba->state) == SOME_STATE_VALUE))
> 
> Does this mean that the drivers should be doing a
> 
> atomic_set(&hba->state, SOME_STATE_VALUE);
> smp_mb();

Possibly "smp_mb__after_atomic_inc()" might be correct.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
