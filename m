From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: fusion problems on 64bit hosts
Date: Mon, 27 Sep 2004 18:12:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57050F84D0@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35061 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S267400AbUI0WMq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2004 18:12:46 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, "Shirron, Stephen" <Stephen.Shirron@lsil.com>

On Saturday, September 25, 2004 7:57 AM, Christoph Hellwig wrote:
> 
> compiling fusion on ppc64 gives:
> 
> drivers/message/fusion/mptbase.c: In function `mpt_interrupt':
> drivers/message/fusion/mptbase.c:360: warning: cast to 
> pointer from integer of different size
> drivers/message/fusion/mptbase.c:384: warning: cast to 
> pointer from integer of different size
> drivers/message/fusion/mptlan.c: In function `lan_reply':
> drivers/message/fusion/mptlan.c:214: warning: cast from 
> pointer to integer of different size
> 
> This is because of:
> 
> #if defined(__alpha__) || defined(__sparc_v9__) || 
> defined(__ia64__) || defined(__x86_64__)
> #define CAST_U32_TO_PTR(x)      ((void *)(u64)x)
> #define CAST_PTR_TO_U32(x)      ((u32)(u64)x)
> #else
> #define CAST_U32_TO_PTR(x)      ((void *)x)
> #define CAST_PTR_TO_U32(x)      ((u32)x)
> #endif
> 
> which shuts the warning up on some 64bit architectures but 
> doesn't solve
> the problem.  You're trying to keep a 64bit pointer in a 
> 32bit hardware
> register which can't work on 64bit architectures (the code if for the
> networking and target modules that few people use)
> 
> The right fix is to only store a 32bit lookup key for some 
> datastructure
> in the register and use it as lookup key in the intr handler.
>

No, we are not keeping a 64bit pointer in a 32bit hardware register.
IMO we can solve this issue by adding ppc64 to define above.

Here is my explanation:
The Reply Message can come in two forms.  (1) Address Reply (2) Context
Reply,
also known as Turbo Reply.  The Address Reply means that the previous
command probally 
had issues completing, or maybe it completed and the Firmware is returning
more detailed info about the request, thus a address is returned in the
RequestFifo pointing to 
Reply Message Frame containing infomation about the request.  A context
reply means the previous
command completed successfully, and the RequestFifo returns a 32bit
MessageContext field 
copied from the original message frame.

For Address Reply, the lower 32 bit physical address is in the
ioc->chip->ReplyFifo register. 
The high 32bit physical address is set when we did the IOCInit config frame 
during driver load time.  If we get a Context Reply, the
ioc->chip->ReplyFifo contains 
protocal dependent data.  In this driver, this is how we define the protocal
dependend data:

Bits 15-0 are index to the orignal request 
Bits 24-16 is callback index.  

The compile errors your refering to { line 360 and 384 in mptbase.c } and {
line 214
in mptlan.c} are context replys.

Therefore the typecasting is used to so both types of Reply Messages (
address and context)
can work thru same callback handlers via MptCallbacks[cb_idx](ioc, mf, mr),
line 427 in mptbase.c







 
