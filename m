From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: queuecommand called in IRQ run level
Date: 27 Aug 2003 16:01:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061996517.22825.41.camel@dhcp23.swansea.linux.org.uk>
References: <3F48F9DA.6080202@il.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc1-cwma1-5-cust4.swan.cable.ntl.com ([80.5.120.4]:49312 "EHLO
	dhcp23.swansea.linux.org.uk") by vger.kernel.org with ESMTP
	id S263411AbTH0PCj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2003 11:02:39 -0400
In-Reply-To: <3F48F9DA.6080202@il.marvell.com>
List-Id: linux-scsi@vger.kernel.org
To: Rabeeh Khoury <rabeeh@il.marvell.com>
Cc: linux-scsi@vger.kernel.org

On Sul, 2003-08-24 at 18:46, Rabeeh Khoury wrote:
> Hi All,
> 
> Is it possible that queuecommand be called in ISR time ? (IRQ run level)
> I want to do kmalloc with GFP_KERNEL priority in queuecommand (or 
> actually pci_pool_alloc which eventually will call kmalloc in pool 
> getting low in memory).

You cannot use GFP_KERNEL in this situation - it may block, it may cause
further I/O. 

