From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.18-mm2
Date: Sat, 30 Sep 2006 10:26:22 -0500
Message-ID: <1159629982.14918.4.camel@mulgrave.il.steeleye.com>
References: <20060928014623.ccc9b885.akpm@osdl.org>
	 <20060929155738.7076f0c8@werewolf> <20060929143949.GL5017@parisc-linux.org>
	 <1159550143.13029.36.camel@localhost.localdomain>
	 <20060929235054.GB2020@slug>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:26835 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751095AbWI3P0o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Sep 2006 11:26:44 -0400
In-Reply-To: <20060929235054.GB2020@slug>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Wilcox <matthew@wil.cx>, "J.A. Magall??n" <jamagallon@ono.com>, Andrew Morton <akpm@osdl.org>, "Linux-Kernel," <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Fri, 2006-09-29 at 23:50 +0000, Frederik Deweerdt wrote:
> +       if (!pdev->irq)
> +               return -ENODEV;
> +

Don't I remember that 0 is a valid IRQ on some platforms?

i.e. shouldn't this be

if (pdev->irq == NO_IRQ)
	return -ENODEV;

?

I think this won't quite work because only the platforms that actually
have a valid zero irq define it, but there must be something else that
works.

James


