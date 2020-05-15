Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0230CC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 00:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC8D8206D8
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 00:21:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ppTMkdbZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgEOAVu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 20:21:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49206 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgEOAVu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 20:21:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F0LUWl191258;
        Fri, 15 May 2020 00:21:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=ETSBHDCL7TNRxPWmHsl09jWxyBGnYxZ+hLUh9qKhCcs=;
 b=ppTMkdbZ+nYtAAAWpouZ81dznyu4TyjDI4vHgEMtudXs6n9gUz+LYlfmNy5EMjPC2W7p
 RzcRvdYJAzDzHxytzEgt7ak+tT4WvTuLYkyIPiEwE4xnHNuMjGNb3XGfc0BVJz2M2Fon
 n1PE13Ug6Xmdt/hYwmysbCAZB5SGbdSV6oQMx1VGUFaFZ5WBsQOT5gL1pil/pGPeiONR
 kULjIgVt7C8KD3J6wTM9jaYWhaNVsyPFGiV7bdE2CkrBR5oZIuLE2FgfRcaoNp7dExhX
 s0xBw1oi6+Mw/73Fz/TNlmrO3tgHeo+8M/xk68vATLv6n1taa/AR/vxeFrYMqc7UDOh0 YA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3100xwnwqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 00:21:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F0IkN8132809;
        Fri, 15 May 2020 00:21:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3100yqbmau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 00:21:37 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04F0LZNe004467;
        Fri, 15 May 2020 00:21:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 17:21:33 -0700
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        Paul Ely <paul.ely@broadcom.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: lpfc: Fix a use after free in
 lpfc_nvme_unsol_ls_handler()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200512181909.GA299091@mwanda>
Date:   Thu, 14 May 2020 20:21:30 -0400
In-Reply-To: <20200512181909.GA299091@mwanda> (Dan Carpenter's message of
        "Tue, 12 May 2020 21:19:09 +0300")
Message-ID: <yq1y2purqt1.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=724 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=753 clxscore=1011 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150001
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> The "axchg" pointer is dereferenced when we call the
> lpfc_nvme_unsol_ls_issue_abort() function.  It can't be either freed or
> NULL.
>
> Fixes: 3a8070c567aa ("lpfc: Refactor NVME LS receive handling")

This fix needs to go through the NVMe tree.

-- 
Martin K. Petersen	Oracle Linux Engineering
