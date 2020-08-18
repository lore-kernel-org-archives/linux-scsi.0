Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B708C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B00B206DA
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:11:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qkCdzGLc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHRDLo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 23:11:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47512 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgHRDLo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 23:11:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I398GR033095;
        Tue, 18 Aug 2020 03:11:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Z76q9Syf5E6geLOMXEwFqaUPd87pHddkw2fm2ePaOx0=;
 b=qkCdzGLcI2aHLdXV1KZIuL/ixuMdCw67fWQo15IBydc3tD0VnlT3ts7VL0FPQbv9XJOb
 fAI5UjeS75ZrbjbqnaPE5zGRbr0lFKDMKi7vhAB4ZRYjTIqVzGxnBphn51Y2jSQMetsW
 eyum7/XDK/UU89uxj+q77mb4PI6lf6RDdjhCeAgaqT0KPgEEGmgVrHel3MTpAnzFz1GA
 xj7sf84mlDx5qYdGVTGvkNyjmdYza73j+VovlZAcKC8sHPyoAwl6Ca3ZxeD5mvbA0LGn
 HZiGyy/4T94osTppYOhVlVFD4XXnf+AJOnUkuadSSOFY74YaHTnyTmkvMMthyVI+Uoh3 2Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32x7nma5be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 03:11:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I37mUQ111766;
        Tue, 18 Aug 2020 03:11:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32xsm1q1xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 03:11:25 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07I3BJrA029256;
        Tue, 18 Aug 2020 03:11:19 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 20:11:19 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     cang@codeaurora.org, stanley.chu@mediatek.com, beanhuo@micron.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, bvanassche@acm.org,
        jejb@linux.ibm.com, asutoshd@codeaurora.org,
        Bean Huo <huobean@gmail.com>, tomas.winkler@intel.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/2] make UFS dev_cmd more readable
Date:   Mon, 17 Aug 2020 23:11:12 -0400
Message-Id: <159772022968.19349.8893371849577463792.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200814095034.20709-1-huobean@gmail.com>
References: <20200814095034.20709-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 14 Aug 2020 11:50:32 +0200, Bean Huo wrote:

> Changelog:
>     v2 -v3:
>         1. fix a coding style issue in [2/2] (Asutosh Das)
> 
>     v1 - v2:
>         1. remove original patch scsi: ufs: differentiate dev_cmd trace message
>         2. add new patch scsi: ufs: remove several redundant goto statements
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/2] scsi: ufs: Change ufshcd_comp_devman_upiu() to ufshcd_compose_devman_upiu()
      https://git.kernel.org/mkp/scsi/c/39e78be3474b
[2/2] scsi: ufs: Remove several redundant goto statements
      https://git.kernel.org/mkp/scsi/c/e62212672ab5

-- 
Martin K. Petersen	Oracle Linux Engineering
