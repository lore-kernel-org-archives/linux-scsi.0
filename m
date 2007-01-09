From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] qla2xxx: spin_unlock_irq in IRQ context
Date: Mon, 08 Jan 2007 23:27:18 -0800
Message-ID: <1168327639.2824.46.camel@mulgrave.il.steeleye.com>
References: <6.0.0.20.2.20070109140514.02ea25e0@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:40783 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751137AbXAIH1y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jan 2007 02:27:54 -0500
In-Reply-To: <6.0.0.20.2.20070109140514.02ea25e0@172.19.0.2>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Tue, 2007-01-09 at 14:35 +0900, Hisashi Hifumi wrote:
> -       spin_unlock_irq(&ha->hardware_lock);
> +       if (in_irq())
> +               spin_unlock(&ha->hardware_lock);
> +       else
> +               spin_unlock_irq(&ha->hardware_lock);
> + 

Really, no!

If the function can be called with interrupts disabled as well as
enabled, then the spin_lock_irq needs to become a spin_lock_irqsave()
which is the correct API for this case.

James


