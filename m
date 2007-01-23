From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [RFC 1/6] bidi support: request dma_data_direction
Date: Tue, 23 Jan 2007 17:17:19 +0200
Message-ID: <45B626FF.9020606@panasas.com>
References: <45B3F578.7090109@panasas.com> <20070122052938.GJ3531@rhun.ibm.com> <45B6115C.2010601@panasas.com> <20070123143758.GA3660@rhun.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:44897 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751982AbXAWPT3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2007 10:19:29 -0500
In-Reply-To: <20070123143758.GA3660@rhun.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com, Daniel.E.Messinger@seagate.com, Liran Schour <LIRANS@il.ibm.com>

Muli Ben-Yehuda wrote:
> On Tue, Jan 23, 2007 at 03:45:00PM +0200, Benny Halevy wrote:
> 
>>>> +static inline int dma_uni_dir(enum dma_data_direction dir)
>>>> +{
>>>> +	return (dir == DMA_TO_DEVICE) || (dir == DMA_FROM_DEVICE) ||
>>>> +	       (dir == DMA_NONE);
>>>> +}
>>> While this doesn't look very useful. Why is "DMA_NONE" a uni-dir? I
>>> suggest replacing this with an open coded (dir != DMA_BIDIRECTIONAL).
>> The idea was to be resilient to invalid values. (dir != DMA_BIDIRECTIONAL)
>> is fine of course, but I'd add a BUG_ON such as (dir < 0 || dir >
>> DMA_BIDIRECTIONAL)
> 
> If DMA_NONE isn't actually allowed here, you can use valid_dma_direction().

DMA_NONE should be allowed as it is used by commands that do no I/O and these
are handled on uni-directional path.

BTW, the BUG_ON I suggested has a bug of course since (countering my intuition)
DMA_BIDIRECTIONAL==0, so it should be BUG_ON(dir < 0 || dir > DMA_NONE)
instead.
