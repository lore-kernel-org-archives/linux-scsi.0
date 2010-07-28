From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 11:16:33 +0200
Message-ID: <20100728091633.GA10219@lst.de>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF42C.1050701@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C4FF42C.1050701@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 28, 2010 at 11:11:08AM +0200, Hannes Reinecke wrote:
> My idea here is to use the 'META' request tag to emulate FUA.
> >From what I've seen, the META request tag is only ever used on gfs2,
> and even that is using is for tagging journal requests on write.

Please don't overload META even more, it's already overloaded with
at least two meanings.
We do in fact already have a REQ_FUA flag, and now that I have unified the
bio and request flags we can easily set it from filesystems.  The problem
is to emulate it properly on devices that do no actually support the FUA bit.
Of which we unfortunately have a lot given that libata by default disables
the FUA support even if the device supports.
