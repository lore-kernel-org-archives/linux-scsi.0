From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH V3] bio: modify __bio_add_page() to accept pages that
 don't start a new segment
Date: Tue, 27 May 2014 13:58:59 +0200
Message-ID: <20140527115859.GA30458@dhcp-27-189.brq.redhat.com>
References: <1398952615-22034-1-git-send-email-mlombard@redhat.com>
 <CACVXFVNSZ7+MxW8-SiLXUFW6pGJ7b-OQzf8-KLzcXyE7BvhbbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaE0L7K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2014 07:59:10 -0400
Content-Disposition: inline
In-Reply-To: <CACVXFVNSZ7+MxW8-SiLXUFW6pGJ7b-OQzf8-KLzcXyE7BvhbbA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, m.lombardi85@gmail.com

On Tue, May 27, 2014 at 06:15:45PM +0800, Ming Lei wrote:
> 
> If the page can be merged to last segment, it should have been
> covered by code in branch of 'if (bio->bi_vcnt > 0) ...', shouldn't it?
> 
> Or maybe it is better to make that code cover your case since
> looks your case is similar with that one according to your commit
> log.
>

I realized that maybe you mean this branch:

if (bio->bi_vcnt > 1 && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec)))

right?
In this case the branch is not even reached in the original code because
the function returned an error way before executing it (line 760)

There was already a patchset trying to modify the code in a different way than mine:

https://groups.google.com/forum/#!msg/linux.kernel/3IanUpBVhFQ/3Xbg3yLRFp4J

but it has been ignored and in my opinion it takes a more
complicated approach.

Regards,
Maurizio Lombardi
