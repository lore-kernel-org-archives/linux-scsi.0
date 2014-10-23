From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: RE: ufs: add UFS power management support
Date: Thu, 23 Oct 2014 10:28:52 +0300
Message-ID: <009c01cfee93$00a96b60$01fc4220$@codeaurora.org>
References: <20141002153112.GB11534@mwanda>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38532 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaJWH24 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2014 03:28:56 -0400
In-Reply-To: <20141002153112.GB11534@mwanda>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Carpenter' <dan.carpenter@oracle.com>, subhashj@codeaurora.org
Cc: linux-scsi@vger.kernel.org

Hi Dan,
This seem like a false alarm, please let me know if it requires a fix.

Thanks,
Dolev
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, 
a Linux Foundation Collaborative Project 

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Thursday, October 02, 2014 6:31 PM
To: subhashj@codeaurora.org
Cc: linux-scsi@vger.kernel.org
Subject: re: ufs: add UFS power management support

Hello Subhash Jadavani,

The patch 57d104c153d3: "ufs: add UFS power management support" from Sep 25,
2014, leads to the following static checker warning:

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
                                                 ^^^^^^^^^^^^^^^ Not needed.

  4747                      !hba->auto_bkops_enabled))) {
  4748                  /*
  4749                   * Change controller state to "reset state" which
  4750                   * should also put the link in off/reset state
  4751                   */
  4752                  ufshcd_hba_stop(hba);
  4753                  /*
  4754                   * TODO: Check if we need any delay to make sure
that
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

