From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] sd: Don't incorrectly "promote" DIF type0 into DIF type1
 disks.
Date: Tue, 27 Nov 2012 16:17:29 -0800
Message-ID: <20121128001729.GB4321@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If I run the following command:
# modprobe scsi_debug dev_size_mb=64 ato=1 dix=1 dif=0

then I see the following in the dmesg log:

[   25.859145] scsi_debug: host protection DIX0

Ok, DIX0, which means "no integrity extensions at all", and no DIF support at all.
I'm not sure why you'd advertise DIX0 at all, but so far so good.

(DIX is the mechanism by which the OS sends integrity data to the disk in
whatever format DIF specifies.  You need DIF for DIX to do anything.)

[   25.860214] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=64, opts=0x0
[   25.863418] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
[   25.880079] sd 0:0:0:0: [sda] 131072 512-byte logical blocks: (67.1 MB/64.0 MiB)
[   25.884133] sd 0:0:0:0: [sda] Write Protect is off
[   25.892205] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.920344]  sda: unknown partition table
[   25.926704] sd_dif_config_host: type=0 dif=0 dix=8
[   25.931651] sd 0:0:0:0: [sda] Enabling DIX T10-DIF-TYPE1-CRC protection

Huh??  Here we are turning on DIX support as if the disk supports DIF type1.
This seems strange to me because we didn't advertise any DIF support at all.

[   25.952208] sd 0:0:0:0: [sda] Attached SCSI disk
[   25.977977] BUG: unable to handle kernel paging request at 00000000000ffc02
[   25.980262] IP: [<ffffffffa01ebaa5>] resp_read.part.38+0x145/0x420 [scsi_debug]

Uhoh, that shouldn't happen.  The SCSI layer sent along what looks like a type1
read request even though the disk wasn't really prepared to handle it, and
kaboom.  I don't think this particular combination is terribly common, but we
could at least not misprogram the disk when we see it.

If the disk advertises DIF type 0, we can skip the rest of the DIF setup.
Right now, the SCSI layer "promotes" a DIF type 0 disk into a DIF type 1 disk,
which seems incorrect.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 drivers/scsi/sd_dif.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 04998f3..ede5b7b 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -313,6 +313,10 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 	u8 type = sdkp->protection_type;
 	int dif, dix;
 
+	/* Don't promote DIF type0 into type1 support. */
+	if (type == SD_DIF_TYPE0_PROTECTION)
+		return;
+
 	dif = scsi_host_dif_capable(sdp->host, type);
 	dix = scsi_host_dix_capable(sdp->host, type);
 
