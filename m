From: Patrick Mochel <mochel@osdl.org>
Subject: Re: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [0/2]
Date: Tue, 13 May 2003 17:00:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0305131659110.9816-100000@cherise>
References: <20030512184140.GB3226@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:15324 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263273AbTEMXrT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2003 19:47:19 -0400
In-Reply-To: <20030512184140.GB3226@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


On Mon, 12 May 2003, Mike Anderson wrote:

> James Bottomley [James.Bottomley@steeleye.com] wrote:
> > On Mon, 2003-05-12 at 12:50, James Bottomley wrote:
> > > Surprisingly, it still fails.  I've debugged the refcounting and I see
> > > it fall to zero in scsi_host_put but the dev release method doesn't
> > > trigger for no reason I can see.
> > > 
> > > It's probably a kobject initialisation problem somewhere.
> > 
> > OK, found it.  the ->release is triggered by the kobj_kset, which isn't
> > set until device_add time, not device init time.
> > 
> > Therefore, we shouldn't really put and get objects until they've been
> > added (or the kobj_set_kset_s needs to be moved to device_initialize()).
> > 
> 
> I would like to have feedback from Mochel on the device_initialize
> call.

Just to set the record straight - James suggested this on irc yesterday, 
and I've added it to my tree. I haven't seen any issues with it, and based 
on later emails, you've worked out the slab issue. So, it'll be pushed to 
Linus. 


	-pat

