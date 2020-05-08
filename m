Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15862C35280
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 01:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6B2D20A8B
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 01:17:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zumj1puW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgEHBRL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 21:17:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34706 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgEHBRK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 21:17:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0481EtXu053085;
        Fri, 8 May 2020 01:16:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=B/hRDV09PxgU8CAFrU/qqcdjm3Rbchmhl4GqvXiY0d0=;
 b=zumj1puW6mDuvyW4hNU7WE2KZX+TMovRoDt6lD9tDcWH7olhwCiL5BZaKjVjcydCxPSE
 7j2AQye1svV13xsWnfqn++Hq3VEIGjnOb2r9mQ6OVA8ECHtdwsvEb1MZqmU8QE2279Os
 /qJ0RyPoAbcbKCnbkjTvyeoEAtYn6ti3oEXnD8z+F+36esmMxpikT6GUcoL0HvXISYlL
 ht6b/XxRgeybPraGJdAzY/J4Psx/HBbViISzeJvoWDQ+q3Hlt+rmGurTIn5zcdFUTIim
 b+2QqX8HNhlzHEUKxH1TiOA6boT3Oq8DNzJNWzhobOD3puj9BlMT83ILqxR6YYYRCmLB fA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30vtewrhms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 01:16:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0481CklV046612;
        Fri, 8 May 2020 01:16:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30vtefjqdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 01:16:50 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0481GkJk012093;
        Fri, 8 May 2020 01:16:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 18:16:46 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     bjorn.andersson@linaro.org, bvanassche@acm.org,
        kernel-team@android.com, nguyenb@codeaurora.org,
        alim.akhtar@samsung.com, stanley.chu@mediatek.com,
        Avri.Altman@wdc.com, Can Guo <cang@codeaurora.org>,
        linux-scsi@vger.kernel.org, salyzyn@google.com,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        saravanak@google.com, asutoshd@codeaurora.org, beanhuo@micron.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/1] scsi: pm: Balance pm_only counter of request queue during system resume
Date:   Thu,  7 May 2020 21:16:43 -0400
Message-Id: <158890041329.32359.15170754765805199921.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1588740936-28846-1-git-send-email-cang@codeaurora.org>
References: <1588740936-28846-1-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080008
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 5 May 2020 21:55:35 -0700, Can Guo wrote:

> During system resume, scsi_resume_device() decreases a request queue's
> pm_only counter if the scsi device was quiesced before. But after that,
> if the scsi device's RPM status is RPM_SUSPENDED, the pm_only counter is
> still held (non-zero). Current scsi resume hook only sets the RPM status
> of the scsi device and its request queue to RPM_ACTIVE, but leaves the
> pm_only counter unchanged. This may make the request queue's pm_only
> counter remain non-zero after resume hook returns, hence those who are
> waiting on the mq_freeze_wq would never be woken up. Fix this by calling
> blk_post_runtime_resume() if a sdev's RPM status was RPM_SUSPENDED.
> 
> [...]

Applied to 5.7/scsi-queue, thanks!

[1/1] scsi: pm: Balance pm_only counter of request queue during system resume
      https://git.kernel.org/mkp/scsi/c/a3b923842626

-- 
Martin K. Petersen	Oracle Linux Engineering
