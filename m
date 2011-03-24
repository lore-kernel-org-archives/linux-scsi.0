From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 4/6] isci: hardware / topology event handling
Date: Thu, 24 Mar 2011 02:26:46 -0400
Message-ID: <20110324062646.GA27051@infradead.org>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
 <20110207003455.27040.94947.stgit@localhost6.localdomain6>
 <20110318161852.GA19008@infradead.org>
 <AANLkTi=dfZ5OtV0rY_y=9boMCAu_=47Bucz_-Jwu0d-6@mail.gmail.com>
 <20110323084054.GA11533@infradead.org>
 <AANLkTinS9xZ3Jhg1C+jWNO0wj+MYW3qvbqc_acvnsOLS@mail.gmail.com>
 <20110323090824.GA14536@infradead.org>
 <AANLkTinYmRZe9HRrNFWMby9FXZNWCdRUb6QBMgRtW28E@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab1CXG0t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Mar 2011 02:26:49 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinYmRZe9HRrNFWMby9FXZNWCdRUb6QBMgRtW28E@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Wed, Mar 23, 2011 at 05:07:49PM -0700, Dan Williams wrote:
> One of the fixes I made in that interim timer api cleanup (8d32e5b2)
> was to use del_timer_sync on all pre-allocated timers to make sure
> nothing fired or was in the process of firing as the driver was
> brought down (unlikely).  The core runs under
> spin_lock_irqsave(ihost->scic_lock) context, and the expectation is
> that all these timeout callbacks are done in that context.

I'm afraid that you'll have to fix that design mistake first.  Running
large amounts of code under a spinlock just is not a good idea for
a wide range of reasons.

