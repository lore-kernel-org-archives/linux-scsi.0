From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [Announce] Emulex LightPulse Device Driver
Date: Wed, 10 Mar 2004 09:59:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040310095908.33b2082f.zaitcev@redhat.com>
References: <3356669BBE90C448AD4645C843E2BF2802C014D7@xbl.ma.emulex.com>
	<mailman.1078908361.15239.linux-kernel2news@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47042 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262734AbUCJR7R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 12:59:17 -0500
In-Reply-To: <mailman.1078908361.15239.linux-kernel2news@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: zaitcev@redhat.com, linux-kernel@vger.kernel.org, James.Smart@Emulex.com, linux-scsi@vger.kernel.org

On Wed, 10 Mar 2004 03:35:09 -0500
Jeff Garzik <jgarzik@pobox.com> wrote:

> I'm only part way through a review of the driver, but I felt there is a 
> rather large and important issue that needs addressing...  "wrappers."

Jeff, I agree completely that Emulex code is infested with wrappers
so much that it's harmful. However, the particular example you selected
you interpret wrong.

> void
> elx_sli_lock(elxHBA_t * phba, unsigned long *iflag)

Flag problem on sparc is fixed by Keith Wesolowsky for 2.6.3-rcX,
and it never existed on sparc64, which keeps CWP in a separate register.

Why it took years to resolve is that the expirience showed that
there is no legitimate reason to pass flags as arguments. Every damn
time it was done, the author was being stupid. Keith resolved it
primarily because it was an unorthogonality in sparc implementation.

> But this bug is only an example that serves to highlight the importance 
> of directly using Linux API functions throughout your code.  It may 
> sound redundant, but "Linux code should look like Linux code."  This 
> emphasis on style may sound trivial, but it's important for 
> review-ability, long term maintenance, and as we see here, bug prevention.

Yes yes yes. This is the way elx_sli_lock is harmful, not because
of its passing flags.

-- Pete
