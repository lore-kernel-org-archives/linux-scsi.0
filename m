Return-Path: <SRS0=ULGd=EP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC15C4741F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 09:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE2BD2083B
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 09:57:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Pjy86Bce"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgKIJ5S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 04:57:18 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36942 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbgKIJ5R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 04:57:17 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A99rm3a168608;
        Mon, 9 Nov 2020 09:57:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=EgR8M57jdF5W6v/LtWZUIPEB0wXu/qEKkaNkJ31iix0=;
 b=Pjy86BceYnOzvN/Zk9owat4C9QapONtcjMroOzrHN5U+wIuBvqcwJYuhGCHLYbjnejJJ
 zoxi++c7n2LdciTYbLKUAVTZPPZTtN7xyX3ingy6EcU5mcOCC6rP4zfRyywVOkbmexsL
 5UNrC65yvZiDwBhMpEoEojCKAHY7spCI1uE4T4ZeiiftDhDD9iPvlsgHlYmaYGeUX00K
 fDIzV6sS48DgNRSn6EqIAMRtn9sKB60dGoprreRwde5iQ7lXXIkI++E7znmypKuffs6M
 rPUoByP7P9is6pEvcbSaIJ1iUguBIx9OSkX7iPlYydXLOkrerWOGKCZy7sQPt13MuJIR 2Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34nh3ana3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 09 Nov 2020 09:57:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A99u3Wl077835;
        Mon, 9 Nov 2020 09:57:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34p5gv29qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Nov 2020 09:57:13 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A99vDNV013495;
        Mon, 9 Nov 2020 09:57:13 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 01:57:12 -0800
Date:   Mon, 9 Nov 2020 12:57:07 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: ufs: Try to save power mode change and UIC cmd
 completion timeout
Message-ID: <20201109095707.GA2453397@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9799 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090063
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9799 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1011 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=3
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090063
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Can Guo,

This is a semi-automatic email about new static checker warnings.

The patch 0f52fcb99ea2: "scsi: ufs: Try to save power mode change and
UIC cmd completion timeout" from Nov 2, 2020, leads to the following
Smatch complaint:

    drivers/scsi/ufs/ufshcd.c:4941 ufshcd_uic_cmd_compl()
    error: we previously assumed 'hba->active_uic_cmd' could be null (see line 4929)

drivers/scsi/ufs/ufshcd.c
  4928	
  4929		if ((intr_status & UIC_COMMAND_COMPL) && hba->active_uic_cmd) {
                                                         ^^^^^^^^^^^^^^^^^^^
Here is the NULL check

  4930			hba->active_uic_cmd->argument2 |=
  4931				ufshcd_get_uic_cmd_result(hba);
  4932			hba->active_uic_cmd->argument3 =
  4933				ufshcd_get_dme_attr_val(hba);
  4934			if (!hba->uic_async_done)
  4935				hba->active_uic_cmd->cmd_active = 0;
  4936			complete(&hba->active_uic_cmd->done);
  4937			retval = IRQ_HANDLED;
  4938		}
  4939	
  4940		if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done) {
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Smatch isn't clever enough to tie this to "hba->active_uic_cmd" and I
looked at it briefly and wasn't able to right away either.

  4941			hba->active_uic_cmd->cmd_active = 0;
                        ^^^^^^^^^^^^^^^^^^^^^
Unchecked NULL dereference.

  4942			complete(hba->uic_async_done);
  4943			retval = IRQ_HANDLED;

regards,
dan carpenter
