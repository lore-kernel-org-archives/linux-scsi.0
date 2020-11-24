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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CBAEC56201
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BCBF20857
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F06RJ+q7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgKXD6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:58:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48252 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728326AbgKXD6V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:58:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3sV1E153279;
        Tue, 24 Nov 2020 03:58:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zNr7iy1F7LaZJP26vo/oHOkbKNGKS36Y6nWHmFHaRNo=;
 b=F06RJ+q7NOabov/LAzHfUad5HGFU4jyN/mWEDolsCVflHhz/wrD9J0X8Zp6iNLQVBm6E
 i6sIN1LqzvavE9D0pB73KYE9Og31WrdDQysp5DaqvTp5ozt7SR30of2d5yOvyLmncNOE
 nFPhuXzVfagoCHyqfRFYf5rBd/GTiaRvtkxS1+T8sSDFhkQDmE7ROVipXZuP6in7HR0G
 PLPpIIs2xlV8k5Dc1pugZ/oMIS1SKZH6O8U02x03auHLaOO8CY5XttFrIQbjy5FhNfCg
 3QKL+ZuHaCZ4dyfaRqBCmMV6/NcCVgjYsk1f0j+fgRRRTrkxbaos+hKb09v0yjq7zWB2 NA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34xtum0e4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:58:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3tocK081007;
        Tue, 24 Nov 2020 03:58:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34ycnrw00j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:58:16 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AO3wGxr009631;
        Tue, 24 Nov 2020 03:58:16 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:58:16 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] lpfc: Fix missing prototype warning for lpfc_fdmi_vendor_attr_mi
Date:   Mon, 23 Nov 2020 22:58:04 -0500
Message-Id: <160618683553.24173.17808060498172976356.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119203328.121772-1-james.smart@broadcom.com>
References: <20201119203328.121772-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0
 phishscore=0 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 19 Nov 2020 12:33:28 -0800, James Smart wrote:

> Function needs to be declared as static.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: lpfc: Fix missing prototype warning for lpfc_fdmi_vendor_attr_mi()
      https://git.kernel.org/mkp/scsi/c/809032ddf9c6

-- 
Martin K. Petersen	Oracle Linux Engineering
