From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH 2/3] scsi_forget_host - scsi_debug usage
Date: Mon, 14 Jun 2004 08:23:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040614152339.GA3826@us.ibm.com>
References: <20040612041930.GA21105@us.ibm.com> <20040612042106.GB21105@us.ibm.com> <20040612042232.GC21105@us.ibm.com> <20040614080632.GA7114@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:44278 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S263154AbUFNPXl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2004 11:23:41 -0400
Content-Disposition: inline
In-Reply-To: <20040614080632.GA7114@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig [hch@infradead.org] wrote:
> On Fri, Jun 11, 2004 at 09:22:32PM -0700, Mike Anderson wrote:
> > DESC
> > scsi_forget_host - scsi_debug usage
> > 
> > Use the export scsi_forget_host interface to remove child scsi devices
> > from the scsi_host prior to removal.
> 
> Moving this into drivers sounds like a rather bad idea.  But with our
> refcounting in place I wonder whether moving scsi_forget_host first in
> scsi_remove_host wouldn't simply work.

Why is this a bad idea? We allow the LLDD to control scanning through
scsi_scan_host. We also have LLDDs calling scsi_remove_device directly
which scsi_forget_host uses.

The issue I was trying to address is there are callers that want to call
scsi_remove_host during unexpected disconnect situations where they want
to reduce more IO being sent to the LLDDs queuecommand. It should be the
case that if a LLDD can handle unexpected disconnect that they already
have code in there queuecommand to stop the flow of IO in these cases so
your suggested change to scsi_remove_host may not negatively effect
LLDDs.

-andmike
--
Michael Anderson
andmike@us.ibm.com

