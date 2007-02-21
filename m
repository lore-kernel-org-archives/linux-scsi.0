From: Greg KH <greg@kroah.com>
Subject: [patch 04/18] SCSI: add missing cdb clearing in scsi_execute()
Date: Tue, 20 Feb 2007 17:50:00 -0800
Message-ID: <20070221015000.GE3684@kroah.com>
References: <20070221014413.282048309@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964781AbXBUBv4@vger.kernel.org>
Content-Disposition: inline; filename="scsi-add-missing-cdb-clearing-in-scsi_execute.patch"
In-Reply-To: <20070221014927.GA3684@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, jens.axboe@oracle.com, dougg@torque.net, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, Tejun Heo <htejun@gmail.com>, Chris Wright <chrisw@sous-sol.org>
List-Id: linux-scsi@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tejun Heo <htejun@gmail.com>

Clear-garbage-after-CDB patch missed scsi_execute() and it causes some
ODDs (HL-DT-ST DVD-RAM GSA-H30N) choke during SCSI scan.  Note that
this patch is only for -stable.  There is another more reliable fix
for this problem proposed for devel tree.

http://thread.gmane.org/gmane.linux.ide/14605/focus=14605

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Douglas Gilbert <dougg@torque.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_lib.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.18.7.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6.18.7/drivers/scsi/scsi_lib.c
@@ -191,6 +191,7 @@ int scsi_execute(struct scsi_device *sde
 		goto out;
 
 	req->cmd_len = COMMAND_SIZE(cmd[0]);
+	memset(req->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
 	memcpy(req->cmd, cmd, req->cmd_len);
 	req->sense = sense;
 	req->sense_len = 0;

--
