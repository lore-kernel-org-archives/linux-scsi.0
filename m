From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: GFP_ATOMIC allocations...
Date: Fri, 30 Aug 2002 11:46:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208301646.g7UGk2c15401@localhost.localdomain>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA30500
	for <linux-scsi@vger.kernel.org>; Fri, 30 Aug 2002 09:46:11 -0700
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Fri, 30 Aug 2002 09:22:57 PDT." <20020830092257.A19730@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, zaitcev@redhat.com

patmans@us.ibm.com said:
> There was past discussion about calling into scsi_build_commandblocks()
>  while not in user context (via usb etc.), this implies that we could
> scan while not in user context.

> I don't see how that would work, since the scan sleeps waiting for IO.
> 

> Do we really call scan_scsis and scsi_build_commandblocks while not in
> user context? Who is the caller (to scsi_register_host)?

> Here is Pete's response saying he found such a case, but not where:

> http://marc.theaimsgroup.com/?l=linux-scsi&m=101678634608966&w=2 

I agree we shouldn't not be in user context here.

What about, instead of Pete's patch, changing the GFP_ATOMIC to GFP_KERNEL and 
adding a BUG_ON(in_interrupt()) at the top and see who sends back bug 
reports...

James


