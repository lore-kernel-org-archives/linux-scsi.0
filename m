From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 10:08:44 +0200
Message-ID: <4C4FE58C.8080403@kernel.org>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100727183546.GG7347@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

Hello,

On 07/27/2010 08:35 PM, Vivek Goyal wrote:
> IIUC, what Christoph is trying to address is that if write cache is
> not enabled then we don't need flushing semantics. We can get rid of
> need of request ordering semantics by waiting on dependent request to
> finish instead of issuing a barrier. That way we will not issue barriers
> no request queue drains and that possibly will help with throughput.

What I don't get here is if filesystems order requests already by
waiting for completions why do they use barriers at all?  All they
need is flush request after all the preceding requests are known to be
complete.

Having writeback cache or not doesn't make any difference
w.r.t. request ordering requirements.  If filesystems don't need the
heavy handed ordering provided by barrier, it should just use flush
instead of barrier.  If filesystem needs the barrier ordering, whether
the device in question is battery backed and costs more than a house
doesn't make any difference.

Thanks.

-- 
tejun
