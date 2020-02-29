Return-Path: <SRS0=kvmt=4R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18451C3F2D1
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Feb 2020 01:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3AF12468A
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Feb 2020 01:40:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jf5/JDF6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgB2Bkk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 20:40:40 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44376 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgB2Bkk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Feb 2020 20:40:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T1cjl4008190;
        Sat, 29 Feb 2020 01:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=IUTaBsnY380paL8lziRtQ5S87cS6fZXH6ocfNUShe9A=;
 b=Jf5/JDF6nrrYbh+Er3drdvyyXAXVzbD2UaKd06RHqbjoMjBimhTBqPmVxlSh/Cu55Oep
 G3MZUjRajmhtGH5xq/gwLmRd4Z1M8LnImvQ+vHTMDCdGNrpo9hfHzaNr1eYwKl0QcmYg
 CIIeqdHGHLJQzzSDnIb1gOV0dQxFXeuNtH9nsLA2g9SznC3vlehldL8Tcen5cFbEIQU1
 J3/PcgCHnAntoG8ibS5y7JwKQ/f0qOyxoHdv2LJq0obpZtIuqBh1Lw0XuPrNaa7F2t6e
 EF+jrlBuUn1YrsBNC4jams/NWuBAYqhLsVvwVN3l097r4z26ndQCt2+FE4o0V+3TcipH 8g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ydct3p1sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 01:40:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T1b6Pn094125;
        Sat, 29 Feb 2020 01:40:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2yfe0d17vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 01:40:34 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01T1eW0w017469;
        Sat, 29 Feb 2020 01:40:33 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 17:40:32 -0800
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Subject: Re: [PATCH v2 0/2] Enable HOST_PA_TACTIVATE quirk for WDC UFS devices
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1582517363-11536-1-git-send-email-cang@codeaurora.org>
Date:   Fri, 28 Feb 2020 20:40:29 -0500
In-Reply-To: <1582517363-11536-1-git-send-email-cang@codeaurora.org> (Can
        Guo's message of "Sun, 23 Feb 2020 20:09:20 -0800")
Message-ID: <yq1d09y6uia.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=932 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002290007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290007
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> Western Digital UFS devices require host PA_TACTIVATE to be lower than
> device PA_TACTIVATE, otherwise it may get stuck during hibern8 sequence.

Applied to 5.7/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
