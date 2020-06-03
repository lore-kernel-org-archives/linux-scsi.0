Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07348C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 01:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCBAA207D0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 01:29:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R03uG6E8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgFCB3a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 21:29:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36040 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgFCB3a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 21:29:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0531S5FO096333;
        Wed, 3 Jun 2020 01:29:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=vXx55ivSFag0AtdoTsVakOCgzcXQe7hrRoJVFEGMHIo=;
 b=R03uG6E8j6wAMohVd1HfV0ayys5VKj+s4OHVrUHwHA7nPdAhTEhpru7elhY501z3JFbi
 6sQLlyupE/IzoV9XwDTup5Gpz45HRf9PS6yRwnp0fWcf2c5jykXKyoxoxc6CcZNRP4l4
 AkhYJAfRKoBFwpoHSAdk1z8BjwvVhRuiOSwiH9oV7cVyUlPofR9A3jVbbIxpiI8famvp
 W90+bS21C5eEMUx3pbt8YusKpY/y0/y5q9x2MFVnzDwDIhOKBLkB8hUk87Sz4OsrCwZU
 rOBTFuSlaEH2rG/TbOJuyJEBslO2GrEL0TazecdHSEVgIo70JwGgdbP7m7hYPH8j+Czq Rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31dkrukrpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 01:29:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0531RwM4057888;
        Wed, 3 Jun 2020 01:29:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31c25qjnpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 01:29:14 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0531TCTF029562;
        Wed, 3 Jun 2020 01:29:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 18:29:12 -0700
To:     =?utf-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= 
        <kai.makisara@kolumbus.fi>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v2] scsi: st: convert convert get_user_pages() -->
 pin_user_pages()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1d06h9bvv.fsf@ca-mkp.ca.oracle.com>
References: <20200526182709.99599-1-jhubbard@nvidia.com>
Date:   Tue, 02 Jun 2020 21:29:09 -0400
In-Reply-To: <20200526182709.99599-1-jhubbard@nvidia.com> (John Hubbard's
        message of "Tue, 26 May 2020 11:27:09 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006030008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 suspectscore=1 malwarescore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 cotscore=-2147483648 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030008
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> This code was using get_user_pages*(), in a "Case 1" scenario (Direct
> IO), using the categorization from [1]. That means that it's time to
> convert the get_user_pages*() + put_page() calls to pin_user_pages*()
> + unpin_user_pages() calls.

Kai: Please review.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
