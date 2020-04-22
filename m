Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D02C38A30
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 04:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0A23206EC
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 04:04:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T0ZCH0yH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgDVEEy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 00:04:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36162 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgDVEEx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 00:04:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M3wv8E052976;
        Wed, 22 Apr 2020 04:04:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=N4uY8+nCCzYgesup0oTIGasfY8c2xgQA/VFW9RtVAbM=;
 b=T0ZCH0yHdxIWSvnvqyi1MBb+hTjQ6Qu3kgDeEViGt0GyXB//8iD4LQ7/6AZ8q2G8yzA2
 gjNkKPlCDRceggEgKm810f0TwHi9Fs95Lcn4kyTncJeqVHyTb5s/V2OnlTE6J4z+HKqt
 TjtZhTe14w1yVitjGqo8+BgFhYPeVxb4Xa/LPWEzkCf+Y3VKLO4olYBcF1uHGbb4hDXS
 g/zn4eqp6JhJS5TH57/44h/j3uVHn1BNjejPXyOr/G/d6GP5T7jEzwkILQ1HDN2qiGE0
 ELnv1rCmPB5RyjYFq9UhE4z4M290iJSYYX5z+sTzqd0/NxoCTkR2NRRhceETinks8nPG ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30ft6n89ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 04:04:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M3vb9B129463;
        Wed, 22 Apr 2020 04:02:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30gb3t7r44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 04:02:46 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M42iIZ031196;
        Wed, 22 Apr 2020 04:02:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 21:02:44 -0700
To:     David Disseldorp <ddiss@suse.de>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, bvanassche@acm.org
Subject: Re: [PATCH] scsi: target/iblock: fix WRITE SAME zeroing
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200419163109.11689-1-ddiss@suse.de>
Date:   Wed, 22 Apr 2020 00:02:42 -0400
In-Reply-To: <20200419163109.11689-1-ddiss@suse.de> (David Disseldorp's
        message of "Sun, 19 Apr 2020 18:31:09 +0200")
Message-ID: <yq1d080i2vx.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=703 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=761 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


David,

> SBC4 specifies that WRITE SAME requests with the UNMAP bit set to zero
> "shall perform the specified write operation to each LBA specified by
> the command".
> 2237498f0b5c modified the iblock backend to call blkdev_issue_zeroout()
> when handling WRITE SAME requests with UNMAP=0 and a zero data segment.
> The iblock blkdev_issue_zeroout() call incorrectly provides a flags
> parameter of 0 (bool false), instead of BLKDEV_ZERO_NOUNMAP. The bool
> false parameter reflects the blkdev_issue_zeroout() API prior to
> ee472d835c264, which was merged shortly before 2237498f0b5c.

Applied to 5.7/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
