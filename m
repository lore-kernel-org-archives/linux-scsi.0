From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Wed, 05 Mar 2008 09:26:19 +0900
Message-ID: <20080305092619Y.fujita.tomonori@lab.ntt.co.jp>
References: <47CD7C05.1080707@gmail.com>
	<20080305041914V.tomof@acm.org>
	<47CDDC31.4070806@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:50346 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759965AbYCEA1u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 19:27:50 -0500
In-Reply-To: <47CDDC31.4070806@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: htejun@gmail.com
Cc: tomof@acm.org, efault@gmx.de, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

On Wed, 05 Mar 2008 08:33:05 +0900
Tejun Heo <htejun@gmail.com> wrote:

> FUJITA Tomonori wrote:
> > Hmm, does SCSI mid-layer need to care about how many bytes the block
> > layer allocates? I don't think that extra_len is NOT good_bytes.
> > 
> > I think that the block layer had better take care about it (fix
> > __end_that_request_first?).
> 
> Yeah, probably calling completion functions w/o bytes count is the right
> thing to do but what I was talking about was what could break when the
> semantics of rq->data_len changed.  If we keep rq->data_len() ==
> sum(sg), we keep it business as usual for all the rest except for the
> device application layer if we don't we do the reverse and SCSI midlayer
> completion was a good example, I think.

sglist is a low-level I/O representation for device drivers. SCSI
midlayer should not care about sglist. We should not fix SCSI midlayer
for rq->data_len != sum(sg) change (so I can't agree with your
diagrams in another mail).

When if we change a rule, we need to fix something.

If we keep rq->data_len == sum(sg), we need to fix the device
application layer. If we keep rq->data_len == the true data length, we
need to fix the low-level drivers.

Now I'm fine with the commit e97a294ef6938512b655b1abf17656cf2b26f709
since we are in -rc stages. But I plan to send a patch to revert it
and fix this issue in the block layer. I'd like to test it in -mm for
a while.

Only sglist stuff in SCSI midlayer is scsi_req_map_sg now. As you
know, we really want to remove it.


> Things going the other way is fine with me but I at least want to hear a
> valid rationale.  Till now all I got is "because that's the true size"
> which doesn't really make much sense to me.

Most of users of request structure care about only the real data
length, don't care about padding and drain length. Why do they bother
to use a helper function to get the real data length?
