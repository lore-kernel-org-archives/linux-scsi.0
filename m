From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH V3] bio: modify __bio_add_page() to accept pages that
 don't start a new segment
Date: Tue, 27 May 2014 13:14:04 +0200
Message-ID: <20140527111404.GE2205@dhcp-27-189.brq.redhat.com>
References: <1398952615-22034-1-git-send-email-mlombard@redhat.com>
 <CACVXFVNSZ7+MxW8-SiLXUFW6pGJ7b-OQzf8-KLzcXyE7BvhbbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaE0LOP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2014 07:14:15 -0400
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

the code in this branch does not cover our case, it is intended to cover the case
where __bio_add_page() is called multiple times with the *same* page as parameter.
My patch deals with the case when __bio_add_page() is called with *different* pages
as parameter but physically adjacent to each other.

That said it is true that maybe this branch can be extended to also cover the case
I'm dealing with and try to avoid the problem that commit 3979ef4dcf introduced.

Thanks,
Maurizio Lombardi
