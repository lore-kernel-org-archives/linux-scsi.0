From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Warning - running *really* short on DMA buffers while doingfiletransfers
Date: Fri, 27 Sep 2002 15:08:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020927220826.GE1366@beaverton.ibm.com>
References: <Pine.BSF.4.21.0209271417260.22542-100000@beppo> <200209272123.g8RLNAi21161@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200209272123.g8RLNAi21161@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: mjacob@feral.com, "Justin T. Gibbs" <gibbs@scsiguy.com>, Andrew Morton <akpm@digeo.com>, Jens Axboe <axboe@suse.de>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


James Bottomley [James.Bottomley@SteelEye.com] wrote:
> mjacob@feral.com said:
> > Duh. There had been race conditions in the past which caused all of us
> > HBA writers to in fact start swalloing things like QFULL and
> > maintaining internal queues. 
> 
> That was true of 2.2, 2.3 (and I think early 2.4) but it isn't true of late 
> 2.4 and 2.5
> 

The current model appears to not be ideal. We go through the process of
starting a cmd only to find out the adapter really knew we could not
start this command. We then put this request back on the head of the
queue while it is holding resources (a request that possibly could have
more merging and mem from the scsi_sg_pools).

I thought there was discussion previously on mid-layer queue
adjustments during the (? attach patch ?) but I am having trouble
finding it.

-andmike
--
Michael Anderson
andmike@us.ibm.com

