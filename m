From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Tue, 27 Jul 2010 21:38:45 +0200
Message-ID: <20100727193845.GB8973@lst.de>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100727183546.GG7347@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, tj@kernel.org, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 27, 2010 at 02:35:46PM -0400, Vivek Goyal wrote:
> IIUC, QUEUE_ORDERED_DRAIN will be set only for storage which either does
> not support write caches or which advertises himself as having no write
> caches (it has write caches but is batter backed up and is capable of 
> flushing requests upon power failure).

More or less.  We set it for scsi devices without the write cache enable
(WCE) bit, which is only set it there is a volatile write cache that
needs flushing.  Some historic arrays used to set it despite having
a non-volatile write cache, but that doesn't happen anymore with any
of the modern ones I have access to.

