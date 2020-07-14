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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DD1C433E8
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61A572193E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:59:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RcQ8N4yE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgGNE7S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 00:59:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37726 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgGNE7R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 00:59:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E4utuQ172701;
        Tue, 14 Jul 2020 04:59:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=8OamBc93tsElgQQ1UHHoc9Ay6yPCeE9e643okWZufPE=;
 b=RcQ8N4yE75AJIagGybBj1DOtp5WeLXeVMtnLPD7qSA1s9F8HbroJ3EngD0TfjMpAWiL5
 bEklOkbecflIy1SNslBC8cOi2ixycHJaUezl+e56jtcDbOPKFloEvpG61tHxbi7LFBkS
 nICuMdIbIJ53L52lKTOizUedA+Ky6g65LdPWbAUBqJllz8LIDmJUR5vHbS0nk3DFdyuT
 wAI0q9Cwp3w/kO5lZUKSzfhV/ApSg74ldxDoXt48oBkWaxQrKklt7/oen8IICsN3A+DX
 VMoXc3mJVH3gLonR22yKfXRFGULbH11pQti19gK2zWrTOjQyh0xljI0yk+O1f7JAWZsj mA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3275cm2x3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 04:59:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E4vXKT174023;
        Tue, 14 Jul 2020 04:59:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 327qb2nuud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 04:59:01 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06E4wxg2025076;
        Tue, 14 Jul 2020 04:58:59 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 21:58:59 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     mst@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        Xianting Tian <xianting_tian@126.com>, jejb@linux.ibm.com,
        stefanha@redhat.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: virtio_scsi: remove unnecessary condition check
Date:   Tue, 14 Jul 2020 00:58:47 -0400
Message-Id: <159470266467.11195.10910825066875185491.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1594307167-8807-1-git-send-email-xianting_tian@126.com>
References: <1594307167-8807-1-git-send-email-xianting_tian@126.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=998 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1011 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140037
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 9 Jul 2020 11:06:07 -0400, Xianting Tian wrote:

> kmem_cache_destroy and mempool_destroy can correctly handle
> null pointer parameter, so there is no need to check if the
> parameter is null before calling kmem_cache_destroy and
> mempool_destroy.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: virtio_scsi: Remove unnecessary condition check
      https://git.kernel.org/mkp/scsi/c/92e8d0323a51

-- 
Martin K. Petersen	Oracle Linux Engineering
