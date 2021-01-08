Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B02C4332B
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EC0B207B8
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbhAHEUp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:20:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52502 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727676AbhAHEUn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 23:20:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10849j0g096801;
        Fri, 8 Jan 2021 04:19:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=mhlu5DlX8TBsODbrNtircvmM16EzqJ5TdA/dACh+jGk=;
 b=Q6EGHzgkmeJBQ8hRqGah/PFytVQxLqYh1KJMcCovgfiLUFxtPvy7/bfJB4YaBNl/uSCj
 UlSPHFbnZCn5IWqMURqHkZ1IQl7+n1wCFW5kWKe6I3LAZniHxUkqV6yxE0n6wY0bCagA
 yqwDnbfPKqRzRzF1G53yNMNitsrAGol/rmN+LzMmbPkBvU9vGlhFwuM335zbh9nUfHgR
 JsFC9eOaOLoBfGvwTiR14BU1W5YSD1MHBx4qC7lLYipdS+Nb4eCJmCRspO+DUS16W3IW
 7ET4lfACUMhTgHoOEdXP5idExbThTHMdI/6MPxWMmXAUk6YhZxAT9pdn/NCMkPv27zsI MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35wepmfd99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 04:19:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1084Au7j079245;
        Fri, 8 Jan 2021 04:19:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 35v1fc2x8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 04:19:55 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1084JsNb012503;
        Fri, 8 Jan 2021 04:19:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 20:19:54 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel test robot <lkp@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH] scsi: ufs: ufshcd-pltfrm depends on HAS_IOMEM
Date:   Thu,  7 Jan 2021 23:19:39 -0500
Message-Id: <161007949339.9892.14233545766949320025.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210106040822.933-1-rdunlap@infradead.org>
References: <20210106040822.933-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=883 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=892
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 5 Jan 2021 20:08:22 -0800, Randy Dunlap wrote:

> Building ufshcd-pltfrm.c on arch/s390/ has a linker error since
> S390 does not support IOMEM, so add a dependency on HAS_IOMEM.
> 
> s390-linux-ld: drivers/scsi/ufs/ufshcd-pltfrm.o: in function `ufshcd_pltfrm_init':
> ufshcd-pltfrm.c:(.text+0x38e): undefined reference to `devm_platform_ioremap_resource'
> 
> where that devm_ function is inside an #ifdef CONFIG_HAS_IOMEM/#endif block.

Applied to 5.11/scsi-fixes, thanks!

[1/1] scsi: ufs: ufshcd-pltfrm depends on HAS_IOMEM
      https://git.kernel.org/mkp/scsi/c/5e6ddadf7637

-- 
Martin K. Petersen	Oracle Linux Engineering
