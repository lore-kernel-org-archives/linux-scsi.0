From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Fri, 02 Mar 2007 15:19:01 -0600
Message-ID: <45E894C5.90101@cs.wisc.edu>
References: <A67893E24596534CB03DD02157A7FBF701879048@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44788 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965629AbXCBVTf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Mar 2007 16:19:35 -0500
In-Reply-To: <A67893E24596534CB03DD02157A7FBF701879048@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>
Cc: Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

Dachepalli, Sudhir wrote:
> scsi_req_map_sg::i=2,len=1024,data_len=3072,off=2048,PAGE_SIZE=4096,byte
> s=1024,nr_vecs=0, nr_pages=0


>                         if (bio_add_pc_page(q, bio, page, bytes, off) !=
>                             bytes) {
>                                 printk("scsi_req_map_sg:: calling
> bio_put \n");
>  
> printk("scsi_req_map_sg::i=%d,len=%d,data_len=%d,off=%d,PAGE_SIZE=%ld,by
> tes=%d,nr_vecs=%d, nr_pages=%d\n",
>  
> i,len,data_len,off,PAGE_SIZE,bytes,nr_vecs,nr_pages);
>                                 if( bio->bi_io_vec == NULL )


I think Boaz's first patch in this thread that counts the offsets
correctly should be merged.

I am not sure about the second one. If allocating a bio with zero vecs
is valid, then I guess the patch should be merged. bio_alloc_bioset
looks like it allows this, but people probably never do it (just when
they hit bugs like this one :)). But I think if we are counting segments
correctly we will not need that patch for this problem will we Boaz?
Boaz, maybe you could also send the first patch in a seperate mail so
that it can be merged (I do not think James wants to cut and paste two
patches from one mail).

Also, you do not want to use scsi_execute_async. I am trying to kill it.
The original patches, never had that function and the later patches had
a warning that you should not use it and that you should just use the
request and the blk_rq* helpers directly.
