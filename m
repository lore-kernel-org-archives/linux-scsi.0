From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] scsi: TUR path is down after adapter gets reset in
 multipath configuration(scsi_error.c)
Date: Tue, 28 Oct 2014 02:04:23 -0700
Message-ID: <20141028090423.GA16532@infradead.org>
References: <20141027180147.030955587@linux.vnet.ibm.com>
 <20141027180346.868651777@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34565 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaJ1JEY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Oct 2014 05:04:24 -0400
Content-Disposition: inline
In-Reply-To: <20141027180346.868651777@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

On Mon, Oct 27, 2014 at 01:01:48PM -0500, wenxiong@linux.vnet.ibm.com wrote:
> After an ipr adapter gets reset, all disk array devices require a start
> unit command to be issued to them before they will accept commands. So,
> with the SCSI EH change, we now end up in a scenario with dual ipr
> adapters where the TUR getting issued from the health checker returns
> with a Not Ready response and since SCSI EH no longer triggers the Start
> Unit in this scenario, the path never recovers.
> 
> Signed-off-by: Christoph Hellwig <hch@infradead.org>
> Tested-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

Th patch description is entirely wrong, but I guess I'll have to
take the blame for that as it's my patch.  How about something like:

From: Christoph Hellwig <hch@infradead.org>
Subject: scsi: call device handler for failed TUR command

Multipath devices using the TUR path checker need to see the sense
code for a failed TUR command in their device handler.  Since commit
<insert commit id here> we always return success for mid layer issued
TUR commands before calling the device handler, which stopped the
TUR path checker from working.

Move the call to the device handler check sense method before the early
return for TUR commands to give the device handler a chance to intercept
them.

Signed-off-by: Christoph Hellwig <hch@infradead.org>
Tested-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
