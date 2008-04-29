From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Recurring qla2xxx crashes (maybe APIC related)
Date: Tue, 29 Apr 2008 15:29:47 -0700
Message-ID: <20080429222947.GE72811@plap4.qlogic.org>
References: <4811ACAC.7060808@linpro.no> <20080425155018.GG8849@plap4> <48120F8B.7060005@linpro.no> <20080425171821.GK8849@plap4> <4815709C.3060502@linpro.no> <20080429211655.GA72811@plap4.qlogic.org> <4817970A.4030807@linpro.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20713 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbYD2W3s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Apr 2008 18:29:48 -0400
Content-Disposition: inline
In-Reply-To: <4817970A.4030807@linpro.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tore Anderson <tore@linpro.no>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 29 Apr 2008, Tore Anderson wrote:

> > That's good news...
> 
> Very good news indeed - it's still up.
> 
> > In general, most MSI/MSI-X machine/chipset quirks (global/bus-level
> > disabling) are handled by the PCI layer.  I'd be curious to see if any
> > of the 30+ updates to drivers/pci/quirk.c since 2.6.22 have addressed
> > this issue via DECLARE_PCI_FIXUP_FINAL()???
> > 
> > Could you send the output of 'lspci -vvx'?
> 
> Certainly!  Attached.

Hmm, nothing really stands out on the quirks-front.  I know there's
several HS21s locally here, I'll try to get some cycles on the box to
see if there's something deeper going on...

We did notice that the RISC firmware being loaded is quite dated (15
months):

	QLogic Fibre Channel HBA Driver: 8.01.07-k7-debug
	QLogic QMC2462S - IBM eServer BC 4Gb FC Expansion Card SFF
	ISP2422: PCI-X Mode 1 (133 MHz) @ 0000:08:01.0 hdma+, host#=1, fw=4.00.27 [IP] 

At a minimum, our FW folks suggested 4.01.00 should be used to address
any known residual MSI issues at the RISC-side.  You can download the
latest 24xx firmware (4.04.00) here:

	ftp://ftp.qlogic.com/outgoing/linux/firmware/ql2400_fw.bin

I'll do what I can to try to reproduce this locally with our HW.

Thanks,
AV
