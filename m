From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 2.4.19 scsi_rescan patch (2nd pass)
Date: Wed, 2 Oct 2002 10:23:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021002102330.A11433@eng2.beaverton.ibm.com>
References: <A5974D8E5F98D511BB910002A50A66470580D251@hdsmsx103.hd.intel.com> <20021002165606.GF30234@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021002165606.GF30234@redhat.com>; from dledford@redhat.com on Wed, Oct 02, 2002 at 12:56:06PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Cress, Andrew R" <andrew.r.cress@intel.com>, 'James Bottomley' <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Wed, Oct 02, 2002 at 12:56:06PM -0400, Doug Ledford wrote:
> On Wed, Oct 02, 2002 at 09:40:06AM -0700, Cress, Andrew R wrote:

> >   3) Other external disk enclosure (JBOD) that doesn't expose a 
> >      SAF-TE or SES interface.
> >      This case is out in the cold without the kernel-level rescan.
> > 
> > I'm disregarding case (1), since my target customer environment won't
> > tolerate the manual step.
> 
> You can forget 3 as well.  It's simply not reasonable to tie up a busy bus 
> with very long selection timeouts to "poll scan" a bus for new insertions.  
> Not gonna happen.  If the JBOD doesn't expose a reasonable interface, then 
> hot plug with it isn't supported in linux.  If it exposes something other 
> than SAF-TE or SES then the protocol it does support needs to be added to 
> the daemon in #2 in order for it to be supported.

For SCSI parallel yes, but for FCP (at least on a switch, I'm not sure about
loop), scanning won't have such a negative affect. With 2.5.x targets can
invoke a device_register and so a hotplug event (FCP adapter driver
changes required), and then the new target could be scanned (somehow via
user space trigger calling scan_scsis for a single host/channel/target id)
without affecting other targets on the switch.

-- Patrick Mansfield

> 
> 
> -- 
>   Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
