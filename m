Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9BFC433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BE7420B1F
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:06:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F/vdbKLj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgJHCGY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 22:06:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49182 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgJHCGY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 22:06:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09824RFp175278;
        Thu, 8 Oct 2020 02:06:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=97yZT1cefAY4ZTPsmF9ckUOhMiUfZRa7uRF+Ezhf5DM=;
 b=F/vdbKLjVMknEe5Rz1H/iH/pVZ74AaC9lXy3P0ks0JwM8hmaL1sSrZcMA3KAm8UUqxfz
 T/R4SNlrJlpH7LGIHqjEmP+NO06DNpmFf0wGtUaPoNHVt0dvHYLYAcRblT3N0AS8dl6O
 4b5N+haprl7uFKlDjayqY8BcPmwcCBxP+aqdiebwHl9SwHT4MpthsPcwxBTIkaJNB3Dl
 OZamy6Po0v/yjVHlht5VuziSJ3XzgxNECAZu1NlQWpbN7mAZZXURKRlAW/bRqQ9bK0pm
 q/NMKJyKqwk+5+AvivkM0LZpqvqdHp+o6Q1Tz9Cu2UicvaRdto3Ith+Fo2Uulxk4CaVX CA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33xhxn51y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 02:06:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09824vdk115013;
        Thu, 8 Oct 2020 02:06:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3410k0cfs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 02:06:19 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09826Fwf012435;
        Thu, 8 Oct 2020 02:06:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 19:06:14 -0700
To:     ching Huang <ching2048@areca.com.tw>
Cc:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] scsi: arcmsr: use upper_32_bits() instead of
 dma_addr_hi32()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zh4xzd2z.fsf@ca-mkp.ca.oracle.com>
References: <9846b9ef4f8dcdac543270c3268d1ebb31aad6a7.camel@areca.com.tw>
Date:   Wed, 07 Oct 2020 22:06:12 -0400
In-Reply-To: <9846b9ef4f8dcdac543270c3268d1ebb31aad6a7.camel@areca.com.tw>
        (ching Huang's message of "Wed, 07 Oct 2020 15:20:14 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=921 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=953 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ching,

> 1. Use upper_32_bits() instead of dma_addr_hi32().
> 2. Use round_up() instead of logical operation.

Merged these. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
