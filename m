From: Jens Axboe <axboe@suse.de>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Fri, 9 Dec 2005 14:42:16 +0100
Message-ID: <20051209134216.GO26185@suse.de>
References: <200512072358.15398.adq_dvb@lidskialf.net> <200512080119.48740.adq@lidskialf.net> <200512080159.10913.adq_dvb@lidskialf.net> <200512080209.17757.adq_dvb@lidskialf.net> <43979E1A.30801@s5r6.in-berlin.de> <20051208173429.GA2666@us.ibm.com> <20051209133743.GN26185@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:22808 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1751318AbVLINkz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2005 08:40:55 -0500
Content-Disposition: inline
In-Reply-To: <20051209133743.GN26185@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Andrew de Quincey <adq_dvb@lidskialf.net>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Fri, Dec 09 2005, Jens Axboe wrote:
> On Thu, Dec 08 2005, Patrick Mansfield wrote:
> > On Thu, Dec 08, 2005 at 03:44:42AM +0100, Stefan Richter wrote:
> > 
> > > What if you replace WRITE by READ in 
> > > drivers/scsi/scsi_ioctl.c::scsi_cmd_ioctl()::case CDROMEJECT ?
> > 
> > You must mean block/scsi_ioctl.c? i.e.:
> > 
> > diff -uprN -X /home/patman/dontdiff linux-2.6.15-rc5-git1/block/scsi_ioctl.c mod- linux-2.6.15-rc5-git1/block/scsi_ioctl.c
> > --- /home/linux/views/linux-2.6.15-rc5-git1/block/scsi_ioctl.c	2005-12-03 22:51:54.000000000 -0800
> > +++ linux-2.6.15-rc5-git1/block/scsi_ioctl.c	2005-12-08 09:31:52.000000000 -0800
> > @@ -566,7 +566,7 @@ int scsi_cmd_ioctl(struct file *file, st
> >  		case CDROMCLOSETRAY:
> >  			close = 1;
> >  		case CDROMEJECT:
> > -			rq = blk_get_request(q, WRITE, __GFP_WAIT);
> > +			rq = blk_get_request(q, READ, __GFP_WAIT);
> >  			rq->flags |= REQ_BLOCK_PC;
> >  			rq->data = NULL;
> >  			rq->data_len = 0;
> 
> This should not make a difference, the direction flag must be ignored
> for !rq->data_len. Similarly you could translate the request with the
> change above into DMA_FROM_DEVICE which is clearly false as well. So it
> must be a bug somewhere that somebody only looks at the direction flag.

This looks like the real bug.

---


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4afef5c..0978887 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1215,12 +1215,12 @@ static int scsi_prep_fn(struct request_q
 		} else {
 			memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
 			cmd->cmd_len = req->cmd_len;
-			if (rq_data_dir(req) == WRITE)
+			if (!req->data_len)
+				cmd->sc_data_direction = DMA_NONE;
+			else if (rq_data_dir(req) == WRITE)
 				cmd->sc_data_direction = DMA_TO_DEVICE;
-			else if (req->data_len)
-				cmd->sc_data_direction = DMA_FROM_DEVICE;
 			else
-				cmd->sc_data_direction = DMA_NONE;
+				cmd->sc_data_direction = DMA_FROM_DEVICE;
 			
 			cmd->transfersize = req->data_len;
 			cmd->allowed = 3;


-- 
Jens Axboe

