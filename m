From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Re: GFP_ATOMIC allocations...
Date: Tue, 03 Sep 2002 09:57:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209031457.g83EvgN03770@localhost.localdomain>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA29725
	for <linux-scsi@vger.kernel.org>; Tue, 3 Sep 2002 07:57:52 -0700
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Fri, 30 Aug 2002 14:55:17 PDT." <20020830145517.A27603@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, zaitcev@redhat.com

patmans@us.ibm.com said:
> How about with printk instead of BUG_ON? BUG_ON is better in the long
> run, but I would rather printk for now. 

I'd still rather use BUG_ON, if we change from GFP_ATOMIC to GFP_KERNEL, since 
we're guaranteeing to kmalloc that we have a user context if it needs to 
sleep.  Otherwise things that shouldn't work will be fine until the system 
runs low on memory an then they'll mysteriously panic with "scheduling in 
interrupt".  It's the job of the caller to kmalloc to verify that it is 
running in a context that can sleep in low memory situations.

A printk is fine for diagnostic purposes, but I bet someone who has a problem device won't report the issue until they see a panic.

James


