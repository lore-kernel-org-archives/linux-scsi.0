From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v4 1/2] SCSI: Asynchronous event	notification	infrastructure
Date: Mon, 29 Oct 2007 12:29:25 -0400
Message-ID: <47260A65.7040008@garzik.org>
References: <15624bab8dc0206e384ac8314257a900e60127c1.1193668176.git.jeff@garzik.org>	 <20071029144208.676251F8168@havoc.gtf.org>	 <1193673088.3383.34.camel@localhost.localdomain>	 <47260546.9090508@garzik.org> <1193674627.3383.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33531 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbXJ2Q31 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2007 12:29:27 -0400
In-Reply-To: <1193674627.3383.45.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>, akpm@linux-foundation.org

James Bottomley wrote:
> On Mon, 2007-10-29 at 12:07 -0400, Jeff Garzik wrote:
>> James Bottomley wrote:
>>> This still doesn't solve the fundamental corruption problem:
>>> sdev->event_work has to contain the work entry until the workqueue has
>>> finished executing it (which is some unspecified time in the future).
>>> As soon as you drop the sdev->list_lock, the system thinks
>>> sdev->event_work is available for reuse.  If we fire another event
>>> before the work queue finished processing the prior event, the queue
>>> will be corrupted.
>> I think you're misunderstanding the workqueue code?  You can call 
>> schedule_work(&sdev->event_work) from anywhere, any time you like, as 
>> many times as you like.
> 
> OK, take me through it slowly then ... I think schedule_work(work)
> inserts work->entry onto the workqueue list (in
> workqueue.c:insert_work()).  If the event hasn't fired, it will already
> be on the list, so adding the same entry to a list twice causes a list
> corruption problem.

It does a test_and_set_bit() first thing in queue_work().  Similar 
exclusivity logic is found in net device land.  Ah, the fun of locking 
without locks that benh grumbles about :)


> Plus, unfortunately, the CC/UA events are going to have to carry extra
> sense data; they're not simply going to be triggers saying something
> happened.

OK this is a fair criticism.

If additional data must be carried, then I must ditch the beloved bitmap 
implementation and go back to a list (with associated GFP_ATOMIC alloc).

I will fix this, unless I receive email to the contrary...

	Jeff


