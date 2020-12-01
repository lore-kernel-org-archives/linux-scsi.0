Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFD0C64E90
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A073F207FF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:07:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G0jMbDpu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgLAFHW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 00:07:22 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56730 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgLAFHW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 00:07:22 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14mxp1008438;
        Tue, 1 Dec 2020 05:06:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=jsShyZ2V8J4gklEIzw+oLHA38zbE1oFxZNyB9LeTj8c=;
 b=G0jMbDpum4xLt/v4rvpJqn6t/WBhQemK7RsG7PNChuVlaXXxaZ0ef8DLtbIMvHXcZFbS
 iz/GrgSyr9oUMBMo/5Q2EpnQN4FglMn4yiDKnqWCYli33jjqzOGu2hu6eLsYgQyzJ0+Q
 DyBjCQGOiX4groWyUr+1hKooFOmw1FjqZ0kGZidRsXMi9OsADin6qijZ2y2J1+vd0Qgj
 ASQLdXp1mdb9SAEWycKU3+T9DlrmXOVQyFTcGLaG89fDo+ASRAea3gOwcHTy4zVOEoql
 7Kzkg2rUJfin6zqRiZ3H9EqF/JM3RdWHu+brGedAcAsRYe74F5ustJftPB4zzJxd7ou1 EA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2arqh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 05:06:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14pJfs051385;
        Tue, 1 Dec 2020 05:04:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3540fwatwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 05:04:31 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B154SVq016728;
        Tue, 1 Dec 2020 05:04:28 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 21:04:28 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Joe Perches <joe@perches.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: pm8001: logging neatening
Date:   Tue,  1 Dec 2020 00:04:18 -0500
Message-Id: <160636449894.25598.4013351377830491111.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1605914030.git.joe@perches.com>
References: <cover.1605914030.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=899 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=908 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 20 Nov 2020 15:16:08 -0800, Joe Perches wrote:

> Reduce code duplication and generic neatening of logging macros
> 
> Joe Perches (2):
>   scsi: pm8001: Neaten debug logging macros and uses
>   scsi: pm8001: Make implicit use of pm8001_ha in pm8001_printk explicit
> 
>  drivers/scsi/pm8001/pm8001_ctl.c  |    7 +-
>  drivers/scsi/pm8001/pm8001_hwi.c  | 1370 ++++++++++---------------
>  drivers/scsi/pm8001/pm8001_init.c |  102 +-
>  drivers/scsi/pm8001/pm8001_sas.c  |  136 ++-
>  drivers/scsi/pm8001/pm8001_sas.h  |   45 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c  | 1596 ++++++++++++-----------------
>  6 files changed, 1361 insertions(+), 1895 deletions(-)

Applied to 5.11/scsi-queue, thanks!

[1/2] scsi: pm8001: Neaten debug logging macros and uses
      https://git.kernel.org/mkp/scsi/c/1b5d2793283d
[2/2] scsi: pm8001: Make implicit use of pm8001_ha in pm8001_printk() explicit
      https://git.kernel.org/mkp/scsi/c/89eddb401080

-- 
Martin K. Petersen	Oracle Linux Engineering
