From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFCv3 00/21] TCM Core and TCM_Loop patches for v2.6.37
Date: Mon, 8 Nov 2010 16:48:25 -0500
Message-ID: <20101108214825.GA26609@infradead.org>
References: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
 <20101108143952.GB22121@infradead.org>
 <1289251207.27226.59.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1289251207.27226.59.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <joel.becker@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 08, 2010 at 01:20:07PM -0800, Nicholas A. Bellinger wrote:
> Hmmm, it is my understanding that seq_file is currently not available
> for configfs.  Also, we never going to expect these particular calls to
> return anything close to PAGE_SIZE, so I am not sure how much of an
> issue this really is.

Seq_file is avaible for anything where you can plug in file_operations.
If configfs doesn't allow plugging in file_operations that's a serious
deficit.  If you need less than a page of data single_open provides a
simplified version of seq_file with a similar but much simpler API.

> >  - the set_configfs_dev_params method implementation contains some
> >    rather nast parsing code.  They look like they really should use
> >    the parser.h helpers we use for mount option parsing.
> 
> <nod>  This code current expects the the incoming buffer to be in the
> form of 'key0=value0,key1=value1,key2=value2' etc.   Assuming that
> parser.h code can handle the comma seperated values, I will look at
> getting these converted as well.

That's exactly how mount options work.
