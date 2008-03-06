From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Thu, 06 Mar 2008 14:02:50 +0900
Message-ID: <47CF7AFA.8060305@gmail.com>
References: <47CDDC31.4070806@gmail.com>	<20080305092619Y.fujita.tomonori@lab.ntt.co.jp>	<47CDECD1.6070601@gmail.com> <20080306135627P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:36087 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYCFFDH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 00:03:07 -0500
Received: by rn-out-0910.google.com with SMTP id v46so727513rnb.15
        for <linux-scsi@vger.kernel.org>; Wed, 05 Mar 2008 21:03:07 -0800 (PST)
In-Reply-To: <20080306135627P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tomof@acm.org, efault@gmx.de, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

Hello, FUJITA.

FUJITA Tomonori wrote:
>>>> Things going the other way is fine with me but I at least want to hear a
>>>> valid rationale.  Till now all I got is "because that's the true size"
>>>> which doesn't really make much sense to me.
>>> Most of users of request structure care about only the real data
>>> length, don't care about padding and drain length. Why do they bother
>>> to use a helper function to get the real data length?
>> I think this is where the difference comes from.  To me it seems
>> internal usage seems more wide-spread and more delicate and not too many
>> care about the true size and when they do only in well defined places.
>> Maybe it comes from the difference between your most and my most.
> 
> I don't think that they only in well defined places.
> 
> If you see scsi mid-layer (and LLDs), you can find several places that
> use rq->data_len as the true data length.
> 
> Breaking rq->data_len == the true data length theoretically
> wrong. Even if it affects only libata now, it will hurt us, I think.

Yeap, I fully agree it's much better not to break any of the two
assumptions except when it's actually needed.  Both padding and draining
are requirements from low level driver which usually stems from hardware
kinkiness, so adjusting sg and length there and let the rest of system
not care about it sounds like a good idea to me.  Maybe something good
can come out of this long thread.  :-)

Thanks.

-- 
tejun
