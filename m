From: Jason L Tibbitts III <tibbs@math.uh.edu>
Subject: Re: [REGRESSION] 28676d869bbb (scsi: sg: check for valid direction before starting the request) breaks mtx tape library control
Date: Wed, 26 Jul 2017 15:19:31 -0500
Message-ID: <ufapocn2bos.fsf@epithumia.math.uh.edu>
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
        <20170726073934.GC4039@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170726073934.GC4039@linux-x5ow.site> (Johannes Thumshirn's
        message of "Wed, 26 Jul 2017 09:39:34 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dvyukov@google.com, hare@suse.com, hch@lst.de, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "JT" == Johannes Thumshirn <jthumshirn@suse.de> writes:

JT> It's probably best to just check for dxfer_len <= 2^28 to be valid
JT> as Doug suggested:

I can verify that patch on top of git head (as of a few hours ago) does
function properly.

It didn't apply directly on top of 4.12 but even I can handle fixing
that up.  The result (just deleting the function and changing the call
to a check for hp->dxfer_len >= SZ_256M) works fine and is at the end.

So thanks.  If this goes in, please CC to stable.

 - J<

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 82c33a6..aa6f1de 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -751,29 +751,6 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 	return count;
 }
 
-static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
-{
-	switch (hp->dxfer_direction) {
-	case SG_DXFER_NONE:
-		if (hp->dxferp || hp->dxfer_len > 0)
-			return false;
-		return true;
-	case SG_DXFER_TO_DEV:
-	case SG_DXFER_FROM_DEV:
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
@@ -794,7 +771,7 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 			"sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
 			(int) cmnd[0], (int) hp->cmd_len));
 
-	if (!sg_is_valid_dxfer(hp))
+	if (hp->dxfer_len >= SZ_256M)
 		return -EINVAL;
 
 	k = sg_start_req(srp, cmnd);
