From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 18:04:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210160104.g9G14km05097@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id SAA04391
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2002 18:04:52 -0700
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Tue, 15 Oct 2002 15:10:31 PDT." <20021015221031.GF1049@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: "Jeffery, David" <David_Jeffery@adaptec.com>, 'Dave Hansen' <haveblue@us.ibm.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

andmike@us.ibm.com said:
> Ok it will not handle fairness, but it will trigger a starved and
> some_device_starved case when SHpnt->can_queue > 0 and SHpnt->
> host_busy >= SHpnt->can_queue. Which is the case we where discussing
> and is not a host blocked condition.

Yes, but this still only activates if the device trying to queue has no 
currently outstanding commands.  Usually under heavy load to multiple LUNs, 
you probably won't run into this too often.

The way the mid-layer expects to operate under load is that a returning 
command for a given device triggers the request queue for that device to queue 
up the next waiting command.

> The reverse ordering of the request_fn call could cause a device to
> stayed starved if the device queue depth is near or equal to the host
> can_queue.

True, I suppose, but only in the limited case where there are no queued 
commands for a particular device.  The most likely case is that one device has 
stolen a huge number of slots and everyone else gets a tiny number, which 
won't activate this code at all.

James


