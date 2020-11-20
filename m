Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE5EC63697
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:02:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CA3122267
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:02:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yWfGxlwF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgKTDBu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:01:50 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55748 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgKTDBt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:01:49 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK2eNsJ187752;
        Fri, 20 Nov 2020 03:01:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=5yz/22Yl6G08HXwAcwpfyNgEoOLNAYM3Qe1qZAv0RRQ=;
 b=yWfGxlwFHHt9jOJZdLBNuwtbYtjzxHWlS1Xvxo3lOdrSaBuoJ/IApnRIgrlv01+TWSUi
 DDws3kJYDlSfW1N4fKOVhZgHBSES3oQn3EClCG7Y1EIz/oTNpX3FXTJNxkqQ9m/kp3Wf
 00N3n+tYU/NLDPrJkEsiRQBEIDEHhEiQnNQ7cr4EaFlS+n+6V1vq3NC+esph2sK6ecoB
 bUfUBjjyBV2DKkl4dOaoLzlCIsow2d+Oo+7+A1BS9nJ9mqalPnETMkOpYwuYj5iOY53T
 NFy67J5MbZJepz8VeA7fnMfBFCat+5Va5fUmZsr1NKTQVaZCq/QygKIVTzPWSHj+snRU bA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34t4rb8s7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:01:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK2dioV164044;
        Fri, 20 Nov 2020 03:01:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34ts0unx6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:01:30 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AK31QII003940;
        Fri, 20 Nov 2020 03:01:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:01:26 -0800
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com
Subject: Re: [PATCH v5 0/5] scsi: ufs: add some fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11rgozq8a.fsf@ca-mkp.ca.oracle.com>
References: <20201117165839.1643377-1-jaegeuk@kernel.org>
Date:   Thu, 19 Nov 2020 22:01:19 -0500
In-Reply-To: <20201117165839.1643377-1-jaegeuk@kernel.org> (Jaegeuk Kim's
        message of "Tue, 17 Nov 2020 08:58:32 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=906 adultscore=0
 bulkscore=0 suspectscore=1 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=918 adultscore=0 phishscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jaegeuk,

> Change log from v4:
>  - add more fixes

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
