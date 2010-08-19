From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Thu, 19 Aug 2010 11:57:53 +0200
Message-ID: <4C6D0021.4040601@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100818094620.GA14707@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:35963 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab0HSKBz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2010 06:01:55 -0400
In-Reply-To: <20100818094620.GA14707@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de

Hello,

On 08/18/2010 11:46 AM, Christoph Hellwig wrote:
> FYI: One issue with this series is that make_request based drivers
> not have to access all REQ_FLUSH and REQ_FUA requests.  We'll either
> need to add handling to empty REQ_FLUSH requests to all of them or
> figure out a way to prevent them getting sent.  That is assuming they'll
> simply ignore REQ_FLUSH/REQ_FUA on normal writes.

Can you be a bit more specific?  In most cases, request based drivers
should be fine.  They sit behind the front most request_queue which
would discompose REQ_FLUSH/FUAs into appropriate command sequence.
For the request based drivers, it's not different from the original
REQ_HARDBARRIER mechanism, it'll just see flushes and optionally FUA
writes.

Thanks.

-- 
tejun
