From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: sg: fix SG_DXFER_FROM_DEV transfers
Date: Fri, 14 Jul 2017 10:46:03 +0300
Message-ID: <20170714074603.7mi6jshrz6zfru4b@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32188 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbdGNHqP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2017 03:46:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jthumshirn@suse.de
Cc: linux-scsi@vger.kernel.org

Hello Johannes Thumshirn,

The patch 68c59fcea1f2: "scsi: sg: fix SG_DXFER_FROM_DEV transfers"
from Jul 7, 2017, leads to the following static checker warning:

	drivers/scsi/sg.c:762 sg_is_valid_dxfer()
	warn: unsigned 'hp->dxfer_len' is never less than zero.

drivers/scsi/sg.c
   754  static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
   755  {
   756          switch (hp->dxfer_direction) {
   757          case SG_DXFER_NONE:
   758                  if (hp->dxferp || hp->dxfer_len > 0)
   759                          return false;
   760                  return true;
   761          case SG_DXFER_FROM_DEV:
   762                  if (hp->dxfer_len < 0)
                            ^^^^^^^^^^^^^^^^^
Not possible.

   763                          return false;
   764                  return true;
   765          case SG_DXFER_TO_DEV:
   766          case SG_DXFER_TO_FROM_DEV:
   767                  if (!hp->dxferp || hp->dxfer_len == 0)
   768                          return false;
   769                  return true;
   770          case SG_DXFER_UNKNOWN:
   771                  if ((!hp->dxferp && hp->dxfer_len) ||
   772                      (hp->dxferp && hp->dxfer_len == 0))
   773                          return false;
   774                  return true;
   775          default:
   776                  return false;
   777          }
   778  }

Btw, I was looking up the type of hp->dxfer_len and I noticed that the
documentation for hp->resid is wrong.  It says:

	int resid;                  /* [o] dxfer_len - actual_transferred */

My guess is that resid stands for Response ID but I'm not positive.

regards,
dan carpenter
