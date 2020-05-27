Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A75E5C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F586207D3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:13:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CysZYNWi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgE0CNR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 22:13:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41360 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgE0CNQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 22:13:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R2C1r2057373;
        Wed, 27 May 2020 02:13:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=V9/ddRs+s6zlLZTM4H2U9lU0S4GWlEzFY0+6zXoWmOU=;
 b=CysZYNWi8N4MyVrKx2GXnBO9T+iDAVvYx4u57XAzaASMrowOlG2zqUKf6dC+exkarbUC
 w8DP3F+q8U+N2/jg8K3a6BndEp2gVwBVEKyVpDN1soxXjxUqzMiC+8v5ttgAVYGFD7Mu
 HUOWm5xai7w3J6FDo0NIBc5U9Mz4NCFeA+Ax971nVYowJVjepn9GEn0FQc0KdqMjR0bS
 jhnPqoYC7xh8hZ4ymgOVb3R33FuHmJULskhYEybKGZstmt489SY5CpDR436x7ZKH0Fvq
 OgX3mEfsdpkNpyJp70i0STF7fR0hRAqL/Otx+8n0iZpbghitwYvlN99rgEwvOHfjW54W DA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 318xbjvym4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 02:13:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R2CoVR060320;
        Wed, 27 May 2020 02:13:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 317dryjtup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 02:13:10 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04R2D9js017230;
        Wed, 27 May 2020 02:13:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 19:13:09 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Christie <mchristi@redhat.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: target: tcmu: Fix a use after free in tcmu_check_expired_queue_cmd()
Date:   Tue, 26 May 2020 22:12:55 -0400
Message-Id: <159054550934.12032.1754394879666854643.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523101129.GB98132@mwanda>
References: <20200523101129.GB98132@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=923 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=972 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 cotscore=-2147483648
 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005270013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 23 May 2020 13:11:29 +0300, Dan Carpenter wrote:

> The pr_debug() dereferences "cmd" after we already freed it by calling
> tcmu_free_cmd(cmd).  The debug printk needs to be done earlier.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Fix a use after free in tcmu_check_expired_queue_cmd()
      https://git.kernel.org/mkp/scsi/c/9d7464b18892

-- 
Martin K. Petersen	Oracle Linux Engineering
