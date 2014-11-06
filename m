From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Large disk drives
Date: Thu, 6 Nov 2014 11:59:33 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1411061151110.886-100000@iolanthe.rowland.org>
References: <545BA314.4050109@plexistor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44105 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751448AbaKFQ7e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 11:59:34 -0500
In-Reply-To: <545BA314.4050109@plexistor.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, "Dale R. Worley" <worley@alum.mit.edu>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Thu, 6 Nov 2014, Boaz Harrosh wrote:

> On 11/06/2014 05:54 PM, James Bottomley wrote:
> > 
> > We don't have a failure.  This is the problem.  Determining that a
> > problem exists 
> > 
> 
> OK Sorry. I assumed the bridge is smart enough to do nothing,
> 
> ie READ_CAPACITY_10 is passed as is via sata to the device that
> actually supports READ_CAPACITY_16, as I understand then the 
> actual good drive is not suppose to send size-modulue-2G in
> response to READ_CAPACITY_10. Should it ?

The bridge does not send SCSI commands to the drive; it sends ATA 
commands.

When the bridge receives a READ CAPACITY(10) command from the host 
computer, if the drive's actual capacity is >= 2^32 blocks then the 
bridge is supposed to send back a result buffer containing 0xffffffff.  
Not the actual capacity modulo 2^32.

> Then the bridge just sends that back to me, now if I send
> READ_CAPACITY_16 the bridge will return NOT-SUPPORTED because
> it is unexpected.

Yes.

> But what are you saying that the bridge was smart enough to
> do READ_CAPACITY_16 get a 64bit value from the drive and then
> return the lower 32bit to me ? Really ? I would not imagine
> in the life of me someone so dumb. And surly it is against
> any spec.

The bridge does not send READ CAPACITY(16) to the drive.  It sends an 
ATA command -- and it probably sends the same command for READ 
CAPACITY(10).

> Are you sure ? I think you are wrong I think the guy reported
> that he can only see 2T out of his 3T drive which means the
> bridge returned 0xffffffff, exactly 2T

We are sure.  Dale reported that the size he got was less than 2 TB, 
and it was equal to the actual capacity modulo 2^32.  You can check for 
yourself; here's the original email:

	http://marc.info/?l=linux-scsi&m=140908235510961&w=2

Alan Stern

