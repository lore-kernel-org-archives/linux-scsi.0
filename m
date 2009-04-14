From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qla2xxx:use spin_lock_irqsave/spin_unlock_irqrestore
	in irq handler
Date: Tue, 14 Apr 2009 08:55:16 -0500
Message-ID: <1239717316.3357.11.camel@mulgrave.int.hansenpartnership.com>
References: <6.0.0.20.2.20090413190947.079089b0@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43937 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756511AbZDNNzQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Apr 2009 09:55:16 -0400
In-Reply-To: <6.0.0.20.2.20090413190947.079089b0@172.19.0.2>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, linux-driver@qlogic.com

On Mon, 2009-04-13 at 19:40 +0900, Hisashi Hifumi wrote:
> Hi
> 
> I think spin_lock_irqsave/spin_unlock_irqrestore instead of spin_lock_irq/spin_unlock_irq
> should be used in IRQ handler.
> Following is the patch that fixes this issue.

I have to ask what the actual problem is?

The qla irq request is only done with IRQF_SHARED (for non msi), so you
know that interrupts are enabled when the handler is entered, so the non
flags versions are acting on this knowledge.

James


