From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Stgt-devel] Question for pass-through target design
Date: Tue, 8 May 2007 00:10:02 +0900 (JST)
Message-ID: <20070507182837E.fujita.tomonori@lab.ntt.co.jp>
References: <463B72F6.3000207@torque.net>
	<20070506053629P.fujita.tomonori@lab.ntt.co.jp>
	<463F36AC.3010207@vlnb.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:58538 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934132AbXEGPKS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 11:10:18 -0400
In-Reply-To: <463F36AC.3010207@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vst@vlnb.net
Cc: fujita.tomonori@lab.ntt.co.jp, scst-devel@lists.sourceforge.net, stgt-devel@lists.berlios.de, linux-scsi@vger.kernel.org

From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Stgt-devel] Question for pass-through target design
Date: Mon, 07 May 2007 18:24:44 +0400

> FUJITA Tomonori wrote:
> >>>>It looks like the pass-through target support is currently broken, at
> >>>>least as I've checked for ibmvstgt, but I think it's a general problem.
> >>>>I wanted to check my assumptions and get ideas.
> >>>
> >>>Yeah, unfortunately, it works only with the iSCSI target driver (which
> >>>runs in user space).
> >>>
> >>>
> >>>
> >>>>The code isn't allocating any memory to pass along to the sg code to store
> >>>>the result of a read or data for a write.  Currently, dxferp for sg_io_hdr
> >>>>or dout_xferp/din_xferp for sg_io_v4 are assigned to the value of uaddr,
> >>>>which is set to 0 in kern_queue_cmd.  With the pointer set to NULL,
> >>>>the pass-through target isn't going to function.  Even if we had memory
> >>>>allocated, there isn't a means of getting data to be written via sg down
> >>>>this code path.
> >>>>
> >>>>What ideas are there as to how the data will get to user-space so that
> >>>>we can use sg?
> >>>
> >>>For kernel-space drivers, we don't need to go to user-space. We can do
> >>>the pass-through in kernel space. I talked with James about this last
> >>>year and he said that if the code is implemented cleanly, he would
> >>>merges it into mainline.
> >>
> >>We already have a pass-through in the kernel space for
> >>kernel space drivers. It is the scsi_tgt* code.
> > 
> > 
> > Could you elaborate more?
> > 
> > What I meant that is that the kernel tgt code (scsi_tgt*) receives
> > SCSI commands from one lld and send them to another lld instead of
> > sending them to user space.
> 
> Although the approach of passing SCSI commands from a target LLD to an
> initiator one without any significant interventions from the target
> software looks to be nice and simple, you should realize how limited,
> unsafe and illegal it is, since it badly violates SCSI specs.

I think that 'implemented cleanly' means that one scsi_host is assigned
to only one initiator.
