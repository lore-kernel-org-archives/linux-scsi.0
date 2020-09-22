Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA3FC2D0E2
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 22:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93DFE221EB
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 22:44:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="asrH79pn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgIVWoE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 18:44:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42182 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIVWoE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 18:44:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MMdArh175204;
        Tue, 22 Sep 2020 22:43:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=6gzNPYWYgr9PhGZ75c/toVv6E+9YyZoUMgpZnmNikd8=;
 b=asrH79pnriMDhMcr6uP4AYCIIihjseW3QCysgvioEkZ+f3AoPGgb6vmNVMnGeGbejYjF
 n24IxKZT7wEBCI+feI6+osGZYDyZFkeB/dliO7xyI6R2f2EI+4oiZQeK+tWl7RIB5K5I
 H0tBEMLj//L3jbCyezo4HQUStrRkE0nXGPyfO0OjHugocM9HdVSqYb7lRyZP+RrRte8N
 ZhGTXlbldS3pyJ6nwCwEbJvZNEXhSyOXkbcEiTm854Yf60zinGrcfaUBka/FQfPO0hRC
 uoa0r9c68h1bWDhkfwE/MOFMiBCMVJQiKJi0/muP81Xg2yrizKnJxjrKRW8eXrNug2lX Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33q5rgdua9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 22:43:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MMZwHT187707;
        Tue, 22 Sep 2020 22:43:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33nuw54u2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 22:43:50 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08MMhmD6000763;
        Tue, 22 Sep 2020 22:43:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 15:43:48 -0700
To:     Nilesh Javali <njavali@marvell.com>
Cc:     Quinn Tran <qutran@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v3 11/13] qla2xxx: Add IOCB resource tracking
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tuvpo2k8.fsf@ca-mkp.ca.oracle.com>
References: <20200904045128.23631-1-njavali@marvell.com>
        <20200904045128.23631-12-njavali@marvell.com>
        <bd547541-5a29-5ec5-305a-8614d5a8792c@acm.org>
        <BYAPR18MB2759BFC109D95D019D027304D53E0@BYAPR18MB2759.namprd18.prod.outlook.com>
        <BYAPR18MB2759B6FC4D9A4E89CDA31CA7D53E0@BYAPR18MB2759.namprd18.prod.outlook.com>
        <DM6PR18MB3052A4B20D0C5AA509A7918BAF3A0@DM6PR18MB3052.namprd18.prod.outlook.com>
Date:   Tue, 22 Sep 2020 18:43:45 -0400
In-Reply-To: <DM6PR18MB3052A4B20D0C5AA509A7918BAF3A0@DM6PR18MB3052.namprd18.prod.outlook.com>
        (Nilesh Javali's message of "Mon, 21 Sep 2020 17:30:11 +0000")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=1 adultscore=0 mlxlogscore=931 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=1 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=946 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220173
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> We do not anticipate further changes to this patch or v3 series.

Applied to 5.10/scsi-staging. Next time, please run checkpatch.

-- 
Martin K. Petersen	Oracle Linux Engineering
