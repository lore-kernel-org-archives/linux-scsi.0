From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [bug report] scsi: ufs-qcom: dump additional testbus registers
Date: Thu, 16 Feb 2017 10:08:47 -0800
Message-ID: <af7910bc1169286ecaa8638136bb6628@codeaurora.org>
References: <20170214075859.GA2550@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34422 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932552AbdBPSIt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2017 13:08:49 -0500
In-Reply-To: <20170214075859.GA2550@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: venkatg@codeaurora.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2017-02-13 23:58, Dan Carpenter wrote:
> Hello Venkat Gopalakrishnan,
> 
> The patch 9c46b8676271: "scsi: ufs-qcom: dump additional testbus
> registers" from Feb 3, 2017, leads to the following static checker
> warning:
> 
> 	drivers/scsi/ufs/ufs-qcom.c:1531 ufs_qcom_testbus_cfg_is_ok()
> 	warn: impossible condition '(host->testbus.select_minor > 255) =>
> (0-255 > 255)'
> 
> drivers/scsi/ufs/ufs-qcom.c
>   1517  static bool ufs_qcom_testbus_cfg_is_ok(struct ufs_qcom_host 
> *host)
>   1518  {
>   1519          if (host->testbus.select_major >= TSTBUS_MAX) {
>   1520                  dev_err(host->hba->dev,
>   1521                          "%s: UFS_CFG1[TEST_BUS_SEL} may not
> equal 0x%05X\n",
>   1522                          __func__, host->testbus.select_major);
>   1523                  return false;
>   1524          }
>   1525
>   1526          /*
>   1527           * Not performing check for each individual 
> select_major
>   1528           * mappings of select_minor, since there is no harm in
>   1529           * configuring a non-existent select_minor
>   1530           */
>   1531          if (host->testbus.select_minor > 0xFF) {
>                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> It might make sense to keep this check.  I don't know.  But it's
> confusing that 0xFF is a magic number.  Better to make it a define.

Yes, i agree, this check is redundant. I will post a fix to remove this.

> 
>   1532                  dev_err(host->hba->dev,
>   1533                          "%s: 0x%05X is not a legal testbus 
> option\n",
>   1534                          __func__, host->testbus.select_minor);
>   1535                  return false;
>   1536          }
>   1537
>   1538          return true;
>   1539  }
> 
> regards,
> dan carpenter

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
