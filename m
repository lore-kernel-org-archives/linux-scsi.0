From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Host drivers and conversion of SCSI to the driver model
Date: Fri, 27 Jun 2003 12:23:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030627192321.GA3338@beaverton.ibm.com>
References: <20030627110259.A3751@infradead.org> <Pine.LNX.4.44L0.0306271347250.774-100000@ida.rowland.org> <20030627190434.A10771@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:64766 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S264736AbTF0THj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 15:07:39 -0400
Content-Disposition: inline
In-Reply-To: <20030627190434.A10771@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Christoph Hellwig [hch@infradead.org] wrote:
> On Fri, Jun 27, 2003 at 01:56:59PM -0400, Alan Stern wrote:
> > I don't see how you can make that work without modifying parts of the 
> > driver model core.  After all, calls to a class_device attribute's show() 
> > and store() methods don't go through the device driver or the bus driver; 
> > they are demultiplexed within drivers/base/class.c.
> 
> Right, the intention is to change the device model cope.  See the dicussion
> about netdev refcounting on linux-netdev a while ago.  
> 

I looked over linux-netdev and can not pick out a thread on this
subject. Could you point to the thread or at least the subject of the
thread. I was wanting to see the consensus of the core change.

I have a set of patch running right now on top of scsi-misc-2.5
(1:a:stern_present 2:a:shost_present 3:a:shost_state 4:a:sdev_state)
that fix some release issues and adds a state attribute to shost and
sdev. The patch set does still have the show / store issue, but does
seem to cleanup better post a surprise removal call to scsi_remove_host.

-andmike
--
Michael Anderson
andmike@us.ibm.com

