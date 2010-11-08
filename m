From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFCv3 00/21] TCM Core and TCM_Loop patches for v2.6.37
Date: Mon, 08 Nov 2010 13:20:07 -0800
Message-ID: <1289251207.27226.59.camel@haakon2.linux-iscsi.org>
References: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
	 <20101108143952.GB22121@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101108143952.GB22121@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <joel.becker@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-11-08 at 09:39 -0500, Christoph Hellwig wrote:
> Some comments on the configfs to backend API:
> 
>  - the various get_*_info methods look like they really should use
>    the seq_file API.  That gives you safety against overflows,
>    and simplifies the code.

Hmmm, it is my understanding that seq_file is currently not available
for configfs.  Also, we never going to expect these particular calls to
return anything close to PAGE_SIZE, so I am not sure how much of an
issue this really is.

>  - why are show_configfs_dev_params and get_dev_info separate
>    methods if they always end up calling the same code?

Hmmm, this was some legacy informational code that no longer has a
reason to be seperate.  I will get this merged into a single function.

>  - the set_configfs_dev_params method implementation contains some
>    rather nast parsing code.  They look like they really should use
>    the parser.h helpers we use for mount option parsing.

<nod>  This code current expects the the incoming buffer to be in the
form of 'key0=value0,key1=value1,key2=value2' etc.   Assuming that
parser.h code can handle the comma seperated values, I will look at
getting these converted as well.

--nab
