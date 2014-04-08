From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 73621] Kernel exception loading sym53c8xx on dual AMD
 Athlon Tyan S2460 motherboard
Date: Tue, 08 Apr 2014 11:16:14 -0700
Message-ID: <1396980974.13341.75.camel@dabdike>
References: <bug-73621-11613@https.bugzilla.kernel.org/>
	 <bug-73621-11613-PL9Lh5NEfT@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59599 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932649AbaDHSQQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Apr 2014 14:16:16 -0400
In-Reply-To: <bug-73621-11613-PL9Lh5NEfT@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org

On Tue, 2014-04-08 at 09:39 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=73621
> 
> Alan <alan@lxorguk.ukuu.org.uk> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |alan@lxorguk.ukuu.org.uk
> 
> --- Comment #1 from Alan <alan@lxorguk.ukuu.org.uk> ---
> Incorrect memory frees on error path
> 
> [    4.522582] sym0: <825> rev 0x2 at pci 0000:00:09.0 irq 10
> [    4.552156] sym0: No NVRAM, ID 7, Fast-10, SE, parity checking
> [    4.580096] CACHE TEST FAILED: script execution failed.
> [    4.608092] start=35bbf900, pc=0000680c, end=35bbf92c
> [    4.636239] sym0: CACHE INCORRECTLY CONFIGURED.
> [    4.664419] sym0: giving up ...

This is the failure, but it's a fatal configuration one; I don't think
we know how to fix it.

> [    4.692375] ------------[ cut here ]------------
> [    4.693343] WARNING: at
> /usr/src/linux-3.10.36/arch/x86/include/asm/dma-mapping.h:166

This is just a warning about freeing with interrupts disabled.  It's
probably fixable, but since the major problem is the cache configuration
one, there doesn't seem to be much point.

James


