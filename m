From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] ses: Fix problems with simple enclosures
Date: Fri, 13 Jan 2017 00:18:36 +0300
Message-ID: <20170112211836.GA5459@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43597 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbdALVSt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2017 16:18:49 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

Hello James Bottomley,

The patch 3417c1b5cb1f: "ses: Fix problems with simple enclosures"
from Dec 8, 2015, leads to the following static checker warning:

	drivers/scsi/ses.c:103 ses_recv_diag()
	info: return a literal instead of 'ret'

drivers/scsi/ses.c
    86  static int ses_recv_diag(struct scsi_device *sdev, int page_code,
    87                           void *buf, int bufflen)
    88  {
    89          int ret;
    90          unsigned char cmd[] = {
    91                  RECEIVE_DIAGNOSTIC,
    92                  1,              /* Set PCV bit */
    93                  page_code,
    94                  bufflen >> 8,
    95                  bufflen & 0xff,
    96                  0
    97          };
    98          unsigned char recv_page_code;
    99  
   100          ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
   101                                  NULL, SES_TIMEOUT, SES_RETRIES, NULL);
   102          if (unlikely(!ret))
   103                  return ret;

This code works, but why is it unlikely() that scsi_execute_req() will
succeed?

   104  
   105          recv_page_code = ((unsigned char *)buf)[0];
   106  
   107          if (likely(recv_page_code == page_code))
   108                  return ret;
   109  
   110          /* successful diagnostic but wrong page code.  This happens to some
   111           * USB devices, just print a message and pretend there was an error */
   112  
   113          sdev_printk(KERN_ERR, sdev,
   114                      "Wrong diagnostic page; asked for %d got %u\n",
   115                      page_code, recv_page_code);
   116  
   117          return -EINVAL;

We sort of mixing a bunch of different types of error codes here aren't
we?  Shouldn't this be "return DRIVER_ERROR << 24;" like how
scsi_execute_req() does it?  I don't think the callers care.

   118  }

regards,
dan carpenter
