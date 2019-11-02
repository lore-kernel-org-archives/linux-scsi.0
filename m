Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947E4CA9ECF
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 00:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CBE621897
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 00:20:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lQtlsjFA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfKBAUy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 20:20:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56424 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbfKBAUy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 20:20:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA209Uoa196566;
        Sat, 2 Nov 2019 00:20:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=xE4qlqAI5hKRp48DIbzIF5qAEwi5D59mIGHHZhWdhKw=;
 b=lQtlsjFAocdbVGmjFrY8WYuF7TxutDaVGB6IQhZHNqd33FcGlffhxXRaq2uxGo+OiTeX
 Dl0XveMS3dMoHws/PJHT4oAMDOfaJChmutqNB68eJXoJdfFoxgdSmCAMl0aNGn5P0dFg
 +viShIMc0JC+CRbfMlJPiNdWnD/UCtwoy6JSepPKlpc3CyPqg2E1U+DcwOd5Q4juSRNB
 BMvxWEOWSImqV+FzK4UI8lYWFW129WV25hgCd1Z/emq+jBvWyR6d1r8GJfdXmeycVKzh
 n3h/8OoGcK1ocH+QfpHxCv2FE690Q0S0/RUa+fpwvJPovyU3dEkElalXWmr+t1xMuR+d GA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vxwhfvm0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Nov 2019 00:20:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA207jUa070829;
        Sat, 2 Nov 2019 00:20:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w0qcry96h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Nov 2019 00:20:20 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA20KHVq020748;
        Sat, 2 Nov 2019 00:20:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 17:20:16 -0700
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com, varun@chelsio.com,
        jthumshirn@suse.de, emilne@redhat.com, hare@suse.de,
        saurav.girepunje@gmail.com, gregkh@linuxfoundation.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        saurav.girepunje@hotmail.com
Subject: Re: [PATCH] scsi: csiostor: Fix NULL check before debugfs_remove_recursive is not needed
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191026195625.GA22455@saurav>
Date:   Fri, 01 Nov 2019 20:20:13 -0400
In-Reply-To: <20191026195625.GA22455@saurav> (Saurav Girepunje's message of
        "Sun, 27 Oct 2019 01:26:30 +0530")
Message-ID: <yq1wocj5dtu.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=776
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010224
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=875 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010224
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Saurav,

> debugfs_remove_recursive() has taken the null pointer into account.
> Remove the null check before debugfs_remove_recursive().

Applied to 5.5/scsi-queue. Thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
