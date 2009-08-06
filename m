From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/3] block: add blk-iopoll, a NAPI like approach for
 block devices
Date: Thu, 6 Aug 2009 22:32:57 +0100
Message-ID: <20090806223257.0c33cf15@lxorguk.ukuu.org.uk>
References: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com>
	<1249588685-4662-2-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37740 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756297AbZHFVdD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2009 17:33:03 -0400
In-Reply-To: <1249588685-4662-2-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, jeff@garzik.org, Jens Axboe <jens.axboe@oracle.com>

> doing the command completion when the irq occurs, schedule a dedicated
> softirq in the hopes that we will complete more IO when the iopoll
> handler is invoked. Devices have a budget of commands assigned, and will
> stay in polled mode as long as they continue to consume their budget
> from the iopoll softirq handler. If they do not, the device is set back
> to interrupt completion mode.

This seems a little odd for pure ATA except for NCQ commands. Normal ATA
is notoriously completion/reissue latency sensitive [to the point I
suspect we should be dequeuing 2 commands from SCSI and loading the next
in the completion handler as soon as we recover the result task file and
see no error rather than going up and down the stack)

What do the numbers look like ?

> This patch holds the core bits for blk-iopoll, device driver support
> sold separately.

You've been at Oracle too long ;) You'll be telling me its not a
supported configuration next.

Alan
