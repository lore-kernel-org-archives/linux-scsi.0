From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 21:49:04 +0200
Message-ID: <20100729194904.GA17098@lst.de>
References: <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:52180 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757841Ab0G2Ttf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2010 15:49:35 -0400
Content-Disposition: inline
In-Reply-To: <4C51DA1F.2040701@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Ted Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Thu, Jul 29, 2010 at 03:44:31PM -0400, Ric Wheeler wrote:
> I confess that I am a bit fuzzy on FUA, but think that it means that any 
> FUA tagged IO will go down to persistent store before returning.

Exactly.

> If so, then all order dependent IO would need to be issued in order and 
> tagged with FUA. It would not suffice to tag just the commit record as 
> FUA, or do I misunderstand what FUA does?

The commit record is ext3/4 specific terminalogy.  In xfs we just have
one type of log buffers, and we could tag that as FUA.  There is very
little other depenent I/O, but if that is present we need a pre-flush
for it anyway. 

