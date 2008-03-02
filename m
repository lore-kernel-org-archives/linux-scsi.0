From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: SCSI RAM driver
Date: Sun, 2 Mar 2008 19:59:32 +0900
Message-ID: <20080302195941B.tomof@acm.org>
References: <20080219221442L.tomof@acm.org>
	<20080219133120.GA23001@parisc-linux.org>
	<20080219224653G.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:54131 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbYCBK7n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 05:59:43 -0500
In-Reply-To: <20080219224653G.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org, kristen.c.accardi@intel.com, fujita.tomonori@lab.ntt.co.jp, dougg@torque.net

On Tue, 19 Feb 2008 22:46:57 +0900
FUJITA Tomonori <tomof@acm.org> wrote:

> On Tue, 19 Feb 2008 06:31:20 -0700
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
> > On Tue, Feb 19, 2008 at 10:14:53PM +0900, FUJITA Tomonori wrote:
> > > I see that two drivers have very different objectives but if we add
> > > use_thread option to scsi_debug (we can do easily), it seems that
> > > scsi_debug can provide all the features that scsi_ram does.
> > 
> > It's not just use_thread.  It's also discard_read/discard_write.
> 
> scsi_debug has a similar option, fake_rw, which discards both read and
> write data.
> 
> 
> > And scsi_ram has a different data storage model from scsi_debug --
> > scsi_debug simulates an arbitrarily sized disc by wrapping around some
> > small (virtually) contiguous allocation of pages; scsi_ram actually
> > allocates the amount of ram that it's told to.  This can be solved with
> > another module parameter, of course.
> 
> IIRC, if virtual_gb option is set to zero, scsi_debug allocates the
> amount of ram that it's told to.

I think that there are only two different features between scsi_debug
and scsi_ram.

The first one is the thread option, a kernel thread per device
executes scsi commands. Adding the option to scsi_debug is not so
difficult though scsi_debug could create a device in the queuecommand
path so we need some modifications to scsi_debug to drop the host_lock
in the path.

The second one is how to allocate memory for logical unit's contents.
scsi_debug uses vmalloc so there is a limit to the capacity of a that
scsi_debug can support. scsi_ram allocates multiple pages so there is
no limit in scsi_ram. However, I think that we could live without this
feature (but I'm happy to send a patch to convert scsi_debug to use
scsi_ram's way if you want).

Architectures that we might want to use scsi_ram with (e.g., x86_64),
vmalloc can allocate huge memory. The advantage of vmalloc, a
continuous memory area, makes the driver simpler a bit (and it enables
scsi_debug to use the APIs to copies data between a sglist and a
buffer, which also works well for other LLDs).
