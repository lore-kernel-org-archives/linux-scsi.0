From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfs rm performance
Date: Mon, 2 Aug 2010 21:18:21 +0200
Message-ID: <20100802191821.GA13452@lst.de>
References: <4C52CBFF.6090406@vlnb.net> <20100730130957.GA26894@lst.de> <4C52D2E0.5000609@vlnb.net> <20100730133410.GA27996@lst.de> <4C52D728.6070008@vlnb.net> <20100730142025.GA29341@lst.de> <20100731004756.GC3273@quack.suse.cz> <4C56A01A.1050107@vlnb.net> <20100802124830.GB22345@lst.de> <4C571664.7030107@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C571664.7030107@vlnb.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 02, 2010 at 11:03:00PM +0400, Vladislav Bolkhovitin wrote:
> I traced what XFS is doing that time. The initiator is sending by a _single command at time_ the following pattern:

That's exactly the queue draining we're talking about here.  To see
how the pattern gets better use the nobarrier option.

Even with that XFS traditionally has a bad I/O pattern for metadata
intensive workloads due to the amount of log I/O needed for it.
Starting from Linux 2.6.35 the delayed logging code fixes this, and
we hope to enable it by default after about 10 to 12 month of
extensive testing.

Try to re-run your test with

	-o delaylog,logbsize=262144

to see better log I/O pattern.  If you target doesn't present a volatile
write cache also add the nobarrier option mentioned above.
