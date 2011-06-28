From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/15] target: Enforce 1 page max for control cdb buffer
 sizes
Date: Tue, 28 Jun 2011 16:15:51 -0400
Message-ID: <20110628201551.GD9676@infradead.org>
References: <1309289377-8029-1-git-send-email-agrover@redhat.com>
 <1309289377-8029-14-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56168
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854Ab1F1UPw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2011 16:15:52 -0400
Content-Disposition: inline
In-Reply-To: <1309289377-8029-14-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jun 28, 2011 at 12:29:35PM -0700, Andy Grover wrote:
> Due to all cdbs' data buffers being referenced by scatterlists, buffers
> of more than a page are not contiguous. Instead of handling this in all
> control command handlers, we may be able to get away with just limiting
> control cdb data buffers to one page. The only control CDBs we handle that
> have potentially large data buffers are REPORT LUNS and UNMAP, so if we
> didn't want to live with this limitation, they would need to be modified
> to walk the pages in the data buffer's sgl.

I think this should be moved earlier in the series, that is before
making all control CDBs use SG lists.

