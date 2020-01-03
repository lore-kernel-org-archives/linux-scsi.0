Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6618DC3276F
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 02:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 392652085B
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 02:56:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jWyNIFBW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbgACC41 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 21:56:27 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56042 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgACC40 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 21:56:26 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0032sG83083534;
        Fri, 3 Jan 2020 02:56:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=poaKakPjj0QvH5CnliZjROxUqZFUku7+pk8lkxPV0UI=;
 b=jWyNIFBWXIL2aI2LBFv7xxoKveoi+P37FZJxjNk4xmDxWU3ZgUl5xreWhJeMblxxiqHq
 /JXRBVk994ArtmT7o4KtoVntAKPkXqyDv/kvny2a6KvlTrNRfWBpKTY1JnNxqr7lBhuA
 kuXMDZBiYHkhYUlzQIxNAg8uB9MMbpiGgZle3l9u1Kk4EOOVfLtXolpqWiWH4DnAe/QJ
 3gqdtGq6Bd3FED5ognbaG17U7HQEWbWXUQl22YEOQxamoqLUspxX3uJPjmJ33pCNDsVk
 Hiq4DJeaLMBAI9f9zGNNAKltC2ML0Y63Cj1c/8wxTC/j5sFUlx7WbREh1X1XsRna34dy YA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2x5ypqt9e3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 02:56:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0032mKs6084960;
        Fri, 3 Jan 2020 02:56:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2x9jm6vqxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 02:56:24 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0032uNGB020833;
        Fri, 3 Jan 2020 02:56:23 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jan 2020 18:56:23 -0800
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] Cleanup sd_zbc zone checks.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191220075823.400072-1-damien.lemoal@wdc.com>
Date:   Thu, 02 Jan 2020 21:56:20 -0500
In-Reply-To: <20191220075823.400072-1-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Fri, 20 Dec 2019 16:58:21 +0900")
Message-ID: <yq1imlt5ju3.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=749
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=828 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030026
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> A couple of small patches to cleanup sd_zbc zone checks formerly
> implemented in sd_zbc_check_zones() and now moved to the block layer as
> generic code. The first patch removes a superfluous check present in the
> block layer. The second patch renames sd_zbc_check_zones() to be clear
> about the function role.

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
