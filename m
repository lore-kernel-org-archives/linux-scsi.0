From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] fusion update to current APIs
Date: Fri, 11 Jun 2004 22:13:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040612051353.GA152829@sgi.com>
References: <20040531115229.GA16143@lst.de> <20040612003608.GA152454@sgi.com> <20040612034518.GN24864@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:7592 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S264642AbUFLFPE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jun 2004 01:15:04 -0400
Content-Disposition: inline
In-Reply-To: <20040612034518.GN24864@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Christoph Hellwig <hch@lst.de>, Emoore@lsil.com, linux-scsi@vger.kernel.org

On Sat, Jun 12, 2004 at 04:45:18AM +0100, Matthew Wilcox wrote:
> On Fri, Jun 11, 2004 at 05:36:08PM -0700, Jeremy Higdon wrote:
> > Christoph, the midlayer gets it wrong sometimes.
> 
> ... then the midlayer needs to get fixed rather than have all this code
> duplicated in a million different drivers with subtly different bugs in
> each one.

That makes sense to me.  In fact, I think we could just fix it in sg.
It's only a problem with the older sg interfaces that don't specify
a direction.

To review, the problem is that many sg1 and sg2 apps don't tightly
trim the reply length.  Thus, even though they're issuing a Write
command, they will set the reply length to a value greater than
SZ_SG_HEADER.

so in sg_write(), hp->dxfer_direction gets set to SG_DXFER_TO_FROM_DEV:
	if (input_size > 0)
                hp->dxfer_direction = (old_hdr.reply_len > SZ_SG_HEADER) ?
                    SG_DXFER_TO_FROM_DEV : SG_DXFER_TO_DEV;
        else
                hp->dxfer_direction = (mxsize > 0) ? SG_DXFER_FROM_DEV : SG_DXFER_NONE;

then in sg_common_write, the data direction of the SCSI request is
set to SCSI_DATA_READ:
        switch (hp->dxfer_direction) {
        case SG_DXFER_TO_FROM_DEV:
        case SG_DXFER_FROM_DEV:
                SRpnt->sr_data_direction = SCSI_DATA_READ;
                break;
        case SG_DXFER_TO_DEV:
                SRpnt->sr_data_direction = SCSI_DATA_WRITE;
                break;
        case SG_DXFER_UNKNOWN:
                SRpnt->sr_data_direction = SCSI_DATA_UNKNOWN;
                break;
        default:
                SRpnt->sr_data_direction = SCSI_DATA_NONE;
                break;
        }


Then when the host driver sends the Write command to the disk with the
data direction set the other way, you usually get a SCSI bus reset.

So we should probably put the direction interpretation in sg_write() near
the bottom just before calling sg_common_write().

Something like this, where sg_direction() does what the host drivers
are currently doing.  I haven't actually tried this yet, but I can
code something up and give it a whirl if folks would like (I'm a little
short on time tonight :-).

===== drivers/scsi/sg.c 1.90 vs edited =====
--- 1.90/drivers/scsi/sg.c	Sat May 29 10:57:23 2004
+++ edited/drivers/scsi/sg.c	Fri Jun 11 22:11:20 2004
@@ -552,11 +552,6 @@
 	hp->cmd_len = (unsigned char) cmd_size;
 	hp->iovec_count = 0;
 	hp->mx_sb_len = 0;
-	if (input_size > 0)
-		hp->dxfer_direction = (old_hdr.reply_len > SZ_SG_HEADER) ?
-		    SG_DXFER_TO_FROM_DEV : SG_DXFER_TO_DEV;
-	else
-		hp->dxfer_direction = (mxsize > 0) ? SG_DXFER_FROM_DEV : SG_DXFER_NONE;
 	hp->dxfer_len = mxsize;
 	hp->dxferp = (char __user *)buf + cmd_size;
 	hp->sbp = NULL;
@@ -566,6 +561,7 @@
 	hp->usr_ptr = NULL;
 	if (__copy_from_user(cmnd, buf, cmd_size))
 		return -EFAULT;
+	hp->dxfer_direction = sg_direction(cmnd);
 	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
 	return (k < 0) ? k : count;
 }


jeremy
