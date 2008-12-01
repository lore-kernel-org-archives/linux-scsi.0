From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 09/11] st: convert read_mode_page to use
 st_scsi_kern_execute
Date: Mon, 1 Dec 2008 17:21:40 +0900
Message-ID: <20081201172154D.fujita.tomonori@lab.ntt.co.jp>
References: <1228032485-10328-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1228032485-10328-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<49328339.5050602@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:36246 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbYLAIV6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2008 03:21:58 -0500
In-Reply-To: <49328339.5050602@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, Kai.Makisara@kolumbus.fi, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Sun, 30 Nov 2008 14:12:41 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> FUJITA Tomonori wrote:
> > This replaces st_do_scsi in read_mode_page (MODE_SENSE) with
> > st_scsi_kern_execute.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  drivers/scsi/st.c |   16 +++++++++++-----
> >  1 files changed, 11 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> > index cc085bc..91d1249 100644
> > --- a/drivers/scsi/st.c
> > +++ b/drivers/scsi/st.c
> > @@ -2393,7 +2393,8 @@ static int st_set_options(struct scsi_tape *STp, long options)
> >  static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
> >  {
> >  	unsigned char cmd[MAX_COMMAND_SIZE];
> > -	struct st_request *SRpnt = NULL;
> > +	struct st_request *SRpnt;
> > +	int ret;
> >  
> >  	memset(cmd, 0, MAX_COMMAND_SIZE);
> >  	cmd[0] = MODE_SENSE;
> > @@ -2402,10 +2403,15 @@ static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
> >  	cmd[2] = page;
> >  	cmd[4] = 255;
> >  
> > -	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE,
> > -			   STp->device->timeout, 0, 1);
> > -	if (SRpnt == NULL)
> > -		return (STp->buffer)->syscall_result;
> > +	SRpnt = st_allocate_request(STp);
> > +	if (!SRpnt)
> > +		return STp->buffer->syscall_result;
> > +
> > +	ret = st_scsi_kern_execute(SRpnt, cmd, DMA_FROM_DEVICE,
> > +				   STp->buffer->b_data, cmd[4],
> > +				   STp->device->timeout, MAX_RETRIES);
> > +	if (ret)
> > +		return ret;
> 
> Are you sure you want to return here without st_release_request() ?
> All other patches return ret but release first.

Ah, thanks a lot.

It should do something like this.

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index cc085bc..cf8861f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2393,7 +2393,8 @@ static int st_set_options(struct scsi_tape *STp, long options)
 static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
 {
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct st_request *SRpnt = NULL;
+	struct st_request *SRpnt;
+	int ret;
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = MODE_SENSE;
@@ -2402,14 +2403,16 @@ static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
 	cmd[2] = page;
 	cmd[4] = 255;
 
-	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE,
-			   STp->device->timeout, 0, 1);
-	if (SRpnt == NULL)
-		return (STp->buffer)->syscall_result;
+	SRpnt = st_allocate_request(STp);
+	if (!SRpnt)
+		return STp->buffer->syscall_result;
 
+	ret = st_scsi_kern_execute(SRpnt, cmd, DMA_FROM_DEVICE,
+				   STp->buffer->b_data, cmd[4],
+				   STp->device->timeout, MAX_RETRIES);
 	st_release_request(SRpnt);
 
-	return (STp->buffer)->syscall_result;
+	return ret ? : STp->buffer->syscall_result;
 }
 
 

