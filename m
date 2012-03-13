From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: qla2xxx: Enable >= 24xx target-mode support in SCSI LLD
Date: Tue, 13 Mar 2012 20:20:16 +0300
Message-ID: <20120313172016.GC31808@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:47479 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334Ab2CMRU1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Mar 2012 13:20:27 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org

Hello Nicholas,

The patch bb52e091fe63: "qla2xxx: Enable >= 24xx target-mode support 
in SCSI LLD" from Mar 8, 2012, leads to the following Smatch warning:

drivers/scsi/qla2xxx/qla_mbx.c:1458 qla2x00_get_port_database()
	 error: potential null derefence 'pd24'.

drivers/scsi/qla2xxx/qla_mbx.c
  1456  
  1457                  /* If not target must be initiator or unknown type. */
  1458                  if ((pd24->prli_svc_param_word_3[0] & BIT_4))
                             ^^^^^^
  1459                          fcport->port_type = FCT_TARGET;
  1460                  else if ((pd24->prli_svc_param_word_3[0] & BIT_5))
                                  ^^^^^^
These are always NULL here.

  1461                          fcport->port_type = FCT_INITIATOR;
  1462  

regards,
dan carpenter

