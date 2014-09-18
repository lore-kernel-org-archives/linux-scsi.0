From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID
 Adapter Driver
Date: Thu, 18 Sep 2014 17:23:09 +0300
Message-ID: <20140918142309.GA20848@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41547 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776AbaIROY2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Sep 2014 10:24:28 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bgrove@attotech.com
Cc: linux-scsi@vger.kernel.org

Hello Bradley Grove,

The patch 26780d9e12ed: "[SCSI] esas2r: ATTO Technology ExpressSAS 6G
SAS/SATA RAID Adapter Driver" from Aug 23, 2013, leads to the
following static checker warning:

	drivers/scsi/esas2r/esas2r_ioctl.c:1902 esas2r_read_vda()
	error: 'count' from user is not capped properly

drivers/scsi/esas2r/esas2r_ioctl.c
  1892  
  1893          if (off > VDA_MAX_BUFFER_SIZE)
  1894                  return 0;
  1895  
  1896          if (count + off > VDA_MAX_BUFFER_SIZE)
                    ^^^^^
"count" is a user controlled int.  Let's assume we're on a 32 system for
simplicity.  If count is a high positive number here, then count + off
is negative and thus less than VDA_MAX_BUFFER_SIZE.

  1897                  count = VDA_MAX_BUFFER_SIZE - off;
  1898  
  1899          if (count < 0)
  1900                  return 0;
  1901  
  1902          memcpy(buf, a->vda_buffer + off, count);
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Memory corruption.

  1903  
  1904          return count;
  1905  }

"count" comes from the ioctl.  Let's look at that:

drivers/scsi/esas2r/esas2r_ioctl.c
  1476          case EXPRESS_IOCTL_VDA:
  1477                  err = esas2r_write_vda(a,
  1478                                         (char *)&ioctl->data.ioctl_vda,
  1479                                         0,
  1480                                         sizeof(struct atto_ioctl_vda) +
  1481                                         ioctl->data.ioctl_vda.data_length);
                                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  1482  
  1483                  if (err >= 0) {
  1484                          err = esas2r_read_vda(a,
  1485                                                (char *)&ioctl->data.ioctl_vda,
  1486                                                0,
  1487                                                sizeof(struct atto_ioctl_vda) +
  1488                                                ioctl->data.ioctl_vda.data_length);
                                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
These additions have integer overflow bugs.  It seems harmless to me,
but hopefully static checkers will eventually start complaining about
them.

  1489                  }
  1490  
  1491  
  1492  
  1493  
  1494                  break;

regards,
dan carpenter
