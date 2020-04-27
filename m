Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0667EC82C82
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 22:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D669E20775
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 22:50:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ks7DmA5b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgD0WuO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 18:50:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33026 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbgD0WuO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 18:50:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RMmnir073103;
        Mon, 27 Apr 2020 22:49:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=qDMayMbg+FKCS2mjLaz0JLNCqW1XcYuqT5QmYVU1E+w=;
 b=Ks7DmA5br7wukiVPXNNHYVopqnlxwvbnbP2Ty7in6w6Ovw0YDkt70e0hhbynRF/Z3wzN
 tJiQKVzsbreVwtMGrupkziINLHPmCMmkVGu6eX+KRId7bBgoDO0/JF43/OHqzAYjkKBd
 81xAMC2QP3YnMbQD0oF3+R0F7nzWNIhd61TStm6zRtgf7NCCiu2Zb0nIQDnYZqjZMReA
 DB0T+PGAfp19QSsy9jZulfEDY83wZlL3UqP6/QKhx6Rq67JrOSer5/ss8baw1pv9DfVN
 XQuy9p+Uc6Oo7zxtjTvII1qWmOVqL3j6pqEK8FTEIwcmwkCtKQixYkOOpvknv6EFrnF1 8g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30nucfvfy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 22:49:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RMbxWg114119;
        Mon, 27 Apr 2020 22:49:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30mxwx5c54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 22:49:56 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03RMnsnn027962;
        Mon, 27 Apr 2020 22:49:55 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 15:49:54 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com, Jason Yan <yanaijie@huawei.com>,
        jejb@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, avri.altman@wdc.com,
        stanley.chu@mediatek.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: use true for bool variables in ufshcd_complete_dev_init()
Date:   Mon, 27 Apr 2020 18:49:50 -0400
Message-Id: <158802757520.27023.7635538053293481561.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200426094305.24083-1-yanaijie@huawei.com>
References: <20200426094305.24083-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270185
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 26 Apr 2020 17:43:05 +0800, Jason Yan wrote:

> Fix the following coccicheck warning:
> 
> drivers/scsi/ufs/ufshcd.c:4140:6-14: WARNING: Assignment of 0/1 to bool
> variable

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: ufs: Use true for bool variables in ufshcd_complete_dev_init()
      https://git.kernel.org/mkp/scsi/c/7dfdcc393dcd

-- 
Martin K. Petersen	Oracle Linux Engineering
