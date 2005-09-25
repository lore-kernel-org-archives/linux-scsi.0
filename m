From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2/7] aacraid: aacraid: AIF preallocation
Date: Sun, 25 Sep 2005 09:41:24 -0500
Message-ID: <1127659284.4839.1.camel@mulgrave>
References: <1127246170.1891.32.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:37507 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751467AbVIYOlr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Sep 2005 10:41:47 -0400
In-Reply-To: <1127246170.1891.32.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Tue, 2005-09-20 at 12:56 -0700, Mark Haverkamp wrote:
> +                                && ((hw_fib_pool = kmalloc(sizeof
> (struct hw_fib *) * num, GFP_ATOMIC|GFP_KERNEL)))
> +                                && ((fib_pool = kmalloc(sizeof(struct
> fib *) * num, GFP_ATOMIC|GFP_KERNEL)))) {
> +                                       hw_fib_p = hw_fib_pool;
> +                                       fib_p = fib_pool;
> +                                       while (hw_fib_p < &hw_fib_pool
> [num]) {
> +                                               if (!(*(hw_fib_p++) =
> kmalloc(sizeof(struct hw_fib), GFP_ATOMIC|GFP_KERNEL))) {
> +                                                       --hw_fib_p;
> +                                                       break;
> +                                               }
> +                                               if (!(*(fib_p++) =
> kmalloc(sizeof(struct fib), GFP_ATOMIC|GFP_KERNEL))) {

all of these allocations should be either GFP_ATOMIC or GFP_KERNEL, but
not both (it looks like they should be GFP_KERNEL).  What GFP_KERNEL|
GFP_ATOMIC actually gives you is a potentially sleeping allocation that
will exhaust the emergency pools, which sounds really undesirable.

James


