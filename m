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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619DAC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1733523125
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbhAMFvm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:51:42 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:35386 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbhAMFvl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:51:41 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5nwZN170908;
        Wed, 13 Jan 2021 05:50:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SedtQit5XrcXPxSi63MAXCoE17t1q9k7AjveDhzCY+4=;
 b=EM89Tv0hTXem4VRWnmfAEwtKiK7D9hPlh7WqKHQRRPxIFVf8XFAcC4T9w0leTjZfIhud
 ozxCjA9Wh1hVjJEGfnVSQIZVMrGkC5/QUiPX375jzpWadZBtj1Jpc8MZ+XFCIB7uvlcO
 5togkNAcdP7+ZgyLrhonlAQ7CPmjIe8+jgQomuOTmU1kKv7f0OHXe69yhRwDLyPAneVx
 NsyHMxAODOKzukpJvYCEpXsPLMiVSsqDYqIBW8pccrWwH7nYIla1Iay1qCmVF+mhyTYz
 ClAN2J4mZhQwWa/buuLjwx8jjwg6utj6ARZSu5kw0o2gD7+aX92xv1gGd6SydAyQnCTC /Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 360kg1sp0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:50:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5eVgu058740;
        Wed, 13 Jan 2021 05:48:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 360kf6w07y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:48:49 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10D5mmor011521;
        Wed, 13 Jan 2021 05:48:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 21:48:36 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     bhoon95.kim@samsung.com, sh425.lee@samsung.com, beanhuo@micron.com,
        jejb@linux.ibm.com, Kiwoong Kim <kwmad.kim@samsung.com>,
        alim.akhtar@samsung.com, bvanassche@acm.org,
        grant.jung@samsung.com, hy50.seo@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, linux-scsi@vger.kernel.org,
        sc.suh@samsung.com, cang@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/2] permit vendor specific values of unipro timeouts
Date:   Wed, 13 Jan 2021 00:48:25 -0500
Message-Id: <161050726818.14224.9504573132098411358.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1608513782.git.kwmad.kim@samsung.com>
References: <CGME20201221013532epcas2p4cfd78329e4d56e3ac5317ae23c27bc8c@epcas2p4.samsung.com> <cover.1608513782.git.kwmad.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130035
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 21 Dec 2020 10:24:39 +0900, Kiwoong Kim wrote:

> v2 -> v3: remove change ids
> v1 -> v2: change some comments and rename the quirk
> 
> There are some attribute settings before power mode change in ufshcd.c
> that should have been variant per vendor.
> 
> Kiwoong Kim (2):
>   ufs: add a quirk not to use default unipro timeout values
>   ufs: ufs-exynos: apply vendor specifics for three timeouts
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/2] ufs: add a quirk not to use default unipro timeout values
      https://git.kernel.org/mkp/scsi/c/b1d0d2eb89d4
[2/2] ufs: ufs-exynos: apply vendor specifics for three timeouts
      https://git.kernel.org/mkp/scsi/c/a967ddb22d94

-- 
Martin K. Petersen	Oracle Linux Engineering
