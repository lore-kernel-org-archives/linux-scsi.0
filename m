From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Wed, 30 Jan 2008 10:34:31 -0600
Message-ID: <1201710871.3292.22.camel@localhost.localdomain>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <adazluoe2t3.fsf@cisco.com> <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46005 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492AbYA3Qei (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2008 11:34:38 -0500
In-Reply-To: <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, rdreier@cisco.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org


On Wed, 2008-01-30 at 09:38 +0100, Bart Van Assche wrote:
> On Jan 30, 2008 12:32 AM, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> >
> > iSER has parameters to limit the maximum size of RDMA (it needs to
> > repeat RDMA with a poor configuration)?
> 
> Please specify which parameters you are referring to. As you know I
> had already repeated my tests with ridiculously high values for the
> following iSER parameters: FirstBurstLength, MaxBurstLength and
> MaxRecvDataSegmentLength (16 MB, which is more than the 1 MB block
> size specified to dd).

the 1Mb block size is a bit of a red herring.  Unless you've
specifically increased the max_sector_size and are using an sg_chain
converted driver, on x86 the maximum possible transfer accumulation is
0.5MB.

I certainly don't rule out that increasing the transfer size up from
0.5MB might be the way to improve STGT efficiency, since at an 1GB/s
theoretical peak, that's roughly 2000 context switches per I/O; however,
It doesn't look like you've done anything that will overcome the block
layer limitations.

James


