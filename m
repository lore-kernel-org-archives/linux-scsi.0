From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Tue, 24 Aug 2004 13:39:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040824203914.GA25755@us.ibm.com>
References: <1093113450.1732.334.camel@mulgrave> <20040824132936.GA25263@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:36312 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S268280AbUHXUkb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 16:40:31 -0400
Content-Disposition: inline
In-Reply-To: <20040824132936.GA25263@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, willy@debian.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Anton Blanchard <anton@samba.org>

Olaf Hering [olh@suse.de] wrote:
>  On Sat, Aug 21, James Bottomley wrote:
> 
> > The problems with domain validation were just the tip of the iceberg in
> > the sym2 driver.  Most of its problems seem to come from an overly
> > complex set of negotiating rules, which I've swept away with this patch.
> 
> I see timeouts on the CDROM during boot with 2.6.8, they do not happen
> with our 2.6.5 based SLES9 kernel. This patch doesnt fix it, no idea if
> it was supposed to fix this sort of error.
> 
> PCI: Enabling device: (0003:61:01.0), cmd 143
> sym1: <875> rev 0x3 at pci 0003:61:01.0 irq 86
> sym1: No NVRAM, ID 7, Fast-20, SE, parity checking
> sym1: SCSI BUS has been reset.
> scsi1 : sym-2.1.18j
> sym1:5:0: ABORT operation started.
> sym1:5:0: ABORT operation timed-out.
> sym1:5:0: DEVICE RESET operation started.
> sym1:5:0: DEVICE RESET operation complete.
> sym1:5:control msgout: c.
> sym1: TARGET 5 has been reset.
> sym1:5:0: ABORT operation started.
> sym1:5:0: ABORT operation complete.
> sym1:5:0: BUS RESET operation started.
> sym1:5:0: BUS RESET operation complete.
> sym1: SCSI BUS reset detected.
> sym1: SCSI BUS has been reset.
>   Vendor: IBM       Model: DROM00203         Rev: 7R41
>   Type:   CD-ROM                             ANSI SCSI revision: 02
> scsi(1:0:5:0): Beginning Domain Validation
> sym1:5: wide asynchronous.
> sym1:5: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 14)
> scsi(1:0:5:0): Domain Validation skipping write tests
> scsi(1:0:5:0): Ending Domain Validation
> sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
> Uniform CD-ROM driver Revision: 3.20
> Attached scsi CD-ROM sr0 at scsi1, channel 0, id 5, lun 0

I would guess this cdrom is behind a ACARD. We have had issues in
the past with negotiation / interaction between the ACARD and the sym. 

I currently do not have local access to a system with this config, but I
am asking around to see if I can get access to one.

-andmike
--
Michael Anderson
andmike@us.ibm.com

