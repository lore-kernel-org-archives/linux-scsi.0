From: "nickcheng" <nick.cheng@areca.com.tw>
Subject: RE: Patch added to scsi-rc-fixes-2.6:  [SCSI] arcmsr: fix messageallocation
Date: Tue, 26 Feb 2008 12:29:13 +0800
Message-ID: <000d01c87830$23d84b00$8800a8c0@Nick>
References: <1203950310.3254.9.camel@localhost.localdomain>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from areca.com.tw ([220.130.178.142]:36213 "EHLO areca.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058AbYBZE3R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 23:29:17 -0500
In-Reply-To: <1203950310.3254.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: 'Daniel Drake' <dsd@gentoo.org>, linux-scsi@vger.kernel.org

James,
Appreciate for your answer.
One more question: do you think there are any compatibility issues on
kmalloc/kfree pair?
I just trace the kernel code. It looks like it would not.
But I am not quite sure absolutely.
May I have your comments?
Thank you,

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Monday, February 25, 2008 10:39 PM
To: nick.cheng@areca.com.tw
Cc: 'Daniel Drake'; linux-scsi@vger.kernel.org; 'erich'
Subject: RE: Patch added to scsi-rc-fixes-2.6: [SCSI] arcmsr: fix
messageallocation

On Mon, 2008-02-25 at 18:47 +0800, nickcheng wrote:
> Sorry, maybe I did not ask distinctly enough.
> I mean if I would like to allocate a memory space from ZONE_DMA for atomic
> context, why can I not use kmalloc(1032, GFP_ATOMIC|GFP_DMA)?
> In case of lack of GFP_DMA, kmalloc would grab the memory from ZONE_HIGH
or
> ZONE_HIGHMEM, isn't it?(I read it from the textbook of Linux Kernel
> Development by Robert Love)

Um, no that's not true at all.  GFP_DMA only allocates memory from
ZONE_DMA and fails otherwise.  You only need memory from ZONE_DMA if you
cannot address physical memory above 24 bits (the old ISA restriction).
This only applies if you're a standard ISA device and you're going
actually to DMA to the memory in question.  Neither of which applies in
the arcmsr case, since you're only using the memory as a copy buffer
within the kernel (it never sees an actual DMA transfer), and arcmsr
doesn't have the ISA restrictions.

> Or the basic is that you don't think it is necessary to allocate a memory
> space from DMA area?
> Please give me some comments.

It's unnecessary because you never DMA to it, but even if you did, since
arcmsr is a non-ISA device (with 64 bit DMA mask falling back to 32) you
can just use ordinary kmalloc'd memory for that (provided you obey the
coherence requirements).

James


