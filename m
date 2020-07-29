Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C26C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5253520768
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:13:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iuvdQaA9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgG2ENG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 00:13:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53944 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgG2ENG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 00:13:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T4CLf8185406;
        Wed, 29 Jul 2020 04:12:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=LawUWswJxsYW16Uo1LM0iQFVAkkF5ZnMSyZcX63eLck=;
 b=iuvdQaA9pwr585uvi0CKtmp2ZmIvTOvZU6zXb0ZrmVgznT4fEnbf84feXYcrbOFaEn0j
 mdcu+DZat5CmigzKzI6B4bEu6ZzwVQf2HqnfhzqN2LwcdYiN8ixW8xqLupuZCwdlrMlW
 drIzfpX9bcezHomVOrJ9co5GfDzKqK3YazCxpyKAdMapq9YHPUzDLo6u5r4cpAd9hteX
 xTDWEl6sTyvu2ZooPyRjWTy01eGRammTRPhm0qdTIrloF0tyR+b2KZ7vjGYDQ6Mu51xT
 I3RuD4n4M6d3UoOV816LwPMHF0bLxUAHtpULmY+mT1uAPVMD9RcvMQAxLqmmc1vYxp5V 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32hu1jk668-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 29 Jul 2020 04:12:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T43M81182563;
        Wed, 29 Jul 2020 04:10:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32hu5u15rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jul 2020 04:10:48 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06T4AlNm024998;
        Wed, 29 Jul 2020 04:10:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 21:10:46 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>, jejb@linux.ibm.com,
        cleech@redhat.com, lduncan@suse.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] scsi: iscsi: Do not put host in iscsi_set_flashnode_param()
Date:   Wed, 29 Jul 2020 00:10:38 -0400
Message-Id: <159599579269.11289.8326075241681410079.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200615081226.183068-1-jingxiangfeng@huawei.com>
References: <20200615081226.183068-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=953 mlxscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 mlxlogscore=976
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290028
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 15 Jun 2020 16:12:26 +0800, Jing Xiangfeng wrote:

> If scsi_host_lookup() failes we will jump to put_host, which may
> cause panic. Jump to exit_set_fnode to fix it.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: iscsi: Do not put host in iscsi_set_flashnode_param()
      https://git.kernel.org/mkp/scsi/c/68e12e5f6135

-- 
Martin K. Petersen	Oracle Linux Engineering
