From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/8] scsi: clean up S/G table freeing
Date: Wed, 1 Oct 2014 23:05:51 +0200
Message-ID: <20141001210551.GA6784@lst.de>
References: <1410107469-896-1-git-send-email-hch@lst.de> <1410107469-896-4-git-send-email-hch@lst.de> <542BF1FA.5050908@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43493 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbaJAVFx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2014 17:05:53 -0400
Content-Disposition: inline
In-Reply-To: <542BF1FA.5050908@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Wed, Oct 01, 2014 at 02:22:18PM +0200, Bart Van Assche wrote:
> I can see that the scsi_free_sgtable(&cmd->sdb, false) call, the 
> scsi_free_sgtable(cmd->prot_sdb, false) call and the 
> scsi_free_sgtable(bidi_sdb, false) call are now performed by the new 
> function scsi_free_sgtables(). But what's not clear to me is to which 
> function the kmem_cache_free(scsi_sdb_cache, bidi_sdb) call has been moved 

Seems like we lost if for the !mq case, oops.

