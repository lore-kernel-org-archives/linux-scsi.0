From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] fix 2.5 scsi queue depth setting
Date: Wed, 6 Nov 2002 10:24:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021106102444.A11790@eng2.beaverton.ibm.com>
References: <patmans@us.ibm.com> <200211061747.gA6HlS803188@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200211061747.gA6HlS803188@localhost.localdomain>; from James.Bottomley@steeleye.com on Wed, Nov 06, 2002 at 12:47:28PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Wed, Nov 06, 2002 at 12:47:28PM -0500, J.E.J. Bottomley wrote:
> This is what I think needs to be done to the patch, does this look OK?
> 
> James

The only problem is that scsi_build_commandblocks() sets sdev->new_queue_depth 
to 1, so if the slave_attach() does not set queue depth, we will leave
it at 1, and the post-slave_attach call to scsi_adjust_queue_depth
can never be hit.

It looks like the code could be removed from scsi_build_commandblocks,
since (in this code path) we will always call scsi_adjust_queue_depth
before sending IO, and other code paths always set new_queue_depth
prior to calling scsi_build_commandblocks.

It would be nice if scsi_request_fn would abort IO if current_queue_depth
== 0 or new_queue_depth == 0.

And yes, I missed scsi_syms.c.

-- Patrick Mansfield

