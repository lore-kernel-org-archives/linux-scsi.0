From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] 2.5.65, cciss_scsi, scsi error handling
Date: Tue, 18 Mar 2003 18:34:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E77ACF6.1000407@redhat.com>
References: <45B36A38D959B44CB032DA427A6E106404513385@cceexc18.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <45B36A38D959B44CB032DA427A6E106404513385@cceexc18.americas.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: "Cameron, Steve" <Steve.Cameron@hp.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Cameron, Steve wrote:

> I think we can implement the abort and device reset handlers,
> (Seems like I tried this once before, but it got really ugly...  
> Hmm, looking through my notes, I see this:
> 
> me> Tue Jul 17 10:35:19 CDT 2001
> me> Actually, looking a bit harder, figured out the real problem 
> me> was that the SCSI mid-layer's error processing code grabs the 
> me> io_request_lock and disables interrupts before calling the 
> me> driver's error handling routines. It holds the flags in a 
> me> local variable inaccessible to the driver, so the driver 
> me> cannot unlock and enable interrupts.

spin_unlock_irq(&hostptr->lock);
wait_for_interrupt();
spin_lock_irq(&hostptr->lock);

You don't need the variable because you already know that the interrupts 
are off and you know you want them back off when you are done waiting. 
So,t he irq variant of the spin lock functions will work just fine for you.


-- 
   Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
          Red Hat, Inc.
          1801 Varsity Dr.
          Raleigh, NC 27606


