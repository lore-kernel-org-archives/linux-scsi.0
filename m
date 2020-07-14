Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED8AC433E5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:59:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C01F221E7
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:59:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q8GHasOo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgGNE7D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 00:59:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43408 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgGNE7C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 00:59:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E4vDtj135818;
        Tue, 14 Jul 2020 04:58:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=7we77lG6mlkFBYcBEmWuLFpucXzC2Q6WUj/T0ePlPLU=;
 b=Q8GHasOodycTHzQuLkCXln/zHIXI9j2E+176fx0CNcwrRo2ckIyUP1iNbKqiONerCBHm
 GxDeQaRu92eDuZio5XVnuTkNOrI1nzCk1ZH3zEFCgVBaPA9b4pyPr+MIkEvk6AU5iJBv
 axt3+7k9G0EPiMatzZJ1f0D4aiv6Ir7gUvJjSd0orEoLF5Q6U7i+djjEML8kSHnRfYQh
 USwKUmYKsph1atXBeBjZK7DEdJ5Ji2sEvcFcbzPtyk8rStTovsHe0Li7YFx5LkiyS602
 2r9Di508tG+7B/CVui/1vlzfn/DhacX85xdj137+RjWXhfNLJ3X+NJrKviNp7JpluEHa UA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32762natk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 04:58:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E4waKZ098640;
        Tue, 14 Jul 2020 04:58:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 327qbwquu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 04:58:54 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06E4wqIM022054;
        Tue, 14 Jul 2020 04:58:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 21:58:52 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linuxarm@huawei.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] hisi_sas: A couple of misc patches
Date:   Tue, 14 Jul 2020 00:58:42 -0400
Message-Id: <159470266468.11195.1920177105269481206.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1594627471-235395-1-git-send-email-john.garry@huawei.com>
References: <1594627471-235395-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1011 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140037
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 13 Jul 2020 16:04:29 +0800, John Garry wrote:

> Includes a patch to speed up error handling and a kerneldoc clean-up.
> 
> John Garry (1):
>   scsi: hisi_sas: Remove one kerneldoc comment
> 
> Luo Jiaxing (1):
>   scsi: hisi_sas: Directly trigger SCSI error handling for completion
>     errors
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/2] scsi: hisi_sas: Directly trigger SCSI error handling for completion errors
      https://git.kernel.org/mkp/scsi/c/05d91b557af9
[2/2] scsi: hisi_sas: Remove one kerneldoc comment
      https://git.kernel.org/mkp/scsi/c/3d570a28ee8d

-- 
Martin K. Petersen	Oracle Linux Engineering
