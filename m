From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: replace numeric messages with string error
	messages when blk_execute_rq fails.  Also add printing of sense
	info.
Date: Tue, 29 Apr 2014 20:00:41 +0200
Message-ID: <20140429180041.GB26194@lst.de>
References: <1398167056-14582-1-git-send-email-mlombard@redhat.com> <20140425131219.GA20644@lst.de> <20140429093035.GA2219@dhcp-27-189.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54322 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933160AbaD2SAo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2014 14:00:44 -0400
Content-Disposition: inline
In-Reply-To: <20140429093035.GA2219@dhcp-27-189.brq.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, JBottomley@Parallels.com

On Tue, Apr 29, 2014 at 11:30:35AM +0200, Maurizio Lombardi wrote:
> If I convert submit_rtpg() to make use of scsi_execute() then I'll not be
> able to read the updated sense buffer.
> 
> scsi_execute() accepts a pointer to the sense buffer as parameter, but
> it does not update its content in case blk_execute_rq() returns an error.

What kind of update do you want?  All the sense buffer updates are done
in the low-level code, and then you could update anything additional
you would need in the caller as you get the whole sense buffer when
using scsi_execute() (for scsi_execute_req_flags it's harder due to the
normalized sense buffer).
