From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: compile warning fix for advansys (trivial)
Date: Mon, 29 Dec 2003 00:26:39 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0312290017120.554-100000@poirot.grange>
References: <20031228200548.A22668@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46813 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262522AbTL1X0o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Dec 2003 18:26:44 -0500
In-Reply-To: <20031228200548.A22668@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Sun, 28 Dec 2003, Christoph Hellwig wrote:

> It's not that easy.  You need to move the request_region as early as
> the check_region is currently and make sure you properly release the
> I/O region again on an initialization failure later on.

Hm, my assumption was, that if the old version, doing

if (check_region())
	fail();

if (!request_region())
	fail();

was correct, it would mean, that if check_region succeeds, but due to the
race, the following request_region() fails, the error-processing and
bailing-out should work correct. So, we can just safely assume, that the
check_region() does succeed, and let the actual request_region decide. So,
I think, the patch would only be wrong if either the original driver
behaviour was wrong in the race-case, or there are other paths, except
the above, where only the result of check_region() is used, without
actually doing request_region(), which would be a bit strange. Or is this
the case?

Thanks
Guennadi
---
Guennadi Liakhovetski


