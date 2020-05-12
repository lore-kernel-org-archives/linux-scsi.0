Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981EAC54E4B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73A70206CC
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:48:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F4OVv/W9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgELDs6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 23:48:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45924 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgELDs5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 23:48:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3hM6b100525;
        Tue, 12 May 2020 03:48:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=PKTVe55m4PB3nZDCl/fZlAPDZjFgKXFhjS0gmg4pNOc=;
 b=F4OVv/W9Sxd8LgU2ns91kc3O+Z7HwdkaKyXuqC/qAeb4QyMJ9aFTK+lRQ4wiurTOPpnR
 mdisSlsDKUS6uKakSOJLCR3uXiZJI2w8Z5CuSONyGQ03ivgxNVaH5jOEpA+0gPHH8KwM
 II6A2+XWCy9D8+Dg8GdyUz/JQqaI7iHaCqf7tysQUheee8lVWye593Rqk/PhRXf6X8MP
 8GyHy2GY0Ji5FTiIGsOWxdqGSj3jd3BnjAD0CJj5oC3iZr8/YEVtxWgkDwhMFRjHWFPB
 +JaLYGwImKx1CU3YzwBBY9eKR5NuGnh3tCGCghpgqa93TSzbuPLs+wL8qr1S6ulsu659 7g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30x3mbrhyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 03:48:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3ldWR136198;
        Tue, 12 May 2020 03:48:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30x63ny1bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 03:48:53 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04C3mqCR017777;
        Tue, 12 May 2020 03:48:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 20:48:52 -0700
To:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, kiran-kumar.kasturi@broadcom.com,
        sankar.patra@broadcom.com, sasikumar.pc@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, anand.lodnoor@broadcom.com
Subject: Re: [PATCH 0/5] megaraid_sas: driver updates for 07.714.04.00-rc1
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200508083838.22778-1-chandrakanth.patil@broadcom.com>
Date:   Mon, 11 May 2020 23:48:50 -0400
In-Reply-To: <20200508083838.22778-1-chandrakanth.patil@broadcom.com>
        (Chandrakanth Patil's message of "Fri, 8 May 2020 14:08:33 +0530")
Message-ID: <yq1lflx3ja5.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120032
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Chandrakanth!

> This patchset contains few critical driver fixes.
>
> Chandrakanth Patil (5):
>   megaraid_sas: Limit device qd to controller qd when device qd is
>     greater than controller qd
>   megaraid_sas: Remove IO buffer hole detection logic
>   megaraid_sas: Replace undefined MFI_BIG_ENDIAN macro with
>     __BIG_ENDIAN_BITFIELD macro
>   megaraid_sas: TM command refire leads to controller firmware crash
>   megaraid_sas: Update driver version to 07.714.04.00-rc1

The threading was messed up in this series and both patchwork and b4
failed to grok it as a single patch set. It looks like your mail system
somehow broke it up into multiple submissions, each with their own
threading and cover letter.

Also, several patches had incorrect attribution. If a patch was not
authored by you it needs to have a From: identifying the original author
(Sumit, Kashyap, etc.) as identified in the first Signed-off-by: tag.

I fixed things up and applied to 5.8/scsi-queue. But please look into
what went wrong when mailing this series. While I can edit my way out of
incorrectly threaded submissions, the build robots and code checkers can
get stumped when something is broken up. And therefore there is a chance
that the patches didn't get full build and code analysis coverage.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
