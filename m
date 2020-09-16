Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F09C43461
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 00:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E447820739
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 00:29:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="v8jyf2LB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgIPA3e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:29:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45788 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbgIPA3b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 20:29:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G0SPDn058075;
        Wed, 16 Sep 2020 00:29:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=JOMCPRO+NynSd8Fx4We8NMAFgKtHKfjlXkUkgCEi4Ks=;
 b=v8jyf2LBhy0LOpEHbZJXU2HfIRoKvFqbT7HYuD7Glf3sEFiwVNM2f0o34KiO3TNvlAwv
 XlRZG3HItiy6V4N8tym1Mx0wzN9KUTJaLI0rfWQvkYhZmiiHD6T7On6Hm2lEGRUfI/FD
 utAYPxj09f/+PrW+EtTtZ8TXeHJgThoowpHVYp5CC5Zl/8OR5Pmaa3mDBWOLE096CY5K
 kc3iPlQXtTaAugoW5eL32oX+Iwqml8XpO5DDiIrPqDvJ5qlHVrw7WeVFmaN72Pv+kmQY
 pa6r2v+qUH6haYA9ynLYOiPNtUZNoEAzBad+gbCTKfEqAu6IkqgFxSLuu6jk59x/8ImL zA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33j91dhsq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 00:29:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G0AhhG089974;
        Wed, 16 Sep 2020 00:29:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33h890afu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 00:29:27 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08G0TQiW021342;
        Wed, 16 Sep 2020 00:29:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 00:29:26 +0000
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/3] Improve error handling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tuvy1s5r.fsf@ca-mkp.ca.oracle.com>
References: <20200910074843.217661-1-damien.lemoal@wdc.com>
Date:   Tue, 15 Sep 2020 20:29:24 -0400
In-Reply-To: <20200910074843.217661-1-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Thu, 10 Sep 2020 16:48:40 +0900")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 mlxscore=0 bulkscore=0 mlxlogscore=774 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=806
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160001
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> A small series to improve command error hadling.
>
> The first patch is a simple code cleanup. The second patch updates
> asc/ascq sense codes list. Finally, the third patch adds zone resource
> errors handling for zoned block deives to return BLK_STS_DEV_RESOURCE,
> similarly to what the NVMe driver does for ZNS devices.

Applied 1+2 to 5.10/scsi-staging. I'll wait to see where the BLK_STS
stuff lands before applying patch 3. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
