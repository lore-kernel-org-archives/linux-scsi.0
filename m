Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85823C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 20:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E18B205CB
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 20:32:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IdBjLtX+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730530AbgJHUcr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Oct 2020 16:32:47 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48596 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgJHUcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2020 16:32:47 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098KUF2a011630;
        Thu, 8 Oct 2020 20:32:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=uYATmJ8iJhLB9arTEoY7vBual1ugG1zNbrvHRtIHtRc=;
 b=IdBjLtX+tIrZakU5O1ux6hh3keYevVyPbX2zTuJCvof9DlU7253Y+EIFw8xqPu7iTZLJ
 gL1X/TaNdg3dXefP2Kn/On56rE8cewqbS0ZO3N15MfM11DcgkjxIceEGBW3MReebNLWY
 wr9QKVKlLxgFwOHjFTIl7E0gGRlrVi8ARf0cdDcvabOBlNfc0PO2pyaWOV347NKKiOvM
 Wfidn7TI3/2TASoZkz/EZCaRZCwzAyYJFabyplW2S2jAc52PGX2GkF2V1h1QTztcQogs
 Kjlh8sCVZvA4vZgHiXKYkZ4CnaTAjxQ+8RwHm3bKOzDUSAJ4v+rNFIgY08n2BlVIpBli Qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 3429jyg3sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 20:32:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098KOtiI059432;
        Thu, 8 Oct 2020 20:32:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3429kagj61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 20:32:43 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 098KWgh5004773;
        Thu, 8 Oct 2020 20:32:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 13:32:42 -0700
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: scsi regression fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z7k31cv.fsf@ca-mkp.ca.oracle.com>
References: <20201008200611.1818099-1-hch@lst.de>
Date:   Thu, 08 Oct 2020 16:32:40 -0400
In-Reply-To: <20201008200611.1818099-1-hch@lst.de> (Christoph Hellwig's
        message of "Thu, 8 Oct 2020 22:06:09 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 phishscore=0 spamscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=753 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010080144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 phishscore=0 suspectscore=1 clxscore=1015 mlxscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 mlxlogscore=769 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010080144
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> two regression fixes for my recently merged series, uncovered by
> libata.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
