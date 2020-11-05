Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D749C00A89
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 04:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF1C820786
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 04:17:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="y8146/db"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgKEERm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 23:17:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39094 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgKEERm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 23:17:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A5450lG023651;
        Thu, 5 Nov 2020 04:17:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zvoRqfPUTIvqrCZUnPyFK3JThN6BSmg7dvuT2LHD+Wo=;
 b=y8146/dbZudcU8UEDlLcF1U5gqCaGAglvPNwMXRVNzFdtJjqClJf1E77fqxSwMTaLXxS
 BtKqULgsBfb6O8iTnDqwkwwmHIjF1ICuvtn8SHLE53t7AWObAxu6QcubWFI0QkrLz3Cy
 Cw76vT6qMdelDSKrxm1+pCAZrLXeBkm34WqJ08QzGnHtrLDEF2l7yYY/da3BfOhrPtcc
 hJ9EeiqJpujnwYKg90ZVBSQvLcXalByiic6Lfr/3tZG6HESr17ntRzITcIPIiOohT3Jj
 F0urbX1WKbzL1BNJNJ0J23t/KYKiEyzR/lbKbszBIiO4lsO0BZPNvJfUkKMijpX1OWtE aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34hhw2sxpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 05 Nov 2020 04:17:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A540ZQE169530;
        Thu, 5 Nov 2020 04:17:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34hw0m07cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Nov 2020 04:17:36 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A54HZ73029151;
        Thu, 5 Nov 2020 04:17:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Nov 2020 20:17:35 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     asutoshd@codeaurora.org, kernel-team@android.com,
        nguyenb@codeaurora.org, Can Guo <cang@codeaurora.org>,
        saravanak@google.com, salyzyn@google.com, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, rnayak@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 0/2] Two minor fixes for UFS driver
Date:   Wed,  4 Nov 2020 23:17:34 -0500
Message-Id: <160454975348.20375.2120794283606643226.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
References: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=886 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 clxscore=1011 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=897 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050029
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2 Nov 2020 22:24:38 -0800, Can Guo wrote:

> This series contains two minor fixes, one for clk gating and one
> for PMC/UIC cmd completion timeout.
> 
> Can Guo (2):
>   scsi: ufs: Fix unbalanced scsi_block_reqs_cnt caused by ufshcd_hold()
>   scsi: ufs: Try to save power mode change and UIC cmd completion
>     timeout
> 
> [...]

Applied to 5.10/scsi-fixes, thanks!

[1/2] scsi: ufs: Fix unbalanced scsi_block_reqs_cnt caused by ufshcd_hold()
      https://git.kernel.org/mkp/scsi/c/da3fecb00403
[2/2] scsi: ufs: Try to save power mode change and UIC cmd completion timeout
      https://git.kernel.org/mkp/scsi/c/0f52fcb99ea2

-- 
Martin K. Petersen	Oracle Linux Engineering
