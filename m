From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] Multi-path IO in 2.5/2.6 ?
Date: Wed, 11 Sep 2002 14:17:35 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20020911211735.GE5534@beaverton.ibm.com>
References: <patmans@us.ibm.com> <200209111420.g8BEKdx01979@localhost.localdomain> <20020911163013.B26367@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020911163013.B26367@redhat.com>
To: James Bottomley <James.Bottomley@steeleye.com>, Patrick Mansfield <patmans@us.ibm.com>, Lars Marowsky-Bree <lmb@suse.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Doug Ledford [dledford@redhat.com] wrote:
> On Wed, Sep 11, 2002 at 09:20:38AM -0500, James Bottomley wrote:
> > patmans@us.ibm.com said:
> >  I did say 
> > when the patches first surfaced that I didn't like the idea of replacing 
> > Scsi_Device with Scsi_Path at the bottom and the concomitant changes to all 
> > the Low Level Drivers which want to support multi-pathing.  If this is to go 
> > in the SCSI subsystem it has to be self contained, transparent and easily 
> > isolated.  That means the LLDs shouldn't have to be multipath aware.
> 
> I agree with this.
> 

In the mid-level mp patch the adapters are not aware of multi-path. The
changes to adapters carried in the patch have to do with a driver not
allowing aborts during link down cases or iterating over the host_queue
for ioctl, /proc reasons. The hiding of some of the lists behind APIs is
something I had to do in the host list cleanup. We might even do some of
this same list cleanup outside of mp.

Also add "my me to" on the scsi error handling is lacking statement. I
am currently trying to do something about not using the failed command
for error recovery (post abort).

-Mike
-- 
Michael Anderson
andmike@us.ibm.com
