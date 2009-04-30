From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] [Target_Core_Mod/pSCSI]: Add	block/blk-map.c:blk_rq_map_kern_sg()
 usage
Date: Thu, 30 Apr 2009 10:37:55 +0900
Message-ID: <49F900F3.2060009@kernel.org>
References: <1240965782.32740.309.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:44523 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbZD3Bmy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2009 21:42:54 -0400
In-Reply-To: <1240965782.32740.309.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Vladislav Bolkhovitin <vst@vlnb.net>

Hello, Nicholas.

Nicholas A. Bellinger wrote:
...
> Once Tejun's patches for block/blk-map.c:blk_rq_map_kern_sg() have
> been included upstream, the legacy pscsi_map_task_SG() will be
> removed and blk-map will become the preferred method for accessing
> struct scatterlist -> struct scsi_device for SCSI target operations.
> For now, I have created a blk-map branch in lio-core-2.6.git with
> LINUX_USE_NEW_BLK_MAP=1 and left LINUX_USE_NEW_BLK_MAP=0 in branch
> master.

Hmm... I don't think the patch will go in as-is although there seem to
be some places which can make use of sg mapping interface (including
OSD).  Currently there are following problems.

* Single kmalloc()ing the whole bio has higher chance of failing if
  the bvec becomes very large.

* Boaz is worried about performance implications with going back and
  forth between sgl and bvec.

In longer term, I think where we should be headed is...

* Expand sgl( or t) such that 1. it uses separate list for cpu and dma
  addresses so that it doesn't take up twice as much space
  unnecessarily, 2. sgl's can be easily chained (alerady somewhat
  there) and thus we don't have to worry about chaining in higher
  layer.

* Replace bvec with sgl in bio.

Dunno what we should do in the meantime tho.

Thanks.

-- 
tejun
