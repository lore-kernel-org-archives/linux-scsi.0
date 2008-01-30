From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] scsi/qlogicpti.c section fixes
Date: Thu, 31 Jan 2008 00:28:59 +0200
Message-ID: <20080130222858.GS29368@does.not.exist>
References: <20080130200336.GN29368@does.not.exist> <1201726817.3292.84.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:33302 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbYA3W2Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2008 17:28:24 -0500
Content-Disposition: inline
In-Reply-To: <1201726817.3292.84.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 03:00:16PM -0600, James Bottomley wrote:
> 
> On Wed, 2008-01-30 at 22:03 +0200, Adrian Bunk wrote:
> > This patch fixes the following section mismatches:
> > 
> > <--  snip  -->
> > 
> > ...
> > WARNING: drivers/scsi/qlogicpti.o(.devexit.text+0x8): Section mismatch in reference from the function qpti_sbus_remove() to the function .init.text:qpti_chain_del()
> > WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x56c): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_map_regs()
> > WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x580): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_register_irq()
> > WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x594): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_get_scsi_id()
> > WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x5b8): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_map_queues()
> > WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x780): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_chain_add()
> > ...
> 
> OK, look, this is really getting out of hand.
> 
> __init is possibly justifiable with a few hundred k savings on boot.
> __devinit and the rest are surely killable on the grounds they provide
> little benefit for all the pain they cause.
> 
> all __exit seems to do is set us up for unreferenced pointers in
> discarded sections, so could we kill that too?

When you are on x86 what you see as "Freeing unused kernel memory: "
at the end of booting contains both __init and __exit code.

> James

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

