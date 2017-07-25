From: Jason L Tibbitts III <tibbs@math.uh.edu>
Subject: Re: [REGRESSION] 28676d869bbb (scsi: sg: check for valid direction before starting the request) breaks mtx tape library control
Date: Tue, 25 Jul 2017 13:25:07 -0500
Message-ID: <ufa1sp474sc.fsf@epithumia.math.uh.edu>
References: <ufafudubmkd.fsf@epithumia.math.uh.edu>
        <20170718073747.GD4875@linux-x5ow.site>
        <ufak235abug.fsf@epithumia.math.uh.edu>
        <20170719070335.GC4151@linux-x5ow.site>
        <ufazic0974h.fsf@epithumia.math.uh.edu>
        <20170719083654.GE4151@linux-x5ow.site>
        <20170721164343.GA4086@linux-x5ow.site>
        <ufa7ez18uhn.fsf@epithumia.math.uh.edu>
        <20170725071852.GA3750@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170725071852.GA3750@linux-x5ow.site> (Johannes Thumshirn's
        message of "Tue, 25 Jul 2017 09:18:52 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dvyukov@google.com, hare@suse.com, hch@lst.de, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "JT" == Johannes Thumshirn <jthumshirn@suse.de> writes:

JT> Yes please (on top of the snippet I've sent you last).

OK, I'm at 4.12 with 68c59fcea1f2c6a54c62aa896cc623c1b5bc9b47 cherry
picked, plus the fix patch and the debug patch you've sent previously.
To make sure we're on the same page, I'll include the patch at the end.

Running "mtx -f /dev/sg7 status" gives proper output with this logged to
the console:

[   36.742905] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 56
[   36.750036] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 136
[   36.791673] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 4240
[   37.339790] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 4240
[   37.393597] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 4240

And running "mtx -f /dev/sg7 next 0" gives the following output:

[root@backup2 ~]# mtx -f /dev/sg7 next 0
Unloading drive 0 into Storage Element 1...mtx: Request Sense: Long
Report=yes
mtx: Request Sense: Valid Residual=no
mtx: Request Sense: Error Code=0 (Unknown?!)
mtx: Request Sense: Sense Key=No Sense
mtx: Request Sense: FileMark=no
mtx: Request Sense: EOM=no
mtx: Request Sense: ILI=no
mtx: Request Sense: Additional Sense Code = 00
mtx: Request Sense: Additional Sense Qualifier = 00
mtx: Request Sense: BPV=no
mtx: Request Sense: Error in CDB=no
mtx: Request Sense: SKSV=no
MOVE MEDIUM from Element Address 1 to 1001 Failed

And the following is logged to the console:

[  192.732294] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 56
[  192.739492] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 136
[  192.781507] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 4240
[  193.392401] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 4240
[  193.448970] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 4240
[  193.495130] sg_is_valid_dxfer: dxfer_direction: -2, dxfer_len: 0

That's not any different than what I provided before, and honestly I
wouldn't expect it to be.

Is there something else I can log or some debugging switch I can twiddle
to give you any more information?  I can also try to be more available
to try and avoid the timezone-induced day-long cycle time.  I'm
available on IRC (tibbs on freenode and oftc) and can try to stay up
late or get up early or something to try and avoid this time zone
mismatch.

Here's what an strace of the last mtx call says:

open("/dev/sg7", O_RDWR)                = 3
ioctl(3, SG_GET_VERSION_NUM, [30536])   = 0
ioctl(3, SG_SET_TIMEOUT, [30000])       = 0
brk(NULL)                               = 0x55d65f68a000
brk(0x55d65f6ab000)                     = 0x55d65f6ab000
brk(NULL)                               = 0x55d65f6ab000
ioctl(3, SG_IO, {interface_id='S', dxfer_direction=SG_DXFER_FROM_DEV, cmd_len=6, cmdp="\x12\x00\x00\x00\x38\x00", mx_sb_len=20, iovec_count=0, dxfer_len=56, timeout=30000, flags=0, dxferp="\x08\x80\x05\x02\x45\x00\x00\x02\x42\x44\x54\x20\x20\x20\x20\x20\x46\x6c\x65\x78\x53\x74\x6f\x72\x20\x49\x49\x20\x20\x20\x20\x20"..., status=0, masked_status=0, msg_status=0, sb_len_wr=0, sbp="", host_status=0, driver_status=0, resid=0, duration=1, info=0}) = 0
ioctl(3, SG_IO, {interface_id='S', dxfer_direction=SG_DXFER_FROM_DEV, cmd_len=6, cmdp="\x1a\x08\x1d\x00\x88\x00", mx_sb_len=20, iovec_count=0, dxfer_len=136, timeout=300000, flags=0, dxferp="\x17\x00\x00\x00\x9d\x12\x00\x00\x00\x01\x03\xe9\x00\x30\x00\x65\x00\x00\x00\x01\x00\x01\x00\x00", status=0, masked_status=0, msg_status=0, sb_len_wr=0, sbp="", host_status=0, driver_status=0, resid=112, duration=61, info=0}) = 0
ioctl(3, CDROMAUDIOBUFSIZ or SCSI_IOCTL_GET_IDLUN, 0x7ffdbfaee7a0) = 0
ioctl(3, SG_IO, {interface_id='S', dxfer_direction=SG_DXFER_FROM_DEV, cmd_len=12, cmdp="\xb8\x32\x03\xe9\x00\x30\x00\x00\x10\x90\x00\x00", mx_sb_len=20, iovec_count=0, dxfer_len=4240, timeout=300000, flags=0, dxferp="\x03\xe9\x00\x30\x00\x00\x09\xc8\x02\x80\x00\x34\x00\x00\x09\xc0\x03\xe9\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"..., status=0, masked_status=0, msg_status=0, sb_len_wr=0, sbp="", host_status=0, driver_status=0, resid=1728, duration=542, info=0}) = 0
ioctl(3, CDROMAUDIOBUFSIZ or SCSI_IOCTL_GET_IDLUN, 0x7ffdbfaee7a0) = 0
ioctl(3, SG_IO, {interface_id='S', dxfer_direction=SG_DXFER_FROM_DEV, cmd_len=12, cmdp="\xb8\x34\x00\x01\x00\x01\x00\x00\x10\x90\x00\x00", mx_sb_len=20, iovec_count=0, dxfer_len=4240, timeout=300000, flags=0, dxferp="\x00\x01\x00\x01\x00\x00\x00\x3c\x04\x80\x00\x34\x00\x00\x00\x34\x00\x01\x09\x00\x00\x00\x00\x00\x00\x81\x03\xe9\x43\x30\x30\x30"..., status=0, masked_status=0, msg_status=0, sb_len_wr=0, sbp="", host_status=0, driver_status=0, resid=4172, duration=47, info=0}) = 0
ioctl(3, CDROMAUDIOBUFSIZ or SCSI_IOCTL_GET_IDLUN, 0x7ffdbfaee7a0) = 0
ioctl(3, SG_IO, {interface_id='S', dxfer_direction=SG_DXFER_FROM_DEV, cmd_len=12, cmdp="\xb8\x31\x00\x00\x00\x01\x00\x00\x10\x90\x00\x00", mx_sb_len=20, iovec_count=0, dxfer_len=4240, timeout=300000, flags=0, dxferp="\x00\x00\x00\x01\x00\x00\x00\x3c\x01\x80\x00\x34\x00\x00\x00\x34\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"..., status=0, masked_status=0, msg_status=0, sb_len_wr=0, sbp="", host_status=0, driver_status=0, resid=4172, duration=37, info=0}) = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
write(1, "Unloading drive 0 into Storage E"..., 43) = 43
ioctl(3, SG_IO, {interface_id='S', dxfer_direction=SG_DXFER_TO_DEV, cmd_len=12, cmdp="\xa5\x00\x00\x00\x00\x01\x03\xe9\x00\x00\x00\x00", mx_sb_len=20, iovec_count=0, dxfer_len=0, timeout=300000, flags=0, dxferp=NULL, status=0, masked_status=0, msg_status=0, sb_len_wr=0, sbp="", host_status=0, driver_status=0, resid=0, duration=0, info=0}) = -1 EINVAL (Invalid argument)
write(2, "mtx: Request Sense: Long Report="..., 36) = 36

And here's what I'm testing on top of 4.12:

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 82c33a6..6870e88 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -753,15 +753,22 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 
 static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
 {
+
+	pr_info("%s: dxfer_direction: %d, dxfer_len: %d\n",
+		__func__, hp->dxfer_direction, hp->dxfer_len);
+
 	switch (hp->dxfer_direction) {
 	case SG_DXFER_NONE:
 		if (hp->dxferp || hp->dxfer_len > 0)
 			return false;
 		return true;
-	case SG_DXFER_TO_DEV:
 	case SG_DXFER_FROM_DEV:
+		if (hp->dxfer_len < 0)
+			return false;
+		return true;
+	case SG_DXFER_TO_DEV:
 	case SG_DXFER_TO_FROM_DEV:
-		if (!hp->dxferp || hp->dxfer_len == 0)
+		if (!hp->dxferp)
 			return false;
 		return true;
 	case SG_DXFER_UNKNOWN:

 - J<
