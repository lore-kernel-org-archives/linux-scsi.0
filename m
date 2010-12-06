From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Mon, 6 Dec 2010 09:59:11 +0200 (EET)
Message-ID: <alpine.LNX.2.00.1012060952570.7928@kai.makisara.local>
References: <1290971729.2814.13.camel@larosa>  <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>  <1291123886.2181.1347.camel@quux.techfak.uni-bielefeld.de>  <alpine.LNX.2.00.1011301813460.9731@kai.makisara.local> <1291223211.2814.72.camel@larosa>
 <alpine.LNX.2.00.1012021823420.9213@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs15.mail.saunalahti.fi ([195.197.172.101]:34984 "EHLO
	vs15.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab0LFH7V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2010 02:59:21 -0500
In-Reply-To: <alpine.LNX.2.00.1012021823420.9213@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thu, 2 Dec 2010, Kai Makisara wrote:

> On Wed, 1 Dec 2010, Lukas Kolbe wrote:
> 
> > Am Dienstag, den 30.11.2010, 18:20 +0200 schrieb Kai Makisara:
> > 
> ...
> > > If you see error with 64 kB block size, I would like to see any messages 
> > > associated with these errors.
> > 
> > I have now hit this bug again. Trying to read and write a label from the
> > tape drive in question results in this (via bacula's btape command):
> > 
...
> > [158529.011206] st1: Can't allocate 2097152 byte tape buffer.
> > [158544.348411] st: append_to_buffer offset overflow.
> > [158544.348416] st: append_to_buffer offset overflow.
> > [158544.348418] st: append_to_buffer offset overflow.
> > [158544.348419] st: append_to_buffer offset overflow.
> > 
> The messages except the first one are something that should never happen. 
> I think that there is something wrong with returning from enlarge_buffer() 
> when it fails. I will look at this when I have time.
> 
OK, today I have had some time (national holiday). I think I have tracked 
down this problem. The patch at the end should fix it. Basically, 
normalize_buffer() needs to know the order of the pages in order to 
properly free the pages and update the buffer size. When allocation 
failed, the order was not yet stored into the tape buffer definition. This 
does explain the problem after allocation failed. Why allocation failed is 
another problem which has been discussed elsewhere.

Kai

-----------------------------------8<------------------------------------
--- linux-2.6.36.1/drivers/scsi/st.c.org	2010-12-05 17:07:04.285226110 +0200
+++ linux-2.6.36.1/drivers/scsi/st.c	2010-12-06 09:46:34.756000154 +0200
@@ -3729,6 +3729,7 @@ static int enlarge_buffer(struct st_buff
 		     order < ST_MAX_ORDER && b_size < new_size;
 		     order++, b_size *= 2)
 			;  /* empty */
+		STbuffer->reserved_page_order = order;
 	}
 	if (max_segs * (PAGE_SIZE << order) < new_size) {
 		if (order == ST_MAX_ORDER)
@@ -3755,7 +3756,6 @@ static int enlarge_buffer(struct st_buff
 		segs++;
 	}
 	STbuffer->b_data = page_address(STbuffer->reserved_pages[0]);
-	STbuffer->reserved_page_order = order;
 
 	return 1;
 }
