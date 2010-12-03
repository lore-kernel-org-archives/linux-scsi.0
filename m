From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Fri, 3 Dec 2010 21:27:57 +0900
Message-ID: <20101203212453W.fujita.tomonori@lab.ntt.co.jp>
References: <1290971729.2814.13.camel@larosa>
	<alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:55337 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292Ab0LCM2M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Dec 2010 07:28:12 -0500
In-Reply-To: <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: lkolbe@techfak.uni-bielefeld.de, linux-scsi@vger.kernel.org

On Mon, 29 Nov 2010 19:09:46 +0200 (EET)
Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:

> > This same behaviour appears when we're doing a few incremental backups;
> > after a while, it just isn't possible to use the tape drives anymore -
> > every I/O operation gives an I/O Error, even a simple dd bs=64k
> > count=10. After a restart, the system behaves correctly until
> > -seemingly- another memory pressure situation occured.
> > 
> This is predictable. The maximum number of scatter/gather segments seems 
> to be 128. The st driver first tries to set up transfer directly from the 
> user buffer to the HBA. The user buffer is usually fragmented so that one 
> scatter/gather segment is used for each page. Assuming 4 kB page size, the 
> maximu size of the direct transfer is 128 x 4 = 512 kB.

Can we make enlarge_buffer friendly to the memory alloctor a bit?

His problem is that the driver can't allocate 2 mB with the hardware
limit 128 segments.

enlarge_buffer tries to use ST_MAX_ORDER and if the allocation (256 kB
page) fails, enlarge_buffer fails. It could try smaller order instead?

Not tested at all.


diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 5b7388f..119544b 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3729,7 +3729,8 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dm
 		b_size = PAGE_SIZE << order;
 	} else {
 		for (b_size = PAGE_SIZE, order = 0;
-		     order < ST_MAX_ORDER && b_size < new_size;
+		     order < ST_MAX_ORDER &&
+			     max_segs * (PAGE_SIZE << order) < new_size;
 		     order++, b_size *= 2)
 			;  /* empty */
 	}
