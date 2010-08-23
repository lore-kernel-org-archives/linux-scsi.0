From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Mon, 23 Aug 2010 14:36:37 +0200
Message-ID: <4C726B55.80503@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100820132214.GA6184@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:35026 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab0HWMlq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2010 08:41:46 -0400
In-Reply-To: <20100820132214.GA6184@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de

Hello,

On 08/20/2010 03:22 PM, Christoph Hellwig wrote:
> Many storage devices, especially in the consumer market, come with volatile
> write back caches.  That means the devices signal I/O completion to the
> operating system before data actually has hit the physical medium.

A bit nit picky but flash devices can also have writeback caches and
the term physical medium sounds a bit off for those cases.  Maybe just
saying "non-volatile media" is better?

> Implementation details for filesystems
> --------------------------------------
> 
> Filesystem can simply set the REQ_FLUSH and REQ_FUA bits and do not have to
> worry if the underlying devices need any explicit cache flushing and how
> the Forced Unit Access is implemented.  The REQ_FLUSH and REQ_FUA flags
> may both be set on a single bio.

It may be worthwhile to explain the sequence of operations when
REQ_FLUSH + data + REQ_FUA is executed.  It can be extrapolated from
the previous two descriptions but I think giving examples of different
sequences depending on FLUSH/FUA configuration would be helpful to
help understanding the overall picture of things.

Other than those, looks good to me.

Thanks.

-- 
tejun
