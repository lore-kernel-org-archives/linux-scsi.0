From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID
 Adapter Driver
Date: Thu, 29 Aug 2013 11:46:04 +0300
Message-ID: <20130829084604.GD14334@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29804 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab3H2IqO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2013 04:46:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bgrove@attotech.com
Cc: linux-scsi@vger.kernel.org

Hello Bradley Grove,

The patch 17adeb6dabbe: "[SCSI] esas2r: ATTO Technology ExpressSAS 6G
SAS/SATA RAID Adapter Driver" from Aug 23, 2013, leads to the
following Smatch warning:
"drivers/scsi/esas2r/esas2r_vda.c:312 esas2r_complete_vda_ioctl()
	 error: format string overflow. buf_size: 4 length: 5"

drivers/scsi/esas2r/esas2r_vda.c
   312                          sprintf((char *)&cfg->data.init.fw_release,
                                                 ^^^^^^^^^^^^^^^^^^^^^^^^^
This is a u32 but we are writing 4 characters and a NUL so it ends up
putting the NUL in cfg->data.init.epoch_time.

   313                                  "%1d.%02d",
   314                                  (int)LOBYTE(le16_to_cpu(rsp->fw_release)),
   315                                  (int)HIBYTE(le16_to_cpu(rsp->fw_release)));

regards,
dan carpenter

