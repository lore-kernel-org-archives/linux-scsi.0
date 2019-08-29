Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.6 required=3.0 tests=BIGNUM_EMAILS,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE1B9C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 12:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91B042339E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 12:41:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AtN5/++r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfH2MlL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 08:41:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40400 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfH2MlL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2019 08:41:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TCdsJO020598;
        Thu, 29 Aug 2019 12:41:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=qYQJUDqvbjCBd9qzJfrKsLJxoTShyvwgZpsn+07ywtM=;
 b=AtN5/++rBFPnOKDQXeFn4Rpe0nj3WPKzHHQ+SpvIj0ie1fb5NCnZge5/94GFYT3UctWT
 Mwm/m+Kxh8mTMxVT9S0BY+3gnNZsSoQ/NJZ3vBn7HJ8r4t70fLezHcNoee4GpEuU+Xnc
 jVnLUkCQlMApqEI8WivC9GmlafuHk8X5qCAN8q08qQgVWweQMJlLMaTGMaLNrz7lxlDj
 KaJ5FWfgSI0w01Sw5FZ8/QBmwr7wRxmHq5ABx6bafEGqnVwM+mmxBVbe4773hQ48jEXY
 MPjQEKPerigZUQXysTmwcABwp+ZnVDkjSNymPfiMhOrX1My9ZfEduxfnzb1sV8VRyrJx VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2upewc0084-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 12:41:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TCbvtx162692;
        Thu, 29 Aug 2019 12:41:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2upc8un95k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 12:41:07 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TCf72w030253;
        Thu, 29 Aug 2019 12:41:07 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 05:41:06 -0700
Date:   Thu, 29 Aug 2019 15:41:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jsmart2021@gmail.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: lpfc: Adding ability to reset chip via pci bus
 reset
Message-ID: <20190829124100.GB20116@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=972
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290139
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James Smart,

The patch 5021267af132: "scsi: lpfc: Adding ability to reset chip via
pci bus reset" from Dec 13, 2018, leads to the following static
checker warning:

	drivers/scsi/lpfc/lpfc_attr.c:1322 lpfc_reset_pci_bus()
	warn: passing bogus address: '&(phba->pcidev)->dev' val = 176

drivers/scsi/lpfc/lpfc_attr.c
  1309  static int
  1310  lpfc_reset_pci_bus(struct lpfc_hba *phba)
  1311  {
  1312          struct pci_dev *pdev = phba->pcidev;
                                ^^^^^^^^^^^^^^^^^^^
pdev and phba->pcidev are the same.

  1313          struct Scsi_Host *shost = NULL;
  1314          struct lpfc_hba *phba_other = NULL;
  1315          struct pci_dev *ptr = NULL;
  1316          int res;
  1317  
  1318          if (phba->cfg_enable_hba_reset != 2)
  1319                  return -ENOTSUPP;
  1320  
  1321          if (!pdev) {
                    ^^^^^
They are both NULL.

  1322                  lpfc_printf_log(phba, KERN_INFO, LOG_INIT, "8345 pdev NULL!\n");

This passes "&(phba->pcidev)->dev" which is "(void *)176" to __dev_printk()
which dereferences it.  Can it really be NULL?

  1323                  return -ENODEV;
  1324          }
  1325  
  1326          res = lpfc_check_pci_resettable(phba);
  1327          if (res)
  1328                  return res;

regards,
dan carpenter
