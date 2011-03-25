From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 4/6] isci: hardware / topology event handling
Date: Fri, 25 Mar 2011 18:07:06 -0400
Message-ID: <20110325220706.GA9535@infradead.org>
References: <20110318161852.GA19008@infradead.org>
 <AANLkTi=dfZ5OtV0rY_y=9boMCAu_=47Bucz_-Jwu0d-6@mail.gmail.com>
 <20110323084054.GA11533@infradead.org>
 <AANLkTinS9xZ3Jhg1C+jWNO0wj+MYW3qvbqc_acvnsOLS@mail.gmail.com>
 <20110323090824.GA14536@infradead.org>
 <AANLkTinYmRZe9HRrNFWMby9FXZNWCdRUb6QBMgRtW28E@mail.gmail.com>
 <20110324062646.GA27051@infradead.org>
 <AANLkTik7DUF=Pim3JMjRmhdVJTCgfimiyhQ5x_CZ9BeU@mail.gmail.com>
 <20110325194530.GA593@infradead.org>
 <AANLkTin-HGv1V7y8Jn8kJ=ZeaPoK4LL+=Tsoz8Ej3Yjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49615 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab1CYWHJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2011 18:07:09 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTin-HGv1V7y8Jn8kJ=ZeaPoK4LL+=Tsoz8Ej3Yjw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Fri, Mar 25, 2011 at 02:39:03PM -0700, Dan Williams wrote:
> In that sense the scope of what scic_lock protects is limited to the
> core/hardware state machines (essentially a controller firmware-like
> context).  Anything that blocks or interfaces with an upper layer runs
> unlocked in the lldd layer, and we don't play any games of dropping
> the lock from the core.  Cancelling and flushing timed events is
> really the only place where the lock gets in the way.  Having a
> "timer_cancelled" flag for these few cases is the approach the core
> took over dropping the lock, del_timer_sync, and re-validating state.

If you just want to deactivate a handler and not wait for it to finish
you can simply use del_timer instead of del_timer_sync.  But it's still
up to you to make sure all timer handlers have finished before freeing
their containing structures or any other resource that they use, which
tends to be rather complicated, and hard to maintain in the long run.
