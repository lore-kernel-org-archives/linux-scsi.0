From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [2.6 patch] scsi/qlogicpti.c section fixes
Date: Wed, 30 Jan 2008 15:00:16 -0600
Message-ID: <1201726817.3292.84.camel@localhost.localdomain>
References: <20080130200336.GN29368@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755568AbYA3VAg@vger.kernel.org>
In-Reply-To: <20080130200336.GN29368@does.not.exist>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Wed, 2008-01-30 at 22:03 +0200, Adrian Bunk wrote:
> This patch fixes the following section mismatches:
> 
> <--  snip  -->
> 
> ...
> WARNING: drivers/scsi/qlogicpti.o(.devexit.text+0x8): Section mismatch in reference from the function qpti_sbus_remove() to the function .init.text:qpti_chain_del()
> WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x56c): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_map_regs()
> WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x580): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_register_irq()
> WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x594): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_get_scsi_id()
> WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x5b8): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_map_queues()
> WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x780): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_chain_add()
> ...

OK, look, this is really getting out of hand.

__init is possibly justifiable with a few hundred k savings on boot.
__devinit and the rest are surely killable on the grounds they provide
little benefit for all the pain they cause.

all __exit seems to do is set us up for unreferenced pointers in
discarded sections, so could we kill that too?

James
