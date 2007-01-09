From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] qla2xxx: spin_unlock_irq in IRQ context
Date: Tue, 09 Jan 2007 16:46:34 +0900
Message-ID: <6.0.0.20.2.20070109162928.02ea3500@172.19.0.2>
References: <6.0.0.20.2.20070109140514.02ea25e0@172.19.0.2>
 <1168327639.2824.46.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:48928 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbXAIILJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jan 2007 03:11:09 -0500
In-Reply-To: <1168327639.2824.46.camel@mulgrave.il.steeleye.com>
References: <6.0.0.20.2.20070109140514.02ea25e0@172.19.0.2>
 <1168327639.2824.46.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi

 >If the function can be called with interrupts disabled as well as
 >enabled, then the spin_lock_irq needs to become a spin_lock_irqsave()
 >which is the correct API for this case.

I know that spin_lock_irqsave()/spin_unlock_irqrestore() is correct .
But in this case, many places need to be modified to use
spin_lock_irqsave()/spin_unlock_irqrestore().Because
spin_lock_irqsave()/spin_unlock_irqrestore() is not in the same function,
and it is needed to pass eflags.

So I use in_irq() to distinguish between IRQ and process context and
minimize modifications.

Thanks. 

