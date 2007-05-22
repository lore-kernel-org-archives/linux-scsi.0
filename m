From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [Stgt-devel] Question for pass-through target design
Date: Tue, 22 May 2007 14:56:56 -0500
Message-ID: <20070522195656.GD5758@austin.ibm.com>
References: <463B72F6.3000207@torque.net> <20070506053629P.fujita.tomonori@lab.ntt.co.jp> <463F36AC.3010207@vlnb.net> <20070507182837E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:50779 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822AbXEVT5D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2007 15:57:03 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l4MJr8K6027824
	for <linux-scsi@vger.kernel.org>; Tue, 22 May 2007 15:53:08 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4MJuvAY207930
	for <linux-scsi@vger.kernel.org>; Tue, 22 May 2007 13:56:57 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4MJuuGi019286
	for <linux-scsi@vger.kernel.org>; Tue, 22 May 2007 13:56:57 -0600
Content-Disposition: inline
In-Reply-To: <20070507182837E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: santil@us.ibm.com, vst@vlnb.net, stgt-devel@lists.berlios.de, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Missed a fair bit of this thread when it was first sent, bad mail
filter I think (or pebkac).

* FUJITA Tomonori (fujita.tomonori@lab.ntt.co.jp) wrote:
> From: Vladislav Bolkhovitin <vst@vlnb.net>
> Subject: Re: [Stgt-devel] Question for pass-through target design
> Date: Mon, 07 May 2007 18:24:44 +0400
> 
> > FUJITA Tomonori wrote:
> > >>>>It looks like the pass-through target support is currently broken, at
> > >>>>least as I've checked for ibmvstgt, but I think it's a general problem.
> > >>>>I wanted to check my assumptions and get ideas.
> > >>>
> > >>>Yeah, unfortunately, it works only with the iSCSI target driver (which
> > >>>runs in user space).
> > >>>
> > >>>
> > >>>
> > >>>>The code isn't allocating any memory to pass along to the sg code to store
> > >>>>the result of a read or data for a write.  Currently, dxferp for sg_io_hdr
> > >>>>or dout_xferp/din_xferp for sg_io_v4 are assigned to the value of uaddr,
> > >>>>which is set to 0 in kern_queue_cmd.  With the pointer set to NULL,
> > >>>>the pass-through target isn't going to function.  Even if we had memory
> > >>>>allocated, there isn't a means of getting data to be written via sg down
> > >>>>this code path.
> > >>>>
> > >>>>What ideas are there as to how the data will get to user-space so that
> > >>>>we can use sg?
> > >>>
> > >>>For kernel-space drivers, we don't need to go to user-space. We can do
> > >>>the pass-through in kernel space. I talked with James about this last
> > >>>year and he said that if the code is implemented cleanly, he would
> > >>>merges it into mainline.
> > >>
> > >>We already have a pass-through in the kernel space for
> > >>kernel space drivers. It is the scsi_tgt* code.
> > > 
> > > 
> > > Could you elaborate more?
> > > 
> > > What I meant that is that the kernel tgt code (scsi_tgt*) receives
> > > SCSI commands from one lld and send them to another lld instead of
> > > sending them to user space.
> > 
> > Although the approach of passing SCSI commands from a target LLD to an
> > initiator one without any significant interventions from the target
> > software looks to be nice and simple, you should realize how limited,
> > unsafe and illegal it is, since it badly violates SCSI specs.
> 
> I think that 'implemented cleanly' means that one scsi_host is assigned
> to only one initiator.

Vladislav listed a number of issues that are inherent in an implementation
that does not have a 1:1 relationship of initiators to targets.  The vscsi
architecture defines the 1:1 relationship; it's imposible to have more
than one initiator per target.  Are there any barriers that we will need
to address if this were the case?

Regards,
Rob Jennings
