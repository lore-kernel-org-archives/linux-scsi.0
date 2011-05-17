From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] isci merge candidate
Date: Tue, 17 May 2011 07:56:07 +0400
Message-ID: <1305604567.6008.5.camel@mulgrave.site>
References: <1305317680.21099.83.camel@dwillia2-linux>
	 <20110514084949.GA23984@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110514084949.GA23984@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Jiang <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2011-05-14 at 10:49 +0200, Christoph Hellwig wrote:
> On Fri, May 13, 2011 at 01:14:40PM -0700, Dan Williams wrote:
> > The isci driver team has now completed the major rework items addressed
> > in the review on linux-scsi (including removal of state handlers,
> > merging lldd and 'core', cleaning up the source code layout).
> 
> I've looked over the driver a bit and I'm quite impressed with what
> you're archived in the short time since taking over the driver from
> whoever came up with the mess that it was initially.

Yes, me too, thanks for doing this.

> I don't think you're quite done yet with the todo list that was given
> to you yet.  One thing that springs to mind is wrappers in timers.c,
> which are not just ugly, but in case of isci_task_execute_tmf is plain
> wrong as the implementation assumes all timers have the same lifetime
> rules as the isci_host.  You'll need to at least replace that last usage
> with a direct wait_for_completion_timeout, and even better get rid
> of it entirely.
> 
> Also not quite done yet, although I'm happy with postponing that for now
> is the unification of the various data structures from the different
> layers of the original driver, e.g. isci_phy vs scic_sds_phy,
> isci_port vs scic_sds_port, isci_remote_device vs scic_sds_remote_device
> and isci_request vs scic_sds_request.

Give me a feel for this: If we put the driver in now, all cleanups
effectively get postponed until .41 (because they're no longer really
-rc candidates).  If the driver gets included in a .40-rc, we have a
couple more months to get the basic cleanups done.

Dan, where's the hardware release at ... as in how urgent is 39-rc last
vs .40 rc?

> And of course there's a lot of room for additional further cleanups
> that should be able to shave off another couple thousands of lines, but
> these never were on the plate for the initial merge anyway.

Right ... I'm happy with the basic progress so far.

James
