Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F731C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 17:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 355CF2184D
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 17:57:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o3M8hguz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgJHR5A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Oct 2020 13:57:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42922 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgJHR5A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2020 13:57:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098Hs46U022618;
        Thu, 8 Oct 2020 17:56:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=h8ss32GNoMY4Gb2h06R51s5k0jGG0pfVMa62VOK6f9g=;
 b=o3M8hguzI65ghvo/l3eusiiM+2QX1EoiTKM76EIDVpm75pkBNAxnUVdZX1Sa8erxByLP
 /XNrfrg3GuAWuIql51hSyJWGoH0Da72r31pjVCdpQsk75DdDTbGQmIcxIrHLwDogjjOZ
 ztPGTubBm/qTPam0cTgvDuZSF5SPMEifhULp9nLVBuACuHv2USnOimUaf0gkCCzSzr0s
 WNYnjqGaZ84J4fakZ6LN85q05wftftLgRumZwJf5Pm22iYKzyDAQpxR+49yHAq1e8Gdt
 wdhACX71pP/lH1LgPRY4miDX+EvM2k8VcPUBg/OxQr1fRD35SDnybxNgf0JAtufjO6t4 JA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33ym34x8f9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 17:56:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098HtNJk022904;
        Thu, 8 Oct 2020 17:56:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33y2vrc30f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 17:56:55 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 098HusN5027222;
        Thu, 8 Oct 2020 17:56:54 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 10:56:54 -0700
Subject: Re: [PATCH 12/16] vhost: support multiple worker threads
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
 <1602104101-5592-13-git-send-email-michael.christie@oracle.com>
Message-ID: <da6f25b4-7a98-9294-a987-43d100625499@oracle.com>
Date:   Thu, 8 Oct 2020 12:56:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1602104101-5592-13-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080131
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/7/20 3:54 PM, Mike Christie wrote:
> This is a prep patch to support multiple vhost worker threads per vhost
> dev. This patch converts the code that had assumed a single worker
> thread by:
> 
> 1. Moving worker related fields to a new struct vhost_worker.
> 2. Converting vhost.c code to use the new struct and assume we will
> have an array of workers.
> 3. It also exports a helper function that will be used in the last
> patch when vhost-scsi is converted to use this new functionality.
> 

Oh yeah I also wanted to bring up this patch:

https://www.spinics.net/lists/netdev/msg192548.html

The problem with my multi-threading patches is that I was focused on
the cgroup support parts and that lead to some gross decisions.

1. I kept the cgroup support, but as a result I do not have control
over the threading affinity and making sure cmds are executed on a
optimal CPU like the above patches do.

When I drop the cgroup support and make sure threads are bound to
specific CPUs and then make sure IO is run on the CPU it came in on
then IOPs jumps from 600K to 800K for vhost-scsi.

2. I can possible create a lot of threads.

So a couple open issues are:

1. Can we do a thread per cpu that is shared across all vhost devices?
That would lead to dropping the cgroup vhost worker support.

2. Can we just use the kernel's workqueues then?
