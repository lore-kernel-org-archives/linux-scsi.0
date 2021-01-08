Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92CB0C43219
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73365207B8
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbhAHEUm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:20:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52478 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727617AbhAHEUm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 23:20:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 108497JA096255;
        Fri, 8 Jan 2021 04:19:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bQJfJncRuhMqPxfFu/CGwRzg5ttluRM2EqJVcWpUmaQ=;
 b=Svxbz2Th6CzVdorPqBDxeb4KYmjXlTZN8ZaoPAMh7duxJDdjQJfYSrTo3Xi4/stEsbyP
 X7wHZBQ8i3v0KH+anc2wEvYJfIdGLzEuq82tfE1ZLKMMr0U65Hr3v9XMJvadWlm5PZhe
 ZxC1EjQYAh98S+bnq1L32BuFYfRm3rqrgEGUNE4Kc3zzHAJg355aIFFhTiLt6ojdVd5o
 hmHvmoOQ2ZXp67HiPStwKg4fPPyddYdIAAsr7F33CuBl3XUWEUDREP1Ysoolyd9NE5xs
 4aTVT69IobHtzKHC/D4lWP+a8bmgTOELQG6XskiWkVXL2dTTRVwez+QxU3+zFZyGU3YZ 9Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35wepmfd95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 04:19:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1084AWMY100163;
        Fri, 8 Jan 2021 04:19:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35v4retw89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 04:19:53 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1084JphK031004;
        Fri, 8 Jan 2021 04:19:51 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 20:19:51 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     grant.jung@samsung.com, linux-scsi@vger.kernel.org,
        bvanassche@acm.org, hy50.seo@samsung.com,
        Kiwoong Kim <kwmad.kim@samsung.com>, cang@codeaurora.org,
        jejb@linux.ibm.com, beanhuo@micron.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, bhoon95.kim@samsung.com,
        alim.akhtar@samsung.com, sc.suh@samsung.com, sh425.lee@samsung.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC PATCH v1] ufs: relocate flush of exceptional event
Date:   Thu,  7 Jan 2021 23:19:36 -0500
Message-Id: <161007949337.9892.6230156161549352721.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1608360039-16390-1-git-send-email-kwmad.kim@samsung.com>
References: <CGME20201219065127epcas2p4ee350f78ba75619dfd502dbb2e694a9b@epcas2p4.samsung.com> <1608360039-16390-1-git-send-email-kwmad.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=859 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1011 mlxlogscore=862
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 19 Dec 2020 15:40:39 +0900, Kiwoong Kim wrote:

> I found one case as follows and the current flush
> location doesn't guarantee disabling BKOPS in the
> case of requsting device power off.
> 1) The exceptional event handler is queued.
> 2) ufs suspend starts with a request of device power off
> 3) BKOPS is disabled in ufs suspend
> 4) The queued work for the handler is done and BKOPS
> is enabled again.

Applied to 5.11/scsi-fixes, thanks!

[1/1] ufs: relocate flush of exceptional event
      https://git.kernel.org/mkp/scsi/c/6948a96a0d69

-- 
Martin K. Petersen	Oracle Linux Engineering
