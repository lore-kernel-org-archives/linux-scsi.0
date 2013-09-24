From: David Jeffery <djeffery@redhat.com>
Subject: [PATCH RESEND] sd: disk offlined prematurely from media access
 timeout
Date: Tue, 24 Sep 2013 15:42:44 -0400
Message-ID: <20130924194244.GA26428@fury.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab3IXToZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Sep 2013 15:44:25 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8OJiPfC009011
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2013 15:44:25 -0400
Received: from fury.redhat.com (vpn-54-129.rdu2.redhat.com [10.10.54.129])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r8OJiNS8030813
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2013 15:44:25 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

There is an error with the medium access timeout feature of the sd driver. The
sdkp->medium_access_timed_out value is set to zero in sd_done() in the wrong
place.  It is set to zero only if a command returns sense data.  If an I/O
command times out, error handling succeeds, and the I/O commands complete, the
value won't be reset if nothing responds with a sense buffer.  Then, another
timeout (no matter how far in the future) can increment it again, causing the
device to be errantly set offline.

The resetting of sdkp->medium_access_timed_out should occur before the check for
sense data.

Signed-off-by: David Jeffery <djeffery@redhat.com>

---

It can be reproduced using scsi_debug and using SCSI_DEBUG_OPT_MAC_TIMEOUT to
force some I/O to timeout once. This small script assumes /dev/sdb as
scsi_debug's disk, causes a timeout, completes 2MB of I/O successfully including
the timed out I/O command, then repeats.  Without the patch, the device is
offlined on the second loop.  All loops will successfully complete I/O
with the patch.

echo "-1" >/sys/bus/pseudo/drivers/scsi_debug/every_nth
for i in `seq 1 4`; do
        echo starting loop $i
        echo "128" >/sys/bus/pseudo/drivers/scsi_debug/opts
        dd if=/dev/sdb of=/dev/null bs=1M iflag=direct count=1 &
        sleep 5
        echo "0" >/sys/bus/pseudo/drivers/scsi_debug/opts
        wait
        dd if=/dev/sdb of=/dev/null bs=1M iflag=direct count=1
        echo ending loop $i
done


diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 86fcf2c..2779e6b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1669,12 +1669,12 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 						   sshdr.ascq));
 	}
 #endif
+	sdkp->medium_access_timed_out = 0;
+
 	if (driver_byte(result) != DRIVER_SENSE &&
 	    (!sense_valid || sense_deferred))
 		goto out;
 
-	sdkp->medium_access_timed_out = 0;
-
 	switch (sshdr.sense_key) {
 	case HARDWARE_ERROR:
 	case MEDIUM_ERROR:
