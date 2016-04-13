From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: libiscsi: Use scsi helper to set information descriptor
Date: Wed, 13 Apr 2016 16:14:25 +0300
Message-ID: <20160413131425.GA9719@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32106 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760425AbcDMNOi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 09:14:38 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sagig@mellanox.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

Hello Sagi Grimberg,

The patch a73c2a2f9123: "libiscsi: Use scsi helper to set information
descriptor" from Jul 15, 2015, leads to the following static checker
warning:

	drivers/scsi/libiscsi.c:858 iscsi_scsi_cmd_rsp()
	error: XXX uninitialized symbol 'sector'.

drivers/scsi/libiscsi.c
   850                  ascq = session->tt->check_protection(task, &sector);

If "ascq" is 0x1 then there sector might not be initialized.  The
documentation is not clear on how that works.  Har dee har har.  The
oldest jokes are still the best...  :P

   851                  if (ascq) {
   852                          sc->result = DRIVER_SENSE << 24 |
   853                                       SAM_STAT_CHECK_CONDITION;
   854                          scsi_build_sense_buffer(1, sc->sense_buffer,
   855                                                  ILLEGAL_REQUEST, 0x10, ascq);
   856                          scsi_set_sense_information(sc->sense_buffer,
   857                                                     SCSI_SENSE_BUFFERSIZE,
   858                                                     sector);
   859                          goto out;
   860                  }

regards,
dan carpenter
