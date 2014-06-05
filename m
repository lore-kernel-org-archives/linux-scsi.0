From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/7] mptfusion: initChainBuffers should return errno
Date: Thu, 5 Jun 2014 02:27:21 -0700
Message-ID: <20140605092721.GD727@infradead.org>
References: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
 <1401900589-19672-4-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38640 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaFEJ1V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2014 05:27:21 -0400
Content-Disposition: inline
In-Reply-To: <1401900589-19672-4-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

On Wed, Jun 04, 2014 at 12:49:45PM -0400, Joe Lawrence wrote:
> The lone caller of initChainBuffers checks the return code for < 0, so
> it is safe to appease smatch and return the proper errno value.

I don't think this is useful on it's own as the whole callchain around
it uses the same -1 for error convention.  Returning proper errnos
seems useful to me, but without converting the whole chain it would
just introduce more inconsistencies.

