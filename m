From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: softscsi patch
Date: Tue, 02 Jul 2002 12:19:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200207021619.g62GJ9A03729@localhost.localdomain>
References: <willy@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA27655
	for <linux-scsi@vger.kernel.org>; Tue, 2 Jul 2002 09:19:22 -0700
In-Reply-To: Message from Matthew Wilcox <willy@debian.org>
   of "Sun, 30 Jun 2002 22:20:43 BST." <20020630222043.B29045@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org, "David S. Miller" <davem@redhat.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

willy@debian.org said:
> The main effect of applying this patch is that scsi_softirq() [was
> scsi_tasklet_func, and before that scsi_bottom_half_handler()] can now
> be run on multiple CPUs at the same time.  We _seem_ to do enough
> locking elsewhere in the SCSI stack that this is safe.  But someone
> who really understands the SCSI stack should audit this. 

I think the locking should be fine.  The only way we get a race is if the same 
HBA card manages to interrupt on two different CPUs before the softirqs run.  
In this case, the queue lock (which is really the host lock) will serialise 
the softirqs.  In all other cases, the locks don't interfere and the softirq's 
should happily run in parallel.

> This work shows up a hole in the current softirq API -- there's no
> support for unregistering a softirq (close_softirq or similar).  We
> should do this in scsi_exit -- make sure no softirqs are running while
> we unload. This probably isn't a problem in practice, but it'd be nice
> to fix it. 

This might be a problem for USB floppies which show up as SCSI mass storage 
devices (and have strange floppy irq characteristics) since their owners tend 
to do multiple inserts and removals of the entire SCSI subsystem.

James


