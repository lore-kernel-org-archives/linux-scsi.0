From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 13:38:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210152038.g9FKc8A03995@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id NAA11813
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2002 13:38:17 -0700
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Tue, 15 Oct 2002 13:10:22 PDT." <20021015201022.GB1049@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: "Jeffery, David" <David_Jeffery@adaptec.com>, 'Dave Hansen' <haveblue@us.ibm.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

andmike@us.ibm.com said:
> I never seen the mid layer handle device starvation correctly. It
> might be because in scsi_queue_next_request we do this:

> /*
>  * Just hit the requeue function for the queue.
>  */
>   q->request_fn(q);

> before we check for starved. 

This starvation code has nothing to do with fairness.  It's job is purely to 
restart the device queue if we got a host blocked condition and we had to 
reject commands with zero depth.  When the host blocked abates then we loop 
over all the starved devices and call their request functions.  Without this, 
we could get a hang in the block layer queueing.

This could do with being converted over to the blk_stop/start_queue api.

The SCSI code seems to have been written with the idea that device queue_depth 
<< can_queue and thus doesn't concern itself with resource fairness issues 
when the two are closer in size to each other.

James



