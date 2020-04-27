Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D65C54EEB
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70246206E2
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:23:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rf906eRb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgD0UXn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 16:23:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56722 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbgD0UXm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 16:23:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKNZI3146115;
        Mon, 27 Apr 2020 20:23:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=gJg86o4qkIqkS+1E64wnRb83FVark41cnwWmAjm6xus=;
 b=rf906eRbxnkMrg0shfSwKv1IyDXd58Tuku1eKgQw+ZIBU6QpU4P6xeXzykEpGQZd5Ko5
 OfSFaxGkFsWzH6N6MspNeakRx5+iOzPgEjVHbyLLtfR3tvZqbn7FlnhHfbQUZQemfQH7
 irI9QsGWfgwPWwSTX1zmkAHGtfIMRppTR9Byns0ktPdCqXbliw3OPzWExIBjqnK9oexm
 e9lrKiD640CXUX5LZ+HMxlYcXnFWtYQriLwQ6bHy/W3LwSNIO3aSSZajevEcxzOnZrKv
 6tc02p2SwpBTQnAqtzekF4nj6GxvE2gtUD9CUL2t+UP8b5xHDPzisidBSk9rMNt2p26K GA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30p01nje6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:23:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKBpYv060342;
        Mon, 27 Apr 2020 20:21:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30mxwwwfx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:21:34 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RKLXDU006431;
        Mon, 27 Apr 2020 20:21:33 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 13:21:33 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-kernel@vger.kernel.org, sebaddel@cisco.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org, kartilak@cisco.com,
        Jason Yan <yanaijie@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: snic: make snic_io_exch_ver_cmpl_handler() void
Date:   Mon, 27 Apr 2020 16:21:22 -0400
Message-Id: <158777063304.4076.1514687099923506496.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200418070615.11603-1-yanaijie@huawei.com>
References: <20200418070615.11603-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=635 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=690 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 18 Apr 2020 15:06:15 +0800, Jason Yan wrote:

> This function do not need a return value and no users use it's return
> value. So we can make it void.
> 
> This also fixes the coccicheck warning:
> 
> drivers/scsi/snic/snic_ctl.c:163:5-8: Unneeded variable: "ret". Return
> "0" on line 228
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: snic: Make snic_io_exch_ver_cmpl_handler() return void
      https://git.kernel.org/mkp/scsi/c/6942d531e2d2

-- 
Martin K. Petersen	Oracle Linux Engineering
