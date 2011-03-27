From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 4/6] isci: hardware / topology event handling
Date: Sun, 27 Mar 2011 18:28:54 -0400
Message-ID: <20110327222854.GA7487@infradead.org>
References: <20110323084054.GA11533@infradead.org>
 <AANLkTinS9xZ3Jhg1C+jWNO0wj+MYW3qvbqc_acvnsOLS@mail.gmail.com>
 <20110323090824.GA14536@infradead.org>
 <AANLkTinYmRZe9HRrNFWMby9FXZNWCdRUb6QBMgRtW28E@mail.gmail.com>
 <20110324062646.GA27051@infradead.org>
 <AANLkTik7DUF=Pim3JMjRmhdVJTCgfimiyhQ5x_CZ9BeU@mail.gmail.com>
 <20110325194530.GA593@infradead.org>
 <AANLkTin-HGv1V7y8Jn8kJ=ZeaPoK4LL+=Tsoz8Ej3Yjw@mail.gmail.com>
 <20110325220706.GA9535@infradead.org>
 <AANLkTimu_jM8wRuURNXrGmD1tJbXeVsJ7Qga9fLC7MJr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46606 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1C0W25 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Mar 2011 18:28:57 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTimu_jM8wRuURNXrGmD1tJbXeVsJ7Qga9fLC7MJr@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Fri, Mar 25, 2011 at 03:34:39PM -0700, Dan Williams wrote:
> Ok, so that's why I went all the way to recommending a switch to
> delayed_workqueue.  We can bring down the core and ensure all events
> have seen a cancellation.  None of these containing objects are
> dynamically destroyed outside of driver exit, nor would they care
> about the switch from timer callback to process context.  That final
> flush is the only elusive bit that is covered by flush_workqueue.

This seems like a really nasy hack to me.  Right now there are 9
callers of isci_timer_create, of those

  5 operate on struct scic_sds_controller
  2 operate on struct scic_sds_phy 
  1 operates on struct scic_sds_port
  1 operates on struct isci_request

of these at least the request has completely different life time rules
than the scic_sds_controller, so both the existing code and the
flush_workqueue variant would be incorrect.

I'd suggest that as a first step you remove the dynamic allocation of
the timers with a structure embedded into the containing structure
and replace isci_timer_list_destroy with a calls to
del_timer_sync when the containing structure is freed.

After that you can trivial remove the wrappers and just opencode the
Linux timer calls, which should lead to much simpler and easier to
understand code.

If the process context of delayed work items provices a significant
benefit to your execution model you can convert the timers to delayed
work items now, and remove the irqsafe locking.  Given that the
isci code still does some non-trivial work from it's interrupt
handlers and tasklets I'm not sure it's going to buy you much, though.

It might be worth to try replacing the tasklets with threaded interrupts
to simplify the locking model, but it will need carefully benchmarking
to evaluate the performance impact.

