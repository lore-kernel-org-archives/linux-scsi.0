Return-Path: <SRS0=AAGU=DU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 190C2C433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C96C021D7A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:43:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tgJP/A3m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgJMWnW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 18:43:22 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46806 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgJMWnU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 18:43:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMYVZJ143624;
        Tue, 13 Oct 2020 22:43:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=TFlRI5MNpsaiIVg+BXhzUzXGZGooOPAo9AUn2HTcu/k=;
 b=tgJP/A3mmSbMW14AMUMEWQnEfIvstm4yiFihDUdWgmxCKTemf0CuaNy10qxPrLDpBmvm
 Fz+bashN0OcECBxs04anOfA2I6nb+Qw5jSapAKD+M4dYHhn2nX6P6N/S7T7UXe3pMHLw
 IlZe0WwIid4PHmeJw/v/DQVaP8o0GjwORpwjS4TDsLr7mqIR1z1L9dSJgZDIsSr95eeR
 mA5wyUSTWSN1n7kBJxljGwiw7FLmC3aLK8zqe6cAA1O/wnECee22uzZlQIakzYPkx4ri
 VT2DFVc4OqUh/gszKi3FbpTp0U6iWEvl6eU4CXwXnb84j7QWBobNKvfsLlDlOuW882Wx Ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 343pajucqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:43:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMaWCb049038;
        Tue, 13 Oct 2020 22:43:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 343pvx1smd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:10 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09DMh8St009844;
        Tue, 13 Oct 2020 22:43:08 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:07 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Colin King <colin.king@canonical.com>,
        Pavel Machek <pavel@denx.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: fix return of uninitialized value in rval
Date:   Tue, 13 Oct 2020 18:42:45 -0400
Message-Id: <160262862435.3018.1712796250437801581.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201008183239.200358-1-colin.king@canonical.com>
References: <20201008183239.200358-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010130158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 8 Oct 2020 19:32:39 +0100, Colin King wrote:

> A previous change removed the initialization of rval and there is
> now an error where an uninitialized rval is being returned on an
> error return path. Fix this by returning -ENODEV.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Fix return of uninitialized value in rval
      https://git.kernel.org/mkp/scsi/c/1ef16a407f54

-- 
Martin K. Petersen	Oracle Linux Engineering
