From: Doug Ledford <dledford@redhat.com>
Subject: Re: Why /dev/sdc1 doesn't show up...
Date: Sun, 17 Nov 2002 18:45:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117234509.GL3280@redhat.com>
References: <20021117195258.GC3280@redhat.com> <20021117232004.GA1779@win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021117232004.GA1779@win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>

On Mon, Nov 18, 2002 at 12:20:04AM +0100, Andries Brouwer wrote:
> On Sun, Nov 17, 2002 at 02:52:58PM -0500, Doug Ledford wrote:
> 
> > Working on a fix.  Haven't decided how to do it yet.
> 
> I encountered similar phenomena with usb-storage.
> I think the proper solution is to never automatically
> scan for a partition table.

Scanning for a partition table is just one aspect.  In general, once a 
module has handed over it's entry points to some other kernel area those 
entry points should be ready for use, so blocking access to them isn't 
needed.  OTOH, when you are tearing a module down then you do want access 
to stop, so that's the proper time to set live == 0.

> We perhaps need to do that at boot time, but in all other
> cases user space can ask the kernel to read a partition table.

(When it works, which it currently doesn't for me in latest bk)

> For usb-storage things work fairly well (for some kernels)
> using
> 	blockdev --rereadpt /dev/sdx

Yeah, that's fine for hotplug.  But, you know what, for PCI hotplug scsi 
this wouldn't even be an issue since a true hot plug event normally would 
be after module init is complete and scanning the table wouldn't be a 
problem then because module->live would be non-0 ;-)

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
