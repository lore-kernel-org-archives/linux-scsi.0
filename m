Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B42C19425
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5EBC23A5A
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbgLIRZz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:25:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:32820 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732488AbgLIRY6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 12:24:58 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HJfGi111633;
        Wed, 9 Dec 2020 17:24:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2l7htSo6MD1dOx5sHS9E/jqRgPMmrfiFHkATVuhk0/M=;
 b=b0jd0zuBjH8IHgFXbldhSWbEBqer47d/ezG2OCaeOZPNaUQpYjuSPkQozSB8dDFvhWxn
 Rd6lAWAnLmrbUuesyaoyWPf8miHKJWE2ETylKCRitcq8mtw7i4r6p//m9hJJjaTX+ZGq
 wTXftEyNNS5CPPVMFSKxi+CZnl1cGAA8S97imezh7qnEbRzSGY7q63n+/7owtvrAnDgz
 JccWunlVLg1wMJdBVNYdejOx4bJFv9I46eIMBXaLYub5yx4B5vFuuKkcbIKGG4uzv3MI
 UMARLVDCpaRHVqDmcnWLMYkR1kD6IqwUz5lCnQfdBrIOuTgJbgslrN16iZAq6UP8IUUL cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35825m9cw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 17:24:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HKY7T186037;
        Wed, 9 Dec 2020 17:24:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 358m40juqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 17:24:09 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B9HO8is014474;
        Wed, 9 Dec 2020 17:24:08 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 09:24:08 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Zhang Qilong <zhangqilong3@huawei.com>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: pm80xx: Fix error return in pm8001_pci_probe
Date:   Wed,  9 Dec 2020 12:23:27 -0500
Message-Id: <160753457753.14816.2017756599021747206.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201205115551.2079471-1-zhangqilong3@huawei.com>
References: <20201205115551.2079471-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 5 Dec 2020 19:55:51 +0800, Zhang Qilong wrote:

> Forget to set error code when pm8001_configure_phy_settings
> failed. We fixed it by using rc to store return value of
> pm8001_configure_phy_settings.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: pm80xx: Fix error return in pm8001_pci_probe
      https://git.kernel.org/mkp/scsi/c/97031ccffa4f

-- 
Martin K. Petersen	Oracle Linux Engineering
