From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Optimize scsi_cmnd initialization and bug fix
Date: Tue, 6 Dec 2005 17:22:00 +0000
Message-ID: <20051206172200.GA24092@infradead.org>
References: <200511232250.jANMo0g20086@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:61639 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932473AbVLFRWB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Dec 2005 12:22:01 -0500
Content-Disposition: inline
In-Reply-To: <200511232250.jANMo0g20086@unix-os.sc.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Cc: linux-scsi@vger.kernel.org, 'James Bottomley' <James.Bottomley@SteelEye.com>

On Wed, Nov 23, 2005 at 02:50:00PM -0800, Chen, Kenneth W wrote:
> I'm proposing the following patch to optimize scsi_cmnd initialization.
> The only part that I'm not 100% sure is struct scsi_pointer SCp and
> eh_eflags.  It appears to be safe, but since I don't have every scsi
> controllers in the world to test, I can't say so for sure.  I'm willing
> to take on the responsibility to fix any hiccup people might have with
> this patch.  Comments?

SCp should be zeroed, it's the scratch area for controllers.  eh_ehflags
is under midlayer control and should start out as zero.

> p.s. de-referencing jiffies_at_alloc ought be in the if(cmd!=NULL) block.

that's fixed already in latest mainline.

