Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 537C3C5DF62
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 05:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AC33217D7
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 05:07:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HXdpk5CQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbfKFFHU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Nov 2019 00:07:20 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46514 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfKFFHU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2019 00:07:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA654TsV093302;
        Wed, 6 Nov 2019 05:06:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=YMhSsJfuFzX8NKIE55Z0ruUkOlafspbftt4YU5VrHOE=;
 b=HXdpk5CQx5RJHpOjFPn9d6znF/L290F3W1M2AFUCA38YhMRqU55qIaLCTsVk+5ZYLfi5
 fa8LZtGr7FgpDSgEVJ7Xwm90t53UpfW41iUaBSVUw34yfhAvNTA7d9AObqxDVjGKkjwa
 wU3upc7U24WOmmmZ0gGQqtrv1s5tEcCn81etOmSckZSnK6TIiqbgy9ULt9JrCFAb58mB
 n9oPQiD8UT/bnpbpLYeZ534QeK3pXo0MhFWvA+oV7nZAU/FfE4VUBC3ql+kOvdUFymG6
 /u0LGGkK+PLEwtterxwbJOa5903eRo4Eh8zDYydXfr2vh0F8m/MEnHDJylQhS76aN8YZ dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w12erb19k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 05:06:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA654RNI060685;
        Wed, 6 Nov 2019 05:04:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2w2wcnqkf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 05:04:54 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA654oYk019310;
        Wed, 6 Nov 2019 05:04:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 21:04:49 -0800
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Alim Akhtar <alim.akhtar@gmail.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH 3/3] ufs: Remove .setup_xfer_req()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191029230710.211926-1-bvanassche@acm.org>
        <20191029230710.211926-4-bvanassche@acm.org>
        <MN2PR04MB69914B9FA252E1B0A05493BAFC600@MN2PR04MB6991.namprd04.prod.outlook.com>
        <MN2PR04MB6991FD5665C0C1E7DEF7854BFC7F0@MN2PR04MB6991.namprd04.prod.outlook.com>
        <CAGOxZ51AHByBFsMiKG_-pGjVe4=1ijQnUipS=Gjq1pYPsCKQGA@mail.gmail.com>
        <CAGOxZ53xoaFrs09KfPFHfR69-n9SnRrZ0uESE65e+Wgwe3Pr7A@mail.gmail.com>
        <5dd9deb7-77c7-332c-6001-c6d232fa7f0d@acm.org>
Date:   Wed, 06 Nov 2019 00:04:47 -0500
In-Reply-To: <5dd9deb7-77c7-332c-6001-c6d232fa7f0d@acm.org> (Bart Van Assche's
        message of "Tue, 5 Nov 2019 20:45:01 -0800")
Message-ID: <yq1y2wt1tow.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=681
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060053
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=756 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060053
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Thanks Alim for having looked up this information. Let's drop this
> patch.

Dropped from 5.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
