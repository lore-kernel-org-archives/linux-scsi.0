Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9861FC3F68F
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 05:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EB1B20838
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 05:34:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n1Zn+uUK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgAJFeW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 00:34:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50342 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgAJFeW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2020 00:34:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00A5NNMX031215;
        Fri, 10 Jan 2020 05:33:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=IY5ypyWB8E0NmjrXstQmSbrKj69APzR1aWp/wYV3cCM=;
 b=n1Zn+uUKIbGajBv+fxV0zAXxrdFGkcPLS5xYgLavxm4mmAnjqQ0PgL5ryM6p7aXpgq37
 hEPh1k96klPemk7mZ8fDXrR+cU1C+OWj2JjeU3npupNb6rA7uo7jEpWvvZK86QW4ZwUh
 s6JwpoT4q5dPR5Ln4WgCknvgueVVorv+c/uF2ViQJBcpMvwOxwkTFw3F4lFUgI1JlaFJ
 pOVMkDjP3CqLHRDJYg9P9LfKlTe5ST/cvz433esof96u3kCogSV5q1vjNUhgsetRe8vC
 65NJXlD0hY/OltdB4kCs0eyY8HxoJQmQ7pEEQq7ZjPpPKZhFO8k3g6j726OZYC1P6DgE vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xajnqfq75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 05:33:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00A5Oge4175226;
        Fri, 10 Jan 2020 05:33:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xeh8yxj4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 05:33:40 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00A5XVT1011528;
        Fri, 10 Jan 2020 05:33:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 21:33:31 -0800
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block\@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme\@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel\@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc\@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "axboe\@kernel.dk" <axboe@kernel.dk>,
        "hare\@suse.de" <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Bates <sbates@raithlin.com>,
        "msnitzer\@redhat.com" <msnitzer@redhat.com>,
        "mpatocka\@redhat.com" <mpatocka@redhat.com>,
        "zach.brown\@ni.com" <zach.brown@ni.com>,
        "roland\@purestorage.com" <roland@purestorage.com>,
        "rwheeler\@redhat.com" <rwheeler@redhat.com>,
        "frederick.knight\@netapp.com" <frederick.knight@netapp.com>,
        Matias Bjorling <Matias.Bjorling@wdc.com>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <BYAPR04MB5749820C322B40C7DBBBCA02863F0@BYAPR04MB5749.namprd04.prod.outlook.com>
        <fda88fd3-2d75-085e-ca15-a29f89c1e781@acm.org>
Date:   Fri, 10 Jan 2020 00:33:27 -0500
In-Reply-To: <fda88fd3-2d75-085e-ca15-a29f89c1e781@acm.org> (Bart Van Assche's
        message of "Wed, 8 Jan 2020 19:18:54 -0800")
Message-ID: <yq1pnfrx4d4.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001100047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001100047
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> * Copying must be supported not only within a single storage device but
>   also between storage devices.

Identifying which devices to permit copies between has been challenging.
That has since been addressed in T10.

> * VMware, which uses XCOPY (with a one-byte length ID, aka LID1).

I don't think LID1 vs LID4 is particularly interesting for the Linux use
case. It's just an additional command tag since the copy manager is a
third party.

> * Microsoft, which uses ODX (aka LID4 because it has a four-byte length
>   ID).

Microsoft uses the token commands.

-- 
Martin K. Petersen	Oracle Linux Engineering
