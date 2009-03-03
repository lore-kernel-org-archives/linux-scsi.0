From: Reinhard Nissl <rnissl@gmx.de>
Subject: Re: [PATCH 5/5] mvsas : redesign the mvsas driver architecture.
Date: Tue, 03 Mar 2009 22:34:34 +0100
Message-ID: <49ADA26A.6020402@gmx.de>
References: <49A3C11B.3020107@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59200 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752357AbZCCVes (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Mar 2009 16:34:48 -0500
In-Reply-To: <49A3C11B.3020107@marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kewei@marvell.com
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, james.bottomley@hansenpartnership.com, qzhao@marvell.com, qswang@marvell.com, jfeng@marvell.com, jasonchu@marvell.com

Hi,

Ke Wei schrieb:

> +		mvs_64xx_detect_porttype(mvi, i);
> +	}
> +	if (mvi->flags & MVF_FLAG_SOC) {
> +		/* set select registers */
> +		writel(0x0E008000, regs + 0x000);
> +		writel(0x59000008, regs + 0x004);
> +		writel(0x20, regs + 0x008);
> +		writel(0x20, regs + 0x00c);
> +		writel(0x20, regs + 0x010);
> +		writel(0x20, regs + 0x014);
> +		writel(0x20, regs + 0x018);
> +		writel(0x20, regs + 0x01c);
> +	}
> +	for (i = 0; i < mvi->chip->n_phy; i++) {
> +		/* clear phy int status */
> +		tmp = mvs_read_port_irq_stat(mvi, i);
> +		tmp &= ~PHYEV_SIG_FIS;
> +		mvs_write_port_irq_stat(mvi, i, tmp);
> +
> +		/* set phy int mask */
> +		tmp = PHYEV_RDY_CH | PHYEV_BROAD_CH | PHYEV_UNASSOC_FIS |
> +			PHYEV_ID_DONE | PHYEV_DCDR_ERR | PHYEV_CRC_ERR |
> +			PHYEV_DEC_ERR;
> +		mvs_write_port_irq_mask(mvi, i, tmp);
> +
> +		msleep(100);
> +		mvs_update_phyinfo(mvi, i, 1);

I assume that this code doesn't work with my Seagate 10k6 drive
ST3450856SS 0003. Looks like it still just waits for 100 ms which
seems to be not sufficient for this drive (see the thread on this
list regarding this drive).

Is there no way to determine that port detection has finished?

Bye.
-- 
Dipl.-Inform. (FH) Reinhard Nissl
mailto:rnissl@gmx.de
