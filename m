From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] ips 2.5 driver update [1/4] irq return update
Date: 06 May 2003 12:47:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052243238.1819.48.camel@mulgrave>
References: <A3B9245C291EEF4785A24A1DBE8D852B0377A3@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:34821 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263879AbTEFRex (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 May 2003 13:34:53 -0400
In-Reply-To: <A3B9245C291EEF4785A24A1DBE8D852B0377A3@rtpexc01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Jeffery, David" <David_Jeffery@adaptec.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, 2003-05-06 at 12:34, Jeffery, David wrote:
> This is the proper way to report if the interrupt
> was from a serveraid or not.

This: 

> +   irqreturn_t       irqstatus;
[...]
> +   irqstatus = (*ha->func.intr)(ha);
[...]
> -   return IRQ_HANDLED;
> +   return IRQ_RETVAL(irqstatus);

Doesn't look right.  Either your (ha->func.intr) returns true or false
and you need to put it through IRQ_RETVAL to get the correct IRQ_ value,
or it returns IRQ_HANDLED, IRQ_NONE and you just return these directly
(the latter looks to be what it does, so the IRQ_RETVAL() isn't needed).

I'm not sure this will work on 2.4 kernels, though, because the compiler
will then be making a

void irqstatus;

declaration which I think at least some versions of gcc won't like.

James


