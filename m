From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Mon, 03 Mar 2008 13:09:13 +0900
Message-ID: <47CB79E9.8000505@gmail.com>
References: <47C8F4FC.1040505@gmail.com>	<20080302235223X.tomof@acm.org>	<47CB6508.3040206@gmail.com> <20080303125940T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.186]:54241 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbYCCEJW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Mar 2008 23:09:22 -0500
Received: by gv-out-0910.google.com with SMTP id s4so2612139gve.37
        for <linux-scsi@vger.kernel.org>; Sun, 02 Mar 2008 20:09:21 -0800 (PST)
In-Reply-To: <20080303125940T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tomof@acm.org, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com

FUJITA Tomonori wrote:
>> - I think bugs caused by using raw_data_len instead of data_len are more
>> subtle than the other way around.  Using data_len instead of
>> raw_data_len usually affects the application layer while using
>> raw_data_len instead of data_len affects the DMA engine and transport layer.
> 
> If we add extra_len, we can get what raw_data_len and data_len
> provide.
> 
> I can't see what changing the meaning of rq->data_len (and
> investigating all the block drivers) gives us.

No matter which way you go, you change the meaning of rq->data_len and
you MUST inspect rq->data_len usage whichever way you go.  Apply your
patch and try to do sg IO on IDE cdrom w/ various transfer lengths.

-- 
tejun
