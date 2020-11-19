Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A867C6369E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 15:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A065724654
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 15:04:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V3g2wOze"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgKSPEU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 10:04:20 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58074 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbgKSPEU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 10:04:20 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJEsNT7178525;
        Thu, 19 Nov 2020 15:03:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=698JySp1SeXV+YubtoacJTUwxrI0tGvgTfAK1MnErAs=;
 b=V3g2wOzeK+XtCHOWXcjII0yj3YBOCGdDQ9s8g9HWcmBwXWgKrdY9T8De75dWRMjRe0bz
 wJqYCjB7YdNxG9NvS1izn2/EwO+aM46mfH6iJWSnyhXN6npwk6nIFwL5+dvLxElSLSH2
 X+fedRm3eORsSWmeAAFdlwDGMk5U+1bgD2VmnGixpC9WXlaudae+tDat9uV1ymmAOPpp
 9qwqAPit/344oXTz05uwaMm8zZR5Ry94k8avk7YwKthW7hEdwV2TlkVAxT+oOz+5wdby
 9iT+YFCIH43TEzMOzDGDt3KXtmLpuO8EeCJzA2nfU6w0n9BuuAHMD/6RVXOSiLyYEJ0f cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34t76m5uek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Nov 2020 15:03:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJEsdGG056602;
        Thu, 19 Nov 2020 15:03:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34ts602v40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 15:03:47 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AJF3jYQ022090;
        Thu, 19 Nov 2020 15:03:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 07:03:45 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     salyzyn@google.com, kernel-team@android.com,
        asutoshd@codeaurora.org, hongwus@codeaurora.org,
        saravanak@google.com, nguyenb@codeaurora.org,
        Can Guo <cang@codeaurora.org>, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH v2 1/1] scsi: ufs: Fix unexpected values get from ufshcd_read_desc_param()
Date:   Thu, 19 Nov 2020 10:03:42 -0500
Message-Id: <160579821160.27938.2855666994784444501.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1603346348-14149-1-git-send-email-cang@codeaurora.org>
References: <1603346348-14149-1-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9809 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011190113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9809 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011190113
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 21 Oct 2020 22:59:00 -0700, Can Guo wrote:

> Since WB feature has been added, WB related sysfs entries can be accessed
> even when an UFS device does not support WB feature. In that case, the
> descriptors which are not supported by the UFS device may be wrongly
> reported when they are accessed from their corrsponding sysfs entries.
> Fix it by adding a sanity check of parameter offset against the actual
> decriptor length.

Applied to 5.10/scsi-fixes, thanks!

[1/1] scsi: ufs: Fix unexpected values from ufshcd_read_desc_param()
      https://git.kernel.org/mkp/scsi/c/1699f980d87f

-- 
Martin K. Petersen	Oracle Linux Engineering
