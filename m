From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Fri, 30 Jul 2010 09:11:38 +0200
Message-ID: <20100730071138.GA6411__9664.82668086446$1280473936$gmane$org@lst.de>
References: <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca> <20100729230406.GI4506@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:35276 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab0G3HMJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 03:12:09 -0400
Content-Disposition: inline
In-Reply-To: <20100729230406.GI4506@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redha>

On Thu, Jul 29, 2010 at 07:04:06PM -0400, Ted Ts'o wrote:
> My understanding is that "everything FUA" can be a performance
> disaster.  That's because it bypasses the track buffer, and things get
> written directly to disk.  So there is no possibility to reorder
> buffers so that they get written in one disk rotation.  Depending on
> the disk, it might even be that if you send N sequential sectors all
> tagged with FUA, it could be slower than sending the N sectors
> followed by a cache flush or SYNCHRONIZE_CACHE command.

Not sure why the discussion is drifting in this direction again, but no
one suggested to switch eweryone to forcefully use a FUA only primitive.
If we offer a WRITE_FUA primitive to those who can make use of it, it
won't mean the the cache flush primitive will go away - we will need it
to implement fsync anyway.

> 
