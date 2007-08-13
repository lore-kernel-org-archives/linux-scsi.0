From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [patch 07/30] Incorrect SCSI transfer length computation from
 odd sized scsi_execute_async() transfers.
Date: Mon, 13 Aug 2007 13:00:11 -0500
Message-ID: <46C09C2B.9050207@cs.wisc.edu>
References: <200708102150.l7ALoaLm011335@imap1.linux-foundation.org> <46C07455.7000903@greshamstorage.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060706030806010602040704"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51083 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032547AbXHMSA5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 14:00:57 -0400
In-Reply-To: <46C07455.7000903@greshamstorage.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jli@greshamstorage.com>
Cc: akpm@linux-foundation.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060706030806010602040704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jeremy Linton wrote:
> akpm@linux-foundation.org wrote:
>> From: Jeremy Linton <jli@greshamstorage.com>
>>
>> Any function which use scsi_execute_async() and transfers "odd" sized 
>> data
>> that doesn't align correctly with the segment sizes may have its transfer
>> length padded out to the closest segment size.
>     I would like to strongly suggest that Mike Christie's patch be used 
> instead.
> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg06032.html
> 
> 
> I finally hit the case he was talking about (the block layer retries 0 
> length commands caused by a size mismatch) and its ugly. I'm not really 
> sure why my initial tests weren't hitting that case, I was trying to 
> understand why some blocks were getting an extra command generated while 
> others weren't.  Sufficient to say, his patch fixes both problems, the 
> incorrect transfer lengths and the extra 0 length transfer being generated.
> 

I am having trouble inlining the patch properly with my mailer. Here is 
the patch from that thread attached if James or Andrew needs it.

--------------060706030806010602040704
Content-Type: text/x-patch;
 name="usebufflen.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usebufflen.patch"

sg's may have setup a the buffer with a different length than
the transfer length so we should be using the bufflen passed
in as the request's data len.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5f95570..30ae831 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -301,7 +301,7 @@ static int scsi_req_map_sg(struct reques
 {
 	struct request_queue *q = rq->q;
 	int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	unsigned int data_len = 0, len, bytes, off;
+	unsigned int data_len = bufflen, len, bytes, off;
 	struct page *page;
 	struct bio *bio = NULL;
 	int i, err, nr_vecs = 0;
@@ -310,10 +310,15 @@ static int scsi_req_map_sg(struct reques
 		page = sgl[i].page;
 		off = sgl[i].offset;
 		len = sgl[i].length;
-		data_len += len;
 
-		while (len > 0) {
+		while (len > 0 && data_len > 0) {
+			/*
+			 * sg sends a scatterlist that is larger than
+			 * the data_len it wants transferred for certain
+			 * IO sizes
+			 */
 			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
+			bytes = min(bytes, data_len);
 
 			if (!bio) {
 				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
@@ -345,12 +350,13 @@ static int scsi_req_map_sg(struct reques
 
 			page++;
 			len -= bytes;
+			data_len -=bytes;
 			off = 0;
 		}
 	}
 
 	rq->buffer = rq->data = NULL;
-	rq->data_len = data_len;
+	rq->data_len = bufflen;
 	return 0;
 
 free_bios:

--------------060706030806010602040704--
