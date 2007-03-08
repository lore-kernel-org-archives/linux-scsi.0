From: Aravind Parchuri <aravind.parchuri@gmail.com>
Subject: Re: WRITE BUFFER commands through SG_IO getting rounded up to sector
 past 32k
Date: Thu, 08 Mar 2007 13:59:19 -0800
Message-ID: <45F08737.3060100@gmail.com>
References: <45EE00F0.2010702@gmail.com> <45EE09A6.7030004@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.231]:61245 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030700AbXCHV7Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Mar 2007 16:59:24 -0500
Received: by wx-out-0506.google.com with SMTP id h31so664134wxd
        for <linux-scsi@vger.kernel.org>; Thu, 08 Mar 2007 13:59:23 -0800 (PST)
In-Reply-To: <45EE09A6.7030004@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

The patch has some problem. While ioctls with dxfer_len < 32k still make 
it through properly, the problematic ones now show up in open-iscsi's 
queuecommand with request_bufflen = 0. I'm not sure what the problem is now.

Aravind.

 michaelc@cs.wisc.edu wrote:
> Aravind Parchuri wrote:
>   
>> In fact, even with the newer kernel, all commands smaller than 32k make
>> it through with the right size, which leads me to think it's something
>> to do with the scatter-gather list. I'm not particularly familiar with
>> the scsi code, but inside scsi_execute_async, in scsi_map_req_sg, should
>> the request's data_len be set to the dxfer_len instead of summing up the
>> scatter-gather list lengths? I must mention again that I haven't really
>> gone through the code thoroughly.
>>
>>     
>
> You are right. sg_build_indirect will do this
> blk_size = (blk_size + SG_SECTOR_MSK) & (~SG_SECTOR_MSK)
> so we should be using the bufflen passed into us. Attached is a patch
> made over scsi-misc. It should also apply to scsi rc fixes.
>   
> ------------------------------------------------------------------------
>
> sg's may have setup a the buffer with a different length than
> the transfer length so we should be using the bufflen passed
> in as the request's data len.
>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 9f7482d..dfe3ccd 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -301,7 +301,7 @@ static int scsi_req_map_sg(struct reques
>  {
>     struct request_queue *q = rq->q;
>     int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
> -   unsigned int data_len = 0, len, bytes, off;
> +   unsigned int len, bytes, off;
>     struct page *page;
>     struct bio *bio = NULL;
>     int i, err, nr_vecs = 0;
> @@ -310,7 +310,6 @@ static int scsi_req_map_sg(struct reques
>         page = sgl[i].page;
>         off = sgl[i].offset;
>         len = sgl[i].length;
> -       data_len += len;
>  
>         while (len > 0) {
>             bytes = min_t(unsigned int, len, PAGE_SIZE - off);
> @@ -350,7 +349,7 @@ static int scsi_req_map_sg(struct reques
>     }
>  
>     rq->buffer = rq->data = NULL;
> -   rq->data_len = data_len;
> +   rq->data_len = bufflen;
>     return 0;
>  
>  free_bios:
>   

