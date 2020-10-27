Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA10DC388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 05:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4946421D42
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 05:51:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gYYMo0Og"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506122AbgJ0Fv3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 01:51:29 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52906 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506115AbgJ0Fv3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2020 01:51:29 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R5nAYK053951;
        Tue, 27 Oct 2020 05:51:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=L6gDPqbDsOQ7HwaslcZdB53llGbJ4RQu93/cOd07F1w=;
 b=gYYMo0OgGBX/ANuqE+aFM62SY3jJHTtOdyn+YAf7R1YYyzm3+SYWI/CR826Pvq6pdKKW
 Gmgda5oCXddV5FR42F+A2na5FwxFS9IrkjouFS2FMMFoOeERWrfzpOXYm4s2zbTcvGA3
 rRLxzmJCc7pmf6zNaq3Te8c1LCkxw2u6FUoXtlIfhxmRQz5e4nbqWeCF+1UTwN2HbqUG
 /NbkTss/AOSqRvNyNcbv5+MptWiI6jukPvRIUCgWd64xpVjwX9hO76fjfX9aBoL25KNQ
 GQUF0VbMfRoZqTUvXbwyJHgkia6tf2SZE4JRTqgD9e7tNEXx3ImEPybyu+ID31RL6gNx Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34c9sar43m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 05:51:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R5fH9p084241;
        Tue, 27 Oct 2020 05:49:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34cx6vj66s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 05:49:25 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09R5nO9o031126;
        Tue, 27 Oct 2020 05:49:24 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 22:49:24 -0700
Subject: Re: [PATCH v2 0/5] scsi: target: COMPARE AND WRITE miscompare sense
To:     David Disseldorp <ddiss@suse.de>, target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org
References: <20201026190646.8727-1-ddiss@suse.de>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <ec78c756-6abd-32a8-a7d3-1c7788fa57d3@oracle.com>
Date:   Tue, 27 Oct 2020 00:49:23 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201026190646.8727-1-ddiss@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270038
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270039
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/20 2:06 PM, David Disseldorp wrote:
> This patchset adds missing functionality to return the offset of
> non-matching read/compare data in the sense INFORMATION field on
> COMPARE AND WRITE miscompare.
> 
> The functionality can be tested using the libiscsi
> CompareAndWrite.MiscompareSense test proposed via:
>    https://urldefense.com/v3/__https://github.com/sahlberg/libiscsi/pull/344__;!!GqivPVa7Brio!LJ-un7MDdHXhZgIK1qgvDgza2El16FK-T_4oDi6VqM0CzetAV9pGHDvLDrZUkITTHxhO$
> 
> Changes since v1:
> - drop unnecessary WARN_ON()
> - fix two checkpatch warnings
> - drop single-use nlbas variable
> - avoid compare_len recalculation
> 
> Cheers, David
> 
>   drivers/target/target_core_sbc.c       | 137 +++++++++++++++----------
>   drivers/target/target_core_transport.c |  33 +++---
>   include/target/target_core_base.h      |   2 +-
>   lib/scatterlist.c                      |   2 +-
>   4 files changed, 102 insertions(+), 72 deletions(-)


Reviewed-by: Mike Christie <michael.christie@oracle.com>
