From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Wed, 11 Aug 2004 22:19:45 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040811201944.GA1550@openzaurus.ucw.cz>
References: <4119611D.60401@optonline.net> <20040811080935.GA26098@elf.ucw.cz> <411A1B72.1010302@optonline.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:57785 "EHLO
	atrey.karlin.mff.cuni.cz") by vger.kernel.org with ESMTP
	id S268217AbUHKU3T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2004 16:29:19 -0400
Content-Disposition: inline
In-Reply-To: <411A1B72.1010302@optonline.net>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Bryant <nbryant@optonline.net>
Cc: Pavel Machek <pavel@ucw.cz>, 'James Bottomley' <James.Bottomley@steeleye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, jgarzik@pobox.com

Hi!

> >swsusp will then resume disk and write the image, that should not be 
> >a
> >problem. Is it guaranteed that after generic_scsi_suspend() no DMA is
> >going on?
> > 
> >
> No. Remember that DMA works differently under SCSI than it does under 
> IDE. SCSI DMA is a host controller feature, whereas under IDE it is 
> enabled/disabled at the drive level and the drives have special 
> knowledge of DMA. Since generic_scsi_suspend() is the device level 
> suspend routine, it is called before the host controller's suspend 
> routine, (due to depth first traversal of device tree), which is 
> responsible for disabling the PCI slot. Only after the host 
> controller is suspended will there be no DMA, but if your real 
> question is "can I generically control a SCSI disk with PIO for 
> software suspend" then the answer is NO. For purposes of not 

No, I do not need PIO. I'll probably need host
controller support, too, but even w/o it it should
work acceptably. Thanks for the answers.
-- 
64 bytes from 195.113.31.123: icmp_seq=28 ttl=51 time=448769.1 ms         

