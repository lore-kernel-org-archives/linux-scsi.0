From: Satyam Sharma <satyam@infradead.org>
Subject: [PATCH -mm] IPS SCSI driver: Check return of scsi_add_host()
Date: Mon, 3 Sep 2007 01:43:49 +0530 (IST)
Message-ID: <alpine.LFD.0.999.0709030142490.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i
 n>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-941044704-1188764032=:29617"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753758AbXIBUBN@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: James Bottomley <james.bottomley@steeleye.com>, aacraid@adaptec.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-941044704-1188764032=:29617
Content-Type: TEXT/PLAIN; charset=iso-2022-jp


drivers/scsi/ips.c: In function ‘ips_register_scsi’:
drivers/scsi/ips.c:6869:
warning: ignoring return value of ‘scsi_add_host’, declared with attribute warn_unused_result

scsi_add_host() is __must_check, so let's check it's return and cleanup
appropriately on errors.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 drivers/scsi/ips.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc4-mm1/drivers/scsi/ips.c~fix	2007-09-02 20:21:27.000000000 +0530
+++ linux-2.6.23-rc4-mm1/drivers/scsi/ips.c	2007-09-02 20:25:58.000000000 +0530
@@ -6866,7 +6866,12 @@ ips_register_scsi(int index)
 	sh->max_channel = ha->nbus - 1;
 	sh->can_queue = ha->max_cmds - 1;
 
-	scsi_add_host(sh, NULL);
+	if (scsi_add_host(sh, NULL)) {
+		IPS_PRINTK(KERN_WARNING, ha->pcidev, "Unable to add SCSI host\n");
+		free_irq(ha->irq, ha);
+		scsi_host_put(sh);
+		return -1;
+	}
 	scsi_scan_host(sh);
 
 	return 0;
--464262402-941044704-1188764032=:29617--
