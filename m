From: Brian King <brking@us.ibm.com>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Tue, 20 Jan 2004 14:13:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <400D8BE9.2070108@us.ibm.com>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <400C3E70.9040702@us.ibm.com> <20040120133858.A15671@infradead.org> <400D5A28.1000301@us.ibm.com> <20040120180151.A18616@infradead.org> <400D7DE2.2080402@us.ibm.com> <20040120192822.A19908@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:29369 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265667AbUATUN4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 15:13:56 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
>>The reason I have a pending_q is so that when I reset the adapter 
>>without the mid-layer knowing about it, I need to fail back any 
>>outstanding ops so they get retried as appropriate. I suppose a way 
>>around this would be a mid-layer interface that an LLD could call which 
>>would cause a host reset. Then the midlayer could drive the reset and 
>>take care of doing the right thing with any outstanding ops.
> 
> 
> Does scsi_reset_provider fit your needs?

scsi_reset_provider needs to be called at task level, I often need to 
initiate a reset from interrupt level. Also, it doesn't seem to touch 
outstanding ops. The interface would really need to walk all the device 
queues, failing all the outstanding ops, putting them on the eh queue, 
then wake the eh thread to do the reset.

Also, regarding the pending_q discussion, one issue with not having a 
pending_q would be additional complexity in my eh_host_reset_handler. I 
would need to be able to find all the ops that timed out so I could free 
up my command block, unmap the data buffer, etc. Currently I can just 
walk my pending_q. Without it, I would need to walk all the device 
queues, which seems like it might be a bad thing for a LLD to do.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

