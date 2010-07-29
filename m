From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 16:30:54 -0600
Message-ID: <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca>
References: <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:13798 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab0G2WbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2010 18:31:09 -0400
In-Reply-To: <4C51DCF1.3010507@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On 2010-07-29, at 13:56, Ric Wheeler wrote:
> I assume that for ext3 it would get more complicated depending on the journal mode. In ordered or data journal mode, we would have to write the dependent non-journal data tagged with FUA, then the FUA tagged transaction and finally the FUA tagged commit block.

Like James wrote, this is basically everything FUA.  It is OK for ordered mode to allow the device to aggregate the normal filesystem and journal IO, but when the commit block is written it should flush all of the previously written data to disk.  This still allows request re-ordering and merging inside the device, but orders the data vs. the commit block.  Having the proposed "flush ranges" interface to the disk would be ideal, since there would be no wasted time flushing data that does not need it (i.e. other partitions).

There is no need to prevent new data from being written during a cache flush, since ext*/jbd will already manage any required data/metadata ordering internally.

There was some proposal (maybe from Eric Sandeen?) about having a device-level IO request counter that numbers every request submitted, and if there are multiple partitions per device, or fsync operations that flush the device cache, it is possible to determine from the request number whether there has already been a cache flush after that request on that device.  This avoids extra cache flushes if it was just done for another file or partition on the same device.

Cheers, Andreas





