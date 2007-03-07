From: Greg KH <gregkh@suse.de>
Subject: [patch 096/101] bug in gdth.c crashing machine
Date: Wed, 07 Mar 2007 09:12:11 -0800
Message-ID: <20070307171654.144647936@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965608AbXCGRXK@vger.kernel.org>
Content-Disposition: inline; filename=bug-in-gdth.c-crashing-machine.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, James.Bottomley@steeleye.com
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, Achim_Leubner@adaptec.com, joerg@dorchain.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


From: Joerg Dorchain <joerg@dorchain.net>

Undocumented...

Signed-off-by: Joerg Dorchain <joerg@dorchain.net>
Acked-by: Achim Leubner <Achim_Leubner@adaptec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/gdth.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.20.1.orig/drivers/scsi/gdth.c
+++ linux-2.6.20.1/drivers/scsi/gdth.c
@@ -3092,6 +3092,7 @@ static int gdth_fill_raw_cmd(int hanum,S
             cmdp->u.raw64.direction  = 
                 gdth_direction_tab[scp->cmnd[0]]==DOU ? GDTH_DATA_OUT:GDTH_DATA_IN;
             memcpy(cmdp->u.raw64.cmd,scp->cmnd,16);
+            cmdp->u.raw64.sg_ranz    = 0;
         } else {
             cmdp->u.raw.reserved   = 0;
             cmdp->u.raw.mdisc_time = 0;
@@ -3108,6 +3109,7 @@ static int gdth_fill_raw_cmd(int hanum,S
             cmdp->u.raw.direction  = 
                 gdth_direction_tab[scp->cmnd[0]]==DOU ? GDTH_DATA_OUT:GDTH_DATA_IN;
             memcpy(cmdp->u.raw.cmd,scp->cmnd,12);
+            cmdp->u.raw.sg_ranz    = 0;
         }
 
         if (scp->use_sg) {

--
