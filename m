Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B96FC35280
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 443112173E
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:55:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BzJrrXib"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgEHCzH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:55:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33752 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbgEHCy6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:54:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482rvSJ092526;
        Fri, 8 May 2020 02:54:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=6z+wiiZ3yboSHw0UcgXPuFfDcE74FaP78xDIV8z82Ck=;
 b=BzJrrXib+4skbkaHpPPKqIzHT1N4BpHhR3BHa0+JwuXGGgi7m802OdVvBZfyaTVj2X6f
 1w0ppuNPp8OIOyPMO2QoRHJLVkvBWndiYC7ESBYxYFRw4KLj0u4ORRbU8QMqTtsXHWKm
 zm3aPx6Tt75rZ4lHbQFBfSSe8to5tJxNyI/5kIXzS9qEb9l55QYGuS0Fs+a6wbiyRMv7
 EdFeh6eildhOSXNe7gVEx9C6t/rrnTE8vVJaFlZPvRjG8wvZU2VOsbDETRJPJDTY0mqh
 bBZVD+sq1sEcfK9AH3IkvrTqP4us/sjc/j6BpigItv8Ztq4Y9jW5UsccpAGZGJSVAA7g kA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30vtexrrm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482pold076352;
        Fri, 8 May 2020 02:54:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30vtdxwpqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:50 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0482sng1024628;
        Fri, 8 May 2020 02:54:49 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 19:54:49 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Jason Yan <yanaijie@huawei.com>,
        thellstrom@vmware.com, pv-drivers@vmware.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jgill@vmware.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: vmw_pvscsi: use true,false for adapter->use_msg
Date:   Thu,  7 May 2020 22:54:35 -0400
Message-Id: <158890633246.6466.6974567661806511973.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200430121729.15064-1-yanaijie@huawei.com>
References: <20200430121729.15064-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 30 Apr 2020 20:17:29 +0800, Jason Yan wrote:

> Fix the following coccicheck warning:
> 
> drivers/scsi/vmw_pvscsi.c:911:2-18: WARNING: Assignment of 0/1 to bool
> variable

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: vmw_pvscsi: Use true, false for adapter->use_msg
      https://git.kernel.org/mkp/scsi/c/013f69a931e7

-- 
Martin K. Petersen	Oracle Linux Engineering
