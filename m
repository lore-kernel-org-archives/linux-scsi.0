From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Fri, 25 Oct 2002 12:08:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021025120802.A12776@eng2.beaverton.ibm.com>
References: <James.Bottomley@steeleye.com> <200210251834.g9PIY2l03794@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200210251834.g9PIY2l03794@localhost.localdomain>; from James.Bottomley@steeleye.com on Fri, Oct 25, 2002 at 01:34:02PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@digeo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Badari Pulavarty <pbadari@us.ibm.com>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Jens Axboe <axboe@suse.de>, Doug Ledford <dledford@redhat.com>

On Fri, Oct 25, 2002 at 01:34:02PM -0500, James Bottomley wrote:
> 
> James.Bottomley@steeleye.com said:
> > This has all the hallmarks of the Qlogic double done bug:  Under
> > certain high  stress/bad bus situations, the Qla driver will call done
> > twice on a SCSI  command structure.  I take it this is the 6.1.0 qla
> > driver, which qlogic has  assured me "really really" has this bug
> > fixed?
> 
> > Is there any way to switch adapters to see if we can confirm this
> > hypothesis? 

These are qla 23xx cards, and are not supported by the qlogicfc driver.

I don't think the feral driver is ported to 2.5.x, so we can't use it.

> Actually, rather than switching adapters, could you try the attached patch.  
> As long as the command isn't reused too fast after the scsi_done, it should 
> pick up this problem.
> 
> James

I tried a similiar patch (printk if SCpnt->state == SCSI_STATE_BHQUEUE),
and got no hits. It looks like the latest qla checks for this state, as
I saw these errors:

Incorrect number of segments after building list
counted 3, received 2
req nr_sec 256, cur_nr_sec 8
end_request: I/O error, dev 08:a0, sector 1334497
qla2x00_status_entry: cmd is NULL: already returned to OS (sp=f39810e0)
cmd_timeout: LOST command state = 0x6 
qla2x00 (2): Did not free all srbs, Free count = 4095, Alloc Count = 4096


I did not try to figure out what happens to the qla after the
qla2x00_status_entry prints the "cmd is NULL".

-- Patrick Mansfield
