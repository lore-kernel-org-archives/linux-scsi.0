From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Possible explanation for SCSI benchmark problems in 2.5
Date: Sun, 29 Sep 2002 23:40:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209300340.g8U3eob03613@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id UAA14991
	for <linux-scsi@vger.kernel.org>; Sun, 29 Sep 2002 20:41:00 -0700
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Sun, 29 Sep 2002 14:32:46 PDT." <20020929213246.GA3743@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: andmike@us.ibm.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@digeo.com>, Jens Axboe <axboe@suse.de>, Kai.Makisara@metla.fi

andmike@us.ibm.com said:
> I thought this was previously discussed on this thread. http://
> marc.theaimsgroup.com/?l=linux-kernel&m=103064539622958&w=2

I remember the thread (well now that my memory's been refreshed).

> and I believe the comment from Jens was that this could be killed off
> in 2.5 if someone did a check for safety on all the devices. 

I'm not really an expert in st, which is where it looks like the problems are. 
 On cursory reading of the code, I think the st driver does dio only if all 
pages are below the HIGHMEM zone, otherwise it does intermediate buffering.  
Thus, the st driver will never put anything in the highmem zone in the queue 
and Andrew Morton's version should be fine.

Does everyone agree with this analysis?

James






