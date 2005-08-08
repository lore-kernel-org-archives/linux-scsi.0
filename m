From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: As of 2.6.13-rc1 Fusion-MPT very slow
Date: Mon, 8 Aug 2005 12:27:32 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C037B0557@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:64143 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932180AbVHHS2F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2005 14:28:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sunday, August 07, 2005 8:30 AM, James Bottomley wrote:

> On Sun, 2005-08-07 at 05:59 +0000, Holger Kiehl wrote:
> > Thanks, removing those it compiles fine. This patch also 
> solves my problem,
> > here the output of dmesg:
> 
> Well ... the transport class was supposed to help diagnose the problem
> rather than fix it.
> 
> However, what it shows is that the original problem is in the fusion
> internal domain validation somewhere, but that we still don't know
> where...
> 
> James
> 


I was corresponding to Mr Holger Hiehl in private email.  
What I understood the problem to be was when he compiled the drivers into
the kernel, instead of as modules, we would get some drives negotiating as 
asyn narrow on the 2nd channel.   What I was trying to do was reproduce the 
issue here, and I was unable to.    Has Mr Holger Hiehl tried compiling
your patch with the drivers compiled statically into the kernel, instead
of modules?

Anyways - My last suggesting was that he change the scsi cable, and reset 
the parameters in  the bios configuration utility.  I don't believe
that fixed it.

Here's my next suggestion.  Recompile the driver with domain validation
debugging enabled.  Then send me the output dmesg so I can analyze it.

That is done by modifying the driver makefile, adding the following lines:

CFLAGS_mptscsih.o += DMPT_DEBUG_DV
CFLAGS_mptscsih.o += DMPT_DEBUG_NEGO



