Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F54CA9EA9
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 22:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00F4320872
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 22:00:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="piDmvKdx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfJRWAV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 18:00:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55084 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbfJRWAV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 18:00:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9ILsWTJ086675;
        Fri, 18 Oct 2019 22:00:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=oIXMUgijEE7y4qWQFymThn8iY/Hvr2ojgKSft1IuDyY=;
 b=piDmvKdxJ5TnfUlXn6c421JbfpL6LXLCDkdUf5X6UIJ8h32bLEazGQyPl+ZBiKKW7n1q
 OxCBnnqvzIaM2P3p67D9ywIRIoBtUJjQtvsr2St3ldPSTbgTxUQmm6EasYVVg2XnP4Ep
 o/EtcBSMFmPPjI2nRCQYxul+sQBrlVJxkqhctJWrfuhUVtnfKudLDvLQdcLM0GxVsiz5
 TutkJKO5WJjA0/G0GknC93l8FF+T5sJC4BfqFmX0xp+/462zMzdhKD8ENBFt0HT8yCD6
 eqbwkS+bvftUHl7ioXEIMCBiuu32ionniYpKPQsHUNI3ex0EBPYD9EOq1i9pSZSkul4R YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vq0q468rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 22:00:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9ILt11n097336;
        Fri, 18 Oct 2019 22:00:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vq0eexd3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 22:00:14 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9IM0Bee021712;
        Fri, 18 Oct 2019 22:00:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Oct 2019 22:00:11 +0000
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Check queue pointer before use
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191018162111.8798-1-dwagner@suse.de>
Date:   Fri, 18 Oct 2019 18:00:09 -0400
In-Reply-To: <20191018162111.8798-1-dwagner@suse.de> (Daniel Wagner's message
        of "Fri, 18 Oct 2019 18:21:11 +0200")
Message-ID: <yq1imolhfyu.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9414 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=500
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910180193
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9414 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=599 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910180193
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Daniel,

> The queue pointer might not be valid. The rest of the code checks the
> pointer before accessing it. lpfc_sli4_process_missed_mbox_completions
> is the only place where the check is missing.

Applied to 5.4/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
