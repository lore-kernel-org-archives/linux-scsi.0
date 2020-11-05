Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1A0C2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 02:57:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDDC02074B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 02:57:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k+EbW4DV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388474AbgKEC5S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 21:57:18 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45904 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388455AbgKEC5S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 21:57:18 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A52s0q6168760;
        Thu, 5 Nov 2020 02:57:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=tOzNk2EK2R/Deek0VqQRL7Ul3752LAL3voCK6gisD8Q=;
 b=k+EbW4DVPyB/DTh58mnGnpmRPBu5l4iNOcv6pQroSaSZnSrkZnDHdm5wHA5Z9ZA0udG4
 B9GHdXh/WIazgWtYqdbk2ASMBcrUPj/dTE3qqcue9nNXEcBjU2mDRdn/fS5gsYUIBlEx
 SKuVczClo+0PpqcePGOCaNOnkPMYsWuUqiU8t5dgHX/sojpP0YEG0yNeT3eH4L4XbQIq
 jv4mos10EN2nQ/wvmF8EmvAumQQbQKZMOrbjx3iQ2POtg5AZkBIgMgfj3aTVVNQmzzFf
 tBtxCzWGQOpW9y7TVKgSv7uw16A0xQCkgkX9kghOYzd92RoVABYobyeNRY6zSqKcujkd xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34hhb29tb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 05 Nov 2020 02:57:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A52tnZd002815;
        Thu, 5 Nov 2020 02:57:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34hvrytjcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Nov 2020 02:57:04 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A52usfM028062;
        Thu, 5 Nov 2020 02:56:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Nov 2020 18:56:53 -0800
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] scsi: aacraid: improve compat_ioctl handlers
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtzwtst4.fsf@ca-mkp.ca.oracle.com>
References: <20201030164450.1253641-1-arnd@kernel.org>
Date:   Wed, 04 Nov 2020 21:56:51 -0500
In-Reply-To: <20201030164450.1253641-1-arnd@kernel.org> (Arnd Bergmann's
        message of "Fri, 30 Oct 2020 17:44:19 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=713 suspectscore=1 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=740 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Arnd,

> The use of compat_alloc_user_space() can be easily replaced by
> handling compat arguments in the regular handler, and this will make
> it work for big-endian kernels as well, which at the moment get an
> invalid indirect pointer argument.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
