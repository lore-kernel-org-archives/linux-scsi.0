From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/2 2.6.29] cxgb3i - accelerating open-iscsi initiator
Date: Tue, 09 Dec 2008 20:42:05 +0200
Message-ID: <493EBBFD.4040607@panasas.com>
References: <200812082030.mB8KUOMD029251@localhost.localdomain> <493E82C6.5030609@panasas.com> <493EA68B.9090902@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:11505 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753998AbYLISmL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Dec 2008 13:42:11 -0500
In-Reply-To: <493EA68B.9090902@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, Karen Xie <kxie@chelsio.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Mike Christie wrote:
> Boaz Harrosh wrote:
> 
>>> +	if (!ddp) {
>>> +		ddp_log_warn("%s unable to alloc ddp 0x%d, ddp disabled.\n",
>>> +			     tdev->name, ppmax);
>>> +		return 0;
>>> +	}
>>> +	ddp->gl_map = (struct cxgb3i_gather_list **)(ddp + 1);
>>> +	ddp->gl_skb = (struct sk_buff **)(((char *)ddp->gl_map) +
>>> +					  ppmax *
>>> +					  sizeof(struct cxgb3i_gather_list *));
>>> +	spin_lock_init(&ddp->map_lock);
>>> +
>>> +	ddp->tdev = tdev;
>>> +	ddp->pdev = uinfo.pdev;
>>> +	ddp->max_txsz = min_t(unsigned int, uinfo.max_txsz, ULP2_MAX_PKT_SIZE);
>>> +	ddp->max_rxsz = min_t(unsigned int, uinfo.max_rxsz, ULP2_MAX_PKT_SIZE);
>> Please note that from what I understand, only the out-going headers can be
>> big, like iscsi_cmd header. But the in-coming headers are always size_of(struct iscsi_hdr).
>> So there is no symmetry here. Actually only iscsi_cmd can get big, the other out-going 
>> data packets are with small headers, but I guess that is an open-iscsi limitation.
>>
>> Mike correct me if I'm wrong?
> 
> Yeah, correct. Other iscsi pdus like tmfs and scsi data out could have 
> ahs but we do not support it. You did the code, so I assumed you only 
> did what you needed and could test.
> 
> On the recv side, I thought scsi cmd response or scsi data-in could have 
> ahses, but libiscsi_tcp/libiscsi just reads as much as it can in and 
> does not process it (actually it only reads in as much buffer space as 
> it has then fails if we overflow). I believe Olaf did this code to be 
> complete as he could with the existing code for the future, and to make 
> sure his abstraction would work for ahs if we needed it.

Yes you are right. I guess none of the targets send AHSs since otherwise
our initiator would fail on that particular packet.

It's time for me to go and look at why would a target send one.
It might be better to make a small enhancement and jump over
iscsi_hdr->hlength just throwing the data away, as a matter of error handling.
Better then failing the command completely.
That is if the AHS is just optional information.

I'll look into it.

Thanks
Boaz
