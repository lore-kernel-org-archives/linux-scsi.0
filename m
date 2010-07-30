From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Fri, 30 Jul 2010 15:34:10 +0200
Message-ID: <20100730133410.GA27996@lst.de>
References: <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca> <20100729230406.GI4506@thunk.org> <4C52CBFF.6090406@vlnb.net> <20100730130957.GA26894@lst.de> <4C52D2E0.5000609@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:41722 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719Ab0G3Neo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 09:34:44 -0400
Content-Disposition: inline
In-Reply-To: <4C52D2E0.5000609@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Fri, Jul 30, 2010 at 05:25:52PM +0400, Vladislav Bolkhovitin wrote:
> Sure. It was only a naive example to illustrate my points. But the FS is 
> still waiting for the requests, so "draining" its "local queue"?

Yes, just a much smaller queue in general.

To present a typical case, fsync() on a regular file that has a few
dirty pages on it using XFS.

We use filemap_write_and_wait to write out those few pages and wait
for it.  And after that we only need to issue a SYNCHRONIZE_CACHE
and we'd be done.  Right now the draining semantics of the (empty)
barrier means we also need to wait for all other I/O in the system
to finish, which is rather suboptimal.

