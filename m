From: "Greg Freemyer" <greg.freemyer@gmail.com>
Subject: Re: [RFC] Separating out libata out of SCSI (finally)
Date: Mon, 23 Jun 2008 17:04:35 -0400
Message-ID: <87f94c370806231404t13586777x7f7bee24ebe25ffc@mail.gmail.com>
References: <485B2CC6.6070201@kernel.org>
	 <1213993737.3443.35.camel@localhost.localdomain>
	 <485C31FE.8050408@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:3580 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765AbYFWVEh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jun 2008 17:04:37 -0400
Received: by an-out-0708.google.com with SMTP id d40so628245and.103
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jun 2008 14:04:36 -0700 (PDT)
In-Reply-To: <485C31FE.8050408@garzik.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, brking@linux.vnet.ibm.com, Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>

On Fri, Jun 20, 2008 at 6:41 PM, Jeff Garzik <jeff@garzik.org> wrote:
> James Bottomley wrote:
>>
>> On Fri, 2008-06-20 at 13:06 +0900, Tejun Heo wrote:
>>>
>>> The biggest problem is how to keep userland happy.  hdX -> sdX
>>> transition was painful enough and I have a strong feeling that
>>> everyone will come after and hunt down us if we try something like sdX
>>> -> bdX now.  :-)
>
>> In theory mounting by label or ID should have fixed a lot of this.
>> However, if we need to head off a revolt, the sdX allocation algorithm
>> can be placed into it's own module so both sd and a ULD ata driver could
>> use it ...
>
>> Actually, surely we can mostly dump the SAT layer?
>
>
> I don't see that we can do that for a long time...  And it's not just the
> sdX allocation algorithm in question -- SCSI block devices come with their
> own partition limits and set of supported ioctls.
>
> Therefore, my recommended path has always been
>
> * create ata_disk block device driver (ULD, in your terminology)
>
> * make SAT an optional piece, which maintains compatibility with existing
> SCSI blkdevs, ioctls, command sets
>
>
> I just don't see a valid path moving forward that breaks userland /again/...
>  we (ATA hackers) would be drummed out of a job I think :)
>
> Another option that's been discussed is
>
> 1) Make SCSI block devices themselves an allocate-able resource (I think
> that's what you meant by "placed into it's own module so both sd and a ULD
> ata driver could use it"?)
>
> 2) Ensure that any ata_disk ULD would support the same partition limits and
> ioctl set, enough to ensure binary compatibility.
>
> Because that's the real need -- maintaining binary compatibility with SCSI
> block devices, so major/minor, ioctl supported set, partition limits, and
> other relevant details need to remain unchanged.
>

I've seen a lot of end user complaints about libata only supporting
15(14?) partitions.  Will that limit be moved back to the traditional
drivers/ide limit as part of this?

FYI: I don't personally use that many partitions, but there is a vocal
minority of users on the opensuse mailinglist that complain pretty
loudly about current restriction.

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
