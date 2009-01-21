From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/2] sg: fix races during device removal (v5)
Date: Wed, 21 Jan 2009 19:25:55 +0100
Message-ID: <497768B3.3050506@s5r6.in-berlin.de>
References: <496E4B93.4000507@cybernetics.com>	<20090119155509Y.fujita.tomonori@lab.ntt.co.jp>	<497506AF.6040109@cybernetics.com> <20090120100451Q.fujita.tomonori@lab.ntt.co.jp> <49764920.30307@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:44953 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbZAUSZ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jan 2009 13:25:59 -0500
In-Reply-To: <49764920.30307@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: James.Bottomley@HansenPartnership.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, hch@infradead.org, linux-scsi@vger.kernel.org

Tony Battersby wrote:
> I think BUG_ON is
> the best way to go for this instead of printk/return because bugs
> will be noticed and fixed instead of possibly going unnoticed.
...
>  static void sg_rq_end_io(struct request *rq, int uptodate)
>  {
...
> +	int result, resid, done = 1;
> +
> +	BUG_ON(srp->done != 0);

AFAIU this is typically called in atomic context.  If so, WARN_ON is
preferred.

...
> +	BUG_ON(sfp == NULL);
> +
> +	sdp = sfp->parentdp;

This would bring up a NULL pointer dereference dump anyway.
-- 
Stefan Richter
-=====-==--= ---= =-=-=
http://arcgraph.de/sr/
