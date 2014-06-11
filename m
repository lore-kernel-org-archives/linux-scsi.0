From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/14] block: Replace bi_integrity with bi_special
Date: Wed, 11 Jun 2014 09:32:57 -0700
Message-ID: <20140611163257.GB28815@infradead.org>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
 <1401334128-15499-3-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53222 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbaFKQdB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 12:33:01 -0400
Content-Disposition: inline
In-Reply-To: <1401334128-15499-3-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

On Wed, May 28, 2014 at 11:28:36PM -0400, Martin K. Petersen wrote:
> For commands like REQ_COPY we need a way to pass extra information along
> with each bio. Like integrity metadata this information must be
> available at the bottom of the stack so bi_private does not suffice.
> 
> Rename the existing bi_integrity field to bi_special and make it a union
> so we can have different bio extensions for each class of command.
> 
> We previously used bi_integrity != NULL as a way to identify whether a
> bio had integrity metadata or not. Introduce a REQ_INTEGRITY to be the
> indicator now that bi_special can contain different things.
> 
> In addition, bio_integrity(bio) will now return a pointer to the
> integrity payload (when applicable).

Instead of having a union of pointer just make it a void pointer.
I also think special is a terribly generic name, but I don't really
have a better idea at hand.

