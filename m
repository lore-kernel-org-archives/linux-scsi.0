From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [REGRESSION] 28676d869bbb (scsi: sg: check for valid direction
 before starting the request) breaks mtx tape library control
Date: Wed, 19 Jul 2017 09:03:35 +0200
Message-ID: <20170719070335.GC4151@linux-x5ow.site>
References: <ufafudubmkd.fsf@epithumia.math.uh.edu>
 <20170718073747.GD4875@linux-x5ow.site>
 <ufak235abug.fsf@epithumia.math.uh.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ufak235abug.fsf@epithumia.math.uh.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason L Tibbitts III <tibbs@math.uh.edu>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dvyukov@google.com, hare@suse.com, hch@lst.de, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 18, 2017 at 12:33:59PM -0500, Jason L Tibbitts III wrote:
> I have verified that building a clean v4.12 with
> 68c59fcea1f2c6a54c62aa896cc623c1b5bc9b47 cherry picked on top still
> shows the problem:
> 
> [root@backup2 ~]# mtx -f /dev/sg7 next 0
> Unloading drive 0 into Storage Element 45...mtx: Request Sense: Long
> Report=yes
> mtx: Request Sense: Valid Residual=no
> mtx: Request Sense: Error Code=0 (Unknown?!)
> mtx: Request Sense: Sense Key=No Sense
> mtx: Request Sense: FileMark=no
> mtx: Request Sense: EOM=no
> mtx: Request Sense: ILI=no
> mtx: Request Sense: Additional Sense Code = 00
> mtx: Request Sense: Additional Sense Qualifier = 00
> mtx: Request Sense: BPV=no
> mtx: Request Sense: Error in CDB=no
> mtx: Request Sense: SKSV=no
> MOVE MEDIUM from Element Address 1 to 1045 Failed
> 
> Nothing appears to be logged; is there any kind of debugging information
> I can collect which might help to track this down?  I'm not particularly
> good at this but I am pretty sure that I'm building everything properly
> and am actually booting the patched kernel.


Can you please apply this debugging patch, so I can see what's going on.

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 1e82d4128a84..2505fa0b2062 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -753,6 +753,10 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 
 static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
 {
+
+	pr_info("%s: dxfer_direction: %d, dxfer_len: %d\n",
+		__func__, hp->dxfer_direction, hp->dxfer_len);
+
 	switch (hp->dxfer_direction) {
 	case SG_DXFER_NONE:
 		if (hp->dxferp || hp->dxfer_len > 0)

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
