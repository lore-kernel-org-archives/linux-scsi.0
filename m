From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 04 Mar 2008 22:50:50 +0900
Message-ID: <47CD53BA.5040908@gmail.com>
References: <20080304093536.GH6704@kernel.dk>	<1204634238.5997.5.camel@homer.simson.net>	<47CD4355.4050401@gmail.com> <20080304223006A.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:25807 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbYCDNvE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 08:51:04 -0500
Received: by wa-out-1112.google.com with SMTP id v27so874145wah.23
        for <linux-scsi@vger.kernel.org>; Tue, 04 Mar 2008 05:51:02 -0800 (PST)
In-Reply-To: <20080304223006A.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: efault@gmx.de, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

FUJITA Tomonori wrote:
>> Aiee... device going down after timing out on READ_DISC_INFO.  That's
>> gruesome.  Can you please try the other patches?
> 
> Tejun, I thought that libata needs a fix for sum(sg) != rq->data_len. No?

The extra_len you added to qc->nbytes should be it.  The only other
place to pay attention is the ATAPI transfer chunk size and your patch
seems to get it right.

> Now Jens' git tree should work with all the non libata stuff, ide,
> firewire, bsg, etc. But I'm not sure about libata.

With the second patch, all others should be fine no matter what.  I'll
go check libata part again.

Thanks.

-- 
tejun
