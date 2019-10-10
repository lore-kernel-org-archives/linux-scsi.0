Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923A5C47404
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 02:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 645F1206C0
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 02:28:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pVlpWsb3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbfJJC2q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 22:28:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55068 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfJJC2p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Oct 2019 22:28:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A2SfLe069286;
        Thu, 10 Oct 2019 02:28:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=OMKO+flb98xcphMu8mOLakZYOK+k4wTPKBq9wBO2vC8=;
 b=pVlpWsb3VNko0fPlT39fa2Y95nAnxG7EM7DjgdYO9rh34jF9d5zkLhF0YcsrcivGx2cz
 f93gFGMpkuhXWQrgneMyr+f5aHSm/lbGoj9yVIocNQpTMKjwPhufZPJH4oAhaZMM/J6F
 C9D1T/3EvFez5bSY8z0I9M4wZOY93mIl8BIdE4DCm/uq3CU49Aj2IqFdHdgoUVjmGMi0
 T0hfcYGz4KGwHy1CcdLugy4GGzx4X+MRn0hMXh6fJZ0ir5wRE1VWnQuPfD7zA/Qw1lGA
 BHRbBFydcSXGy2uIxHx2XKw6VbtsSkjsrPDXztZwXSPoxoP2tZvsY1Hg/foTIVxD4twy OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vektrqysg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 02:28:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A2SbqV001100;
        Thu, 10 Oct 2019 02:28:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vh5cc2sp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 02:28:41 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9A2RslD009120;
        Thu, 10 Oct 2019 02:27:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 19:27:54 -0700
To:     Himanshu Madhani <hmadhani@marvell.com>
Cc:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 08/14] qla2xxx: Dual FCP-NVMe target port support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190912180918.6436-1-hmadhani@marvell.com>
        <20190912180918.6436-9-hmadhani@marvell.com>
Date:   Wed, 09 Oct 2019 22:27:48 -0400
In-Reply-To: <20190912180918.6436-9-hmadhani@marvell.com> (Himanshu Madhani's
        message of "Thu, 12 Sep 2019 11:09:12 -0700")
Message-ID: <yq1r23ljpwb.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910100022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Himanshu,

> Some storage arrays advertise FCP LUNs and NVMe namespaces behind the
> same WWN.  The driver now offer's a user option by way of NVRAM
> parameter to allow users to choose, on a per port basis, the kind of
> FC-4 type they would like to prioritize for login.

Applied patches 8-14 to 5.5/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
