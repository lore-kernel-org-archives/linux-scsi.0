Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4886C54E8D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9359D206B8
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:28:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SAL856Bq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgELD2x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 23:28:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38660 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgELD2w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 23:28:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3RKVm105259;
        Tue, 12 May 2020 03:28:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=dA6Oeud2F4cRc543OO5Veb1/Pt6WtgBUIO8gFviymxk=;
 b=SAL856Bq7IMxNQnybEd3Vuggfnb/SnzyM2XqXh+7dlX5mhwMUtftMpcSPxXG/DkDIqGD
 wl8kdRKZ4kEGqm7CnJCxbisy6h/hvewURSrWWLx9yBmhDZf/QP0PfDPXxHy86Pyh224v
 PjB12teFxDxNySisiIgNpOouRJ+cAdOv6EHQvujEEkXPMHACvZWDdvWzMMG7fHMTgXB4
 2DjiUHxf0Nqm3bD2QisWaRMr5gninahs2dIUi4WQtWR2dmsqgZN191t4R8BDxlnJ4Hlu
 oWzgfbF6TQ+fE9lWWWnxf4sjdCBDFSSl6pwIaEGI6cCD05DS/drB9XPHNdzyaMwrpmrm fA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30x3gmghsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 03:28:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3Mnfl016267;
        Tue, 12 May 2020 03:28:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30xbggtm4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 03:28:49 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04C3SlSe004004;
        Tue, 12 May 2020 03:28:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 20:28:47 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sreekanth.reddy@broadcom.com, Sathya.Prakash@broadcom.com,
        dan.carpenter@oracle.com, Johannes.Thumshirn@wdc.com
Subject: Re: [v1] mpt3sas: Fix double free warnings
Date:   Mon, 11 May 2020 23:28:33 -0400
Message-Id: <158925392374.17325.12960314431033073561.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508110738.30732-1-suganath-prabu.subramani@broadcom.com>
References: <20200508110738.30732-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=813
 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=855
 clxscore=1015 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120029
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 8 May 2020 07:07:38 -0400, Suganath Prabu S wrote:

> Fix below warnings from Smatch static analyser:
> 
> drivers/scsi/mpt3sas/mpt3sas_base.c:5256 _base_allocate_memory_pools()
> warn: 'ioc->hpr_lookup' double freed
> 
> drivers/scsi/mpt3sas/mpt3sas_base.c:5256 _base_allocate_memory_pools()
> warn: 'ioc->internal_lookup' double freed

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Fix double free warnings
      https://git.kernel.org/mkp/scsi/c/cbbfdb2a2416

-- 
Martin K. Petersen	Oracle Linux Engineering
