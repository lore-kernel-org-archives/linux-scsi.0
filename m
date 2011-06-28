From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/15] target: Remove direct ramdisk code
Date: Tue, 28 Jun 2011 17:15:17 -0400
Message-ID: <20110628211517.GB7594@infradead.org>
References: <1309289377-8029-1-git-send-email-agrover@redhat.com>
 <1309289377-8029-15-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48706
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819Ab1F1VPT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2011 17:15:19 -0400
Content-Disposition: inline
In-Reply-To: <1309289377-8029-15-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jun 28, 2011 at 12:29:36PM -0700, Andy Grover wrote:
> Instead of converting rd_dr to be se_mem-free, maybe we should just
> remove it. Do we really need *two* private ramdisk implementations,
> especially when the kernel already has its own ramdisk code, that we
> could access via the iblock backstore?
> 
> This also lets us remove hooks like do_se_mem_map, that are in the common
> path but only implemented by rd_dr.

I always hated the hooks the direct ramdisk code had to the core code,
so I'm absolutely in favour of it.  The indirect ramdisk currently is
used for things like the virtual lun0 handling, which requires it to
be just there instead of setting up a block device.  I think keeping
the simple internal ramdisk around for that and benchmarking is fine.

