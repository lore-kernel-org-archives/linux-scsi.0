Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B76CC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7B9320734
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F5ZC2J77"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgFJC1k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 22:27:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53970 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgFJC1i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 22:27:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05A2QPiZ139299;
        Wed, 10 Jun 2020 02:27:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=ELt5ueHlKvPbb2jU3C8rLa/P2s/Mvvoqw609o7bcY6I=;
 b=F5ZC2J77kaPhPuW74M8O7YKOIRH46D4lUcbP5Oc81u0DW7+6fnY/6VbPd/3ckUz70DiM
 JIrJowohKE7q/d7hNDlkc7uY6jY9UMo263z2DoacL5/MH/KmHOfcuXii+I8vg8oUleSf
 j6TzLbNZfuQANeJTdZMWZzeR/Syxrcfa6Of/e+oa0tgsYmT9zIWWDpKIMto4YuluXlxo
 5nS53scDWMsEtPSzsBrpaDPDpX5Dmdn7Y1zxd0GAP9sN7e0nVh7yQVTegLlrC+IUwvT2
 cQdm9CHiy3VmOf/bsshaqX9KVIBy7fcb/zyF6U0ClNeHp1NxtJh5e3DpkbhcQa29UpVI Bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31g3smyspn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 10 Jun 2020 02:27:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05A2OQ7M110510;
        Wed, 10 Jun 2020 02:27:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31gmwsck4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jun 2020 02:27:36 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05A2RZJm027649;
        Wed, 10 Jun 2020 02:27:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jun 2020 19:27:35 -0700
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: Use sd_first_printk() where possible
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18sgvsllr.fsf@ca-mkp.ca.oracle.com>
References: <20200608045746.1275523-1-damien.lemoal@wdc.com>
Date:   Tue, 09 Jun 2020 22:27:33 -0400
In-Reply-To: <20200608045746.1275523-1-damien.lemoal@wdc.com> (Damien Le
        Moal's message of "Mon, 8 Jun 2020 13:57:46 +0900")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=838 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006100017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=1
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=889 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006100017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> In sd.c and sd_zbc.c, replace sd_printk() calls conditional to
> sdkp->first_scan with calls to sd_first_printk(). This simplifies the
> code (no functional changes).

I'm currently digging in this area trying to completely revamp the
revalidate stuff to accommodate a few broken devices we have come
across. The first_printk stuff is going to change substantially.

-- 
Martin K. Petersen	Oracle Linux Engineering
