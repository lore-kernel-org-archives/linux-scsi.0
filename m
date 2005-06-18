From: Peter Missel <peter.missel@onlinehome.de>
Subject: Re: SYM8xx_2 sync speed negotiation
Date: Sat, 18 Jun 2005 23:52:46 +0200
Message-ID: <200506182352.47197.peter.missel@onlinehome.de>
References: <200412311343.42484.peter.missel@onlinehome.de> <200504092344.41310.peter.missel@onlinehome.de> <200505042347.31251.peter.missel@onlinehome.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:39120 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S261468AbVFRVxX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Jun 2005 17:53:23 -0400
In-Reply-To: <200505042347.31251.peter.missel@onlinehome.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, james.bottomley@steeleye.com

Greetings!

Following up on this: With released 2.6.12 kernel, the problem remains.

I'd like to emphasize again that this particular SCSI chain has been working 
perfectly with sym8xx drivers before 2.1.18. The culprit is the later 
drivers' inability to honor the sync period negotiation limits set in the 
adapter's NVRAM. (sym0:1 is the only Ultra capable device on a chain that 
can't run Ultra due to cable length. NVRAM is set to limit the entire chain 
to 10 MB/s).

2.1.18 forced me to disconnect the external branch because this driver would 
run this device in Ultra mode despite NVRAM forbidding it. Now, with 2.2.0, 
even with just the internal chain, this channel has become entirely 
inoperable, as shown below.

I understand how the reading of sync/wide negotiation limits disappeared from 
the low level driver with the introduction of the "transport" layer - but now 
that a mechanism for doing exactly that has been implemented into the 
latter ...

http://marc.theaimsgroup.com/?l=linux-scsi&m=111540278825762&w=2

... wouldn't it be time to finally bring this important feature back into the 
sym8xx driver's interaction with the transport layer?

I'll close with a self-quote:

> Domain-validate and negotiate as much as you please, but never, ever, set
> up a sync speed higher than the limit set in SCSI BIOS (for the device or
> the entire channel).

best regards,
Peter Missel

On Wednesday 04 May 2005 23:47, Peter Missel wrote:
> ... is getting worse.
>
> Having just tried kernel 2.6.12-rc3 for unrelated reasons, I have found
> that this cannot run my 2nd SCSI chain AT ALL. The driver is stuck in an
> endless loop of resets:
>
> May  4 23:23:28 Earth kernel: sym0: PCI STATUS = 0x2000
> May  4 23:23:28 Earth kernel: sym0: SCSI BUS reset detected.
> May  4 23:23:28 Earth kernel: sym0: SCSI BUS has been reset.
> May  4 23:23:31 Earth kernel: sym0:1: ERROR (20:0) (0-a3-0) (0/7/0) @ (mem
> f000e810:00000000).
> May  4 23:23:31 Earth kernel: sym0: regdump: da 10 c0 07 47 00 01 02 70 00
> 00 a3 80 01 0b 00 00 c8 94 1f 08 00
>  00 00.
> May  4 23:23:31 Earth kernel: sym0: PCI STATUS = 0x2000
> May  4 23:23:31 Earth kernel: sym0: SCSI BUS reset detected.
> May  4 23:23:31 Earth kernel: sym0: SCSI BUS has been reset.
> May  4 23:23:35 Earth kernel: sym0:1: ERROR (20:0) (0-a3-0) (0/7/0) @ (mem
> f000e810:00000000).
> May  4 23:23:35 Earth kernel: sym0: regdump: da 10 c0 07 47 00 01 02 70 00
> 00 a3 80 01 0b 00 00 30 b8 0e 08 00
>  00 00.
> May  4 23:23:35 Earth kernel: sym0: PCI STATUS = 0x2000
> May  4 23:23:35 Earth kernel: sym0: SCSI BUS reset detected.
> May  4 23:23:35 Earth kernel: sym0: SCSI BUS has been reset.
> May  4 23:23:38 Earth kernel: sym0:1: ERROR (20:0) (0-a3-0) (0/7/0) @ (mem
> f000e810:00000000).
> May  4 23:23:38 Earth kernel: sym0: regdump: da 10 c0 07 47 00 01 02 70 00
> 00 a3 80 01 0b 00 00 c0 94 1f 08 00
>  00 00.
> May  4 23:23:38 Earth kernel: sym0: PCI STATUS = 0x2000
> May  4 23:23:38 Earth kernel: sym0: SCSI BUS reset detected.
> May  4 23:23:38 Earth kernel: sym0: SCSI BUS has been reset.
> May  4 23:23:42 Earth kernel: sym0:1: ERROR (20:0) (0-a3-0) (0/7/0) @ (mem
> f000e810:00000000).
> May  4 23:23:42 Earth kernel: sym0: regdump: da 10 c0 07 47 00 01 02 70 00
> 00 a3 80 01 0b 00 00 c8 94 1f 08 00
>  00 00.
>
