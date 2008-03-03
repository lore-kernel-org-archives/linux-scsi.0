From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Mon, 03 Mar 2008 23:22:46 +0900
Message-ID: <47CC09B6.6090709@gmail.com>
References: <47CBFF6F.4060301@gmail.com>	<20080303225024J.tomof@acm.org>	<47CC036C.2060902@gmail.com> <20080303230121M.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ag-out-0708.google.com ([72.14.246.246]:29063 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbYCCOW6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 09:22:58 -0500
Received: by ag-out-0708.google.com with SMTP id 33so13910481agc.1
        for <linux-scsi@vger.kernel.org>; Mon, 03 Mar 2008 06:22:55 -0800 (PST)
In-Reply-To: <20080303230121M.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com

FUJITA Tomonori wrote:
>> At the end of blk_rq_map_user() together with data_len / extra_len
>> mangling or were you talking about James' original patch?
> 
> With my patch, at the end of blk_rq_map_user, we have:
> 
> 	if (len & queue_dma_alignment(q)) {
> 		unsigned int pad_len = (queue_dma_alignment(q) & ~len) + 1;
> 
> 		rq->extra_len += pad_len;
> 	}
> 
> 
> So no change as compared with 2.6.24?

Oh.. you killed sg list manipulation.  Many controllers do allow odd
bytes as the last sg entry but not all.  Also, if you append drain
buffer after it, it ends up with unaligned sg entry in the middle and
rq->data_len + rq->extra_len will overrun the sg entry after the drain
page which is really dangerous.

-- 
tejun
