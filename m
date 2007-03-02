From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Fri, 02 Mar 2007 15:59:42 -0600
Message-ID: <45E89E4E.7080003@cs.wisc.edu>
References: <A67893E24596534CB03DD02157A7FBF701879048@NAMAIL2.ad.lsil.com> <45E894C5.90101@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44883 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030502AbXCBWAT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Mar 2007 17:00:19 -0500
In-Reply-To: <45E894C5.90101@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>
Cc: Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

Mike Christie wrote:
> Dachepalli, Sudhir wrote:
>> scsi_req_map_sg::i=2,len=1024,data_len=3072,off=2048,PAGE_SIZE=4096,byte
>> s=1024,nr_vecs=0, nr_pages=0
> 
> 
>>                         if (bio_add_pc_page(q, bio, page, bytes, off) !=
>>                             bytes) {
>>                                 printk("scsi_req_map_sg:: calling
>> bio_put \n");
>>  
>> printk("scsi_req_map_sg::i=%d,len=%d,data_len=%d,off=%d,PAGE_SIZE=%ld,by
>> tes=%d,nr_vecs=%d, nr_pages=%d\n",
>>  
>> i,len,data_len,off,PAGE_SIZE,bytes,nr_vecs,nr_pages);
>>                                 if( bio->bi_io_vec == NULL )
> 
> 
> I think Boaz's first patch in this thread that counts the offsets
> correctly should be merged.

Just one clarification.

When I wrote scsi_execute_async, it was meant as a temp hack so we would
kill scsi_request and fix scatterlists for drivers like iscsi_tcp and
ib_iser, but in the original patches and the patches I am sending now I
modify the blk helpers and have sg use them directly.

scsi_execute_async was meant to be temporary only supported what sg and
st and other mainline drivers were sending at the time, so it did not
support something like:

sg[0].offset 0;
sg[0].length = 4096;
sg[1].offset = 1024;
sg[1].offset = 3072;

because sg and st can only have a offset for the first sg element
(offsets for the sg element is supported).

If we are going to support whatever scsi_do_req supported the we should
merge Boaz's patch.

If scsi_execute_async is going to be limited to what is in mainline
until I can kill it, then we may not want to merge Boaz's patch and just
have people convert the code to use blk_get_request, blk_rq_map_kern or
blk_rq_map_user and blk_execute_rq_nowait.
