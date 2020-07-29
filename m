Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B09FC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C49120786
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:10:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xY2yF6hp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgG2EKw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 00:10:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45504 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgG2EKw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 00:10:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T41dmo159218;
        Wed, 29 Jul 2020 04:10:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=mriZwRXIHonAt6bhurHKpqs0Cl4KXgEcu8ISDCpfmc4=;
 b=xY2yF6hp6KDHK2Jotxq6nztFRfiKg8PUYZyekmlqmiwdv6frHrK+gCnMpM/CXWNth9V2
 +mQTkHIL2rBsnsGreOoFkE5a9ttaWw17rwrF/JWyNI7a/1EqKyLZNxXoupzfRuwA8cw7
 pBS956jVdn/lP5DIOynaPQnw1LrpOXywMB/DkTJ4kcGoDtKq77vJcEARBAwG5a4gdQBu
 8Bo/UVI5xVWbiATgfSDYPWJEWMRsNAWrbxMUWIbnyIo7Y170i25oRDtRGayUkpQ8PAbp
 0KydUzSmXUC4CeAQY8VOnRHyH+0PrdBJ+u0lXijzBZeRGEZSlCm2cW0SWEg1YXpwJCkz uQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32hu1jb5r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 29 Jul 2020 04:10:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T42bbe023836;
        Wed, 29 Jul 2020 04:10:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32hu5u1pwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jul 2020 04:10:47 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06T4AjLl030755;
        Wed, 29 Jul 2020 04:10:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 21:10:45 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Hou Pu <houpu@bytedance.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        mchristi@redhat.com
Subject: Re: [PATCH v4 0/2] iscsi-target: fix login error when receiving is too fast
Date:   Wed, 29 Jul 2020 00:10:37 -0400
Message-Id: <159599579268.11289.2746650835004823983.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716100212.4237-1-houpu@bytedance.com>
References: <20200716100212.4237-1-houpu@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=857 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=873
 lowpriorityscore=0 malwarescore=0 clxscore=1011 mlxscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 16 Jul 2020 06:02:10 -0400, Hou Pu wrote:

> We encountered "iSCSI Login negotiation failed" several times.
> After enable debug log in iscsi_target_nego.c of iSCSI target.
> Error shows:
>   "Got LOGIN_FLAGS_READ_ACTIVE=1, conn: xxxxxxxxxx >>>>"
> 
> Patch 1 is trying to fix this problem. Please see comment in patch 1
> for details.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/2] scsi: target: iscsi: Fix login error when receiving
      https://git.kernel.org/mkp/scsi/c/4e108d4f2816
[2/2] scsi: target: iscsi: Fix inconsistent debug message
      https://git.kernel.org/mkp/scsi/c/df2de6f28629

-- 
Martin K. Petersen	Oracle Linux Engineering
