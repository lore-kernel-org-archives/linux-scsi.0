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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A04EC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 04:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52B1123A5A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 04:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgLHExU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 23:53:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38372 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbgLHExU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 23:53:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B84o0Wa134051;
        Tue, 8 Dec 2020 04:52:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Z5gANhFzEDcQn1CLVh1lPm7JVtP3YdJZL0uddwjJ3mo=;
 b=Y4be0dQcMOGqn7I70h/kVwtW0Ed9zgdqqcycWbcZU+UgFT4mXq8DVVkmUO/QZDs4C1ve
 I22PgUg/0DENrp0SCEcfgy5gaOVaY1+7Kc2NozgyvjdTSPPsWweXdL5kMP3zlmOww2a+
 HLuMAxyNiz88hm0J2xofl4C3RqvM18PjJkeGKQSRhNgu1JLD/3cf0cX06OwPxJB4iqop
 B4fOxA44iss6CYC0OgySrd4MLFwm7xGc/937H1CI85Xdh1ivTA42a3j8Z503yr/FYSb+
 VoxpZeFRh0ZxtS84cZVQ/aytIUdLYnOEivqqogJMhjfEKUPyx0ufnQnSTlXkUrdbxLBH 3w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3581mqrrp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 04:52:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B84ojxc008196;
        Tue, 8 Dec 2020 04:52:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 358ksn26uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 04:52:12 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B84q7xM014550;
        Tue, 8 Dec 2020 04:52:08 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 20:52:07 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     rnayak@codeaurora.org, salyzyn@google.com, hongwus@codeaurora.org,
        saravanak@google.com, asutoshd@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Can Guo <cang@codeaurora.org>, nguyenb@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Satya Tangirala <satyat@google.com>
Subject: Re: [PATCH 1/1] scsi: ufs: Remove scale down gear hard code
Date:   Mon,  7 Dec 2020 23:51:59 -0500
Message-Id: <160740299785.710.4686167036921392934.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1606442334-22641-1-git-send-email-cang@codeaurora.org>
References: <1606442334-22641-1-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080029
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 26 Nov 2020 17:58:48 -0800, Can Guo wrote:

> Instead of making the scale down gear a hard code, make it a member of
> ufs_clk_scaling struct.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: ufs: Remove scale down gear hard code
      https://git.kernel.org/mkp/scsi/c/29b87e92a216

-- 
Martin K. Petersen	Oracle Linux Engineering
