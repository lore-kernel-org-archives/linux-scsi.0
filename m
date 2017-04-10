From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: sd: wait for slow devices on shutdown path
Date: Mon, 10 Apr 2017 20:49:33 -0300
Message-ID: <20170410234933.GA10185@khazad-dum.debian.net>
References: <20170410232118.GA4816@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170410232118.GA4816@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Author: Henrique de Moraes Holschuh <hmh@debian.org>
Date:   Wed Feb 1 20:42:02 2017 -0200

    sd: wait for slow devices on shutdown path
    
    Wait 1s during suspend/shutdown for the device to settle after
    we issue the STOP command.
    
    Otherwise we race ATA SSDs to powerdown, possibly causing damage to
    FLASH/data and even bricking the device.
    
    This is an experimental patch, there are likely better ways of doing
    this that don't punish non-SSDs.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4e08d1cd..3c6d5d3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3230,6 +3230,38 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 			res = 0;
 	}
 
+	/*
+	 * Wait for slow devices that signal they have fully entered
+	 * the stopped state before they actully did it.
+	 *
+	 * This behavior is apparently allowed per-spec for ATA
+	 * devices, and our SAT layer does not account for it.
+	 * Thus, on return, the device might still be in the process
+	 * of entering STANDBY state.
+	 *
+	 * Worse, apparently the ATA spec also says the unit should
+	 * return that it is already in STANDBY state *while still
+	 * entering that state*.
+	 *
+	 * SSDs absolutely depend on receiving a STANDBY IMMEDIATE
+	 * command prior to power off for a clean shutdown (and
+	 * likely we don't want to send them *anything else* in-
+	 * between either, to be on the safe side).
+	 *
+	 * As things stand, we are racing the SSD's firmware.  If it
+	 * finishes first, nothing bad happens.  If it doesn't, we
+	 * cut power while it is still saving metadata, and not only
+	 * this will cause extra FLASH wear (and maybe even damage
+	 * some cells), it also has a non-zero chance of bricking the
+	 * SSD.
+	 *
+	 * Issue reported on Intel, Crucial and Micron SSDs.
+	 * Issue can be detected by S.M.A.R.T. signaling unexpected
+	 * power cuts.
+	 */
+	if (!res && !start)
+		msleep(1000);
+
 	/* SCSI error codes must not go to the generic layer */
 	if (res)
 		return -EIO;

-- 
  Henrique Holschuh
