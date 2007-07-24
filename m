From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large
 IO sg-chaining
Date: Tue, 24 Jul 2007 20:12:47 +0900
Message-ID: <20070724201247A.fujita.tomonori@lab.ntt.co.jp>
References: <46A5BCB6.9050102@panasas.com>
	<20070724181635G.fujita.tomonori@lab.ntt.co.jp>
	<46A5CDFE.3020801@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:63558 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933497AbXGXLOg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 07:14:36 -0400
In-Reply-To: <46A5CDFE.3020801@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large IO sg-chaining
Date: Tue, 24 Jul 2007 13:01:34 +0300

> FUJITA Tomonori wrote:
> > From: Boaz Harrosh <bharrosh@panasas.com>
> > Subject: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large IO sg-chaining
> > Date: Tue, 24 Jul 2007 11:47:50 +0300
> > 
> >> As Jens said, there is nothing common to scsi_sgtable and 
> >> sglists. Save the fact that it is a massive conflict at 
> >> scsi-ml. They touch all the same places.
> >>
> >> Proposed is a simple way out. Two patchsets That produce the
> >> same output at the end.
> >>
> >> One: scsi_sgtable_than_sg-chaining
> >> Two: sg-chaining_than_scsi_sgtable
> > 
> > Hmm, I thought that I've already posted a scsi_sgtable patch working
> > with sg-chaining together.
> > 
> > http://marc.info/?l=linux-scsi&m=118519987632758&w=2
> > 
> > I quoted from my mail:
> > 
> > ---
> > I think that the main issue of integrating sgtable and sglist is how
> > to put scatterlist to scsi_sgtable structure.
> > 
> > If we allocate a scsi_sgtable structure and sglists separately, the
> > code is pretty simple. But probably it's not the best way from the
> > perspective of performance.
> > 
> I was just answering your other mail when this came in so I'll answer
> here. 
> This Approach is exactly the scsi_data_buffer approach we both
> had solutions for. At the time I was all for that approach because it
> is safer and could be kept compatible to old drivers. (Less work for
> me) But it was decided against it. So suggesting it again is plain
> going back.

Well, the approach to shuffle the entire request setup around was
rejected. But was the approach to use two data buffers for bidi
completely rejected?


> > If we put sglists into the scsi_sgtable structure (like Boaz's patch
> > does) and allocate and chain sglists only for large I/Os, we would
> > have the better performance (especially for small I/Os). But we will
> > have more complicated code.
> 
> Only that my proposed solution is more simple more elegant and more
> robust than even Jens's solution without any sgtable at all. Actually 
> the sgtable does good to chaining. scsi_lib with sglist+sgtable is 
> smaller than Jens's sglist by itself.

Your patch chains sgtables instead of sglists. It uses more memory for
simple code. But I think that it's a nice approach.
