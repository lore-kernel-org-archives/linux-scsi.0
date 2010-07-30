From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Fri, 30 Jul 2010 15:12:05 +0200
Message-ID: <20100730131205.GA27348@lst.de>
References: <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <1280433591.4441.393.camel@mulgrave.site> <20100729200327.GA17767@lst.de> <4C52C994.2040405@vlnb.net> <20100730125750.GB26118@lst.de> <4C52CF20.6090404@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:40077 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895Ab0G3NMd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 09:12:33 -0400
Content-Disposition: inline
In-Reply-To: <4C52CF20.6090404@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@suse.de>, Ric Wheeler <rwheeler@redhat.com>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Fri, Jul 30, 2010 at 05:09:52PM +0400, Vladislav Bolkhovitin wrote:
> Sorry, I can't follow you here. What was the load pattern difference 
> between the tests in the way how the backend device saw it? I thought, 
> it was only in absence of the cache flush commands (SYNCHRONIZE_CACHE?) 
> in the write through case, but looks like there is something more different?

The only difference in commands is that we see no SYNCHRONIZE_CACHE.
The big picture difference is that we also only drain the queue just
to undrain it ASAP, instead of keeping it drained over a sequence
of SYNCHRONIZE_CACHE + WRITE + SYNCHRONIZE_CACHE, which can make
a huge difference for a device with very low latencies like the SSD
in my laptop.

