From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi host cleanup 3/3 (driver changes)
Date: Thu, 10 Oct 2002 13:05:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021010200543.GB1348@beaverton.ibm.com>
References: <20021010164633.GA1348@beaverton.ibm.com> <200210101659.g9AGxCA02928@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210101659.g9AGxCA02928@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley [James.Bottomley@steeleye.com] wrote:
> I (finally) got around to looking at the patches.  There were only a few minor 
> quibbles, really boiling down to the fact that you export some functions 
> beginning shost_ instead of scsi_ (shost_tp_for_each_host, 
> shost_chk_and_release).  I can't see any reason why this might cause a naming 
> clash, but I think it is safer to stick to exports beginning with scsi_.

Ok will change to scsi_.

> 
> Also, why do we now have some functions beginning scsi_host and some beginning 
> scsi_shost?  Could we just use one or the other (I'd vote for scsi_host, since 
> it's shorter).
> 

Ok. will change to scsi_host.

Currently I waiting on a re-roll because of an issue currently with the
patch relating to driverfs registration. Since I moved a lot of
functionality to scsi_register (which I wanted to do because of past
issues / comments) I am registering the host with driverfs prior to
scsi_set_pci_device being called by the host driver. This result in
scsi(n) showing up under root. I could move registration into the
scsi_set_pci_device function, but was wanting to wait until we get some
driverfs layout issues understood.

-andmike
--
Michael Anderson
andmike@us.ibm.com

