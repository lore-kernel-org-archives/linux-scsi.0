From: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with
	blk_rq_map_kern_sgl()
Date: Mon, 13 Apr 2009 14:59:12 +0200
Message-ID: <20090413125912.GA16337@liondog.tnic>
References: <49D39DBC.3000206@panasas.com> <20090413164146J.fujita.tomonori@lab.ntt.co.jp> <49E3080F.7080206@kernel.org> <20090413190747V.fujita.tomonori@lab.ntt.co.jp>
Reply-To: petkovbb@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:30576 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbZDMM7T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2009 08:59:19 -0400
Content-Disposition: inline
In-Reply-To: <20090413190747V.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tj@kernel.org, bharrosh@panasas.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 13, 2009 at 07:07:58PM +0900, FUJITA Tomonori wrote:
> On Mon, 13 Apr 2009 18:38:23 +0900
> Tejun Heo <tj@kernel.org> wrote:
> 
> > FUJITA Tomonori wrote:
> > >> I thought that was agreed and done? What is left to do for that to go
> > >> in.
> > > 
> > > I've converted all the users (sg, st, osst). Nothing is left. So we
> > > don't need this.
> > 
> > Yeah, pulled it.  Okay, so we can postpone diddling with request
> > mapping for now.  I'll re-post fixes only from this and the previous
> > patchset and proceed with other patchsets.
> 
> To be honest, I don't think that we can clean up the block
> mapping. For example, blk_rq_map_kern_prealloc() in your patchset
> doesn't look cleanup to me. It's just moving a hack from ide to the
> block (well, I have to admit that I did the same thing when I
> converted sg/st/osst...).

Well, since blk_rq_map_kern_prealloc() is going to be used only in
ide-cd (driver needs it to queue a sense request from within the irq
handler) and since it is considered a hack I could try to move it out of
the irq handler and do away only with blk_rq_map_kern() if that is more
of an agreeable solution?

-- 
Regards/Gruss,
    Boris.
