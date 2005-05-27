From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] fix ide-scsi EH locking
Date: Sat, 28 May 2005 00:09:02 +0100
Message-ID: <1117235334.29624.251.camel@localhost.localdomain>
References: <42978EF1.5000703@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:8126 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP id S262646AbVE0XLe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 19:11:34 -0400
In-Reply-To: <42978EF1.5000703@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, Dave Jones <davej@redhat.com>, Andrew Morton <akpm@osdl.org>

On Gwe, 2005-05-27 at 22:19, Jeff Garzik wrote:
> Patch untested, but at least the code isn't obviously wrong now...

The abort code check of cmd->serial_number is the only thing I can see
that needs care and that looks safe by the time we hit eh_abort because
the mid level has quiesced the request queue.

eh_reset is whacking on requests but they are the IDE layer requests so
I suspect you want to simply drop the scsi locks for the eh functions
much earlier and use spin_lock_irqsave/restore on the ide lock ?

