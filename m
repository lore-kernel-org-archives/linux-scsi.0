Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,BIGNUM_EMAILS,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D195C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 10:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4922D23F37
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 10:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405773AbgLKKH2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 05:07:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36642 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405753AbgLKKHP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2020 05:07:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BBA033E145285;
        Fri, 11 Dec 2020 10:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Suwa93DbWrz58RR2+bpuE9W2/mMIDQqJWkyjlROTi0k=;
 b=pwZ6PkbRzWUr6nYLUFQyZ8t8ril7eoINejcde6FYKq18xY+A+Yk/a3nL5OxxA7yUW5/3
 LLeTVT3E/gUs5uiAffm9FzZiZb3LeHzfA7JdiWYTCeGLbEtyt+4r3d01ReXDafwF9mcP
 s1RSwaZvb1U/AUj5BVce/h645ies9zVtrQ60QZeIlNWW24WKU/tXMx26CR91/+A8b53y
 eRfSzNAcFTrgHztPsjLbM4dhSa8Gd2SkxvUC4/0oyRDrOv+JU7JxfOZIHeHTRXYpX/hT
 sEk9M/ATbOwoxQpzeMvcFLIxewot1dgA27DNaGN4nTPSfCenAHrjqbrbWHpZxEJuw56F Nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3581mr9uuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Dec 2020 10:06:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BBA0w60152505;
        Fri, 11 Dec 2020 10:06:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 358kst33ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Dec 2020 10:06:28 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BBA6R8u026092;
        Fri, 11 Dec 2020 10:06:27 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Dec 2020 02:06:27 -0800
Date:   Fri, 11 Dec 2020 13:06:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: ufs: Serialize eh_work with system PM events and
 async scan
Message-ID: <X9NEnPx/3fb+K9AE@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9831 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=814 suspectscore=3
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012110061
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9831 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxlogscore=800
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012110061
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Can Guo,

This is a semi-automatic email about new static checker warnings.

The patch 88a92d6ae4fe: "scsi: ufs: Serialize eh_work with system PM
events and async scan" from Dec 2, 2020, leads to the following
Smatch complaint:

    drivers/scsi/ufs/ufshcd.c:8971 ufshcd_system_resume()
    error: we previously assumed 'hba' could be null (see line 8970)

drivers/scsi/ufs/ufshcd.c
  8965  int ufshcd_system_resume(struct ufs_hba *hba)
  8966  {
  8967          int ret = 0;
  8968          ktime_t start = ktime_get();
  8969  
  8970          if (!hba) {
  8971                  up(&hba->eh_sem);

If "hba" is NULL then this will Oops, but I suspect that we could just
remove the check for NULL.

  8972                  return -EINVAL;
  8973          }
  8974  
  8975          if (!hba->is_powered || pm_runtime_suspended(hba->dev))
  8976                  /*
  8977                   * Let the runtime resume take care of resuming
  8978                   * if runtime suspended.
  8979                   */
  8980                  goto out;
  8981          else
  8982                  ret = ufshcd_resume(hba, UFS_SYSTEM_PM);
  8983  out:
  8984          trace_ufshcd_system_resume(dev_name(hba->dev), ret,
  8985                  ktime_to_us(ktime_sub(ktime_get(), start)),
  8986                  hba->curr_dev_pwr_mode, hba->uic_link_state);
  8987          if (!ret)
  8988                  hba->is_sys_suspended = false;
  8989          up(&hba->eh_sem);
  8990          return ret;
  8991  }

regards,
dan carpenter
