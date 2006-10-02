From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: Panic from mptspi_dv_renegotiate_work in 2.6.18-mm2
Date: Mon, 2 Oct 2006 17:21:08 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D703507DA@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:32201 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964981AbWJBXVU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Oct 2006 19:21:20 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Martin Bligh <mbligh@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>, linux-scsi@vger.kernel.org

On Monday, October 02, 2006 2:40 PM, Andrew Morton wrote: 

> 
> Yeah, Bryce@osdl is hitting this.  Apparently it can be worked around
> by compiling the driver as a module.
>

What I saw in Bryces trace was the driver was not receiving interrupts
for
the first command sent after interrutps were enabled.  This was a config
page
for spi port pages.  Since this command timed out, an internal timeout
handler was called,
and we issued an internal host reset.  The host reset called each
driver,
such as mptspi, mptfc, mptsas,  callback handers.  That ended with
as pacin in mptspi, due to we assume ioc->hd to be a valid pointer.  
We don't allocate ioc->hd to well after mpt_attach, which is where the
config
page that timed out.    We could prevent the panic in mptspi, but that 
doesn't fix the problem why we are not getting interrupts.   

I have a 2.6.18 gold kernel, and that works fine with modules.  
There are no changes in mpt stack since 2.6.18 that would effect
interrupts.  
Do you know of any changes in kernel effecting interrupts?   I suspect
that
modules versus linked drivers into kernel would matter, or would it?

I've been busy with SAS issues today, and not had time to replicat this.

Eric
