From: Mark Haverkamp <markh@osdl.org>
Subject: Re: Problem with aacraid driver in 2.5.63-bk-latest
Date: 13 Mar 2003 07:42:13 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1047570132.30105.7.camel@markh1.pdx.osdl.net>
References: <20030228133037.GB7473@jiffies.dk>
	 <1047510381.12193.28.camel@markh1.pdx.osdl.net>
	 <1047514681.23725.35.camel@irongate.swansea.linux.org.uk>
	 <3E6FC8D6.7090005@torque.net>
	 <1047517604.23902.39.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1047517604.23902.39.camel@irongate.swansea.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dougg@torque.net, Christoffer Hall-Frederiksen <hall@jiffies.dk>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux aacraid devel <linux-aacraid-devel@dell.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2003-03-12 at 17:06, Alan Cox wrote:
> On Wed, 2003-03-12 at 23:55, Douglas Gilbert wrote:
> >          /*
> >           * Limit max queue depth on a single lun to 256 for now.  Remember,
> >           * we allocate a struct scsi_command for each of these and keep it
> >           * around forever.  Too deep of a depth just wastes memory.
> >           */
> >          if(tags > 256)
> >                  return;
> > ....
> 
> I can see the memory consideration. However the thing can really handle big
> queues well. Possibly we should be setting the queue to 512 / somefunction(volumes)
> though to avoid the worst case overcommit here
> 

Does the cmd_per_lun element of the Scsi_Host_Template structure serve
more than one purpose?  In scsi_alloc_sdev it is passed into
scsi_adjust_queue_depth.  In the aacraid case this is 512.  Later the
aacraid driver (in aac_slave_configure) sets the queue depth to either
128 for tagged or 1 if not.

Mark.
-- 
Mark Haverkamp <markh@osdl.org>
