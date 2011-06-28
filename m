From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/15] target: WRITE_SAME_16 and WRITE_SAME_32 should be
 DATA_SG_IO cdbs
Date: Tue, 28 Jun 2011 16:14:02 -0400
Message-ID: <20110628201402.GC9676@infradead.org>
References: <1309289377-8029-1-git-send-email-agrover@redhat.com>
 <1309289377-8029-12-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56145
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753136Ab1F1UOD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2011 16:14:03 -0400
Content-Disposition: inline
In-Reply-To: <1309289377-8029-12-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jun 28, 2011 at 12:29:33PM -0700, Andy Grover wrote:
> The definition of what's a data and what's a control CDB is not
> totally clear, but both of these set t_task_lba, so I'm inclined
> to call them data CDBs.

Currently DATA cdbs are those that get passes through to the
backend (except for pscsi which gets all of them). As the backends
can't handle WRITE_SAME this patch is incorrect.

I have a nice prototype to kill that whole DATA vs CONTROL flag thing,
which will be much nicer after your series.  Once the guts of your
patches hit the tree I'll resubmit them.

