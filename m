Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8FFC82C82
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 22:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53FB3208FE
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 22:50:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O4Xu+i0t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgD0WuB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 18:50:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39604 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgD0WuA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 18:50:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RMnNm1009357;
        Mon, 27 Apr 2020 22:49:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=sLggsoEFtGniqF0JPb7gUbtB/mnUevIpZo7E3ptmJVQ=;
 b=O4Xu+i0trWDn+gknwrUqGzYYwusfK/6Jm1j2YA70P7PqftL2poQsgRBW/6xohHvMBy5d
 EKRbrcIlVSLGeTl/7LVm5zWw8CcnFbbLysudVJNvLFm5VCAvlmWOIz/7qqfEt52YYDZb
 t219LgNF/19LFF4JWMlBZvvADEvUftA4lF1NQQMaBYZEHSN/MvSR206UBvuf7uqIPsDT
 MXo3pItIpw3bkFGwx4I6F4NRHtFilyFFANxF9ZVDrKagm8UFqClU4xyTyw2KRDtdor3B
 68zEBLFbPMTuKaBdFjW2cfJIMKPFyiNBCOd2YVo6BMEJtZSsSOk2qd39AsckxzFnUbJg 6Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30p2p01w0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 22:49:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RMci17113010;
        Mon, 27 Apr 2020 22:49:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30mxpe9crb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 22:49:54 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RMnqCH012401;
        Mon, 27 Apr 2020 22:49:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 15:49:52 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Merlijn Wajer <merlijn@archive.org>
Subject: Re: [PATCH] sr: Use {get,put}_unaligned_be*() instead of open-coding these functions
Date:   Mon, 27 Apr 2020 18:49:48 -0400
Message-Id: <158802757521.27023.12691315116947855783.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200427014844.12109-1-bvanassche@acm.org>
References: <20200427014844.12109-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=880 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=951 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270185
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 26 Apr 2020 18:48:44 -0700, Bart Van Assche wrote:

> This patch makes the sr code slightly easier to read.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: sr: Use {get,put}_unaligned_be*() instead of open-coding these functions
      https://git.kernel.org/mkp/scsi/c/655da8e57a46

-- 
Martin K. Petersen	Oracle Linux Engineering
