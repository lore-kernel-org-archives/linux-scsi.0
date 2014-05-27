From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH V3] bio: modify __bio_add_page() to accept pages that
 don't start a new segment
Date: Tue, 27 May 2014 22:04:58 +0800
Message-ID: <CACVXFVNwn+_6qk29HtqLLsyiJVHLgJ9XgP=owHJ_B0z_Y0_DuA@mail.gmail.com>
References: <1398952615-22034-1-git-send-email-mlombard@redhat.com>
	<CACVXFVNSZ7+MxW8-SiLXUFW6pGJ7b-OQzf8-KLzcXyE7BvhbbA@mail.gmail.com>
	<20140527115859.GA30458@dhcp-27-189.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f173.google.com ([209.85.128.173]:49002 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbaE0OE7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 10:04:59 -0400
In-Reply-To: <20140527115859.GA30458@dhcp-27-189.brq.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, Kent Overstreet <kmo@daterainc.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Maurizio Lombardi <m.lombardi85@gmail.com>

On Tue, May 27, 2014 at 7:58 PM, Maurizio Lombardi <mlombard@redhat.com> wrote:
> On Tue, May 27, 2014 at 06:15:45PM +0800, Ming Lei wrote:
>>
>> If the page can be merged to last segment, it should have been
>> covered by code in branch of 'if (bio->bi_vcnt > 0) ...', shouldn't it?
>>
>> Or maybe it is better to make that code cover your case since
>> looks your case is similar with that one according to your commit
>> log.
>>
>
> I realized that maybe you mean this branch:
>
> if (bio->bi_vcnt > 1 && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec)))
>
> right?
> In this case the branch is not even reached in the original code because
> the function returned an error way before executing it (line 760)
>
> There was already a patchset trying to modify the code in a different way than mine:
>
> https://groups.google.com/forum/#!msg/linux.kernel/3IanUpBVhFQ/3Xbg3yLRFp4J
>
> but it has been ignored and in my opinion it takes a more
> complicated approach.

Looks your approach is simpler.

But looks there is one problem if I understand correctly:
__blk_recalc_rq_segments() may not cover the last vector
because bio->bi_iter.bi_size isn't updated until the end of
__bio_add_page().

But it shouldn't have been related with current virtio-blk problem.

Thanks,
-- 
Ming Lei
