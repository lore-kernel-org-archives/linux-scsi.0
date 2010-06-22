From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: MSIX and multiple reply queues
Date: Tue, 22 Jun 2010 09:59:31 -0700
Message-ID: <20100622165931.GB30696@linux.intel.com>
References: <4565AEA676113A449269C2F3A549520F3FF6C887@cosmail03.lsi.com> <1277163505.10998.143.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1277163505.10998.143.camel@mulgrave.site>
Sender: linux-pci-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 21, 2010 at 06:38:25PM -0500, James Bottomley wrote:
> So I think what you're saying is that you plan to have one MSI-X vector
> per CPU (which is possbile)?  If so, you just bind the vector affinity
> of the interrupt to the CPU you want.  If it's something more complex
> than this, I'd suggest asking the PCI list ... I cc'd them in case they
> have any insight.

This is something I've been discussing with the Intel 10Gbit NIC people.
They want the same thing you do -- spread the interrupts out across the
different CPUs.  I think we need an API to have the PCI subsystem set up
as many MSI-X interrupts as possible (limited by # supported by device
and # of CPUs), and spread them out across the CPUs as widely as possible
(per logical CPU if we have enough, per core, per socket, even per node).
Then we need an API to go from CPU number to MSI-X vector number.

Something else I've been musing is the idea of marking these interrupts
as per-cpu (since, well, they are).  That gives an optmised interrupt
handler path in __do_IRQ.  It's going to make the ->set_affinity handler
significantly different, but it seems worth doing.

No idea when I'll have time to do this ...
