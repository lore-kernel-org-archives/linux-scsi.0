From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 2.6 ] MPT Fusion driver 3.01.02 update
Date: Wed, 17 Mar 2004 15:20:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4058B311.1010502@pobox.com>
References: <0E3FA95632D6D047BA649F95DAB60E57040DB25E@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:44224 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261898AbUCQUUy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 15:20:54 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57040DB25E@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, ak@suse.de, Alexander.Stohr@gmx.de, rddunlap@osdl.org

Moore, Eric Dean wrote:
> This is an update for the MPT Fusion drivers 2.6 kernel.
> Version 3.01.02.
> 
> Changelog:
> 
> (1) Andi Kleen[ak@suse.de]
> put warning "Device (0:0:0) reported QUEUE_FULL!" into debug messages
> 
> (2) Alexander Stohr[Alexander.Stohr@gmx.de]
> fix warnings from mptscsih_setup when driver isn't compiled as module
> 
> (3) Randy.Dunlap[rddunlap@osdl.org]
> Remove unnecessary min/max macros and change calls to 
> use kernel.h macros instead.

Here are some wrappers to remove:

static inline void CHIPREG_PIO_WRITE32(volatile u32 *a, u32 v)
{
         outl(v, (unsigned long)a);
}

static inline u32 CHIPREG_PIO_READ32(volatile u32 *a)
{
         return inl((unsigned long)a);
}


Also, I'm not sure about these wrappers, but it's mainly as style issue 
due to the "if (PortIo)" test.  You should remove the 'volatile' 
markers, at least.


static inline u32 CHIPREG_READ32(volatile u32 *a)
{
         if (PortIo)
                 return inl((unsigned long)a);
         else
                 return readl(a);
}

static inline void CHIPREG_WRITE32(volatile u32 *a, u32 v)
{
         if (PortIo)
                 outl(v, (unsigned long)a);
         else
                 writel(v, a);
}


