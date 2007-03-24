From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic7xxx: aic7892(B): BUG: soft lockup detected on CPU#0!
Date: Fri, 23 Mar 2007 19:17:12 -0600
Message-ID: <1174699032.13717.25.camel@mulgrave.il.steeleye.com>
References: <46029D72.3060403@gmx.de> <4602B576.6020602@gmx.de>
	 <4602EED5.5070503@gmx.de> <46030A9A.2060604@gmx.de>
	 <46032CC8.6030307@gmx.de>
	 <1174625139.30030.31.camel@mulgrave.il.steeleye.com>
	 <4603827C.4080701@gmx.de>  <46040047.3000104@gmx.de>
	 <1174670587.30030.47.camel@mulgrave.il.steeleye.com>
	 <46041B11.6000004@gmx.de> <46042383.7010704@gmx.de>
	 <460475F5.1080805@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52841 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934337AbXCXBRS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Mar 2007 21:17:18 -0400
In-Reply-To: <460475F5.1080805@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: t.schorpp@gmx.de
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 2007-03-24 at 01:51 +0100, thomas schorpp wrote:
> > no. so the pci layer reports wrong start:
> 
> nonsense. it succeeds, confused function return with the error flag:
> 
> //      u_long  start;
> //      u_long  start = 0xFFEFF000;
>         u_long  start = 0x30000000;
>         int     error;
> 
>         struct resource* ret1;
>         error = 0;
> //      start = pci_resource_start(ahc->dev_softc, 1);
>         if (start != 0) {
>                 *bus_addr = start;
>                 if ((ret1 = request_mem_region(start, 0x1000, "aic7xxx")) == 0)

You can't do this.  The pci_resource_start is getting the address of
something called a Bus Address Register (BAR) it says in physical
address space where the card is responding ... you can't simply set that
to a random value.

The problem you seem to have is that your system is reporting a BAR
beyond 32 bits (4GB) which the card physically can't use.  This could be
because of a BIOS misconfiguration or because there's a bug in the PCI
subsystem somewhere.

James


