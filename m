From: Matthew Jacob <mjacob@feral.com>
Subject: Re: Warning - running *really* short on DMA buffers while
 doingfiletransfers
Date: Fri, 27 Sep 2002 14:18:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0209271417260.22542-100000@beppo>
References: <200209272113.g8RLD1420775@localhost.localdomain>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200209272113.g8RLD1420775@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, Andrew Morton <akpm@digeo.com>, Jens Axboe <axboe@suse.de>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> 
> Linux is perfectly happy just to have you return 1 in queuecommand if the 
> device won't accept the tag.  The can_queue parameter represents the maximum 
> number of outstanding commands the mid-layer will ever send.  The mid-layer is 
> happy to re-queue I/O below this limit if it cannot be accepted by the drive.  
> In fact, that's more or less what queue plugging is about.
> 
> The only problem occurs if you return 1 from queuecommand with no other 
> outstanding I/O for the device.

Duh. There had been race conditions in the past which caused all of us
HBA writers to in fact start swalloing things like QFULL and maintaining
internal queues.

> 
> There should be no reason in 2.5 for a driver to have to implement an internal 
> queue.

That'd be swell.


