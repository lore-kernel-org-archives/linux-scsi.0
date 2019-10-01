Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA44BC35280
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 02:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9116521855
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 02:47:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V+DvV5F6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731164AbfJACrJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 22:47:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33186 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbfJACrI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 22:47:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x912ietS072998;
        Tue, 1 Oct 2019 02:47:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=5ajElRluRaDKmT5qKWoKBEmQyom0UcLIBvK/0WLe5eg=;
 b=V+DvV5F6+WlAFpiSjX6wI5RguXjWveujZ3MiVOzT0yon9e+I5ErgkoE0tgQiIgJCnbEK
 tJ3sv+rUT18dCyvfhYSnuDeQ9jk178OrtUIFpg7YBI5IgtfNHlEVfSy6TxNTkm++e4My
 ml/bvjE/vRpR/Q+2EJHIO2JX5nxJmbM0Uqe+sW6g/BP165RjvrhFaOHpUvm1t8q4gnUv
 Q0v0UajJ87AaUT704wa1xnclF+SI9UrxcPqeMUfLJAvhe6DQ+Fh0JTulGiO4gzwV/2au
 W8Fwe1KpDUOzmf69J1RNO465nFWVpuxPLqQnmd256J3CbTZ0RUgaWHNQ+6YRS3VbqMgX MA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v9yfq2ue2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 02:47:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x912hoZw039376;
        Tue, 1 Oct 2019 02:47:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vbnqbv7v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 02:47:02 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x912l1WR023898;
        Tue, 1 Oct 2019 02:47:01 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 19:47:01 -0700
To:     Colin King <colin.king@canonical.com>
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ips: make array 'options' static const, makes object smaller
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190906164522.5644-1-colin.king@canonical.com>
Date:   Mon, 30 Sep 2019 22:46:59 -0400
In-Reply-To: <20190906164522.5644-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 6 Sep 2019 17:45:22 +0100")
Message-ID: <yq15zl9yyfw.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=945
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> Don't populate the array 'options' on the stack but instead make it
> static const. Makes the object code smaller by 143 bytes.

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
