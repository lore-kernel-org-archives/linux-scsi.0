Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C9F8C4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 02:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4B1123A6A
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 02:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgLIChw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 21:37:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44694 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgLIChw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 21:37:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B92Yogx151683;
        Wed, 9 Dec 2020 02:37:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=r/Lh49/O2EZr6JB2u3epTpgfpKC+u36DuUavw2fVJ5o=;
 b=tCsmcjxQTQSWWdj1qCU7IxjVvC493QHkXcydTtpZSeVVoFWHI9DBzzmcJevuTyHVMTw/
 sXKmXKnkGMGvXie54A6bqI0ZkCE7YxvSrY+iu4lJLo+beCtZnxr1rITpxYt0h7fQeDwM
 z0quhxiAMhs0McYhPc0j5K0Gv37z6ZuuyJtzpXlk1ru43KCOGry9UCYHzrELrh9NFmjB
 Frwsu3yeWR1t9ImQ/X7hJoYY/bBLxjW7egbp44r/igs+fxMKML01+iAz1cEEzdaFLcFS
 KvpV7Pmef0ugGtz89FDHcmo0Ouy5iHgfinzYE0yyya4Y69MNcGMJR6SD/qHTagjEosy8 jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3581mqwvy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 02:37:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B92YnR3174630;
        Wed, 9 Dec 2020 02:37:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 358kspf2ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 02:37:00 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B92aukJ022294;
        Wed, 9 Dec 2020 02:36:57 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Dec 2020 18:36:56 -0800
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        Randall Huang <huangrandall@google.com>,
        Leo Liou <leoliou@google.com>
Subject: Re: [PATCH v2] scsi: ufs: clear uac for RPMB after ufshcd resets
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zh2nso1v.fsf@ca-mkp.ca.oracle.com>
References: <20201201041402.3860525-1-jaegeuk@kernel.org>
        <X8/1U8+Dd3UJjKA/@google.com>
Date:   Tue, 08 Dec 2020 21:36:53 -0500
In-Reply-To: <X8/1U8+Dd3UJjKA/@google.com> (Jaegeuk Kim's message of "Tue, 8
        Dec 2020 13:51:15 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=841 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=871
 clxscore=1011 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jaegeuk,

> If RPMB is not provisioned, we may see RPMB failure after UFS suspend/resume.
> Inject request_sense to clear uac in ufshcd reset flow.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
