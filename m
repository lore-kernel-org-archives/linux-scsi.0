From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] target: call queue reset if supported
Date: Fri, 27 May 2016 01:22:15 -0700
Message-ID: <20160527082215.GA31630@infradead.org>
References: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
 <1464162903-14735-4-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54776 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454AbcE0IWQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2016 04:22:16 -0400
Content-Disposition: inline
In-Reply-To: <1464162903-14735-4-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mchristi@redhat.com
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, target-devel@vger.kernel.org

On Wed, May 25, 2016 at 02:55:01AM -0500, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> Instead of waiting for commands, map the lun reset operation
> to a queue reset.
> 
> We do not check the result of blk_reset_queue because if
> it works then we need to wait for the bio/request completions
> and if it failed we might as wait and hope like we did before.

Please don't call into block device code from the file handler.
