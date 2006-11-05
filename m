From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] [SCSI] sg.c: SG_DXFER_TO_FROM_DEV mean DMA_BIDIRECTIONAL
Date: Sun, 05 Nov 2006 09:34:01 -0500
Message-ID: <454DF659.6050608@torque.net>
References: <20465.60059.qm@web31801.mail.mud.yahoo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34464 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965880AbWKEOeA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Nov 2006 09:34:00 -0500
In-Reply-To: <20465.60059.qm@web31801.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> SG_DXFER_TO_FROM_DEV means DMA_BIDIRECTIONAL, not
> DMA_FROM_DEVICE.
> 
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
>  drivers/scsi/sg.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
> 
> This patch is 8 months old.

While this patch is sensible, it breaks a very arcane
usage that I inherited with the sg driver in 1998.
At that time there was no resid, so application clients
(e.g. cdrecord) had no way of knowing if the amount of
data they requested to be read, was actually read.
So, as indirect IO was the only game in town, the
hack used was to prefill the kernel buffer prior to
a read, and then check if it had been overwritten
after the read operation.
Hence SG_DXFER_TO_FROM_DEV was actually a read from
the device.

Some LLDs still do not implement resid (properly).

I'm happy to accept the change as long as people are
prepared to wear the breakage.

Doug Gilbert
