From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: host_lock use in LLD
Date: Sun, 20 Jun 2004 22:25:03 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0406202205430.969@poirot.grange>
References: <Pine.LNX.4.60.0406182225260.10481@poirot.grange>
 <1087739384.10858.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37272 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263338AbUFTU1F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2004 16:27:05 -0400
In-Reply-To: <1087739384.10858.9.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Kurt Garloff <garloff@suse.de>, Christoph Hellwig <hch@infradead.org>

On Sun, 20 Jun 2004, James Bottomley wrote:

> On Fri, 2004-06-18 at 16:28, Guennadi Liakhovetski wrote:
>> While reviewing tmscsim, I noticed something, I didn't quite like /
>> understand. The driver takes the host_lock (with irqsave) at the entry to
>> the ISR, and releases it at the exit. And inside the ISR there are
>> potentially long busy-waits... Like
>>
>>  	int ctr = 6000000; /* only try for about a second */
>>  	while( --ctr && !((dstate = DC390_read8 (DMA_Status)) &
>>  				DMA_XFER_DONE) && pSRB->SGToBeXferLen );
>>
>> The attached patch is attempting to fix those places. Not sure if this is
>> a proper fix though. In my understanding, after looking through the code,
>> the host_lock is used to protect host-specific data and host-registers.
>> The ->queuecommand is already called with it help, so, one just,
>> basically, have to protect other contexts - interrupt, timer,... So, looks
>> mostly right.
>
> This patch is rejecting in this part:
>
> static void __devexit dc390_remove_one(struct pci_dev *dev)
> {
>        struct Scsi_Host *scsi_host = pci_get_drvdata(dev);
> -       DC390_IFLAGS;
> +       unsigned long iflags;
>        PACB pACB = (PACB) scsi_host->hostdata;
>
>        scsi_remove_host(scsi_host);
>
> -       DC390_LOCK_IO(scsi_host);
> +       spin_lock_irqsave(scsi_host->host_lock, iflags);
>
>
> As best as I can tell, DC390_IFLAGS has never been part of the tmscsim.c
> file ... I think this must be against some modification of the driver
> you have in your tree.

Sorry, James. It's been a pretty long Sunday, and I do have a bit of a 
headache, so, what I see might quite well differ from what everybody else 
sees, but it does look like DC390_IFLAGS is still a part of tmscsim.c as 
of 2.6.7... And rejects are due to my another patch, sent to the list, 
cc'ed to you, Christoph and Kurt on the 31st May, and I did receive it 
back from the list. So, it could have happen that you didn't receive it 
personally, but it did come through to the list. Tell me if I should 
re-send it. Actually, according to my calculations, there are 3 more 
(apart from these 2) outstanding patches for tmscsim.

BTW, what is your preferred way of receiving patches, which depend on each 
other? Should I (in the future) wait until the previous patch appears 
(where?) in a global tree, or collect several patches and send them 
together, or is what I am doing ATM ok (just send patches in as they 
appear, "on the queue")?

Sorry for the inconvenience.

Thanks
Guennadi
---
Guennadi Liakhovetski

