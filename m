From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 09:37:19 -0500
Message-ID: <1280327839.30808.188.camel@mulgrave.site>
References: <20100727165627.GA474@lst.de>
	 <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com>
	 <4C4FE58C.8080403@kernel.org> <4C4FE860.7000903@suse.de>
	 <4C5036BC.30709@vlnb.net>  <4C503D50.4010006@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C503D50.4010006@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <teheo@suse.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-07-28 at 16:23 +0200, Tejun Heo wrote:
> Hello,
> 
> On 07/28/2010 03:55 PM, Vladislav Bolkhovitin wrote:
> >> The only benefit of doing it in the block layer, and probably the
> >> reason why it was done this way at all, is making use of advanced
> >> ordering features of some devices - ordered tag and linked commands.
> >> The latter is deprecated and the former is fundamentally broken in
> >> error handling anyway.
> > 
> > Why? SCSI provides ACA and UA_INTLCK which provide all needed
> > facilities for errors handling in deep ordered queues.
> 
> I don't remember all the details now but IIRC what was necessary was
> earlier write failure failing all commands scheduled as ordered.  Does
> ACA / UA_INTLCK or whatever allow that?

No.  That requires support for QErr ... which is in the same mode page.

The real reason we have difficulty is that BUSY/QUEUE_FULL can cause
reordering in the issue queue, which is a driver problem and not in the
SCSI standards.

James


