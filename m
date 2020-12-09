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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35926C4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB83523A5A
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731574AbgLIRY2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:24:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52140 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731244AbgLIRYS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 12:24:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HK6ac078542;
        Wed, 9 Dec 2020 17:23:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=gwNIt2FBy+r3VieI/FhGNcprg9z8Y9mB79smd7XjyC0=;
 b=F2k6Dsn6OlDS9qNGEnS8pL3bOjHP9NrdUy30zUv6Q41GbKGeN7ugBOE2548S4W58zl59
 0AQIIVuE/zGJOBeYDxLMkIVAhLa0qlg0vZRDqQhgldF+lw0oS6OBosgIGPQqJ1SueNPE
 XxS4wwfXmWhzrlFTbNCAUBQOpu/UHsEiWW3HVCqzpzmAH/ohPjJTWalpLKly05VEUT7d
 RWtCbvKgFE1VwwRbrxz1shEPN82d3JEXxfkfnXTjFcb9gD1HV1OEn2wy4idH/koAvDvk
 a4nT2KrQnTJEKTZJTDX/KM9YmQFRSawfFQ5O/FOReY3aqnAPigKCQjAW8ZnSTKwDryPC Eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3581mr1a3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 17:23:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HKqlK100041;
        Wed, 9 Dec 2020 17:23:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 358ksqdjm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 17:23:32 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B9HNVT2017684;
        Wed, 9 Dec 2020 17:23:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 09:23:31 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     saravanak@google.com, asutoshd@codeaurora.org, salyzyn@google.com,
        rnayak@codeaurora.org, kernel-team@android.com,
        hongwus@codeaurora.org, Can Guo <cang@codeaurora.org>,
        nguyenb@codeaurora.org, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V7 0/3] Minor fixes to UFS error handling
Date:   Wed,  9 Dec 2020 12:23:15 -0500
Message-Id: <160753457754.14816.406841787648084993.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1606910644-21185-1-git-send-email-cang@codeaurora.org>
References: <1606910644-21185-1-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=925 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=938
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2 Dec 2020 04:04:00 -0800, Can Guo wrote:

> This series mainly fixes below two things which come along with UFS error
> handling in some corner cases.
> [1] Concurrency problems btw err_handler and paths like system suspend/resume/shutdown and async scan.
> [2] Race condition btw UFS error recovery and task abort which happens to W-LU during suspend/resume/shutdown.
> 
> The 1st change is tested with error/fault injections to power mode change
> operations during system PM operations and async scan. The 2nd change is
> tested by mimicing SSU cmd timeout during suspend/resume/shutdown. The 3rd
> one is just a minor change to a check condition in IRQ handler such that
> the driver can dump host regs when AH8 error happens.
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/3] scsi: ufs: Serialize eh_work with system PM events and async scan
      https://git.kernel.org/mkp/scsi/c/88a92d6ae4fe
[2/3] scsi: ufs: Fix a race condition between ufshcd_abort and eh_work
      https://git.kernel.org/mkp/scsi/c/7a7e66c65d41
[3/3] scsi: ufs: Print host regs in IRQ handler when AH8 error happens
      https://git.kernel.org/mkp/scsi/c/ace3804b69af

-- 
Martin K. Petersen	Oracle Linux Engineering
