From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] ibmvscsi driver - next version
Date: Mon, 23 Feb 2004 14:08:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040223220807.GB1389@beaverton.ibm.com>
References: <opr3s2iefyl6e53g@us.ibm.com> <20040223144542.A9624@infradead.org> <403A6822.2040700@us.ibm.com> <20040223210842.A14093@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from over.ny.us.ibm.com ([32.97.182.111]:55241 "EHLO
	over.ny.us.ibm.com") by vger.kernel.org with ESMTP id S262065AbUBWWNW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 17:13:22 -0500
Received: from e32.co.us.ibm.com (e32.esmtp.ibm.com [9.14.4.130])
	by pokfb.esmtp.ibm.com (8.12.10/8.12.9) with ESMTP id i1NM5XRa195124
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2004 17:05:33 -0500
Content-Disposition: inline
In-Reply-To: <20040223210842.A14093@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian King <brking@us.ibm.com>, Dave Boutcher <sleddog@us.ibm.com>, linux-scsi@vger.kernel.org

Christoph Hellwig [hch@infradead.org] wrote:
> On Mon, Feb 23, 2004 at 02:52:50PM -0600, Brian King wrote:
> > I'm not sure I agree with this statement. Looking at scsi_error.c, it looks
> > to me like there is a race condition in that the midlayer decides whether or
> > not to abort an op, then grabs the host lock, then calls eh_abort. From the
> > time that the midlayer decides to abort an op and then grabs the host lock, the
> > op may have finished.
> 
> Could ypu please submit a patch to fix it?
> 
> I wish people would just send patches directly if they encounter problem..

I believe the comment was in review of the driver. There is no scsi core
patch needed. The LLDD driver being reviewed should return "SUCCESS".

In the future having all completions go through scsi_done would help
here and make it clearer to the LLDD on what to do.

-andmike
--
Michael Anderson
andmike@us.ibm.com

