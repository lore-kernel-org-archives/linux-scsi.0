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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C818C6379D
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1147122256
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:32:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dXoEMp6j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgKTDcA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:32:00 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35080 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgKTDcA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:32:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3QOHl097173;
        Fri, 20 Nov 2020 03:31:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ofRlNUws8pz30CMsIW3vU9rnckAljY2y638SwvM8cEA=;
 b=dXoEMp6j9n2W4mmSEAlVZknhsgmSmo1P6fYK2v0cfmcSd1bPoyQJak1AozTIvWtpJ/0u
 Z2DWtLMVAUvyxaTU/Rg7tyRwWdRHmv8VPVspqjYr/M6Gvfj4DYEtdoalCOcwmpuKia1c
 MLTikE4Fxdq9dy6n6wiHyAtSagVWcjxoftXpbaHE7JOcW62YgYBxf53+z/8bTnb6Gspu
 05Bc6VUlU+v/Ug7z1XvR6cdqanhl06lfSkmF/APFJTJlIjcgUvVWbEjRJkVVVRRyjTyQ
 pU5oj88VdG79wCjw9QEdfVLsrz2QWpetUwP+tev757f7VhAcJPLrhRP2S4yqo63Grs0J Uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34t76m8qxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:31:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3PjJT032475;
        Fri, 20 Nov 2020 03:31:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34uspx2jwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:31:49 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AK3VleU017490;
        Fri, 20 Nov 2020 03:31:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:31:47 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: qla4xxx: Remove redundant assignment to variable rval
Date:   Thu, 19 Nov 2020 22:31:40 -0500
Message-Id: <160584262853.7157.9544470440731442413.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103120137.109717-1-jingxiangfeng@huawei.com>
References: <20201103120137.109717-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 3 Nov 2020 20:01:37 +0800, Jing Xiangfeng wrote:

> The variable rval has been initialized with 'QLA_ERROR'. The assignment
> is redundant in an error path. So remove it.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: qla4xxx: Remove redundant assignment to variable rval
      https://git.kernel.org/mkp/scsi/c/cf4d4d8ebdb8

-- 
Martin K. Petersen	Oracle Linux Engineering
