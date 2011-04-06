From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] mpt2sas: Reduce cache misses in command submission
 path
Date: Wed, 6 Apr 2011 09:46:55 -0400
Message-ID: <20110406134654.GB21729@infradead.org>
References: <20110405214714.GR4183@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46759 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab1DFNqz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2011 09:46:55 -0400
Content-Disposition: inline
In-Reply-To: <20110405214714.GR4183@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

On Tue, Apr 05, 2011 at 05:47:14PM -0400, Matthew Wilcox wrote:
> 
> In a high-IOPS workload, mpt2sas_base_get_smid_scsiio shows up in the top
> 20 cache misses.  This is because the data structure used for allocating
> SMIDs is cache unfriendly; freed SMIDs are placed on the tail of the list,
> guaranteeing a cache miss by the time we allocate it again.
> 
> By placing the freed SMID at the head of the list, we increase the
> likelihood of it being cache-hot when it's used again.

Looks good for now.  But given that the smids are a statically allocated
ressource it might be a good idea to get rid of all the rather cache
unfriendly linked lists and locking and use a bitmap to allocate
smids and then just index into a linear array of them.

