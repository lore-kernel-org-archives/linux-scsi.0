From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: max_sectors in libata when using md
Date: Thu, 26 Aug 2004 13:51:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412E233A.1040601@pobox.com>
References: <412DFFA9.8030504@wasp.net.au> <8746466a0408260852205a7842@mail.gmail.com> <412E11E3.9050207@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:59345 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269333AbUHZRwH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 13:52:07 -0400
In-Reply-To: <412E11E3.9050207@wasp.net.au>
List-Id: linux-scsi@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Dave <dave.jiang@gmail.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, RAID Linux <linux-raid@vger.kernel.org>

Brad Campbell wrote:
> I also note than in sata_sil there is a workaround for Seagate drives 
> that knocks max_sectors back to 15.

That's very specific to SiI-311x + Seagate drives.


> Is the md driver going to circumvent 
> that also and lock up those interfaces?
> 
> I realise that 200 is decimal, my question was more how are requests of 
> 1024 sectors making it to the driver when the driver has a max_sector 
> value of 200?
> 
> I'm only seeing sectors > 200 when the request comes from md, thus my 
> cc'ing it to the raid list to see if anyone there has any idea.

With a filesystem+MD, you have two entities trying hard to generate the 
largest request possible, the VM [handles filesystem writeback] and MD. 
   If you remove MD from the picture, you remove one entity that tries 
to create large requests.  So that part makes sense.

However, if md violates or increases the max-sectors above what the 
driver sets, then hardware would be failing all over the place.  I could 
be wrong, but I tend to doubt md would do something like that.

	Jeff


