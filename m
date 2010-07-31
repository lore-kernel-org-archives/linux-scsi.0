From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] relaxed barrier semantics
Date: Sat, 31 Jul 2010 02:47:57 +0200
Message-ID: <20100731004756.GC3273@quack.suse.cz>
References: <20100729194904.GA17098@lst.de>
 <4C51DCF1.3010507@redhat.com>
 <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca>
 <20100729230406.GI4506@thunk.org>
 <4C52CBFF.6090406@vlnb.net>
 <20100730130957.GA26894@lst.de>
 <4C52D2E0.5000609@vlnb.net>
 <20100730133410.GA27996@lst.de>
 <4C52D728.6070008@vlnb.net>
 <20100730142025.GA29341@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab0GaAs0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 20:48:26 -0400
Content-Disposition: inline
In-Reply-To: <20100730142025.GA29341@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Fri 30-07-10 16:20:25, Christoph Hellwig wrote:
> On Fri, Jul 30, 2010 at 05:44:08PM +0400, Vladislav Bolkhovitin wrote:
> > Yes, but why not to make step further and allow to completely eliminate 
> > the waiting/draining using ORDERED requests? Current advanced storage 
> > hardware allows that.
> 
> There is a few caes where we could do that - the fsync without metadata
> changes above would be the prime example.  But there's a lot lower
> hanging fruit until we get to the point where it's worth trying.
  Umm, I don't understand you. I think that fsync in particular is an
example where you have to wait and issue cache flush if the drive has
volatile write cache. Otherwise you cannot promise to the user data will be
really on disk in case of crash. So no ordering helps you.
  And if you are speaking about a drive without volatile write caches, then
fsync without metadata changes is just trivial and you don't need any
ordering.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
