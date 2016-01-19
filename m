From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ncr5380: Implement new eh_bus_reset_handler
Date: Tue, 19 Jan 2016 12:31:40 +0300
Message-ID: <20160119093140.GA22738@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:48966 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933721AbcATE0Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2016 23:26:16 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
	by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u0J9VoUm017602
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 19 Jan 2016 09:32:50 GMT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fthain@telegraphics.com.au
Cc: linux-scsi@vger.kernel.org

Hello Finn Thain,

The patch 62717f537e1b: "ncr5380: Implement new eh_bus_reset_handler"
from Jan 3, 2016, leads to the following static checker warning:

	drivers/scsi/NCR5380.c:2476 NCR5380_bus_reset()
	error: potential NULL dereference 'hostdata->connected'.

drivers/scsi/NCR5380.c
  2468  
  2469          if (hostdata->connected) {
                    ^^^^^^^^^^^^^^^^^^^
  2470                  set_host_byte(hostdata->connected, DID_RESET);
  2471                  complete_cmd(instance, hostdata->connected);
  2472                  hostdata->connected = NULL;
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^
->connected is NULL because it either starts as NULL or we set it to
NULL.

  2473          }
  2474  
  2475          if (hostdata->sensing) {
  2476                  set_host_byte(hostdata->connected, DID_RESET);
                                      ^^^^^^^^^^^^^^^^^^^
It leads to a NULL dereference here.

  2477                  complete_cmd(instance, hostdata->sensing);
  2478                  hostdata->sensing = NULL;
  2479          }
  2480  
  2481          for (i = 0; i < 8; ++i)
  2482                  hostdata->busy[i] = 0;

regards,
dan carpenter
