From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH RFC/RFT 4/4]  convert st
Date: Thu, 15 Sep 2005 23:43:52 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0509152247500.5552@kai.makisara.local>
References: <1126736393.16778.28.camel@max>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep32-0.kolumbus.fi ([193.229.0.63]:62136 "EHLO
	fep32-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S932160AbVIOUie (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 16:38:34 -0400
In-Reply-To: <1126736393.16778.28.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Wed, 14 Sep 2005, Mike Christie wrote:

> Convert st to always use scatterlists.
> 
I have looked at the changes and they look very good. You have succeeded 
in doing the changes so that the tape handling logic does not need any 
changes. This makes testing easier.

> Patch is completely untested. I do not have tape.
> 
I have done preliminary tests. The first attempt lead to an oops. The 
reason was that the field ->stp in st_request was never set to point to struct 
scsi_tape. After fixing this, the driver has not oopsed any more. It does 
not pass all tests but I will be looking at that problem later (something 
to do with detecting filemark at end of data).

I enabled debugging and the driver did not compile but this was simple to 
fix. The patch at the end fixes both the oops and these compilation 
problems.

> Note that this should work like before except that
> HighMem is no longer supported for DIO (we drop down
> to indirect).
This may decrease throughput with ia32 machines having more than 1 GB of 
memory and a SCSI HBA that can reach all of the memory. It would be nice 
if DIO would be possible in this case but this is not a showstopper.

>               However we support bounce buffers
> for the non-DIO case now. So we could kill restr_dma too becuase
> the block layer will bounce the buffers that are beyond queue limits.
> 
Theoretically, restr_dma prevents "double bouncing". However, the hardware 
requiring restr_dma is not common any more.

> This was meant to be a safer patch that maybe Kai or someone
> could test and adjust, but then we could move scsi-ml forward.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
...
> +/*
> + * we can change this to use a mempool if Kai wants
> + */
> +static struct st_request *st_allocate_request(void)
> +{
> +	return kzalloc(sizeof(struct st_request), GFP_ATOMIC);
> +}

This must not fail. Is GFP_ATOMIC necessary or could we use GFP_KERNEL? 
One possibility might be to allocate this together with the st internal 
buffer (st is designed so that there is only one SCSI request going on at 
any time).

...
> @@ -4411,33 +4404,18 @@ static void do_create_class_files(struct
>  
>  /* Pin down user pages and put them into a scatter gather list. Returns <= 0 if
>     - mapping of all pages not successful
> -   - any page is above max_pfn
> +   - A HighMem page is returned
>     (i.e., either completely successful or fails)
>  */
> -static int st_map_user_pages(struct scatterlist *sgl, const unsigned int max_pages, 
> -			     unsigned long uaddr, size_t count, int rw,
> -			     unsigned long max_pfn)
> -{
> -	int i, nr_pages;
> -
> -	nr_pages = sgl_map_user_pages(sgl, max_pages, uaddr, count, rw);
> -	if (nr_pages <= 0)
> -		return nr_pages;
> -
> -	for (i=0; i < nr_pages; i++) {
> -		if (page_to_pfn(sgl[i].page) > max_pfn)
> -			goto out_unmap;
> -	}
> -	return nr_pages;
> -
> - out_unmap:
> -	sgl_unmap_user_pages(sgl, nr_pages, 0);
> -	return 0;
> +static int st_map_user_pages(struct kvec *iov, const unsigned int max_pages, 
> +			     unsigned long uaddr, size_t count, int rw)
> +{
> +	return sgl_map_user_pages(iov, max_pages, uaddr, count, rw);
>  }
>  
This functioncould probably be removed and the calls be changed to calls 
to sgl_map_use_pages()? st_map_user_pages() does exist because I needed to 
change some things after Doug Gilbert had copied sgl_map_user_pages() (the 
st_map_user_pages()) to sg.c and I did not change code that was meant to 
be similar in both drivers.

-- 
Kai

----------------------------------8<----------------------------------------
--- linux-2.6.14-rc1-blk1/drivers/scsi/st.c	2005-09-15 22:38:19.000000000 +0300
+++ linux-2.6.14-rc1-blk2/drivers/scsi/st.c	2005-09-15 22:30:36.000000000 +0300
@@ -371,7 +371,7 @@
 		       SRpnt->cmd[0], SRpnt->cmd[1], SRpnt->cmd[2],
 		       SRpnt->cmd[3], SRpnt->cmd[4], SRpnt->cmd[5]);
 		if (cmdstatp->have_sense)
-			scsi_print_req_sense("st", SRpnt);
+			__scsi_print_sense("st", SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
 	} ) /* end DEB */
 	if (!debugging) { /* Abnormal conditions for tape */
 		if (!cmdstatp->have_sense)
@@ -495,6 +495,7 @@
 				(STp->buffer)->syscall_result = (-EBUSY);
 			return NULL;
 		}
+		SRpnt->stp = STp;
 	}
 
 	/* If async IO, set last_SRpnt. This ptr tells write_behind_check
@@ -1420,7 +1421,8 @@
 			STp->nbr_dio++;
 			STp->nbr_pages += STbp->do_dio;
 			for (i=1; i < STbp->do_dio; i++)
-				if (page_to_pfn(STbp->sg[i].page) == page_to_pfn(STbp->sg[i-1].page) + 1)
+				if (STbp->iov[i].iov_base ==
+				    STbp->iov[i-1].iov_base + PAGE_SIZE)
 					STp->nbr_combinable++;
 		     }
 		)
@@ -1804,10 +1806,10 @@
 		retval = 1;
 		DEBC(printk(ST_DEB_MSG "%s: Sense: %2x %2x %2x %2x %2x %2x %2x %2x\n",
                             name,
-                            SRpnt->sr_sense_buffer[0], SRpnt->sr_sense_buffer[1],
-                            SRpnt->sr_sense_buffer[2], SRpnt->sr_sense_buffer[3],
-                            SRpnt->sr_sense_buffer[4], SRpnt->sr_sense_buffer[5],
-                            SRpnt->sr_sense_buffer[6], SRpnt->sr_sense_buffer[7]));
+                            SRpnt->sense[0], SRpnt->sense[1],
+                            SRpnt->sense[2], SRpnt->sense[3],
+                            SRpnt->sense[4], SRpnt->sense[5],
+                            SRpnt->sense[6], SRpnt->sense[7]));
 		if (cmdstatp->have_sense) {
 
 			if (cmdstatp->sense_hdr.sense_key == BLANK_CHECK)
