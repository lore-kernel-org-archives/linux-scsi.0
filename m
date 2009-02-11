From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Thu, 12 Feb 2009 02:14:29 +0900
Message-ID: <20090212021447X.fujita.tomonori@lab.ntt.co.jp>
References: <4992F98B.1060401@panasas.com>
	<20090212013215L.fujita.tomonori@lab.ntt.co.jp>
	<499302E4.9010309@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:43097 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892AbZBKRVT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2009 12:21:19 -0500
In-Reply-To: <499302E4.9010309@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, seokmann.ju@qlogic.com, andrew.vasquez@qlogic.com, sven@linux.vnet.ibm.com

On Wed, 11 Feb 2009 18:55:00 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> > It's about a bidi request. We already have tons of loops, memory
> > allocations, etc in the path. Do you think that adding one more loop
> > leads to a notable performance regression?
> > 
> > Well, if you say that it's hacky then I would agree. But your patch
> > using ~0 is hacky too.
> 
> It is an hack if used by an outside user, because it assumes knowledge
> of block-internals. It is much less of an hack if done by block-internals
> which knows for sure that this has no side effects.
> 
> But I agree that this is not clean. The clean solution is to add an extra
> parameter to blk_end_request() and change all callers.

I don't agree.


> Or even cleaner is to add a new request->residual member and leave
> request->data_len be in peace. Then change the few users that care
> about residual, and one caller that sets it. I'll prepare a patch.

Yeah, it's clean but I'm not sure Jens would accept such patch since
fattening request struct leads to a notable performance regression.
