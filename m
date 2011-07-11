From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 20/20] target: change alloc_task call to take *cdb, not
 *cmd
Date: Mon, 11 Jul 2011 11:28:15 -0400
Message-ID: <20110711152815.GA20603@infradead.org>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
 <1310174329-22228-21-git-send-email-agrover@redhat.com>
 <20110709101105.GA26456@infradead.org>
 <4E1A2AAF.6080705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41579
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757782Ab1GKP2P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2011 11:28:15 -0400
Content-Disposition: inline
In-Reply-To: <4E1A2AAF.6080705@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Jul 10, 2011 at 03:41:51PM -0700, Andy Grover wrote:
> We can assume each se_cmd only needs 1 se_task???
> 
> I couldn't see where the max sectors per se_cmd was limited, therefore
> we needed to support cmds being broken up into
> se_sub_dev.max_sectors-size chunks, and therefore being >1 se_task per
> se_cmd, for all backstores not just pscsi?

The most important backend, iblock already handles arbitrarily sized
payloads by using multiple bios internally, which is much lower overhead
than using the multiple task complexity, and the ramdisk code has no
inherent limitation either.  The file code has a limitation on the
number of iovecs accepted by the kernel, and only the pscsi backend
really needs multiple "tasks".

Given that the performance of iblock is the important one streamline
the path for this backend as much as possible sounds like a good idea.

