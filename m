From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 00/11] st: remove scsi_execute_async usage (the first
 half)
Date: Tue, 2 Dec 2008 21:08:19 +0200 (EET)
Message-ID: <alpine.LNX.2.00.0812022059120.6402@kai.makisara.local>
References: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:40557 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbYLBTI0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2008 14:08:26 -0500
In-Reply-To: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Sun, 30 Nov 2008, FUJITA Tomonori wrote:

> This patchset removes the majority of scsi_execute_async in st
> driver. IOW, this converts st driver to use the block layer functions.
> 
> We are in the process of removing scsi_execute_async and
> scsi_req_map_sg. scsi_execute_async in sg driver were removed in
> 2.6.27. Now only st and osst drivers use scsi_execute_async().
> 
> st driver uses scsi_execute_async for two purposes, performing sort
> management SCSI commands internally and data transfer between user and
> kernel space (st_read and st_write). This patchset converts the
> former.
> 
> The former performs SCSI commands synchronously. It uses a liner
> in-kernel buffer (not scatter gather) for data transfer. To perform
> such commands, other upper layer drivers (e.g. sd) use
> scsi_execute_req (internally uses blk_rq_map_kern and and
> blk_execute_rq). scsi_execute_req is not fully fit for st so I adds a
> helper function similar to scsi_execute_req and replace
> scsi_execute_async in st driver (I might modify scsi_execute_req for
> st and remove the helper function later).
> 
> I'm still working on converting scsi_execute_async for data transfer
> between user and kernel space but I want to get this first half be
> merged.
> 
I have looked at the patches but it is a little difficult to say much 
without seeing the other half. I think there should be only one function 
in st to handle scsi. If you extend st_scsi_kern_execute to handle also 
read and write (as you later indicate you may do) I think that is a good 
direction.

I tested the patches in 2.6.28-rc7 and noticed a couple of problems. The 
patches do not convert st_int_ioctl. I added simple conversion (at the end 
of this message) but after this, the driver did not pass my simple tests. 
Looking at st_scsi_kern_execute(), it seems that it does not copy the 
sense data to struct st_request.

Thanks,
Kai

--- linux-t1/drivers/scsi/st.c.org	2008-12-02 20:14:11.000000000 +0200
+++ linux-t1/drivers/scsi/st.c	2008-12-02 20:34:49.000000000 +0200
@@ -2872,12 +2872,14 @@ static int st_int_ioctl(struct scsi_tape
 		return (-ENOSYS);
 	}
 
-	SRpnt = st_do_scsi(NULL, STp, cmd, datalen, direction,
-			   timeout, MAX_RETRIES, 1);
+
+	SRpnt = st_allocate_request(STp);
 	if (!SRpnt)
-		return (STp->buffer)->syscall_result;
+		return STp->buffer->syscall_result;
 
-	ioctl_result = (STp->buffer)->syscall_result;
+	ioctl_result = st_scsi_kern_execute(SRpnt, cmd, direction,
+					    STp->buffer->b_data, datalen,
+					    timeout, MAX_RETRIES);
 
 	if (!ioctl_result) {	/* SCSI command successful */
 		st_release_request(SRpnt);
