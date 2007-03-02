From: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>
Subject: RE: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Fri, 2 Mar 2007 16:45:25 -0700
Message-ID: <A67893E24596534CB03DD02157A7FBF7018D15CC@NAMAIL2.ad.lsil.com>
References: <45E89E4E.7080003@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36546 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992768AbXCBXpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Mar 2007 18:45:44 -0500
Content-class: urn:content-classes:message
In-Reply-To: <45E89E4E.7080003@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

Mike,

I applied "patch 1" posted by Boaz Harrosh to my SLES 10 kernel.
So far IO's are running for 45 minutes which is the longest in my
numerous re-tries.


We were not aware that "scsi_execute_async" was temperory workaround.

Where is the depricated warning that you mentioned about ?
I tried to look in scsi_lib.c and scsi_device.h


Regards,
Sudhir 

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Friday, March 02, 2007 4:00 PM
To: Dachepalli, Sudhir
Cc: Benny Halevy; Jens Axboe; Boaz Harrosh; linux-scsi@vger.kernel.org;
James Bottomley
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()

Mike Christie wrote:
> Dachepalli, Sudhir wrote:
>> scsi_req_map_sg::i=2,len=1024,data_len=3072,off=2048,PAGE_SIZE=4096,b
>> yte
>> s=1024,nr_vecs=0, nr_pages=0
> 
> 
>>                         if (bio_add_pc_page(q, bio, page, bytes, off)
!=
>>                             bytes) {
>>                                 printk("scsi_req_map_sg:: calling 
>> bio_put \n");
>>  
>> printk("scsi_req_map_sg::i=%d,len=%d,data_len=%d,off=%d,PAGE_SIZE=%ld
>> ,by
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
