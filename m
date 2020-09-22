Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDBD3C4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 16:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B02A239D2
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 16:20:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V42mT00w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgIVQUy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:20:54 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37184 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgIVQUy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 12:20:54 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MGJWlB085329;
        Tue, 22 Sep 2020 16:20:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dCFWRfWECqmX8nHjc16FkUwgcgwrpp4Azy2vtcSDC7E=;
 b=V42mT00wcf/4C7vpn1OHmblFQ0uKCXyuFnqgMS0Qf0zn3x+ikAQ0ZiVz2z6Hoh05mZ+6
 BtreBzJIFciGHR0U4M1l/DXOH0xhBqdPghT0JJ8F0XpqCMh54+wog3H2CT7VeJ39M6XL
 +BSsDgfyFdD3t8072SGG7AdBhyqB3rON3sR1wEzocHBeLhszAMVfxoGaceOptybGcICg
 tASicC0o9Y0HE/ZtJSH88fHplZg16sPuhrqelTVLy6TdclpX+s3rN1Euysg5yJMWUyko
 JSociGXXcZ6KRBRi2oM/Zr+8MSLOc1+0pb2N6lk7gG1H7cfKwjGO6+9i1Ic4VLVUKm49 UA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33qcpttqmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 16:20:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MGFM3N122491;
        Tue, 22 Sep 2020 16:20:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33nuwymnqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 16:20:50 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08MGKnnq020189;
        Tue, 22 Sep 2020 16:20:49 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 09:20:49 -0700
Subject: Re: [PATCH 0/3] target: scsi: tcmu: code rework and speed up of read
 data handling
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <2ba4d645-02b2-acd4-f009-ad1aade5f048@oracle.com>
Date:   Tue, 22 Sep 2020 11:20:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220125
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/10/20 10:50 AM, Bodo Stroesser wrote:
> This small series is made on top of Martin's 5.10/scsi-queue branch.
> 
> The patches simplify some code, splits off new helper functions
> or implement a cleaner code sequence to prevent double work.
> The 3rd patch speeds up buffer preparation for SCSI commands with
> long read data.
> The series is also base for cleaned up version v3 of my patch
>   scsi: target: tcmu: add compat mode for 32bit userspace on 64bit kernel
> 
> Bodo Stroesser (3):
>   scsi: target: tcmu: join tcmu_cmd_get_data_length and tcmu_cmd_get_block_cnt
>   scsi: target: tcmu: optimize queue_cmd_ring
>   scsi: target: tcmu: optimize scatter_data_area
> 
>  drivers/target/target_core_user.c | 340 +++++++++++++++++++-------------------
>  1 file changed, 170 insertions(+), 170 deletions(-)
> 

Acked-by: Mike Christie <michael.christie@oracle.com>
