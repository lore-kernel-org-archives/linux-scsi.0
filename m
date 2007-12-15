From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: 2.6.24-rc5-mm1:  kernel BUG at include/linux/scatterlist.h:59!
Date: Sat, 15 Dec 2007 15:51:55 +0900
Message-ID: <20071215155444Z.tomof@acm.org>
References: <18275.3156.745358.12056@stoffel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:51999 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbXLOGwH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Dec 2007 01:52:07 -0500
In-Reply-To: <18275.3156.745358.12056@stoffel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: john@stoffel.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Fri, 14 Dec 2007 18:05:56 -0500
"John Stoffel" <john@stoffel.org> wrote:

> 
> Hi,
> 
> Just fired up 2.6.24-rc5-mm1 on a Dual CPU PIII 550mhz system with 2gb
> of RAM.  Got the following error.  Let me know if you need more
> details or want me to run tests or make changes.  Looks like something
> in the SCSI st driver, which makes sense since I have a pair of DLT 7k
> drives hooked upto this system via a Symbios PCI card.  I've also got
> a P1000 jukebox on there as well.

Can you try the following patch?

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 98dfd6e..328c47c 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3611,6 +3611,7 @@ static struct st_buffer *
 
 	tb->dma = need_dma;
 	tb->buffer_size = got;
+	sg_init_table(tb->sg, max_sg);
 
 	return tb;
 }
-- 
1.5.3.4

