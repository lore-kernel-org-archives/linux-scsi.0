From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/5] sg_ring for scsi
Date: Fri, 21 Dec 2007 13:37:46 +0900
Message-ID: <20071221133746B.fujita.tomonori@lab.ntt.co.jp>
References: <200712211013.38511.rusty@rustcorp.com.au>
	<20071221112834X.fujita.tomonori@lab.ntt.co.jp>
	<200712211426.47896.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:50855 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbXLUEjH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 23:39:07 -0500
In-Reply-To: <200712211426.47896.rusty@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rusty@rustcorp.com.au
Cc: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net

On Fri, 21 Dec 2007 14:26:47 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Friday 21 December 2007 13:28:34 FUJITA Tomonori wrote:
> > I'm not sure about chaining the headers (as your sg_ring and
> > scsi_sgtable do) would simplify LLDs. Have you looked at ips or
> > qla1280?
> 
> Not yet, am working my way through the drivers, but I don't expect it will be 
> a simplification to the normal SCSI LLDs.  Most of them are mere consumers of
> sgs...

Some scsi drivers like ips access to sglist in a tricky way. I feel
that they don't work with the sg_ring interface well. So if you
convert scsi_lib.c to use sg_ring, please see how it works with the
tricky drivers before that.


> I'm not a SCSI person: I'm patching SCSI because I have to to get my
> own sg-using code clean :)

I'm SCSI-biased. If you don't convert scsi to use sg_ring, I don't
complain. :) Though it would be better to have only one mechanism to
handle large sglist in kernel.
