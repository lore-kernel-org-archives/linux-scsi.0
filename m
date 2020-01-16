Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBE1C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 04:07:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8406F20723
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 04:07:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qgOiszyt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730718AbgAPEHh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jan 2020 23:07:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56336 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbgAPEHh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2020 23:07:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G3w3ke108635;
        Thu, 16 Jan 2020 04:07:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=Jl44vm8C+vvCxM3gcaystgVEf1gfnugoX9H2gAUIctU=;
 b=qgOiszytJ21ybDmhPYu6M40WwGSDOsVCg1SXUqVnl870PhIRfePKbn+hYV3uSe6dqhtr
 NV8BmseD1ZFq5ExgrwazcBjmpmDMG2pBT/7pEbDJaiZeW++cruteM4W5Ka0liex/u6sU
 g7JqGnnb9QuF9ukHuea8DRODbeCODDz/tXNwHoEJ58o/yGUpYHrRNF9qhnOCUZUhjrOC
 NSIh6f22Q2wUVrD2pPHPxuHsl6bzowuYZU8mxUFnS/oGqUnur9xqcf/zDJxlLL7AK9RI
 2qPy+KNWQ9JAh++bIZcloH9d056hYUyeGqUH5VRCEB2+znVeaNGWjwMepSVwShYMPiBi 6g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xf73tyyte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 04:07:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G3xIQG167730;
        Thu, 16 Jan 2020 04:07:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xhy22jdcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 04:07:32 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00G47V5Y025610;
        Thu, 16 Jan 2020 04:07:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 20:07:31 -0800
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Tom Hatskevich <tom2001tom.23@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] scsi: mptfusion: Fix double fetch bug in ioctl
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200114123414.GA7957@kadam>
Date:   Wed, 15 Jan 2020 23:07:28 -0500
In-Reply-To: <20200114123414.GA7957@kadam> (Dan Carpenter's message of "Tue,
        14 Jan 2020 15:34:14 +0300")
Message-ID: <yq1d0bkniwv.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=590
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=666 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> Tom Hatskevich reported that we look up "iocp" then, in the called
> functions we do a second copy_from_user() and look it up again.  The
> problem that could cause is:

Applied to 5.5/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
