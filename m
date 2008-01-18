From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc8-mm1 Build Failure on scsi driver
Date: Thu, 17 Jan 2008 23:27:27 -0800
Message-ID: <20080117232727.7ef194af.akpm@linux-foundation.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<478F7F2B.9000801@linux.vnet.ibm.com>
	<20080117111104.3baa878e.akpm@linux-foundation.org>
	<47904927.1040000@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46551 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988AbYARH1g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jan 2008 02:27:36 -0500
In-Reply-To: <47904927.1040000@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fischer@norbit.de, Andy Whitcroft <apw@shadowen.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, Samuel Ortiz <samuel@sortiz.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <htejun@gmail.com>

On Fri, 18 Jan 2008 12:07:27 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> Patch from Tejun Heo fixes the aha152x.c build failure, and following second part
> of the build failure, is still occurring.
> 
> drivers/scsi/fdomain.o:(.data+0x0): multiple definition of `fdomain_driver_template'
> drivers/scsi/pcmcia/built-in.o:(.data+0x5a0): first defined here
> drivers/scsi/fdomain.o: In function `fdomain_16x0_bus_reset':
> /home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/fdomain.c:1568: multiple definition of `fdomain_16x0_bus_reset'
> drivers/scsi/pcmcia/built-in.o:/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/fdomain.c:1568: first defined here
> drivers/scsi/fdomain.o: In function `__fdomain_16x0_detect':
> /home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/fdomain.c:894: multiple definition of `__fdomain_16x0_detect'
> drivers/scsi/pcmcia/built-in.o:/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/fdomain.c:894: first defined here
> ld: Warning: size of symbol `__fdomain_16x0_detect' changed from 1206 in drivers/scsi/pcmcia/built-in.o to 1700 in drivers/scsi/fdomain.o
> drivers/scsi/fdomain.o: In function `fdomain_setup':
> /home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/fdomain.c:554: multiple definition of `fdomain_setup'
> drivers/scsi/pcmcia/built-in.o:/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/fdomain.c:554: first defined here

Tejun has more fixing to do, I suspect ;)

I assume a basic allyesconfig will weed out most remaining problems of this
sort.  Problem is, it needs to be done for all architectures (and even that
might not suffice).  So old-fashioned code inspection is also needed.
