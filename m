From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [REGRESSION] 28676d869bbb (scsi: sg: check for valid direction
 before starting the request) breaks mtx tape library control
Date: Wed, 26 Jul 2017 09:39:34 +0200
Message-ID: <20170726073934.GC4039@linux-x5ow.site>
References: <ufafudubmkd.fsf@epithumia.math.uh.edu>
 <20170718073747.GD4875@linux-x5ow.site>
 <ufak235abug.fsf@epithumia.math.uh.edu>
 <20170719070335.GC4151@linux-x5ow.site>
 <ufazic0974h.fsf@epithumia.math.uh.edu>
 <20170719083654.GE4151@linux-x5ow.site>
 <20170721164343.GA4086@linux-x5ow.site>
 <ufa7ez18uhn.fsf@epithumia.math.uh.edu>
 <20170725071852.GA3750@linux-x5ow.site>
 <ufa1sp474sc.fsf@epithumia.math.uh.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ufa1sp474sc.fsf@epithumia.math.uh.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason L Tibbitts III <tibbs@math.uh.edu>
Cc: Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dvyukov@google.com, hare@suse.com, hch@lst.de, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 25, 2017 at 01:25:07PM -0500, Jason L Tibbitts III wrote:
> >>>>> "JT" == Johannes Thumshirn <jthumshirn@suse.de> writes:
> ioctl(3, SG_IO, {interface_id='S', dxfer_direction=SG_DXFER_TO_DEV, cmd_len=12, cmdp="\xa5\x00\x00\x00\x00\x01\x03\xe9\x00\x00\x00\x00", mx_sb_len=20, iovec_count=0, dxfer_len=0, timeout=300000, flags=0, dxferp=NULL, status=0, masked_status=0, msg_status=0, sb_len_wr=0, sbp="", host_status=0, driver_status=0, resid=0, duration=0, info=0}) = -1 EINVAL (Invalid argument)

[...]
 	case SG_DXFER_TO_DEV:
  	case SG_DXFER_TO_FROM_DEV:
 		if (!hp->dxferp)
  			return false;
  		return true;

So here we go, dxfer_direction is SG_DXFER_TO_DEV, dxfer_len is 0 and dxferp
is NULL. We bail out because dxferp is NULL here.

I only looked at sg_write() and not sg_new_write() which is called by the
SG_IO path not the fops->write() path.

It's probably best to just check for dxfer_len <= 2^28 to be valid as Doug
suggested:

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4fe606b000b4..d7ff71e0c85c 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -751,35 +751,6 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 	return count;
 }
 
-static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
-{
-	switch (hp->dxfer_direction) {
-	case SG_DXFER_NONE:
-		if (hp->dxferp || hp->dxfer_len > 0)
-			return false;
-		return true;
-	case SG_DXFER_FROM_DEV:
-		/*
-		 * for SG_DXFER_FROM_DEV we always set dxfer_len to > 0. dxferp
-		 * can either be NULL or != NULL so there's no point in checking
-		 * it either. So just return true.
-		 */
-		return true;
-	case SG_DXFER_TO_DEV:
-	case SG_DXFER_TO_FROM_DEV:
-		if (!hp->dxferp || hp->dxfer_len == 0)
-			return false;
-		return true;
-	case SG_DXFER_UNKNOWN:
-		if ((!hp->dxferp && hp->dxfer_len) ||
-		    (hp->dxferp && hp->dxfer_len == 0))
-			return false;
-		return true;
-	default:
-		return false;
-	}
-}
-
 static int
 sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		unsigned char *cmnd, int timeout, int blocking)
@@ -800,7 +771,7 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 			"sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
 			(int) cmnd[0], (int) hp->cmd_len));
 
-	if (!sg_is_valid_dxfer(hp))
+	if (hp->dxfer_len >= SZ_256M)
 		return -EINVAL;
 
 	k = sg_start_req(srp, cmnd);

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
