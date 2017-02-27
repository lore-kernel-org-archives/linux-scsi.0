From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: aacraid: Reorder Adapter status check
Date: Mon, 27 Feb 2017 18:31:31 +0300
Message-ID: <20170227153131.GA24809@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18457 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751643AbdB0Pdf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 10:33:35 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: RaghavaAditya.Renukunta@microsemi.com
Cc: linux-scsi@vger.kernel.org

Hello Raghava Aditya Renukunta,

The patch c421530bf848: "scsi: aacraid: Reorder Adapter status check"
from Feb 16, 2017, leads to the following static checker warning:

	drivers/scsi/aacraid/src.c:471 aac_src_check_health()
	warn: was shift intended here '(status > 16)'

drivers/scsi/aacraid/src.c
   464           */
   465          return 0;
   466  
   467  err_out:
   468          return -1;
   469  
   470  err_blink:
   471          return (status > 16) & 0xFF;
                        ^^^^^^^^^^^^^^^^^^^
Issue #1:  This is obviously a typo.

   472  }

Issue #2:  The caller checks for if the return is greater than 2.  It
           never is.  We can remove this dead code.

Issue #3:  The caller passes "bled" to aac_send_iop_reset() which
           ignores it.  What's up with that?  Either it's a bug or we
           should delete that dead code.

regards,
dan carpenter
