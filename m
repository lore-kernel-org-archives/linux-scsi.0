From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ufs: add UFS power management support
Date: Thu, 2 Oct 2014 18:31:12 +0300
Message-ID: <20141002153112.GB11534@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25393 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbaJBPb0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 11:31:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: subhashj@codeaurora.org
Cc: linux-scsi@vger.kernel.org

Hello Subhash Jadavani,

The patch 57d104c153d3: "ufs: add UFS power management support" from
Sep 25, 2014, leads to the following static checker warning:

	drivers/scsi/ufs/ufshcd.c:4746 ufshcd_link_state_transition()
	warn: we tested 'check_for_bkops' before and it was 'true'

drivers/scsi/ufs/ufshcd.c
  4734          if (req_link_state == UIC_LINK_HIBERN8_STATE) {
  4735                  ret = ufshcd_uic_hibern8_enter(hba);
  4736                  if (!ret)
  4737                          ufshcd_set_link_hibern8(hba);
  4738                  else
  4739                          goto out;
  4740          }
  4741          /*
  4742           * If autobkops is enabled, link can't be turned off because
  4743           * turning off the link would also turn off the device.
  4744           */
  4745          else if ((req_link_state == UIC_LINK_OFF_STATE) &&
  4746                     (!check_for_bkops || (check_for_bkops &&
                                                 ^^^^^^^^^^^^^^^
Not needed.

  4747                      !hba->auto_bkops_enabled))) {
  4748                  /*
  4749                   * Change controller state to "reset state" which
  4750                   * should also put the link in off/reset state
  4751                   */
  4752                  ufshcd_hba_stop(hba);
  4753                  /*
  4754                   * TODO: Check if we need any delay to make sure that
  4755                   * controller is reset
  4756                   */
  4757                  ufshcd_set_link_off(hba);
  4758          }
  4759  
  4760  out:
  4761          return ret;
  4762  }

regards,
dan carpenter
