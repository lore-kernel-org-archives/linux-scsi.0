From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: bnx2i kthread madness
Date: Wed, 28 Sep 2011 12:47:06 -0500
Message-ID: <1317232026.22022.11.camel@dabdike.hansenpartnership.com>
References: <1317222318.24040.46.camel@twins>
	 <1317230982.3678.1000.camel@ltirv-waie-lx1>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47785 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377Ab1I1RrI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 13:47:08 -0400
In-Reply-To: <1317230982.3678.1000.camel@ltirv-waie-lx1>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>

On Wed, 2011-09-28 at 10:29 -0700, Eddie Wai wrote:
> On Wed, 2011-09-28 at 08:05 -0700, Peter Zijlstra wrote:
> > Hi,
> > 
> > I accidentally looked at all kthreads in existence on my system and
> > found I had:
> > 
> > [iscsi_eh]
> > [bnx2i_thread/0]
> > [bnx2i_thread/1]
> > [bnx2i_thread/2]
> > [bnx2i_thread/3]
> > [bnx2i_thread/4]
> > [bnx2i_thread/5]
> > [bnx2i_thread/6]
> > [bnx2i_thread/7]
> > [bnx2i_thread/8]
> > [bnx2i_thread/9]
> > [bnx2i_thread/10]
> > [bnx2i_thread/11]
> > [bnx2i_thread/12]
> > [bnx2i_thread/13]
> > [bnx2i_thread/14]
> > [bnx2i_thread/15]
> > [bnx2i_thread/16]
> > [bnx2i_thread/17]
> > [bnx2i_thread/18]
> > [bnx2i_thread/19]
> > [bnx2i_thread/20]
> > [bnx2i_thread/21]
> > [bnx2i_thread/22]
> > [bnx2i_thread/23]
> > 
> > This left me wondering why, because I most certainly am not using iSCSI.
> > I don't even know why its enabled in my .config (and it won't be long). 
> > 
> > Please fix this muck to not create useless threads.
> 
> Hello Peter,
> 
> Point noted.  In the current bnx2i driver, one kthread is created per
> cpu core upon module init (and destroyed upon module exit).  The
> kthreads are meant only to improve I/O performance when iSCSI is
> employed.  Otherwise, I agree that they should not exist.

So if I look at the code, you seem to be trying to direct outbound
commands via the CPU specified in the request?  I assume this is because
we need to access the data to generate things like the checksum, in
which case the command data needs to be CPU hot in the outbound path?
(although I thought the bnx2 had a hardware engine that can do this).

If we genuinely need to do something like this, the interface
work_on_cpu() was defined for something like this purpose.

James


