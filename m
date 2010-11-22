From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] target: simplify cmd to task mapping
Date: Mon, 22 Nov 2010 16:07:07 -0500
Message-ID: <20101122210707.GA25898@infradead.org>
References: <20101117213857.GB26557@infradead.org>
 <4CE516F5.10400@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37743 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab0KVVHL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2010 16:07:11 -0500
Content-Disposition: inline
In-Reply-To: <4CE516F5.10400@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, nab@linux-iscsi.org, linux-scsi@vger.kernel.org

On Thu, Nov 18, 2010 at 02:07:17PM +0200, Boaz Harrosh wrote:
> If all these are mutual exclusive (if..elseif..else) can we not make
> them an enum and switch() for costless-ness and clarity?

We could.  But IMHO we should simply get rid of all the special cases
instead.  First remove the non-SG case, then fold the zero transfer
length one in as a special zero-length SG and then check how many
differences we have left between the data and control plane.

