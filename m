From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC/RFT 4/4]  convert st
Date: Thu, 15 Sep 2005 16:05:20 -0500
Message-ID: <4329E210.5050007@cs.wisc.edu>
References: <1126736393.16778.28.camel@max> <Pine.LNX.4.61.0509152247500.5552@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:32456 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1161029AbVIOVFS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 17:05:18 -0400
In-Reply-To: <Pine.LNX.4.61.0509152247500.5552@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Kai Makisara wrote:
> On Wed, 14 Sep 2005, Mike Christie wrote:
> 
> 
>>Convert st to always use scatterlists.
>>
> 
> I have looked at the changes and they look very good. You have succeeded 
> in doing the changes so that the tape handling logic does not need any 
> changes. This makes testing easier
> 
> 
>>Patch is completely untested. I do not have tape.
>>
> 
> I have done preliminary tests. The first attempt lead to an oops. The 
> reason was that the field ->stp in st_request was never set to point to struct 
> scsi_tape. After fixing this, the driver has not oopsed any more. It does 
> not pass all tests but I will be looking at that problem later (something 
> to do with detecting filemark at end of data).

ok thanks, I changed the API so that we could support HighMem in DIO and 
I found some bugs so I will send a update tonight.

> 
> I enabled debugging and the driver did not compile but this was simple to 
> fix. The patch at the end fixes both the oops and these compilation 
> problems.
>

Ok thanks will incorporate that.


> 
>>Note that this should work like before except that
>>HighMem is no longer supported for DIO (we drop down
>>to indirect).
> 
> This may decrease throughput with ia32 machines having more than 1 GB of 
> memory and a SCSI HBA that can reach all of the memory. It would be nice 
> if DIO would be possible in this case but this is not a showstopper.
> 

I fixed it last night by being paged based similar to what you had before :)

> 
>>              However we support bounce buffers
>>for the non-DIO case now. So we could kill restr_dma too becuase
>>the block layer will bounce the buffers that are beyond queue limits.
>>
> 
> Theoretically, restr_dma prevents "double bouncing". However, the hardware 
> requiring restr_dma is not common any more.
> 
> 
>>This was meant to be a safer patch that maybe Kai or someone
>>could test and adjust, but then we could move scsi-ml forward.
>>
>>Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>>
>>
>>diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
>>--- a/drivers/scsi/st.c
>>+++ b/drivers/scsi/st.c
> 
> ...
> 
>>+/*
>>+ * we can change this to use a mempool if Kai wants
>>+ */
>>+static struct st_request *st_allocate_request(void)
>>+{
>>+	return kzalloc(sizeof(struct st_request), GFP_ATOMIC);
>>+}
> 
> 
> This must not fail. Is GFP_ATOMIC necessary or could we use GFP_KERNEL? 
> One possibility might be to allocate this together with the st internal 
> buffer (st is designed so that there is only one SCSI request going on at 
> any time).

That sounds better. I was not sure if this was the case.

> 
> ...
> 
>>@@ -4411,33 +4404,18 @@ static void do_create_class_files(struct
>> 
>> /* Pin down user pages and put them into a scatter gather list. Returns <= 0 if
>>    - mapping of all pages not successful
>>-   - any page is above max_pfn
>>+   - A HighMem page is returned
>>    (i.e., either completely successful or fails)
>> */
>>-static int st_map_user_pages(struct scatterlist *sgl, const unsigned int max_pages, 
>>-			     unsigned long uaddr, size_t count, int rw,
>>-			     unsigned long max_pfn)
>>-{
>>-	int i, nr_pages;
>>-
>>-	nr_pages = sgl_map_user_pages(sgl, max_pages, uaddr, count, rw);
>>-	if (nr_pages <= 0)
>>-		return nr_pages;
>>-
>>-	for (i=0; i < nr_pages; i++) {
>>-		if (page_to_pfn(sgl[i].page) > max_pfn)
>>-			goto out_unmap;
>>-	}
>>-	return nr_pages;
>>-
>>- out_unmap:
>>-	sgl_unmap_user_pages(sgl, nr_pages, 0);
>>-	return 0;
>>+static int st_map_user_pages(struct kvec *iov, const unsigned int max_pages, 
>>+			     unsigned long uaddr, size_t count, int rw)
>>+{
>>+	return sgl_map_user_pages(iov, max_pages, uaddr, count, rw);
>> }
>> 
> 
> This functioncould probably be removed and the calls be changed to calls 
> to sgl_map_use_pages()? st_map_user_pages() does exist because I needed to 
> change some things after Doug Gilbert had copied sgl_map_user_pages() (the 
> st_map_user_pages()) to sg.c and I did not change code that was meant to 
> be similar in both drivers.


Forgot to clean that up. Will fix that up tonight.

Thakns for taking a look.
