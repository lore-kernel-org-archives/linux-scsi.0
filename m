From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/8] scsi: Drop struct Scsi_Host->host_lock around
	SHT->queuecommand()
Date: Fri, 17 Sep 2010 09:37:58 -0700
Message-ID: <1284741478.13344.154.camel@haakon2.linux-iscsi.org>
References: <1284676529-10756-1-git-send-email-nab@linux-iscsi.org>
	 <1284691571.26423.50.camel@mulgrave.site>
	 <20100917072022.GB2644@gargoyle.ger.corp.intel.com>
	 <1284725592.26423.60.camel@mulgrave.site>
	 <4C9379AA.4000103@linux.intel.com>
	 <1284735438.26423.81.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1284735438.26423.81.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-09-17 at 10:57 -0400, James Bottomley wrote:
> On Fri, 2010-09-17 at 16:22 +0200, Andi Kleen wrote:
> > > I don't disagree with the idea of removing it, especially as it has so
> > > few users, but replacing the host lock with an atomic here would still
> > > vastly reduce the contention, which is the initial complaint.  The
> > 
> > Actually the complaint is the overhead of the spin lock. This can be 
> > either caused
> > by contention or by cache line bounce time.
> 
> The original complaint was contention.  My desire is to reduce the
> locked path coverage, so I saw an opportunity.
> 
> What I was actually thinking of for the atomic is that we'd let it range
> [1..INT_MAX] so a zero was an indicator of no use of this.  Then the
> actual code could become
> 
> if (atomic_read(x)) {
> 	do {
> 		y = atomic_add_return(1, x);
> 	} while (y == 0);
> }

The conversion of struct scsi_cmnd->serial_number to atomic_t and the
above code for scsi_cmd_get_serial() sounds perfectly reasonable to me.

I will take a look at this conversion and respin a complete set of
patches for review a bit later today.

Thanks!

--nab

> 
> So "fast" cards not using the serial number set a zero there (we'd
> default initialise to one), the line is shared so no bouncing (because
> it's never updated).  This should satisfy everyone.
> 
> > > contention occurs because the host lock is so widely used for other
> > > things.  The way to reduce that contention is firstly to reduce the
> > > length of code covered by the lock and also reduce the actual number of
> > > places where the lock is taken.  Compared with host lock's current vast
> > > footprint, and atomic here is tiny.
> > 
> > That assumes that it's contention that is the problem and not simply 
> > bounce time.
> 
> That's what the patch and data that started this whole thread showed,
> yes ... but I think actual bounce in the spinlock is also a problem ...
> we just don't have data to show it.
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
