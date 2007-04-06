From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
Date: Fri, 06 Apr 2007 11:14:56 -0500
Message-ID: <1175876096.3677.24.camel@mulgrave.il.steeleye.com>
References: <200704061551.l36FpWoV015751@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933069AbXDFQV0@vger.kernel.org>
In-Reply-To: <200704061551.l36FpWoV015751@cichlid.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: cebbert@redhat.com, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, aradford@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2007-04-06 at 08:51 -0700, Andrew Burgess wrote:
> James Bottomley wrote:
> 
> >It's actually a long standing bug in the 3w-xxxx driver.  Apparently it
> >assumes request sense is always the use_sg == 0 case.  This is what it
> >does on a request sense:
> 
> >static int tw_scsiop_request_sense(TW_Device_Extension *tw_dev, int request_id)
> >{
> >        dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_request_sense()\n");
> 
> >        /* For now we just zero the request buffer */
> >        memset(tw_dev->srb[request_id]->request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
> >        tw_dev->state[request_id] = TW_S_COMPLETED;
> >        tw_state_request_finish(tw_dev, request_id);
> >....
> 
> >Note that it's clearing the request buffer, which is actually zeroing the scatterlist, hence the problem.
> 
> OK. Is there a quick workaround or should I just wait for
> Adam & Company to make a patch?

Try this ... I think it's roughly the correct fix.

> You said your earlier patch would hide it, and then said you
> had a length wrong in it and I'm not sure what length you
> mean.

It's the length specifier in the error handler request sense command ...
I'll fix it up and redo my patch through scsi-misc, since it's not going
to fix the root cause of the problem.

James

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index bf5d63e..6b303ba 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1864,10 +1864,17 @@ static int tw_scsiop_read_write(TW_Device_Extension *tw_dev, int request_id)
 /* This function will handle the request sense scsi command */
 static int tw_scsiop_request_sense(TW_Device_Extension *tw_dev, int request_id)
 {
+	char request_buffer[18];
+
 	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_request_sense()\n");
 
-	/* For now we just zero the request buffer */
-	memset(tw_dev->srb[request_id]->request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
+	memset(request_buffer, 0, sizeof(request_buffer));
+	request_buffer[0] = 0x70; /* Immediate fixed format */
+	request_buffer[7] = 11;	/* minimum size per SPC: 18 bytes */
+	/* leave all other fields zero, giving effectively NO_SENSE return */
+	tw_transfer_internal(tw_dev, request_id, request_buffer,
+			     sizeof(request_buffer));
+	
 	tw_dev->state[request_id] = TW_S_COMPLETED;
 	tw_state_request_finish(tw_dev, request_id);
 
