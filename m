From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: aha1542: Stop using scsi_module.c
Date: Wed, 4 May 2016 08:55:42 +0300
Message-ID: <20160504055542.GA19150@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28563 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbcEDFz4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2016 01:55:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux@rainbow-software.org
Cc: linux-scsi@vger.kernel.org

Hello Ondrej Zary,

The patch 643a7c43f11e: "aha1542: Stop using scsi_module.c" from Feb
6, 2015, leads to the following static checker warning:

	drivers/scsi/aha1542.c:703 aha1542_hw_init()
	error: buffer overflow 'io' 4 <= 4

drivers/scsi/aha1542.c
   995  static int aha1542_pnp_probe(struct pnp_dev *pdev, const struct pnp_device_id *id)
   996  {
   997          int indx;
   998          struct Scsi_Host *sh;
   999  
  1000          for (indx = 0; indx < ARRAY_SIZE(io); indx++) {
                               ^^^^^^^^^^^^^^^^^^^^^
Let's assume we exit the loop with indx == ARRAY_SIZE(io).  Actually,
that's the only way we can exit the loop.


  1001                  if (io[indx])
  1002                          continue;
  1003  
  1004                  if (pnp_activate_dev(pdev) < 0)
  1005                          continue;
  1006  
  1007                  io[indx] = pnp_port_start(pdev, 0);
  1008  
  1009                  /* The card can be queried for its DMA, we have
  1010                     the DMA set up that is enough */
  1011  
  1012                  dev_info(&pdev->dev, "ISAPnP found an AHA1535 at I/O 0x%03X", io[indx]);
  1013          }
  1014  
  1015          sh = aha1542_hw_init(&driver_template, &pdev->dev, indx);
                                                                   ^^^^
Then this is beyond the end of the array.  I'm not sure what was
intended.

  1016          if (!sh)
  1017                  return -ENODEV;
  1018  
  1019          pnp_set_drvdata(pdev, sh);
  1020          return 0;
  1021  }

regards,
dan carpenter
