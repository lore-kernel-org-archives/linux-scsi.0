From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 4/6] isci: hardware / topology event handling
Date: Fri, 25 Mar 2011 15:45:30 -0400
Message-ID: <20110325194530.GA593@infradead.org>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
 <20110207003455.27040.94947.stgit@localhost6.localdomain6>
 <20110318161852.GA19008@infradead.org>
 <AANLkTi=dfZ5OtV0rY_y=9boMCAu_=47Bucz_-Jwu0d-6@mail.gmail.com>
 <20110323084054.GA11533@infradead.org>
 <AANLkTinS9xZ3Jhg1C+jWNO0wj+MYW3qvbqc_acvnsOLS@mail.gmail.com>
 <20110323090824.GA14536@infradead.org>
 <AANLkTinYmRZe9HRrNFWMby9FXZNWCdRUb6QBMgRtW28E@mail.gmail.com>
 <20110324062646.GA27051@infradead.org>
 <AANLkTik7DUF=Pim3JMjRmhdVJTCgfimiyhQ5x_CZ9BeU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1CYTpe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2011 15:45:34 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTik7DUF=Pim3JMjRmhdVJTCgfimiyhQ5x_CZ9BeU@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Thu, Mar 24, 2011 at 05:57:17PM -0700, Dan Williams wrote:
> I have been waiting for this issue to be raised.  This was one of the
> first items brought up in our internal reviews of the Linux driver.
> Why does it still exist and what is the rationale for addressing it
> incrementally?:
> 
> Starting with simple locking and then scaling it is arguably easier
> than unwinding a more complex locking scheme implemented too early in
> the design phase.

I don't care about the lock scalability.  The problem with a global
spinlock is that a lot of primitives that a driver needs need to block,
and with a global spinlock that's almost impossible to handle, as
you'd need to drop the lock, and have very little chance to figure
out what state it actually protects that now needs to be re-checked.

Things are a little better with a global sleeping lock as it allows
you to block, as long as you don't actually plan to keep it over I/O.

