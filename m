Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D03C43461
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 01:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F16C321655
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 01:26:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vHuXl+ZJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgIPB0a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 21:26:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55962 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgIPB0a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 21:26:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G1AJ8v124667;
        Wed, 16 Sep 2020 01:26:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Qcfrtfu8h68tlpCvfoY/mvtlu0Rz7OT0JJfax3Yw3Cc=;
 b=vHuXl+ZJtkAOy7v3UmgGx1j+PWGBNuyL5+Ed1D6PlotfC23x5IAIeW8KDL9uM/hDApCS
 CkFfYVsSgWIsLYgMUBLGstgCrPzsLas7e5VvedSip1/tBob4rgAHj6NJNmVFQpS6ZH04
 L3npAm1cNEySh5bYoXgG2By5xfyRuohxcYF8DmjsK2jehZWTLIp+2Q2Xt1A/H09IFqtk
 SpAkDpibZByNyRp5iPnH+5S3Zk8C8IYz06CQrwjAw6oIxkzZWIsIaFEif3dPFLTupJnr
 Tf6za61jIkYng1jbFNnRZhfwaURtnFhmblhSZ2dzCn14ZJLu7ubrmwrnVnfTqwjoRAhH pQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33j91dhws0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 01:26:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G1Ovf0103185;
        Wed, 16 Sep 2020 01:26:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33h890d0jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 01:26:20 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08G1QGeV007876;
        Wed, 16 Sep 2020 01:26:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 01:26:16 +0000
To:     Ye Bin <yebin10@huawei.com>
Cc:     <willy@infradead.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sym53c8xx_2: Delete useless if-else in
 sym_xerr_cam_status
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bli61phr.fsf@ca-mkp.ca.oracle.com>
References: <20200902061646.576966-1-yebin10@huawei.com>
Date:   Tue, 15 Sep 2020 21:26:14 -0400
In-Reply-To: <20200902061646.576966-1-yebin10@huawei.com> (Ye Bin's message of
        "Wed, 2 Sep 2020 14:16:46 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160005
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ye,

> Only (x_status & XE_PARITY_ERR) is true we set cam_status = DID_PARITY,
> other condition we set cam_status = DID_ERROR. So delete useless if-else.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
