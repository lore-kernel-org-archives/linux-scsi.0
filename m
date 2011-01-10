From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] cxgbi: get rid of gl_skb in cxgbi_ddp_info
Date: Mon, 10 Jan 2011 13:57:08 -0600
Message-ID: <4D2B6494.8070406@cs.wisc.edu>
References: <201101072245.p07MjdBm027576@localhost6.localdomain6> <4D27A500.2020009@cs.wisc.edu> <4D27A628.7040008@cs.wisc.edu> <8A71B368A89016469F72CD08050AD33408D571D6@maui.asicdesigners.com> <4D27E6AA.5010304@cs.wisc.edu> <8A71B368A89016469F72CD08050AD33408D5743D@maui.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34726 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab1AJUA0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2011 15:00:26 -0500
In-Reply-To: <8A71B368A89016469F72CD08050AD33408D5743D@maui.asicdesigners.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On 01/10/2011 11:52 AM, Karen Xie wrote:
> Hi, Mike,
>
> What I mean is even if cxgb3i maintains a pool of skbs (equivalent of
> gl_skbs). Once they are handed down to the network layer cxgb3 they will
> still be freed by the network driver (on the tx path).
>

So hows does it work now? It seems ddp_alloc_gl_skb is called at device 
setup time, then when IO is queued/xmited we run ddp_set_map which 
allocates from gl_skbs. If when you transmit the IO, the driver frees 
the skb, how does gl_skb get replenished?
