From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: status of patch to fix memory leak in scan_scsis_single
Date: Thu, 9 Oct 2003 18:25:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031009222559.GB15493@ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gn78-101.ma.emulex.com ([138.239.78.101]:60820 "EHLO
	wintermute.ma.emulex.com") by vger.kernel.org with ESMTP
	id S261872AbTJIW0A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Oct 2003 18:26:00 -0400
Received: from wintermute.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by wintermute.ma.emulex.com (8.12.8/8.12.8) with ESMTP id h99MPxZP023436
	for <linux-scsi@vger.kernel.org>; Thu, 9 Oct 2003 18:25:59 -0400
Received: (from jamesw@localhost)
	by wintermute.ma.emulex.com (8.12.8/8.12.8/Submit) id h99MPxbS023434
	for linux-scsi@vger.kernel.org; Thu, 9 Oct 2003 18:25:59 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

There appears to be a memory leak in the scan_scsis_single function in
2.4.23pre6: the scsi_release_commandblocks function is not called in a
couple of cases where scan_scsis_single returns early.  (This memory
was allocated by scsi_build_commandblocks.)

I found this patch:

--- scsi_scan.c 2003-01-17 11:53:07.000000000 -0700
+++ scsi_scan.c.mine    2003-01-17 11:53:03.000000000 -0700
@@ -596,6 +596,7 @@
                } else {
                        /* assume no peripheral if any other sort of error */
                        scsi_release_request(SRpnt);
+                       scsi_release_commandblocks(SDpnt);
                        return 0;
                }
        }
@@ -619,6 +620,7 @@
         */
        if ((scsi_result[0] >> 5) == 3) {
                scsi_release_request(SRpnt);
+               scsi_release_commandblocks(SDpnt);
                return 0;       /* assume no peripheral if any sort of error */
        }
         /*   The Toshiba ROM was "gender-changed" here as an inline hack.

(full message here:
http://marc.theaimsgroup.com/?l=linux-scsi&m=104282995014242&w=2
)

... posted to linux-scsi back in January, but this change doesn't
appear to be in 2.4.23pre6.  (The first block does seem to have been
applied to Red Hat's recent kernels.)

Is there something wrong with this patch or is it pending for
2.4.twentysomething?

Thanks,
Jamie Wellnitz
Jamie.Wellnitz@emulex.com
