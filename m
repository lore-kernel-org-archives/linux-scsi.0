From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 00/11] st: remove scsi_execute_async usage (the first
 half)
Date: Wed, 3 Dec 2008 09:27:44 +0900
Message-ID: <20081203092808I.fujita.tomonori@lab.ntt.co.jp>
References: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<alpine.LNX.2.00.0812022059120.6402@kai.makisara.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33658 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbYLCA17 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2008 19:27:59 -0500
In-Reply-To: <alpine.LNX.2.00.0812022059120.6402@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Tue, 2 Dec 2008 21:08:19 +0200 (EET)
Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:

> On Sun, 30 Nov 2008, FUJITA Tomonori wrote:
> 
> > This patchset removes the majority of scsi_execute_async in st
> > driver. IOW, this converts st driver to use the block layer functions.
> > 
> > We are in the process of removing scsi_execute_async and
> > scsi_req_map_sg. scsi_execute_async in sg driver were removed in
> > 2.6.27. Now only st and osst drivers use scsi_execute_async().
> > 
> > st driver uses scsi_execute_async for two purposes, performing sort
> > management SCSI commands internally and data transfer between user and
> > kernel space (st_read and st_write). This patchset converts the
> > former.
> > 
> > The former performs SCSI commands synchronously. It uses a liner
> > in-kernel buffer (not scatter gather) for data transfer. To perform
> > such commands, other upper layer drivers (e.g. sd) use
> > scsi_execute_req (internally uses blk_rq_map_kern and and
> > blk_execute_rq). scsi_execute_req is not fully fit for st so I adds a
> > helper function similar to scsi_execute_req and replace
> > scsi_execute_async in st driver (I might modify scsi_execute_req for
> > st and remove the helper function later).
> > 
> > I'm still working on converting scsi_execute_async for data transfer
> > between user and kernel space but I want to get this first half be
> > merged.
> > 
> I have looked at the patches but it is a little difficult to say much 
> without seeing the other half. I think there should be only one function 
> in st to handle scsi. If you extend st_scsi_kern_execute to handle also 
> read and write (as you later indicate you may do) I think that is a good 
> direction.

First, thanks a lot for taking a look at the patchset!

Yeah, I would extend st_scsi_kern_execute to handle st_read and
st_write (and remove st_do_scsi).

Or I would replace st_scsi_kern_execute with scsi_execute in
scsi_lib.c (then there is no homegrown function to perform internal
management SCSI commands in st driver).


> I tested the patches in 2.6.28-rc7 and noticed a couple of problems. The 
> patches do not convert st_int_ioctl.

Yeah, I left it alone since I didn't finish testing st_int_ioctl. But
you are right, st_int_ioctl does in-kernel data transfer so it needs
to be converted with st_scsi_kern_execute.


> I added simple conversion (at the end 
> of this message) but after this, the driver did not pass my simple tests. 
> Looking at st_scsi_kern_execute(), it seems that it does not copy the 
> sense data to struct st_request.

I think that blk_execute_rq copies the sense data for us. So we don't
need to worry about it.

Without your patch, that is, with only my patchset, the driver passed
your tests?

If so, can you try this patch to convert st_int_ioctl?


Do you prefer me to change st_scsi_kern_execute to set -EBUSY to
syscall_result if st_scsi_kern_execute internally fails (that is,
blk_rq_map_kern or blk_get_request fails)?

Note that scsi_execute_async (which st_do_scsi uses) could fail
internally. scsi_execute_async and st_scsi_kern_execute uses the same
functions that could fail, blk_rq_map_kern or blk_get_request


diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 02c3138..a70401f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2872,12 +2872,15 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		return (-ENOSYS);
 	}
 
-	SRpnt = st_do_scsi(NULL, STp, cmd, datalen, direction,
-			   timeout, MAX_RETRIES, 1);
+	SRpnt = st_allocate_request(STp);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
-	ioctl_result = (STp->buffer)->syscall_result;
+	ioctl_result = st_scsi_kern_execute(SRpnt, cmd, direction,
+					    STp->buffer->b_data, datalen,
+					    timeout, MAX_RETRIES);
+	if (!ioctl_result)
+		ioctl_result = (STp->buffer)->syscall_result;
 
 	if (!ioctl_result) {	/* SCSI command successful */
 		st_release_request(SRpnt);
