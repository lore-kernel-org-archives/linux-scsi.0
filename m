Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A841BC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 20:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 888F020657
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 20:20:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="u/O2MEJT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgGOUUN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 16:20:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42278 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgGOUUN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 16:20:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FKC9aj035619;
        Wed, 15 Jul 2020 20:19:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=peZ+vRId/ykXQLD5oamoNCCTsVfZ602Lx7lqj/8gGks=;
 b=u/O2MEJT5hTpPHg2Knqp+4T+7D7JXuVwi2Hs8num47piMyNm1pZRlhcJ+1oVV2SBvHZw
 T3SECeP+gkVSb8vWHAgM6Yt4p3yx8AP/26iFTHygrsmXr/itr73U/S0ioarUSRAdM4Ke
 yfcuPTBF0EZOkuQ/+kixeHDFUzZPNF1tpZX5SqlYfzn+QYmCTFuq9OKfNRmZHZQOMsmn
 xNKhFEFZ7G/nXN6vBuKNwNZO+vDiW4Y6+GgQOojFl8TOd90t4hrTOTxv9mB7vi63D58+
 /GNz10w2JShFFzjVLMb4LmrhWi2A6oRdfj+v4MrX55SEzA9csHdJ28g2Bvdcn8TSncgd Mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3274urdnvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 20:19:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FKHeuL107174;
        Wed, 15 Jul 2020 20:19:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 327q0rxbcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 20:19:55 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FKJmxW006290;
        Wed, 15 Jul 2020 20:19:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 13:19:47 -0700
To:     Niklas Cassel <niklas.cassel@wdc.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Export max open zones and max active zones to sysfs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mu40o7jj.fsf@ca-mkp.ca.oracle.com>
References: <20200714211824.759224-1-niklas.cassel@wdc.com>
Date:   Wed, 15 Jul 2020 16:19:42 -0400
In-Reply-To: <20200714211824.759224-1-niklas.cassel@wdc.com> (Niklas Cassel's
        message of "Tue, 14 Jul 2020 23:18:22 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150155
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Niklas,

> Export max open zones and max active zones to sysfs.

Looks fine.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
