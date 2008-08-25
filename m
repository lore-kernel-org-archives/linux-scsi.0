From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Ksummit-2008-discuss] Kernel Summit Request for Discussion:
	The Future of Target mode and Cloud storage on Linux
Date: Mon, 25 Aug 2008 14:59:30 -0700
Message-ID: <1219701570.13470.156.camel@haakon2.linux-iscsi.org>
References: <48ADC53B.6090501@vlnb.net>  <48ADFAB7.5010201@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:20884 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753200AbYHYV7d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 17:59:33 -0400
In-Reply-To: <48ADFAB7.5010201@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>

On Thu, 2008-08-21 at 18:31 -0500, Mike Christie wrote:
> snip
> 

Ok, I took in the weekend to let things settle for a few moments.. 

> > 
> > If all necessary pieces of STGT moved in the kernel, it would become 
> > pretty much the same as SCST at the moment. 
> 
> In the top paragraph James is saying to move scst into stgt, so it seems 
> like we can do the following:
> 
> 1. You and with Nick battle each other about what are the best pieces of 
> scst and his target and what should go upstream.
> 

Ok, Vlad and I have discussed and determined that the process will be
something roughly along the lines of

*) Vlad releases upstream patches for SCST Core in the late v2.6.27 time
frame.
*) /me will cherry picks from lio-core-2.6.git specific code (namely the
memory allocation and mapping algorithms) and begin to integrate these
into SCST-Core upstream and get bulk I/O moving between SCST Core
kernel/user CDB generation API.
*) Around the same time, I will begin the porting process of moving
LIO-Target to use the new upstream target infrastructure, whatever it
shall be called.. :-)


> 2. Do a ibm vscsi target for the new framework since that is the only 
> upstream kernel target right now. For qla2xxx, we can forget the patches 
> we sent qlogic and use what comes with the common framework since scst 
> has one already.

This would be fun.. :-)  What hardware do I need to do this again..?

> 
> 3. Start sending patches for common code like scatterlist improvements 
> and scatterlist memory reservations.
> 

Ok, I have been thinking about how to go about this, and it seems to
make sense to incorporate these improvements from LIO-Core into SCST
Core during the first phase.  This codepath in LIO is historically known
as ICF_SCSI_DATA_SG_IO_CDB which handles the 1 -> N allocation and
mapping for the generic linked list pages -> contigious scatterlist
array memory mapping case.

This is also piece that can be generic for handling WRITE/READ I/Os with
LBA + SECTOR_COUNT + SECTOR_SIZE across the "SCSI-less" target cases.  I
guess putting it into SCST Core for now makes sense, espically if we
move SCST Core into supporting the SCSI-less target fabrics..

> 4. Send patches for new target infrastructure core code for review and 
> cleanup. And send ibm vscsi target driver for an example and to make 
> sure there are no functionality regressions. The latter should not be 
> too hard because stgt does not have many features right? :)
> 

Understood.

> 5. When common code is merged and new core target infrastructure is 
> through the review process we can just swap out the new code for stgt 
> and name it whatever you want.
> 

Heh, looks like we have to start thinking of a new name. :-)

> Tomo and I can handle trying to modify the new framework to support 
> putting a scsi state machine in userspace and sharing that with kernel 
> code. Right now the primary targets for stgt that users are deploying 
> are are completely in userspace, so we do not have much to worry about. 
> There are ibm vscsi users, but they are a lot smaller in number compared 
> to iscsi. I would bet the ibmvscsi would prefer to use the kernel target 
> we make too.
> 

Understood.

> Our userspace tools will also be able to support both kernel space and 
> userspace targets with little trouble so distros that have stgt will not 
> notice any differences.
> 

So this is one of the items that I mentioned to Vlad as being a
potential stumbling block..  I stated that I have no problem dumping the
LIO IOCTL in favor of something better, and having to break backwards
compat with LIO userspace tools (well, until I have to emulate the
backwards compat wrt target-ctl ;-)) is something I am ready to deal
with.

So I definately see your point here, having the exist CLI logic in place
into distros is something that we are going to have to deal with (even
if the core behind them is completely different).  

I should also mention that virtually all of the configuration logic done
from the LIO-Core and LIO-Target IOCTLs today is intended (minus a bug
or two :-) to be done without having to shutdown/stop anything other
than the referenced object for the target-ctl operation.  Obviously, I
really want to keep the same functionality with the CLI interface the
LIO pieces are ported to.

I will be sure to take a look at the STGT control interface and see how
I can fit the current functionality in.  I believe SCST uses an IOCTL
today as well, which would put them in a similar situation.


> Surely this will be faster than writing all these mails and wasting time 
> on this :)
> 
> I think James also said something about moving STGT in-kernel to get 
> performance gains, but I do not think it means that we have to push 
> exact code that sits in Tomo's git tree from usrspace into the kernel. 
> If along the way we replace it with scst or Nick's code and we end up 
> with a variant of scst or Nicks code that can still support userspace 
> targets then I do not think any one is going to make long threads like 
> these have resulted in :)
> 
> Will this work for everyone?
> 

Sounds good.  Many thanks for putting things into perspective mnc.

:-)

--nab


