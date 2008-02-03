From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH RESEND number 2] libata: eliminate the home grown dma
 padding in favour of that provided by the block layer
Date: Sun, 03 Feb 2008 12:04:03 +0900
Message-ID: <47A52F23.70506@gmail.com>
References: <1199138168.3110.12.camel@localhost.localdomain>	 <1200698057.3111.68.camel@localhost.localdomain>	 <1201894847.3134.59.camel@localhost.localdomain>	 <47A37AF3.3030503@garzik.org> <1201900175.3134.67.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:11282 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693AbYBCDEM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Feb 2008 22:04:12 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1143708rvb.1
        for <linux-scsi@vger.kernel.org>; Sat, 02 Feb 2008 19:04:12 -0800 (PST)
In-Reply-To: <1201900175.3134.67.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

James Bottomley wrote:
> On Fri, 2008-02-01 at 15:02 -0500, Jeff Garzik wrote:
>> James Bottomley wrote:
>>> Could we please get this in ... I thought I mentioned several times that
>>> it fixes a fatal oops in both aic94xx and ipr.
>> Tejun has a persistent objection...  see other email.
> 
> Actually, see other email .. I meant that this patch (eliminate dma
> padding) is independent of the drain one.

Sorry about the delay.

There's a problem here.  For the blk layer dma padding itself, it's okay
but the problem is that it blocks the pending draining patch without
supplying usable alternative at the moment.  I agree that the long term
solution should be in the block layer && I understand that it causes
problem for SAS controllers but for the moment if we don't include the
existing draining patch, far more ATAPI devices are affected.  So, it's
catch-22 situation.

I think the best solution is to update block layer draining such that it
can be included together before the merge window closes.  I'll dig into it.

Thanks.

-- 
tejun
