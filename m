Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF93C64E7B
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33FA522256
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:32:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sc3CWN2/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgKTDcM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:32:12 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59688 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgKTDcL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:32:11 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3OJNO154667;
        Fri, 20 Nov 2020 03:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=B5dAIWNAWxpxpo5GDliSJO+sq7nWXhLzfFffoPKdA3A=;
 b=sc3CWN2/I+B5fF96vaDKLVsNowdMqN7P9/Ml0pbvZANGBLAwxXwG9LttokJrhgaKMJqF
 fV4PXNvti4e4KmxpX/Uhe7eX4fVovJKw70n6M3oJZoIhDO88IZnvF18CH2Zs23l+Sw03
 WH091XXhQoiBlnX4bw7Cwa/ARDWMnoZWYKh/I8J11K+O7Y7rUhF6JszVmDqMAGnoOoA0
 mzpbgED5BBElxgrIMdaI525hnpokbnSLIwsn+TbMujaz7JSDV1ca8F+S6H5Bbo1fCxA6
 C05fOtyGqfr6G3U6hVlHAX60d41v+pmvBud5Bwzlp2Sz53pA3krWfzliiT4MkP2LR775 IA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34t7vngp5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:31:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3PPFi032562;
        Fri, 20 Nov 2020 03:31:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34umd2w0v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:31:54 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AK3VqZN011039;
        Fri, 20 Nov 2020 03:31:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:31:51 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        Stanley Chu <stanley.chu@mediatek.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        cang@codeaurora.org, bvanassche@acm.org, cc.chou@mediatek.com,
        linux-mediatek@lists.infradead.org, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, asutoshd@codeaurora.org,
        jiajie.hao@mediatek.com, peter.wang@mediatek.com,
        matthias.bgg@gmail.com, linux-arm-kernel@lists.infradead.org,
        chun-hung.wu@mediatek.com, beanhuo@micron.com,
        alice.chao@mediatek.com
Subject: Re: [PATCH] scsi: ufs: Add retry flow for failed hba enabling
Date:   Thu, 19 Nov 2020 22:31:44 -0500
Message-Id: <160584262850.7157.8410136729002405136.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201112054537.22494-1-stanley.chu@mediatek.com>
References: <20201112054537.22494-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 12 Nov 2020 13:45:37 +0800, Stanley Chu wrote:

> Once hba enabling is failed, add retry mechanism and in the
> meanwhile allow vendors to apply specific handlings before
> the next retry. For example, vendors can do vendor-specific
> host reset flow in variant function "ufshcd_vops_hce_enable_notify()".

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: ufs: Add retry flow for failed HBA enabling
      https://git.kernel.org/mkp/scsi/c/6081b12ceb7d

-- 
Martin K. Petersen	Oracle Linux Engineering
