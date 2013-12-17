From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] bfa: Firmware patch simplification
Date: Tue, 17 Dec 2013 17:57:15 +0300
Message-ID: <20131217145715.GA32365@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46711 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab3LQO53 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2013 09:57:29 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vmohan@brocade.com
Cc: linux-scsi@vger.kernel.org

Hello Vijaya Mohan Guvva,

The patch 4e88a72d1574: "[SCSI] bfa: Firmware patch simplification"
from Nov 21, 2013, leads to the following Smatch warning:
	drivers/scsi/bfa/bfa_ioc.c:6859 bfa_flash_status_read()
	warn: unsigned 'status' is never less than zero.

drivers/scsi/bfa/bfa_ioc.c
  6851  bfa_flash_status_read(void __iomem *pci_bar)
  6852  {
  6853          union bfa_flash_dev_status_reg_u        dev_status;
  6854          u32                             status;
  6855          u32                     ret_status;
  6856          int                             i;
  6857  
  6858          status = bfa_flash_fifo_flush(pci_bar);
  6859          if (status < 0)
                    ^^^^^^^^^^
"status" is unsigned.

  6860                  return status;

There are some other Smatch warnings as well:

drivers/scsi/bfa/bfa_ioc.c:3882 bfa_sfp_show_comp() error: memcpy() 'des' too small (64 vs 248)

This is not a real bug, it's just an over-sight.  The code uses:
	u8 *des = (u8 *) &(sfp->sfpmem->srlid_base);
but the intent was:
	void *dest = &sfp->sfpmem;

The two assignments are equivalent in terms of pointer math, but we are
refering to the whole struct and not the first member.

The other warnings are real:

drivers/scsi/bfa/bfa_ioc.c:6859 bfa_flash_status_read() warn: unsigned 'status' is never less than zero.
drivers/scsi/bfa/bfa_ioc.c:6881 bfa_flash_status_read() warn: unsigned 'status' is never less than zero.
drivers/scsi/bfa/bfa_ioc.c:6917 bfa_flash_read_start() warn: unsigned 'status' is never less than zero.
drivers/scsi/bfa/bfa_ioc.c:7043 bfa_flash_raw_read() warn: unsigned 'status' is never less than zero.

regards,
dan carpenter

