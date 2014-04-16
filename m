From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] csiostor: Chelsio FCoE offload driver
Date: Wed, 16 Apr 2014 18:33:24 +0300
Message-ID: <20140416153324.GA16325@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36095 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319AbaDPPd0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Apr 2014 11:33:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: naresh@chelsio.com
Cc: linux-scsi@vger.kernel.org

Hello Naresh Kumar Inna,

The patch a3667aaed569: "[SCSI] csiostor: Chelsio FCoE offload
driver" from Nov 15, 2012, leads to the following static checker
warning:

	drivers/scsi/csiostor/csio_mb.c:1534 csio_mb_isr_handler()
	warn: was 'sizeof(*mbp)' intended?

drivers/scsi/csiostor/csio_mb.c
  1451  int
  1452  csio_mb_isr_handler(struct csio_hw *hw)
  1453  {
  1454          struct csio_mbm         *mbm = &hw->mbm;
                                         ^^^
This struct is fairly large.

  1455          struct csio_mb          *mbp =  mbm->mcurrent;
  1456          __be64                  *cmd;
  1457          uint32_t                ctl, cim_cause, pl_cause;
  1458          int                     i;
  1459          uint32_t                ctl_reg = PF_REG(hw->pfn, CIM_PF_MAILBOX_CTRL);

[ snip ]

  1530                  /*
  1531                   * Enqueue event to EventQ. Events processing happens
  1532                   * in Event worker thread context
  1533                   */
  1534                  if (csio_enqueue_evt(hw, CSIO_EVT_MBX, mbp, sizeof(mbp)))
                                                                    ^^^^^^^^^^
This is equivalent to sizeof(long) when sizeof(*mbp) was probably
intended.

  1535                          CSIO_INC_STATS(hw, n_evt_drop);
  1536  

regards,
dan carpenter
