From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/3] Add disk hotswap support to libata
Date: Tue, 26 Jul 2005 13:22:38 -0400
Message-ID: <42E6715E.5080308@pobox.com>
References: <42E0102E.2050603@nit.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261820AbVGZRXr@vger.kernel.org>
In-Reply-To: <42E0102E.2050603@nit.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukasz Kosewski <lkosewsk@nit.ca>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Lukasz Kosewski wrote:
> This patch changes the sata_promise driver in libata to correctly mask 
> out hotplug interrupts.  The location of the primary hotplug registers 
> in the SATA150 Tx4/Tx2 Plus controllers is correctly defined as '0x6C', 
> HOWEVER, for the SATAII150 Tx4/Tx2 Plus controllers, this changes to 
> '0x60'.  This patch rectifies us 'masking out interrupts' at the wrong 
> location, thus not masking them out at all.
> 
> Also, the promise interrupt handler uses a 'spin_lock', I have changed 
> it into a 'spin_lock_irqsave', since I observe this on most other libata 
> drivers, so for consistency.

Comments:

1) Interrupt handler should use the much-less-expensive spin_lock(). 
spin_lock_irqsave() is only used where two separate interrupts (legacy 
IDE irqs 14 & 15) could be sharing the same interrupt handler.

2) Don't pass the hotplug register offset as an argument to a function. 
  Add the offset as a member of struct pdc_port_priv.

This eliminates the need to split up the interrupt handler as you have done.

3) Don't comment out ATA_FLAG_SATA, it is a SATA controller :)

	Jeff


P.S.  Watch for the SiI hotplug email I'm about to send, too...
