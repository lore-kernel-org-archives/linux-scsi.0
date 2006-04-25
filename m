From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [RFC][PATCH] mpt fusion driver initialization failure fix
Date: Tue, 25 Apr 2006 17:47:40 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D700A4907@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:22517 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932308AbWDYXrz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Apr 2006 19:47:55 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vgoyal@in.ibm.com, linux-scsi@vger.kernel.org, Morton Andrew Morton <akpm@osdl.org>

On Tuesday, April 25, 2006 2:01 PM, Vivek Goyal wrote:

> o Kdump capture kernel boot fails during initialization of 
> MPT fusion driver.
>   (LSI Logic / Symbios Logic SAS1064E PCI-Express Fusion-MPT 
> SAS (rev 01))
> 
> o Problem is easily reproducible, if system crashed while 
> some disk activity
>   like cp operation was going on.
> 
> o After a system crash, devices are not shutdown and capture 
> kenrel starts
>   booting while skipping BIOS. Hence underlying device is 
> left in operational
>   state. In this case scsi contoller was left with interrupt 
> line asserted
>   reply FIFO was not empty. When driver starts initializing 
> in the second 
>   kernel, it receives the interrupt the moment request_irq() 
> is called.
>   Interrupt handler, reads the message from reply FIFO and 
> tries to access
>   the associated message frame and panics, as in the new 
> kernel's context
>   that message frame is not valid at all.
> 
> o In this scenario, probably we should delay the 
> request_irq() call. First
>   bring up the IOC, reset it if needed and then should 
> register for irq.
> 
> o I have tested the patch with SAS1064E and 53c1030 controllers.
> 

Its been busy today, and I have not had a chance to review this today.  
I will work on this tommorrow.

Eric Moore
LSI Logic

* I dropped all the cc'd people and mailing list that don't apply.
