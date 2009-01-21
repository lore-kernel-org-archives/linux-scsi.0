From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH 1/2] sg: fix races during device removal (v5)
Date: Wed, 21 Jan 2009 14:23:10 -0500
Message-ID: <4977761E.3050705@cybernetics.com>
References: <496E4B93.4000507@cybernetics.com>	<20090119155509Y.fujita.tomonori@lab.ntt.co.jp>	<497506AF.6040109@cybernetics.com> <20090120100451Q.fujita.tomonori@lab.ntt.co.jp> <49764920.30307@cybernetics.com> <497768B3.3050506@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:2675 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbZAUTXM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jan 2009 14:23:12 -0500
In-Reply-To: <497768B3.3050506@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James.Bottomley@HansenPartnership.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, hch@infradead.org, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Tony Battersby wrote:
>   
>> I think BUG_ON is
>> the best way to go for this instead of printk/return because bugs
>> will be noticed and fixed instead of possibly going unnoticed.
>>     
> ...
>   
>>  static void sg_rq_end_io(struct request *rq, int uptodate)
>>  {
>>     
> ...
>   
>> +	int result, resid, done = 1;
>> +
>> +	BUG_ON(srp->done != 0);
>>     
>
> AFAIU this is typically called in atomic context.  If so, WARN_ON is
> preferred.
>
>   

Good point.  I think the following would be the best way then:

	if (WARN_ON(srp->done != 0))
		return;


> ...
>   
>> +	BUG_ON(sfp == NULL);
>> +
>> +	sdp = sfp->parentdp;
>>     
>
> This would bring up a NULL pointer dereference dump anyway.
>   

Yes, and that would have the same problem as BUG_ON by killing the
machine.  So I think WARN_ON()/return works best for this too.

Tony

