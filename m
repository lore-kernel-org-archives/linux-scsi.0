Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 312C4C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 00:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0313720726
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 00:02:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DX1aD8HN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfLJACk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 19:02:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48190 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfLJACk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 19:02:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBA006Cx028284;
        Tue, 10 Dec 2019 00:02:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=nXa48o1cVQ7vSxlMzWYvYRBeRr88JUKVcjqZsAk9698=;
 b=DX1aD8HNdJuuwUu4inTgRthaMVXefe17rP1NtklYg4PF/6EBZB4L/kFYDrDKfWVTVPh6
 PBKDnGRZUv7ZJ/mtFqACpMIkegPiJusasxozPZ5dM1juPQmn22K379yicVyBZZFE0uPp
 cgJ3eFJdLqko162DJurUZh1EVCusgScbyOqDeQmO/GYrhPjJPRrz4WNDWLVeVGyegHLb
 mSu6qUg7AhoAIM4pj7HQdYRxeXTJXHLnYYesug/DLfbFxm7PC8dfzzaw3XYvXRauif7i
 AmkgbhJF5iBubUIXjXrSdVATtBAsYBKS3yLoL2H2fkVbUk+Ek4y09PY4Y/HRDnU82AAN ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wr41q2w8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 00:02:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9NrnOD051324;
        Tue, 10 Dec 2019 00:02:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2wsw6fyw0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 00:02:19 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBA02IR8013031;
        Tue, 10 Dec 2019 00:02:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 16:02:18 -0800
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     QLogic-Storage-Upstream@qlogic.com,
        David Somayajulu <david.somayajulu@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] iscsi: qla4xxx: fix double free in probe
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191203094421.hw7ex7qr3j2rbsmx@kili.mountain>
Date:   Mon, 09 Dec 2019 19:02:15 -0500
In-Reply-To: <20191203094421.hw7ex7qr3j2rbsmx@kili.mountain> (Dan Carpenter's
        message of "Tue, 3 Dec 2019 12:45:09 +0300")
Message-ID: <yq1o8whoxo8.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=700
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912090189
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=781 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912090190
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> On this error path we call qla4xxx_mem_free() and then the caller also
> calls qla4xxx_free_adapter() which calls qla4xxx_mem_free().  It leads
> to a couple double frees:

Applied to 5.5/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
