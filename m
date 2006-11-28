From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Tue, 28 Nov 2006 17:44:04 +0200
Message-ID: <456C5944.9060509@panasas.com>
References: <456B2416.7000101@panasas.com> <456B38E9.6060209@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:32206 "EHLO
	cassoulet.panasas.com") by vger.kernel.org with ESMTP
	id S935384AbWK1PpT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Nov 2006 10:45:19 -0500
In-Reply-To: <456B38E9.6060209@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Benny Halevy <bhalevy@panasas.com>

Mike Christie wrote:
> Boaz Harrosh wrote:
>> Playing with some tests which I admit are not 100% orthodox I have
>> stumbled upon a bug that raises a serious question:
>>
>> In the call to scsi_execute_async() in the use_sg case, must the
>> scatterlist* (pointed to by buffer) map a buffer that's contiguous in
>> virtual memory or is it allowed to map disjoint segments of memory?
> 
> I thought they were continguous. I think James has said before that they
> can be disjoint. When we converted sg it did not look like sg or st
> supported disjoint. The main non dio path used a buffer from
> get_free_pages so I thought that would always be contiguous. The dio
> path then always set the first sg offset, but the rest it set to zero.
> 
> How did you hit this problem? Is it with sg or st, or with some other
> code? Is it the mmap path maybe?

OK I admit, guilty as charged, I was using it from a kernel driver, OSD-Initiator from IBM. The code is unorthodox in mapping user space iovects into scatterlist*. I will have to work around it than. Such a petty because it saves me a copy of an high bandwidth channel. with iSCSI the fix works well but I guess if the working assumption was "contiguous", than allowing it here will expose problems in drivers that don't expect it.

In any way the bio.c patch should go in. 1. Zero vecs bio cannot be freed with current code 2. It lets kernel exit gracefully with an error instead of a crash.

should we at least do below patch so people know what happened postmortem:

diff -Npu /tmp/tmp.5864.0 /home/bharrosh/p4.local/local/scsi-misc-2.6-dev/linux/drivers/scsi/scsi_lib.c -L a/scsi_lib.c -L b/scsi_lib.c
--- a/scsi_lib.c
+++ b/scsi_lib.c
@@ -321,6 +321,9 @@ static int scsi_req_map_sg(struct reques
 				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
 				nr_pages -= nr_vecs;
 
+				/* most probably not a contiguous memory mapping */ 
+				BUGON(!nr_vecs); 
+
 				bio = bio_alloc(gfp, nr_vecs);
 				if (!bio) {
 					err = -ENOMEM;
 

