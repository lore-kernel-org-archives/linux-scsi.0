From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3] Save command pool address of Scsi_Host
Date: Mon, 4 Aug 2014 04:08:44 -0700
Message-ID: <20140804110844.GC19109@infradead.org>
References: <1407126369-16543-1-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44411 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaHDLIo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2014 07:08:44 -0400
Content-Disposition: inline
In-Reply-To: <1407126369-16543-1-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgross@suse.com
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 06:26:09AM +0200, jgross@suse.com wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> If a scsi host driver specifies .cmd_len in it's scsi_host_template, a driver's
> private command pool is needed. scsi_find_host_cmd_pool() will locate it, but
> scsi_alloc_host_cmd_pool() isn't saving the pool address in the host template.
> 
> This will result in an access error when the host is removed.
> 
> Avoid the problem by saving the address of a new allocated command pool where
> it is expected and delete it again when the pool is destroyed.

I don't really like the double pointer passing - just NULLing out the
pointer in the caller where needed seems cleaner.

Otherwise this looks good to me.

