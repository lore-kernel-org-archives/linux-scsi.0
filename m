From: mike@it-loops.com
Subject: Re: PROBLEM: 2.6.3 hangs when writing to scsi-dvd
Date: Mon, 23 Feb 2004 14:46:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1AvGPf-0005BY-00@localhost>
References: <403512B8.2060403@ics.uci.edu>
            <4036867C.60803@ics.uci.edu>
            <Pine.LNX.4.58.0402231329480.1749@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [62.116.46.196] ([62.116.46.196]:31497 "EHLO it-loops.com")
	by vger.kernel.org with ESMTP id S261862AbUBWNuf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 08:50:35 -0500
In-Reply-To: <Pine.LNX.4.58.0402231329480.1749@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Joachim Feise <jfeise@ics.uci.edu>, linux-scsi@vger.kernel.org, Michael Guntsche <mike@it-loops.com>, Andrew Morton <akpm@osdl.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Frank Pieczynski <pieczy@web.de>, Jens Axboe <axboe@suse.de>

Kai Makisara writes: 


>> --- linux-2.6.3/drivers/scsi/scsi_lib.c.orig    2004-02-17 19:57:57.000000000 -0800
>> +++ linux-2.6.3/drivers/scsi/scsi_lib.c 2004-02-20 13:52:46.000000000 -0800
>> @@ -1292,7 +1292,7 @@
>>          * host adapters.  A host driver can alter this mask in its
>>          * slave_alloc() or slave_configure() callback if necessary.
>>          */
>> -       blk_queue_dma_alignment(q, (8 - 1));
>> +       /* blk_queue_dma_alignment(q, (8 - 1)); */ 
>> 
>>         if (!shost->use_clustering)
>>                 clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags); 
>> 
>> But without knowing what this particular line does, it is impossible for me
>> to say if commenting out the line is the right thing to do. 
>> 
> This line has has several duties. For me, it sets the alignment constaint 
> used by st for deciding whether to use direct i/o or internal buffer. For 
> other people more important is that it is used for similar purpose in 
> linux/fs/bio.c. The beginning of __bio_map_user contains the following:
<snip> 

Thanks for the info. Since my problem occured with an external firewire
burner I asked Ben Collins (maintainer of the sbp2 driver) about it this 
weekend.
The USB2 port of the burner worked without any problems, so we took a look 
at the USB mass-storage driver.
It calls blk_queue_dma_alignment(q, (512 - 1)) in slave_configure.
We decided to add a slave_configure in sbp2 too and it works now.
I know that this doesn't solve the problem for other users, but it seems to 
be the fastest solution for devices connected via sbp2. 

Michael 

