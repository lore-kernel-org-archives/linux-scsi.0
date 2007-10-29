From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v4 1/2] SCSI: Asynchronous event notification	infrastructure
Date: Mon, 29 Oct 2007 12:07:34 -0400
Message-ID: <47260546.9090508@garzik.org>
References: <15624bab8dc0206e384ac8314257a900e60127c1.1193668176.git.jeff@garzik.org>	 <20071029144208.676251F8168@havoc.gtf.org> <1193673088.3383.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47318 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbXJ2QHf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2007 12:07:35 -0400
In-Reply-To: <1193673088.3383.34.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>, akpm@linux-foundation.org

James Bottomley wrote:
> This still doesn't solve the fundamental corruption problem:
> sdev->event_work has to contain the work entry until the workqueue has
> finished executing it (which is some unspecified time in the future).
> As soon as you drop the sdev->list_lock, the system thinks
> sdev->event_work is available for reuse.  If we fire another event
> before the work queue finished processing the prior event, the queue
> will be corrupted.

I think you're misunderstanding the workqueue code?  You can call 
schedule_work(&sdev->event_work) from anywhere, any time you like, as 
many times as you like.


> Also, I think Kristin's initial use of execute_in_user_context() was a
> good call .. if we already have a user context, there's no need to
> bother the workqueue ... some of these events will likely trigger from
> thread backed kernel daemons.

Quite agreed that sdev_evt_notify() might be called from kernel daemons, 
but in general this is a fire-and-forget API that is -likely- to be 
called from interrupt or completion context of many drivers, just like 
scsi_done or other completion APIs.  It is a fundamentally parallel 
interface.

If thread-backed kernel daemons want to use this, it is trivial for them 
to schedule work, then sync.

	Jeff


