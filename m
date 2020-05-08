Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7491AC47247
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5534121655
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:55:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fAc8swnf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgEHCy4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:54:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36336 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgEHCyz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:54:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482rJ8H067461;
        Fri, 8 May 2020 02:54:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Iq4YkMGuTegzTbXTVNQZC7qoH3AFT/7se00BpzYH3cg=;
 b=fAc8swnfJaCQGPwKtQTqd20mydDVthI1kHavjvOSaghSxKDm3Cp99LQjcYOcZ9jN8Wou
 CYW+bkzMFGCQFa2tXiHnBfG516IrvGCODyXJOrdcRX41Lvlij+4FGe1ew16NhzBS5SHd
 RqCrH1N5Rxv20vYEkxJeK2SULMlDZntTmDHie9WNG53FHjTaEIiAv0qZjGYuDeL+Jq45
 ECN2BANortysPzXBlY0Qo0q3sVUZbNVZOUI4JwHz7V+3DYvIX1D/dgg9sOURYeTS8ZVN
 gBhqSIocVUtDGYFloLQMmaH9ukiKPEPzmuN6JXsTL7FRhQ5hnst8CGtrNM+M9yR5OQrL ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30vtepgrm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482qv7b138432;
        Fri, 8 May 2020 02:54:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30vtdmp5a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:47 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0482sjjM024620;
        Fri, 8 May 2020 02:54:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 19:54:44 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, hmadhani@marvell.com,
        Jason Yan <yanaijie@huawei.com>, njavali@marvell.com,
        joe.carnuccio@cavium.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: Make qla_set_ini_mode() return void
Date:   Thu,  7 May 2020 22:54:31 -0400
Message-Id: <158890633244.6466.17502687618100970580.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429140952.8240-1-yanaijie@huawei.com>
References: <20200429140952.8240-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 mlxlogscore=913 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 mlxlogscore=960 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005080022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 29 Apr 2020 22:09:52 +0800, Jason Yan wrote:

> The return value is not used by the caller and the local variable 'rc'
> is not needed. So make qla_set_ini_mode() return void and remove 'rc'.
> This also fixes the following coccicheck warning:
> 
> drivers/scsi/qla2xxx/qla_attr.c:1906:5-7: Unneeded variable: "rc".
> Return "0" on line 2180

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Make qla_set_ini_mode() return void
      https://git.kernel.org/mkp/scsi/c/1b007f96f9e0

-- 
Martin K. Petersen	Oracle Linux Engineering
