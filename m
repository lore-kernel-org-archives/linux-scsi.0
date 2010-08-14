From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Removing LUNs that no longer exist when scst_scan.c::scsi_report_lun_scan
 runs
Date: Sat, 14 Aug 2010 15:07:46 -0700
Message-ID: <AANLkTi=xLzvUmiJsAc5te5=uyED32297shirNPHQZVyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34750 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab0HNWHt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Aug 2010 18:07:49 -0400
Received: by gxk23 with SMTP id 23so1515482gxk.19
        for <linux-scsi@vger.kernel.org>; Sat, 14 Aug 2010 15:07:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I recently added AEN support to scst_local so that newly add LUNs on a
target, or LUNs that are deleted are dealt with. In a work function I
call scsi_scan_target with the LUN set to SCAN_WILD_CARD. This works
well when LUNs are added (the new LUNs are found and installed in the
kernel), but does not work when LUNs are deleted. The LUNs are not
removed from the kernel.

Perhaps I am doing it the wrong way, and if so can someone tell me the
correct way.

However, in looking at scsi_report_lun_scan it seemed that after it
finishes scanning the LUNs found in the REPORT_LUNS response, it
should remove any LUNs the still exist beyond the last LUN that was
reported in the REPORT_LUNS response. The following patch is an
attempt to do this, and while it seems to work (in the limited testing
I have done), it still has problems:

1. It does not remove LUN 0, even if LUN 0 no longer exists, although
perhaps that is OK.
2. It should probably do the same when there are gaps in the LUNs
reported. Eg, if LUNs 0, 1, 5 are reported, we should probably check
to see of 2,3 and 4 no longer exist and delete them.

Does this sound reasonable?

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1c027a9..a39b7aa 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1488,6 +1488,23 @@ static int scsi_report_lun_scan(struct scsi_target *starg
                }
        }

+       /*
+        * Remove any device that no longer exist. Does not work for LUN 0 :-(
+        */
+       if (lun < shost->max_lun) {
+               int i = 0;
+               struct scsi_device *sdev;
+               for (i = lun + 1; i < shost->max_lun; i++) {
+                       sdev = scsi_device_lookup_by_target(starget, i);
+                       if (sdev) {
+                               scsi_device_put(sdev);
+                               __scsi_remove_device(sdev);
+                               SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
+                                       "Removed LUN %d\n", i));
+                       }
+               }
+       }
+
  out_err:
        kfree(lun_data);
  out:


-- 
Regards,
Richard Sharpe
