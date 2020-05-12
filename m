Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B720C54E8D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4782720769
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:29:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bpthnbw0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgELD3E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 23:29:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38872 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728709AbgELD3D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 23:29:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3RLxY105406;
        Tue, 12 May 2020 03:28:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Ul1MQ9V/DIgV6pt2ygn/L2NqNfjK8CMuQ9o1DGGXPHc=;
 b=Bpthnbw0LWJDqfpRI3aStgG9H+2vFx3GquljTwNuzhCq8GO+verXEkBYeAStXMuSqYgu
 fvVtYaobhqLE+n6YK2XSVwyuTjlk61UdYqp6Bw50/3Qjf/716oryffHJba9589XyEJ45
 Ta46wyvbbzt1K0hel2onR0ltM27sM4qMXlNqW6Pmc+VJTWISIxwzVNQkEr34uW+8gYeW
 2V64vf0vzM7n3NS0USHQwGiUpkDZphXypby514oBU00nwNd/dZg648HIDEQLMij53kw2
 KF2+wxwzMppfe3pt6+hgnmSpHILuqIE6Vy07cwnFKZjuP5mNSf+hq7Ao0oEbA/nVOwuA WQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30x3gmghsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 03:28:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3NsMC044088;
        Tue, 12 May 2020 03:28:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30ydspj6ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 03:28:54 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04C3Sre1004039;
        Tue, 12 May 2020 03:28:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 20:28:52 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Zou Wei <zou_wei@huawei.com>, aacraid@microsemi.com,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next v2] scsi: aacraid: Use memdup_user() as a cleanup
Date:   Mon, 11 May 2020 23:28:37 -0400
Message-Id: <158925392372.17325.1168480334838921553.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1587868964-75969-1-git-send-email-zou_wei@huawei.com>
References: <1587868964-75969-1-git-send-email-zou_wei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 mlxlogscore=846 malwarescore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=900
 clxscore=1015 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120029
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 26 Apr 2020 10:42:44 +0800, Zou Wei wrote:

> Fix coccicheck warning which recommends to use memdup_user().
> 
> This patch fixes the following coccicheck warning:
> 
> drivers/scsi/aacraid/commctrl.c:516:15-22: WARNING opportunity for memdup_user

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: aacraid: Use memdup_user() as a cleanup
      https://git.kernel.org/mkp/scsi/c/8d925b1f00e6

-- 
Martin K. Petersen	Oracle Linux Engineering
