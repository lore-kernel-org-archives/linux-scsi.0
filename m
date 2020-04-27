Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADF6C4CECC
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50535206E2
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:21:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FomNxJni"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgD0UVe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 16:21:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35630 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgD0UVd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 16:21:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKJdmq141433;
        Mon, 27 Apr 2020 20:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Ex3LWTatXSpzb95hu/uBC69ji3vlL1xDOm/FGgrwL00=;
 b=FomNxJni7fA6R7aDTTIDMj94Sp9+QyG+T1gpiSKoME+K3kcb44JAeqhNIksWZZuZihHa
 8hCAUI1ZXIg2aojS92C6DgdB7Qi2A81nsq5lau+jJQ2ApjX8vVcLYfVfH+hnYcYtdh7v
 hDOeKbLkoI3wYBqPuuu8LA+adISRTzSTH0LW9GvnhhZU5mbVhyiVDAqhLe5jwQYxisD1
 IBSu8ZtTHg1T5UZwQFc6y/REQW8lNP72KOAjLUwTis6Qkoa+ePp49sCj7AoIWussbyVO
 v+DRpSJUmVWX9otJhYf7pVUl0mRkJH2/ku/mluHXoMHR2vnuca8PGTgXnkAHO9zcC6+F gQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30p2p01a1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:21:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKBojk060146;
        Mon, 27 Apr 2020 20:21:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30mxwwwfsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:21:25 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03RKLOWL021194;
        Mon, 27 Apr 2020 20:21:24 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 13:21:24 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Wu Bo <wubo40@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linfeilong@huawei.com, linux-scsi@vger.kernel.org,
        liuzhiqiang26@huawei.com
Subject: Re: [PATCH] scsi:pmcraid:Replace dma_pool_malloc with dma_pool_zalloc
Date:   Mon, 27 Apr 2020 16:21:13 -0400
Message-Id: <158777063305.4076.8471124147787391487.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1587197241-274646-1-git-send-email-wubo40@huawei.com>
References: <1587197241-274646-1-git-send-email-wubo40@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=768 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=839 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270164
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 18 Apr 2020 16:07:21 +0800, Wu Bo wrote:

> Replace dma_pool_malloc with dma_pool_zalloc to make the code more concise
> in pmcraid_allocate_control_blocks() function.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: pmcraid: Replace dma_pool_malloc with dma_pool_zalloc
      https://git.kernel.org/mkp/scsi/c/f8f794a15adc

-- 
Martin K. Petersen	Oracle Linux Engineering
