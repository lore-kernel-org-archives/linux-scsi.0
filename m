From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH V3] bio: modify __bio_add_page() to accept pages that
 don't start a new segment
Date: Tue, 27 May 2014 16:27:26 +0200
Message-ID: <20140527142726.GB30458@dhcp-27-189.brq.redhat.com>
References: <1398952615-22034-1-git-send-email-mlombard@redhat.com>
 <CACVXFVNSZ7+MxW8-SiLXUFW6pGJ7b-OQzf8-KLzcXyE7BvhbbA@mail.gmail.com>
 <20140527115859.GA30458@dhcp-27-189.brq.redhat.com>
 <CACVXFVNwn+_6qk29HtqLLsyiJVHLgJ9XgP=owHJ_B0z_Y0_DuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVNwn+_6qk29HtqLLsyiJVHLgJ9XgP=owHJ_B0z_Y0_DuA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, axboe@kernel.dk
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Maurizio Lombardi <m.lombardi85@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 27, 2014 at 10:04:58PM +0800, Ming Lei wrote:
> 
> Looks your approach is simpler.
> 
> But looks there is one problem if I understand correctly:
> __blk_recalc_rq_segments() may not cover the last vector
> because bio->bi_iter.bi_size isn't updated until the end of
> __bio_add_page().
> 
> But it shouldn't have been related with current virtio-blk problem.
>

This is a valid point, bi_iter.bi_size influences the behaviour of
blk_recount_segments(). Maybe Jens can confirm your observation.

Anyway it doesn't explain the reason behind the regression
introduced by commit 3979ef4dcf

Maurizio Lombardi
