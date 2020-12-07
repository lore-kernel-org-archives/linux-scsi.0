Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 754CFC433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 23:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B62D23A1C
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 23:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgLGXcu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:32:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41354 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbgLGXct (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 18:32:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7NTdVV030111;
        Mon, 7 Dec 2020 23:32:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=7VGQsa+Nbk8oaQWOKQT29bcJvT1R2NMaFM6EEoJVzyA=;
 b=KKtQ/Tny5hgCWYm1E/KQP5cgg32yKNSxeCLvcR5CwBUN8FN1qNarth5gMJH+lJZrQsdN
 re9HNlXDO9m6RdLEbwavW3WEkTEdPPxShAVcM+NVNL+MyLDudUNJSCowNWKDUkU8u9vI
 JPYKOCVDiLCQnEAGTSlNaYRAFoc/w+OQ5jzGTnYuU6Fppip8y6eHHG1FgSWFQ3ZSCIAS
 68o4S4+PTfFSTaKnRVS+XhhuRlqORNXa1T8FTOvXgNeMNDMpYrWbcX3GXIILnbThb6MI
 qqzhL/JV11JSNDM/KBqqVF1FQwlL/7voyWBqe/sb02a/0QQu6dokD5ST/eowDlpUs00+ fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35825m04n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 23:32:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7NUTNx050208;
        Mon, 7 Dec 2020 23:32:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 358m3wywt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 23:32:02 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B7NW0m2012443;
        Mon, 7 Dec 2020 23:32:00 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 15:32:00 -0800
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH V7 0/3] Minor fixes to UFS error handling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtyp19en.fsf@ca-mkp.ca.oracle.com>
References: <1606910644-21185-1-git-send-email-cang@codeaurora.org>
Date:   Mon, 07 Dec 2020 18:31:57 -0500
In-Reply-To: <1606910644-21185-1-git-send-email-cang@codeaurora.org> (Can
        Guo's message of "Wed, 2 Dec 2020 04:04:00 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=1 mlxscore=0 mlxlogscore=604
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=618 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070155
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> This series mainly fixes below two things which come along with UFS error
> handling in some corner cases.
> [1] Concurrency problems btw err_handler and paths like system suspend/resume/shutdown and async scan.
> [2] Race condition btw UFS error recovery and task abort which happens to W-LU during suspend/resume/shutdown.

Applied to 5.11/scsi-staging, thanks!

Stanley: Please verify conflict resolution with your event notification
series.

-- 
Martin K. Petersen	Oracle Linux Engineering
