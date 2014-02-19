From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] mpt fusion: Add support for ATTO 4LD: Rebranded LSI
 53C1030
Date: Wed, 19 Feb 2014 12:53:55 +0300
Message-ID: <20140219095355.GB22351@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17616 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaBSJyC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Feb 2014 04:54:02 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: eric.moore@lsi.com
Cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org

Hello Eric Moore,

The patch 232f08fc82b1: "[SCSI] mpt fusion: Add support for ATTO 4LD:
Rebranded LSI 53C1030" from Aug 14, 2007, leads to the following
static checker warning:

	drivers/message/fusion/mptbase.c:5527 mpt_GetScsiPortSettings()
	warn: was hexadecimal intended '10'

drivers/message/fusion/mptbase.c
  5522                                    if (ATTOFlags & ATTOFLAG_TAGGED)
  5523                                      data |= (MPI_SCSIPORTPAGE2_DEVICE_TAG_QUEUE_ENABLE);
  5524                                    if (!(ATTOFlags & ATTOFLAG_WIDE_ENB))
  5525                                      data |= (MPI_SCSIPORTPAGE2_DEVICE_WIDE_DISABLE);
                                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
MPI_SCSIPORTPAGE2_DEVICE_WIDE_DISABLE is 0x10.

  5526  
  5527                                    data = (data << 16) | (pdevice->Period << 8) | 10;
                                                                                         ^^

"data" is is a bit field except for the last "10" here.  Maybe it should
be 0x10 instead of 10.  But then we already set 0x10 on the line before
so this code is not clear.

  5528                                    ioc->spi_data.nvram[ii] = data;
  5529                                  }

regards,
dan carpenter
