Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD48C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 02:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A9232465A
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 02:06:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H1AOdTQg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgAWCGP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 21:06:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50338 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAWCGO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 21:06:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N24011098341;
        Thu, 23 Jan 2020 02:06:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=icp45S5bUhijDCq0JyU6nlIHY3xlMajIYm3xfCx6Rvk=;
 b=H1AOdTQg4+5nKx+AagsyBrTblArf/TBTqSYnx8W7T83g4zeszOt90ulP/Y8yaj/Dx7A1
 fCTfpNKUHTXmaEjZHefZV3q0qPXoAkUngJ6eFXnNweAmVpdhd3y13g6dr6x/NTiSA4WS
 jivEv/OcMRKB3/A+59ftgA9OeK9+pBE1A1N3avM4f3rsTlZIbb36uBnWoJmCFR2H0ZxO
 pVzvw5HNuBSvUEQS4xlDr6WantpqGcFEASzwjBF5qGB/Ld8rgkk+8703UwIXzXtx0rjY
 8k9Ivge50CEwxA9VaJZF7nVxXPC/f+IhgSW/fZ95Jjp2mAN2cHuBmdCoqC/HHhfW6g4U Tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xksyqfeqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 02:06:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N25QjA004191;
        Thu, 23 Jan 2020 02:06:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xpt6n60ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 02:06:06 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00N265OM022332;
        Thu, 23 Jan 2020 02:06:06 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 18:06:05 -0800
To:     Arun Easi <aeasi@marvell.com>
Cc:     "Elliott\, Robert \(Servers\)" <elliott@hpe.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "James.Bottomley\@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "martin.petersen\@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v4] qla2xxx: Fix unbound NVME response length
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200121192710.32314-1-hmadhani@marvell.com>
        <DF4PR8401MB1241B973AEE70A60D1D08133AB0C0@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
        <alpine.LRH.2.21.9999.2001221611360.15850@irv1user01.caveonetworks.com>
Date:   Wed, 22 Jan 2020 21:06:03 -0500
In-Reply-To: <alpine.LRH.2.21.9999.2001221611360.15850@irv1user01.caveonetworks.com>
        (Arun Easi's message of "Wed, 22 Jan 2020 16:20:17 -0800")
Message-ID: <yq1d0bbexkk.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=655
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001230015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=718 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230015
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Arun,

> I can post a follow on patch, with the WARN/log message under driver 
> debug.

Just send a v5. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
