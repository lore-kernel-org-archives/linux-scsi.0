From: Christoph Hellwig <hch@lst.de>
Subject: Re: Patch?: linux-2.5.45/drivers/scsi/hosts.[ch] - Eliminate scsi_host_tmpl_list
Date: Sun, 10 Nov 2002 04:13:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021110041346.A31976@lst.de>
References: <200211060051.QAA27231@adam.yggdrasil.com> <20021107120045.A14136@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021107120045.A14136@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Thu, Nov 07, 2002 at 12:00:45PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: "Adam J. Richter" <adam@yggdrasil.com>, James.Bottomley@HansenPartnership.com, hch@lst.de, linux-scsi@vger.kernel.org

On Thu, Nov 07, 2002 at 12:00:45PM -0800, Patrick Mansfield wrote:
> I fixed that, and added code in scsi_alloc_host_num to reuse empty
> slots (if no match on scsihosts or scsihosts is empty).
> 
> But, there is no way to match the previous functionallity without having
> a host name list.
> 
> That is before the patch we can do this:
> 
> 	insmod foo; insmod bar
> 
> And foo gets scsi4, bar scsi5. And then:
> 
> 	rmmod foo; rmmod bar
> 	insmod bar; insmod foo
> 
> And foo should still be scsi4, bar scsi5.
> 
> Without the host name list, the best we can do is have
> foo become scsi5, and bar scsi4.

Well, this is a behaviour change, but IMHO the old behaviour is bad.
> 
> I think we should forget about this patch for now, and at some time in
> the future after we have some device naming persistence drop the name
> list and scsihosts option.

I'd really like to get your fixed version of the patch in, no other
subsystem has similar strange hacks and I don't think the cruft is worth
that little gain.  People unsing that feature (are there any?  if yes
please explain what it buys you) might have a different opinion..

