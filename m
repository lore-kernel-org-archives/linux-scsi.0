Return-Path: <SRS0=mW7r=XC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F95EC43331
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Sep 2019 19:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3576421744
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Sep 2019 19:32:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EObHS0rC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfIGTcR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Sep 2019 15:32:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60896 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbfIGTcQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Sep 2019 15:32:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87JSgOu104208;
        Sat, 7 Sep 2019 19:32:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=SgGFU7IMYi6ERDbbjxl0LB9XovWkwsv9kTnuq2X2GFE=;
 b=EObHS0rCY7PLI6MpIBcAzUG8CLtqDDGITKlWr7Y7eDV8VfshotWcE9tqzKCacy1cjmrf
 Lcuf7NB+SuO05cNJ9L0RqqlzneKP13MdD1sNqB50TJ7WPWM7siO0TWUvOvVKjxuPN6n5
 fvzOdVubV9ZMwloKhvDV5ZPlym81xsjPhUoBYN2fA9F08T2LG63szbWCvVduktR7DPnf
 yqs4xwn10nnxmvwyaduthoUMyMMYVghIYU/z/mEbasNa5VCOdifZrS0K1X5Ep39IiMbz
 /cmemBT2BdoFpxzArQTk4wy50apP+b+1iNBb43AUDKtF3xpxEg26u68Jli8/8EpS9VIs 4w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uvjr3g04q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 19:32:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87JSkhH181250;
        Sat, 7 Sep 2019 19:32:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uv4d0efkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 19:32:14 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x87JWDYN016114;
        Sat, 7 Sep 2019 19:32:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 07 Sep 2019 12:32:12 -0700
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: Improve unaligned completion resid message
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190828053511.14818-1-damien.lemoal@wdc.com>
Date:   Sat, 07 Sep 2019 15:32:10 -0400
In-Reply-To: <20190828053511.14818-1-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Wed, 28 Aug 2019 14:35:11 +0900")
Message-ID: <yq1y2yzkimd.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=813
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909070210
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=893 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909070211
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> For commands completing with a resid not aligned on the device logical
> sector size, also print the command CDB in addition to the current
> message to help debug hardware generating such incorrect command
> completion information.

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
