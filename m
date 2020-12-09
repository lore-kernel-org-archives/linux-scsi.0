Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BF6C4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 02:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B8D323A53
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 02:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgLICU0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 21:20:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60510 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgLICU0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 21:20:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B92JW2f182600;
        Wed, 9 Dec 2020 02:19:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=nZYjrGGwDwfThZmI9/f1v1fyLzckJb4SQFat3NYmYtc=;
 b=yKW2vB0zmj6LAIN1JiEZH0tqoRqrHd5Bne89R9nfeMus/uDML3b5Rv6NvDGxGvELjEHx
 w45xkzFd2qyVLSbonD3sq+huYfsAhaybrR1GBErbPZFoqgdbLB02HVhd6rYcDZ38q2fw
 Wa03r1xKNs6kS8eABb9YT+ncfHmxQfZnnhDXsCW+xBX9F7v2YBG/jLsxnVqkxS7B2a7y
 FXS/g94sHxkQhH+T0rIs7kOIU+E1H65/luCnL3ZiXCg2LdVi68ceLdqoweuS2F7+TIU3
 wVpqH3wRcjOuake4/dILMJmC736Z8zZTeLmGixktdDlLn/CHcS/bqBKJ9Ab5kmPD7JLJ 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35825m5wy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 02:19:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B92AVUx049869;
        Wed, 9 Dec 2020 02:19:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 358m3ykdmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 02:19:32 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B92JS89015830;
        Wed, 9 Dec 2020 02:19:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Tue, 08 Dec 2020 18:17:58 -0800
ORGANIZATION: Oracle Corporation
MIME-Version: 1.0
Message-ID: <yq15z5bu3hw.fsf@ca-mkp.ca.oracle.com>
Date:   Tue, 8 Dec 2020 18:17:55 -0800 (PST)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] two UFS changes
References: <20201207190137.6858-1-huobean@gmail.com>
In-Reply-To: <20201207190137.6858-1-huobean@gmail.com> <(Bean> <Huo's>
 <message> <of> <"Mon> <> <7> <Dec> <2020> <20:01:35> <+0100")>
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090013
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean,

> Bean Huo (2):
>   scsi: ufs: Remove an unused macro definition POWER_DESC_MAX_SIZE
>   scsi: ufs: Fix wrong print message in dev_err()

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
