From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 2.5.17] Making SCSI not copy the request structure
Date: Fri, 24 May 2002 11:56:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200205241556.g4OFudC02563@localhost.localdomain>
References: <alan@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA02536
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2002 08:56:43 -0700
In-Reply-To: Message from Alan Cox <alan@lxorguk.ukuu.org.uk>
   of "Fri, 24 May 2002 16:32:52 BST." <E17BH3k-0006cI-00@the-village.bc.nu>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Doug Ledford <dledford@redhat.com>, Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

dledford@redhat.com said:
> On a non-0 return, the mid layer throws the  command onto the mlqueue
> and waits to send it until the mid layer  processes a completion event
> from you (or there might also be a timeout, 

Actually, there is no mlqueue any more, all commands are pushed back up to the 
block layer instead now.

dledford@redhat.com said:
> I'm not sure, but I would hope there is also a timeout since otherwise 
> returning non-0 with no outstanding commands on a device because your 
> driver is busy with something else could cause a queue to hang).  Anyway, 
> it's there even if I never did personally use it since my driver used the 
> old eh code ;-)

alan@lxorguk.ukuu.org.uk said:
> That does sound close to unusable on an SMP system. I don't see how
> you guarantee that all your events do not complete between you
> executing the non zero return to the scsi stack and it check for
> events 

Since we use the block queues and everything has to come back in through 
scsi_request_fn, we are SMP safe because of the per queue lock held over the 
request function as it takes work off the queue.

I think our actual problem is failure to signal plugging when we stop 
executing the request function under certain circumstances, so the block layer 
doesn't necessarily see when to call the request function again.

James


