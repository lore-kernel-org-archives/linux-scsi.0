From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/5] sg_ring for scsi
Date: Thu, 20 Dec 2007 18:53:48 +1100
Message-ID: <200712201853.48643.rusty@rustcorp.com.au>
References: <200712201645.19035.rusty@rustcorp.com.au> <20071220160741K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:50549 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbXLTHx4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Dec 2007 02:53:56 -0500
In-Reply-To: <20071220160741K.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net

On Thursday 20 December 2007 18:07:41 FUJITA Tomonori wrote:
> On Thu, 20 Dec 2007 16:45:18 +1100
>
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> > OK, some fixes since last time, as I wade through more SCSI drivers. 
> > Some drivers use "use_sg" as a flag to know whether the request_buffer is
> > a scatterlist: I don't need the counter, but I still need the flag, so I
> > fixed that in a more intuitive way (an explicit ->sg pointer in the cmd).
>
> use_sg and the request_buffer will be removed shortly.
>
> http://marc.info/?l=linux-scsi&m=119754650614813&w=2

Thanks!  Is there a git tree somewhere with these changes?

> I think that we tried the similar idea before, scsi_sgtable, but we
> seem to settle in the current simple approach.

Yes, a scsi-specific solution is a bad idea: other people use sg.  
Manipulating the magic chains is horrible; it looks simple to the places 
which simply want to iterate through it, but it's awful for code which wants 
to create them.

Cheers,
Rusty.
